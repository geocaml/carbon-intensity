type t = { token : string; net : Eio.Net.t }

let v ~api_key net = { token = api_key; net }

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
    code : ISO3166.alpha2;
    datetime : string;
    carbon_intensity : int;
    fossil_fuel_percentage : float;
  }

  let intensity t = t.carbon_intensity
  let datetime t = t.datetime
  let country t = t.code
  let pp_co2 ppf v = Fmt.pf ppf "%i gCO2/kWh" v

  let pp ppf t =
    Fmt.pf ppf
      "country: %s@.datetime: %s@.intensity: %a@.fossil fuel percentage: %f"
      (ISO3166.alpha2_to_string t.code)
      t.datetime pp_co2 t.carbon_intensity t.fossil_fuel_percentage
end

let get_intensity ~country_code t =
  let code = ISO3166.alpha2_to_string country_code in
  let headers = headers t in
  let resource =
    Endpoints.uri ~path:"latest" ~query:[ ("countryCode", [ code ]) ]
    |> Uri.path_and_query
  in
  let data =
    Http_client.get_json ~net:t.net ~headers Endpoints.(base, resource)
    |> J.path [ "data" ]
  in
  match
    ( J.find data [ "datetime" ],
      J.find data [ "carbonIntensity" ],
      J.find data [ "fossilFuelPercentage" ] )
  with
  | Some date, Some ci, Some ffp ->
      Intensity.
        {
          code = country_code;
          datetime = J.to_string date;
          carbon_intensity = J.to_int ci;
          fossil_fuel_percentage = J.to_float ffp;
        }
  | _ -> invalid_arg "Malformed JSON data for get_intensity"
