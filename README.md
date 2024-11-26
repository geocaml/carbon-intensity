carbon-intensity
----------------

Carbon Intensity is an OCaml client for querying various energy grid APIs to understand the energy generation mix. This enables programs like schedulers, energy monitors etc. to have a better understanding of their carbon intensity.

The API provides geographic-specific services, which allow you to exploit more fine-grained APIs and then a generic `Intensity` interface for a global-oriented API.

### Integrated APIs

 - Great Britain:
    + https://www.carbonintensity.org.uk/
 - France:
    + https://www.rte-france.com/eco2mix
 - Misc:
    + https://www.co2signal.com (requires API key)

### Usage

A very simple use of the region specific API for Great Britain only requires the user to provide Eio's network capability.

<!-- $MDX skip -->
```ocaml
# Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun _ ->
  let gb = Carbon.Gb.v env#net in
  Carbon.Gb.get_intensity gb
  |> Eio.traceln "%a" Carbon.Gb.Intensity.pp;;
+period: 2024-11-25T21:00Z - 2024-11-25T21:30Z
+forecast: 99 gCO2/kWh
+actual: 92 gCO2/kWh
+index: low
+
- : unit = ()
```

