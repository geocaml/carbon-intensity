module type Intensity = sig
  type t
  (** A configuration parameter for the API *)

  val get_intensity : t -> int
  (** [get_intensity t] returns the gCO2/kWh. *)
end
