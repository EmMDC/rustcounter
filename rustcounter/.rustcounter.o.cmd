savedcmd_rustcounter.o := OBJTREE=/usr/src/linux-headers-7.0.0-14-generic RUST_MODFILE=./rustcounter rustc --edition=2021 -Zbinary_dep_depinfo=y -Astable_features -Aunused_features -Dnon_ascii_idents -Dunsafe_op_in_unsafe_fn -Wmissing_docs -Wrust_2018_idioms -Wunreachable_pub -Wclippy::all -Wclippy::as_ptr_cast_mut -Wclippy::as_underscore -Wclippy::cast_lossless -Wclippy::ignored_unit_patterns -Wclippy::mut_mut -Wclippy::needless_bitwise_bool -Aclippy::needless_lifetimes -Wclippy::no_mangle_with_rust_abi -Wclippy::ptr_as_ptr -Wclippy::ptr_cast_constness -Wclippy::ref_as_ptr -Wclippy::undocumented_unsafe_blocks -Wclippy::unnecessary_safety_comment -Wclippy::unnecessary_safety_doc -Wrustdoc::missing_crate_level_docs -Wrustdoc::unescaped_backticks -Cpanic=abort -Cembed-bitcode=n -Clto=n -Cforce-unwind-tables=n -Ccodegen-units=1 -Csymbol-mangling-version=v0 -Crelocation-model=static -Zfunction-sections=n -Wclippy::float_arithmetic --target=/usr/src/linux-headers-7.0.0-14-generic/scripts/target.json -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2 -Ctarget-cpu=x86-64 -Ztune-cpu=generic -Cno-redzone=y -Ccode-model=kernel -Zfunction-return=thunk-extern -Zpatchable-function-entry=16,16 -Copt-level=2 -Cdebug-assertions=n -Coverflow-checks=y -Cforce-frame-pointers=y -Zdwarf-version=5 -Cdebuginfo=2  --cfg MODULE  @/usr/src/linux-headers-7.0.0-14-generic/include/generated/rustc_cfg -Zallow-features=asm_const,asm_goto,arbitrary_self_types,lint_reasons,offset_of_nested,raw_ref_op,slice_ptr_len,strict_provenance,used_with_arg -Zcrate-attr=no_std -Zcrate-attr='feature(asm_const,asm_goto,arbitrary_self_types,lint_reasons,offset_of_nested,raw_ref_op,slice_ptr_len,strict_provenance,used_with_arg)' -Zunstable-options --extern pin_init --extern kernel --crate-type rlib -L /usr/src/linux-headers-7.0.0-14-generic/rust/ --crate-name rustcounter --sysroot=/dev/null --out-dir ./ --emit=dep-info=./.rustcounter.o.d --emit=obj=rustcounter.o rustcounter.rs  ; /usr/src/linux-headers-7.0.0-14-generic/tools/objtool/objtool --hacks=jump_label --hacks=noinstr --hacks=skylake --retpoline --rethunk --sls --stackval --static-call --uaccess --prefix=16  --link  --module rustcounter.o

source_rustcounter.o := rustcounter.rs

deps_rustcounter.o := \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libcore.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libkernel.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libffi.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libcompiler_builtins.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libpin_init.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libpin_init_internal.so \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libmacros.so \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libbuild_error.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libbindings.rmeta \
  /usr/src/linux-headers-7.0.0-14-generic/rust/libuapi.rmeta \

rustcounter.o: $(deps_rustcounter.o)

$(deps_rustcounter.o):

rustcounter.o: $(wildcard /usr/src/linux-headers-7.0.0-14-generic/tools/objtool/objtool)
