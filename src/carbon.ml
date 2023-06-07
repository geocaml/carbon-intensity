module Gb = Gb
module Fr = Fr
module Co2_signal = Co2_signal

module Intensity = struct
  module Gb = struct
    type t = Gb.t

    let get_intensity (t : Gb.t) =
      let i = Gb.get_intensity t in
      Gb.Intensity.actual i
  end

  module Fr = struct
    type t = Fr.t

    let get_intensity t = Some (Fr.get t)
  end

  module Co2_signal (C : sig
    val country : ISO3166.alpha2
  end) =
  struct
    type t = Co2_signal.t

    let get_intensity t =
      let i = Co2_signal.get_intensity ~country_code:C.country t in
      Some (Co2_signal.Intensity.intensity i)
  end
end
