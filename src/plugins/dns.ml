(* HACK: until we get full support for DNS in the Eio ecosystem *)
let get_addr name =
  Eio_unix.run_in_systhread @@ fun () ->
  let host_entry = Unix.gethostbyname name in
  Eio_unix.Ipaddr.of_unix host_entry.h_addr_list.(0)
