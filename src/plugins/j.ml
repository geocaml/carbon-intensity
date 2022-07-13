let find = Ezjsonm.find_opt
let to_list = Ezjsonm.get_list
let to_string = Ezjsonm.get_string
let to_int = Ezjsonm.get_int
let null_to_option = function `Null -> None | v -> Some v
