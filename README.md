carbon-intensity
----------------

*Status: WIP & Experimental*

Carbon Intensity is an OCaml client for querying various energy grid APIs to understand the energy generation mix. This enables programs like schedulers, energy monitors etc. to have a better understanding of their carbon intensity.

The API provides geographic-specific services, which allow you to exploit more fine-grained APIs and then a generic `Intensity` interface for a global-oriented API.

*This library uses an experimental Cohttp client with Eio*.

### Integrated APIs

 - Great Britain:
    + https://www.carbonintensity.org.uk/

### Usage

<!-- $MDX non-deterministic=output -->
```ocaml
# Eio_main.run @@ fun env ->
  Carbon.Gb.get_intensity env
  |> Eio.traceln "%a" Carbon.Gb.Intensity.pp;;
+period: 2022-07-13T16:30Z - 2022-07-13T17:00Z
+forecast: 224 gCO2/kWh
+actual: 220 gCO2/kWh
+index: high
+
- : unit = ()
```
