type t
(** A configuration value for accessing the data *)

module Zone = Zone
(** Possible Zones as defined by the Electric Map API
    for more information see {{: https://static.electricitymaps.com/api/docs/index.html#zones} the zones API}. *)

val v : api_key:string -> _ Eio.Net.t -> t
(** [v api_key] constructs a new configuration value using the provided
    [api_key]. *)

module Intensity : sig
  type t
  (** A value returned from the API for intensity data. *)

  val intensity : t -> int
  (** The CO{_2}-eq intensity (gCO{_2}-eq/kWh) *)

  val zone : t -> Zone.t
  (** The zone code for the data *)

  val datetime : t -> string
  (** The datetime for the value. *)

  val pp : t Fmt.t
  (** A pretty printer for intensity values. *)
end

val get_intensity : zone:Zone.t -> t -> Intensity.t
(** [get_intensity ~net ~zone t] will try to get the intensity values for
    a particular zone by calling the API. *)
