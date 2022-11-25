module type Intensity = sig
  type t
  (** A configuration parameter for the API *)

  val get_intensity : net:Eio.Net.t -> t -> int option
  (** [get_intensity t] returns the current gCO2/kWh if available. *)
end
