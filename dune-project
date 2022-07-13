(lang dune 2.9)
(using mdx 0.1)
(name carbon)
(generate_opam_files true)
(source
 (github geocaml/carbon-intensity))
(license MIT)
(authors "Patrick Ferris")
(maintainers "patrick@patricksirref.org")
(package
 (name carbon)
 (synopsis "OCaml library for accessing various Carbon Intensity APIs")
 (description "")
 (depends
   cohttp-eio
   ezjsonm
   ptime
   (mdx :with-test)
   (eio_main :with-test)))