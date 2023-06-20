let co2_signal env =
  match Eio.Path.(load (env#fs / ".co2-token")) with
  | exception Eio.Io _ -> ()
  | api_key ->
      let co2_signal = Carbon.Co2_signal.v ~api_key env#net in
      Carbon.Co2_signal.get_intensity ~zone:Carbon.Co2_signal.Zone.dk_dk1
        co2_signal
      |> Eio.traceln "INDIA:@.%a" Carbon.Co2_signal.Intensity.pp

let gb env =
  let gb = Carbon.Gb.v env#net in
  Carbon.Gb.get_intensity gb |> Eio.traceln "GB:@.%a" Carbon.Gb.Intensity.pp

let fr env =
  let fr = Carbon.Fr.v env#net in
  Carbon.Fr.get fr |> Eio.traceln "FR:@.%d"

let () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun _ ->
  co2_signal env;
  gb env;
  fr env
