type t

val v : string -> t

module Intensity : sig
  type t

  val intensity : t -> int
  val country : t -> ISO3166.alpha2
  val datetime : t -> string
  val pp : t Fmt.t
end

val get_intensity :
  net:Eio.Net.t -> country_code:ISO3166.alpha2 -> t -> Intensity.t
