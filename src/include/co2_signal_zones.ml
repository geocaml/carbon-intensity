let replace_hyphens n = String.split_on_char '-' n |> String.concat "_"

let check_keyword = function
  | "do" -> "do_"
  | "for" -> "for_"
  | "in" -> "in_"
  | "to" -> "to_"
  | s -> s

let read_zones () =
  let zones =
    In_channel.with_open_bin "./include/zones.json" @@ fun ic ->
    Ezjsonm.from_channel ic
  in
  match zones with
  | `O assoc ->
      let f (n, obj) =
        match obj with
        | `O [ ("zoneName", `String name) ] ->
            (n, Fmt.str "This is the zone %s" name)
        | `O [ ("countryName", `String country); ("zoneName", `String name) ] ->
            (n, Fmt.str "This is the zone %s in country %s" name country)
        | _ -> failwith "expected a zonename"
      in
      List.map f assoc
  | _ -> failwith "Expected dictionary"

let impl () =
  let zones = read_zones () in
  let impl (name, _) =
    let ocaml_name =
      String.lowercase_ascii name |> replace_hyphens |> check_keyword
    in
    Fmt.str {|let %s = "%s"|} ocaml_name name
  in
  Fmt.pr "type t = string\n\n";
  List.iter (fun v -> Fmt.pr "%s\n\n" (impl v)) zones;
  Fmt.pr "let of_string v = v\n\n";
  Fmt.pr "let to_string v = v"

let intf () =
  let zones = read_zones () in
  let impl (name, d) =
    let ocaml_name =
      String.lowercase_ascii name |> replace_hyphens |> check_keyword
    in
    Fmt.str {|val %s : t
    (** %s *)|} ocaml_name d
  in
  Fmt.pr "type t\n\n";
  List.iter (fun v -> Fmt.pr "%s\n\n" (impl v)) zones;
  Fmt.pr "val of_string : string -> t\n\n";
  Fmt.pr "val to_string : t -> string\n\n"

let () =
  match Sys.argv.(1) with
  | "impl" -> impl ()
  | "intf" -> intf ()
  | m ->
      failwith
        ("Not a valid argument, should be either impl or intf but got " ^ m)
