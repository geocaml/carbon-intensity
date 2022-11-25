carbon-intensity
----------------

Carbon Intensity is an OCaml client for querying various energy grid APIs to understand the energy generation mix. This enables programs like schedulers, energy monitors etc. to have a better understanding of their carbon intensity.

The API provides geographic-specific services, which allow you to exploit more fine-grained APIs and then a generic `Intensity` interface for a global-oriented API.

### Integrated APIs

 - Great Britain:
    + https://www.carbonintensity.org.uk/
 - Misc:
    + https://www.co2signal.com (requires API key)

### Usage

A very simple use of the region specific API for Great Britain only requires the user to provide Eio's network capability.

<!-- $MDX skip -->
```ocaml
# Eio_main.run @@ fun env ->
  Carbon.Gb.get_intensity env#net
  |> Eio.traceln "%a" Carbon.Gb.Intensity.pp;;
+period: 2022-08-28T17:30Z - 2022-08-28T18:00Z
+forecast: 255 gCO2/kWh
+actual: None
+index: high
+
- : unit = ()
```

Some APIs require more configuration, for example an access token. In order to use them you will need to construct a configuration and pass this into any calls that are made. For example:

<!-- $MDX skip -->
```ocaml
# Eio_main.run @@ fun env ->
  let token = Eio.Path.(load (env#fs / ".co2-token")) in
  let t = Carbon.Co2_signal.v token in
  Carbon.Co2_signal.get_intensity ~net:env#net ~country_code:`FR t
  |> Eio.traceln "%a" Carbon.Co2_signal.Intensity.pp;;
+country: FR
+datetime: 2022-08-29T11:00:00.000Z
+intensity: 99 gCO2/kWh
+fossil fuel percentage: 15.230000
- : unit = ()
```
