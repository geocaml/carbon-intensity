module Gb = Gb
module Co2_signal = Co2_signal

module Intensity = struct
  module Gb = struct
    type t = Gb.t

    let get_intensity ~net (_ : Gb.t) =
      let i = Gb.get_intensity net in
      Gb.Intensity.actual i
  end

  module Co2_signal (C : sig
    val country : ISO3166.alpha2
  end) =
  struct
    type t = Co2_signal.t

    let get_intensity ~net t =
      let i = Co2_signal.get_intensity ~net ~country_code:C.country t in
      Some (Co2_signal.Intensity.intensity i)
  end
end
