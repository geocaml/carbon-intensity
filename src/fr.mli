type t
(** A configuration value for accessing the data *)

val v : _ Eio.Net.t -> t
(** Creates a new configuration value with network access. *)

val get : t -> int
(** Get the newest data for carbon intensity in gCO2/kWh. *)
