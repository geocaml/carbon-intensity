(*---------------------------------------------------------------------------
   Copyright (c) 2022 Geocaml Developers
   Distributed under the ISC license, see terms at the end of the file.
  ---------------------------------------------------------------------------*)
type t = { net : [ `Generic ] Eio.Net.ty Eio.Net.t }

let v net = { net :> [ `Generic ] Eio.Net.ty Eio.Net.t }

module Endpoints = struct
  let ( // ) a b = a ^ "/" ^ b
  let base = "api.carbonintensity.org.uk"
  let intensity = "/intensity"

  let intensity_from ~from t =
    let from = Ptime.to_rfc3339 from in
    match t with
    | `Fw24 -> intensity // from // "fw24h"
    | `Fw48 -> intensity // "fw48h"
    | `Pt24 -> intensity // "pt24h"
    | `To iso -> intensity // Ptime.to_rfc3339 iso
end

module Period = struct
  type t = { from_ : string; to_ : string }

  let from t = t.from_
  let to_ t = t.to_
  let pp ppf t = Fmt.pf ppf "%s - %s" t.from_ t.to_
end

module Error = struct
  type t = { code : string; message : string }
end

module Intensity = struct
  type index = [ `Very_low | `Low | `Moderate | `High | `Very_high ]

  type t = {
    period : Period.t;
    forecast : int;
    actual : int option;
    index : index;
  }

  let period t = t.period
  let forecast t = t.forecast
  let actual t = t.actual
  let index t = t.index

  let index_of_string = function
    | "very low" -> `Very_low
    | "low" -> `Low
    | "moderate" -> `Moderate
    | "high" -> `High
    | "very high" -> `Very_high
    | s -> invalid_arg s

  let index_to_string = function
    | `Very_low -> "very low"
    | `Low -> "low"
    | `Moderate -> "moderate"
    | `High -> "high"
    | `Very_high -> "very high"

  let of_json json =
    match (J.find json [ "from" ], J.find json [ "to" ]) with
    | Some from_, Some to_ -> (
        let from_ = J.to_string from_ in
        let to_ = J.to_string to_ in
        match
          ( J.find json [ "intensity"; "forecast" ],
            J.find json [ "intensity"; "actual" ],
            J.find json [ "intensity"; "index" ] )
        with
        | Some forecast, Some actual, Some index ->
            let forecast = J.to_int forecast in
            let actual = Option.map J.to_int (J.null_to_option actual) in
            let index = J.to_string index |> index_of_string in
            { period = { from_; to_ }; forecast; actual; index }
        | _ -> invalid_arg "JSON has malformed intensity object")
    | _ -> invalid_arg "JSON does not have keys `from' and `to'"

  let pp_gco2 ppf = function
    | Some v -> Fmt.pf ppf "%i gCO2/kWh" v
    | None -> Fmt.pf ppf "None"

  let pp ppf t =
    Fmt.pf ppf "period: %a@.forecast: %a@.actual: %a@.index: %s@." Period.pp
      t.period pp_gco2 (Some t.forecast) pp_gco2 t.actual
      (index_to_string t.index)
end

module Factors = struct
  type t = {
    biomass : int;
    coal : int;
    dutch_imports : int;
    french_imports : int;
    gas_combined_cycle : int;
    gas_open_cycle : int;
    hydro : int;
    irish_imports : int;
    nuclear : int;
    oil : int;
    other : int;
    pumped_storage : int;
    solar : int;
    wind : int;
  }
end

let headers =
  Http.Header.of_list
    [ ("Accept", "application/json"); ("Host", "api.carbonintensity.org.uk") ]

let get_intensity t =
  Http_client.get_json ~headers ~net:t.net Endpoints.(base, intensity)
  |> J.path [ "data" ]
  |> Ezjsonm.get_list Intensity.of_json
  |> List.hd

let get_intensity_period ~period:(from, to_) t =
  (Http_client.get_json ~headers ~net:t.net
  @@ Endpoints.(base, intensity_from ~from to_))
  |> J.path [ "data" ]
  |> Ezjsonm.get_list Intensity.of_json

(*---------------------------------------------------------------------------
   Copyright (c) 2022 Patrick Ferris <patrick@sirref.org>

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
  ---------------------------------------------------------------------------*)
