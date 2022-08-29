open Eio
open Cohttp_eio

let tls_config =
  Mirage_crypto_rng_unix.initialize ();
  let null ?ip:_ ~host:_ _certs = Ok None in
  Tls.Config.client ~authenticator:null () (* todo: TOFU *)

let get_json ?headers ~net (base, resource) =
  match Net.getaddrinfo_stream ~service:"https" net base with
  | [] -> failwith "Host resolution failed"
  | stream :: _ ->
      Switch.run @@ fun sw ->
      let conn = Net.connect ~sw net stream in
      let conn =
        Tls_eio.Tls_flow.client_of_flow tls_config
          ?host:
            (Domain_name.of_string_exn base
            |> Domain_name.host |> Result.to_option)
          conn
      in
      let resp = Client.get ?headers ~conn ("https://" ^ base, None) resource in
      let s = Client.read_fixed resp in
      Ezjsonm.value_from_string s |> fun v -> Ezjsonm.find v [ "data" ]
