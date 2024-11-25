(** {1 Energy Mix for Great Britain }
    
  This plugin provides a client for interacting with {{: https://www.carbonintensity.org.uk/} the carbon-intensity} API.
  This includes intelligent forecasting models as well as current and past energy mixes.
*)

type t
(** A configuration value for accessing the data *)

val v : _ Eio.Net.t -> t
(** Creates a new configuration value with network access. *)

(** {2 Data types} *)

module Period : sig
  type t
  (** A period of time as returned from the API *)

  val from : t -> string
  (** Start of the period (in ISO8601) *)

  val to_ : t -> string
  (** End of the period (in ISO8601) *)
end

module Error : sig
  type t = { code : string; message : string }
  (** An error code from the API *)
end

module Intensity : sig
  type t

  type index = [ `Very_low | `Low | `Moderate | `High | `Very_high ]
  (** The index is a measure of the Carbon Intensity represented as a scale *)

  val period : t -> Period.t
  (** The period of time for which the Carbon Intensity information is valid. *)

  val forecast : t -> int
  (** The forecast Carbon Intensity for the period in units gCO2/kWh *)

  val actual : t -> int option
  (** The forecast Carbon Intensity for the period in units gCO2/kWh. This is
      optional as the data might be for the future. *)

  val index : t -> index
  (** Extracts the index for a given intensity *)

  val pp : t Fmt.t
  (** A simple pretty printer for intensity information *)
end

module Factors : sig
  type t
end

val get_intensity : t -> Intensity.t

val get_intensity_period :
  period:Ptime.t * [ `Fw24 | `Fw48 | `Pt24 | `To of Ptime.t ] ->
  t ->
  Intensity.t list
