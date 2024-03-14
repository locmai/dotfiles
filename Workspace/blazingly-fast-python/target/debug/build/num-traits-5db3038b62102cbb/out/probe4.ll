; ModuleID = 'probe4.dba62a34cb19b777-cgu.0'
source_filename = "probe4.dba62a34cb19b777-cgu.0"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx11.0.0"

@alloc_d97bce5cf248005335e8851c8b05c1bf = private unnamed_addr constant <{ [86 x i8] }> <{ [86 x i8] c"/private/tmp/nix-build-rustc-1.75.0.drv-0/rustc-1.75.0-src/library/core/src/num/mod.rs" }>, align 1
@alloc_084d3469c0b09baca05aed7e3efe5df5 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_d97bce5cf248005335e8851c8b05c1bf, [16 x i8] c"V\00\00\00\00\00\00\00y\04\00\00\05\00\00\00" }>, align 8
@str.0 = internal constant [25 x i8] c"attempt to divide by zero"

; probe4::probe
; Function Attrs: uwtable
define void @_ZN6probe45probe17h962900a0f03aaf49E() unnamed_addr #0 {
start:
  %0 = call i1 @llvm.expect.i1(i1 false, i1 false)
  br i1 %0, label %panic.i, label %"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h5bb631d4eb763272E.exit"

panic.i:                                          ; preds = %start
; call core::panicking::panic
  call void @_ZN4core9panicking5panic17h7af515ee7c59afa3E(ptr align 1 @str.0, i64 25, ptr align 8 @alloc_084d3469c0b09baca05aed7e3efe5df5) #3
  unreachable

"_ZN4core3num21_$LT$impl$u20$u32$GT$10div_euclid17h5bb631d4eb763272E.exit": ; preds = %start
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(none)
declare i1 @llvm.expect.i1(i1, i1) #1

; core::panicking::panic
; Function Attrs: cold noinline noreturn uwtable
declare void @_ZN4core9panicking5panic17h7af515ee7c59afa3E(ptr align 1, i64, ptr align 8) unnamed_addr #2

attributes #0 = { uwtable "frame-pointer"="non-leaf" "target-cpu"="apple-m1" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(none) }
attributes #2 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "target-cpu"="apple-m1" }
attributes #3 = { noreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{!"rustc version 1.75.0 (82e1608df 2023-12-21) (built from a source tarball)"}
