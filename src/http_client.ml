open Cohttp_eio

let authenticator =
  match Ca_certs.authenticator () with
  | Ok x -> x
  | Error (`Msg m) ->
      Fmt.failwith "Failed to create system store X509 authenticator: %s" m

let https ~authenticator =
  let tls_config =
    match Tls.Config.client ~authenticator () with
    | Error (`Msg msg) -> failwith ("tls configuration problem: " ^ msg)
    | Ok tls_config -> tls_config
  in
  fun uri raw ->
    let host =
      Uri.host uri
      |> Option.map (fun x -> Domain_name.(host_exn (of_string_exn x)))
    in
    Tls_eio.client_of_flow ?host tls_config raw

let get_json ?headers ~net (host, resource) =
  Eio.Switch.run @@ fun sw ->
  let uri = Uri.make ~scheme:"https" ~host ~path:resource () in
  let client = Client.make ~https:(Some (https ~authenticator)) net in
  let _body, resp = Client.get ~sw client ?headers uri in
  let s = Eio.Flow.read_all resp in
  Ezjsonm.value_from_string s
