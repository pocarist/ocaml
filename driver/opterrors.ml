(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* WARNING: if you change something in this file, you must look at
   errors.ml to see if you need to make the same changes there.
*)

open Format

(* Report an error *)

let report_error ppf exn =
  let report ppf = function
  | Typetexp.Error(loc, env, err) ->
      Location.print_error ppf loc; Typetexp.report_error env ppf err
  | Typedecl.Error(loc, err) ->
      Location.print_error ppf loc; Typedecl.report_error ppf err
  | Typeclass.Error(loc, env, err) ->
      Location.print_error ppf loc; Typeclass.report_error env ppf err
  | Includemod.Error err ->
      Location.print_error_cur_file ppf;
      Includemod.report_error ppf err
  | Typemod.Error(loc, env, err) ->
      Location.print_error ppf loc; Typemod.report_error env ppf err
  | Translcore.Error(loc, err) ->
      Location.print_error ppf loc; Translcore.report_error ppf err
  | Translclass.Error(loc, err) ->
      Location.print_error ppf loc; Translclass.report_error ppf err
  | Translmod.Error(loc, err) ->
      Location.print_error ppf loc; Translmod.report_error ppf err
  | Compilenv.Error code ->
      Location.print_error_cur_file ppf;
      Compilenv.report_error ppf code
  | Asmgen.Error code ->
      Location.print_error_cur_file ppf;
      Asmgen.report_error ppf code
  | Asmlink.Error code ->
      Location.print_error_cur_file ppf;
      Asmlink.report_error ppf code
  | Asmlibrarian.Error code ->
      Location.print_error_cur_file ppf;
      Asmlibrarian.report_error ppf code
  | Asmpackager.Error code ->
      Location.print_error_cur_file ppf;
      Asmpackager.report_error ppf code
  | Sys_error msg ->
      Location.print_error_cur_file ppf;
      fprintf ppf "I/O error: %s" msg
  | Warnings.Errors (n) ->
      Location.print_error_cur_file ppf;
      fprintf ppf "Some fatal warnings were triggered (%d occurrences)" n
  | x ->
      match Location.error_of_exn x with
      | Some err -> Location.report_error ppf err
      | None -> fprintf ppf "@]"; raise x
  in

  fprintf ppf "@[%a@]@." report exn
