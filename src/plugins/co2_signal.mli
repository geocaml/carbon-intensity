type t
(** A configuration value for accessing the data *)

val v : string -> t
(** [v api_key] constructs a new configuration value using the provided
    [api_key]. *)

module Intensity : sig
  type t
  (** A value returned from the API for intensity data. *)

  val intensity : t -> int
  (** The CO{_2}-eq intensity (gCO{_2}-eq/kWh) *)

  val country : t -> ISO3166.alpha2
  (** The {! ISO3166.alpha2} country code for the data *)

  val datetime : t -> string
  (** The datetime for the value. *)

  val pp : t Fmt.t
  (** A pretty printer for intensity values. *)
end

val get_intensity :
  net:Eio.Net.t -> country_code:ISO3166.alpha2 -> t -> Intensity.t
(** [get_intensity ~net ~country_code t] will try to get the intensity values for
    a particular country by calling the API. *)
