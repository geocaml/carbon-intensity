(** [Carbon] is a library for inquiring information about the {b carbon intensity}
    of energy grids around the world. It integrates various APIs to be able to
    do this. Some require API keys others do not.

    Carbon intensity values are measured in {e grams of carbon dioxide equivalent
    per kilowatt hour}. Carbon dioxide equivalent (CO{_ 2}-eq) is a unit for measuring
    the impact of various {e greenhouse gases}. This makes it possible to compare say
    methane and CO{_2} for their {e global-warming potential}.

    A killowatt hour is a measurement of energy use. 1kWh is the energy used by an appliance
    with a 1kW power rating for one hour.

    So far there are two APIs available for use:

    {ul {- {!Gb} uses {{: https://carbonintensity.org.uk} carbonintensity.org.uk} which does
           not require any API key, but it only works for Great Britain.}
        {- {!Co2_signal} uses {{: https://www.co2signal.com} co2signal.com} which {e does} require
           an API key but has many more countries available.}}
    *)

(** {2 Low-level API Access} *)

module Gb = Gb
module Fr = Fr
module Co2_signal = Co2_signal

(** {2 Generic Interface}*)

module Intensity : sig
  module Gb : Carbon_intf.Intensity with type t = Gb.t
  module Fr : Carbon_intf.Intensity with type t = Fr.t

  module Co2_signal (C : sig
    val zone : Co2_signal.Zone.t
  end) : Carbon_intf.Intensity with type t = Co2_signal.t

  (** The generic interface for [Co2_signal] requires you to provide
      a specific zone to use. For example:
      {[
        module France = Co2_signal (struct let zone = Co2_signal.Zone.fr end)
      ]}
    *)
end
