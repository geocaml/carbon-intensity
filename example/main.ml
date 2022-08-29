let () =
  Eio_main.run @@ fun env ->
  let token = Eio.Path.(load (env#fs / ".co2-token")) in
  let t = Carbon.Co2_signal.v token in
  Carbon.Co2_signal.get_intensity ~net:env#net ~country_code:`FR t
  |> Eio.traceln "%a" Carbon.Co2_signal.Intensity.pp
