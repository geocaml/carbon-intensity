let () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun _ ->
  let api_key = Eio.Path.(load (env#fs / ".co2-token")) in
  let co2_signal = Carbon.Co2_signal.v ~api_key env#net in
  Carbon.Co2_signal.get_intensity ~country_code:`FR co2_signal
  |> Eio.traceln "FRANCE:@.%a" Carbon.Co2_signal.Intensity.pp;
  let gb = Carbon.Gb.v env#net in
  Carbon.Gb.get_intensity gb |> Eio.traceln "GB:@.%a" Carbon.Gb.Intensity.pp
