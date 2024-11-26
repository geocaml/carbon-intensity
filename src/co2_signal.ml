module Zone = Zone

type t = { token : string; net : [ `Generic ] Eio.Net.ty Eio.Net.t }

let v ~api_key net =
  { token = api_key; net :> [ `Generic ] Eio.Net.ty Eio.Net.t }

module Endpoints = struct
  let base = "api.co2signal.com"
  let version = "v1"

  let uri ~path ~query =
    Uri.make ~scheme:"https" ~host:base ~path:(version ^ "/" ^ path) ~query ()
end

let headers t =
  Http.Header.of_list
    [
      ("Accept", "application/json");
      ("auth-token", t.token);
      ("Host", Endpoints.base);
    ]

module Intensity = struct
  type t = {
    zone : Zone.t;
    datetime : string;
    carbon_intensity : int;
    fossil_fuel_percentage : float;
  }

  let intensity t = t.carbon_intensity
  let datetime t = t.datetime
  let zone t = t.zone
  let pp_co2 ppf v = Fmt.pf ppf "%i gCO2/kWh" v

  let pp ppf t =
    Fmt.pf ppf
      "zone: %s@.datetime: %s@.intensity: %a@.fossil fuel percentage: %f"
      (Zone.to_string t.zone) t.datetime pp_co2 t.carbon_intensity
      t.fossil_fuel_percentage
end

let get_intensity ~zone t =
  let headers = headers t in
  let resource =
    Endpoints.uri ~path:"latest"
      ~query:[ ("countryCode", [ Zone.to_string zone ]) ]
    |> Uri.path_and_query
  in
  let data =
    Http_client.get_json ~net:t.net ~headers Endpoints.(base, resource)
    |> J.path [ "data" ]
  in
  Fmt.pr "%s" (Ezjsonm.value_to_string data);
  match
    ( J.find data [ "datetime" ],
      J.find data [ "carbonIntensity" ],
      J.find data [ "fossilFuelPercentage" ] )
  with
  | Some date, Some ci, Some ffp ->
      {
        Intensity.zone;
        datetime = J.to_string date;
        carbon_intensity = J.to_int ci;
        fossil_fuel_percentage = J.to_float ffp;
      }
  | _ -> invalid_arg "Malformed JSON data for get_intensity"
