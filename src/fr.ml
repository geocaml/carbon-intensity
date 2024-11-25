type t = { net : [ `Generic ] Eio.Net.ty Eio.Net.t }

let v net = { net :> [ `Generic ] Eio.Net.ty Eio.Net.t }
let url_host = "odre.opendatasoft.com"
let url_path = "/api/explore/v2.0/catalog/datasets/eco2mix-national-tr/records"
let encode_value = Stringext.replace_all ~pattern:" " ~with_:"%20"

let query_params =
  [
    ("select", "taux_co2");
    ("where", "taux_co2 is not null");
    ("order_by", "date_heure desc");
    ("limit", "1");
  ]

let extract_from_response json =
  json |> J.path [ "records" ] |> J.only
  |> J.path [ "record"; "fields"; "taux_co2" ]
  |> J.to_int

let get { net } =
  let query_string =
    Printf.sprintf "%s?%s" url_path
      (List.map
         (fun (k, v) -> Printf.sprintf "%s=%s" k (encode_value v))
         query_params
      |> String.concat "&")
  in
  Http_client.get_json ~net
    ~headers:(Http.Header.of_list [ ("Host", url_host) ])
    (url_host, query_string)
  |> extract_from_response
