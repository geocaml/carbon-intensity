open Eio
open Cohttp_eio

let tls_config =
  let null ?ip:_ ~host:_ _certs = Ok None in
  Tls.Config.client ~authenticator:null ()

let get_json ?headers ~net (host, resource) =
  Net.with_tcp_connect ~service:"https" ~host net @@ fun conn ->
  let conn =
    Tls_eio.client_of_flow tls_config
      ?host:
        (Domain_name.of_string_exn host |> Domain_name.host |> Result.to_option)
      conn
  in
  let resp = Client.get ?headers ~conn ~host:("https://" ^ host) (object method net = net end) resource in
  let s = Client.read_fixed resp in
  Ezjsonm.value_from_string s |> fun v -> Ezjsonm.find v [ "data" ]
