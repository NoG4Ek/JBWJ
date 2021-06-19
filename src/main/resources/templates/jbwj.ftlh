setlocal EnableDelayedExpansion

<#if Args.dllAs == true>
start cmd /k ^
"call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat" ^
& call native-image --shared -jar ${Args.jarFileName}"
</#if>

<#if Args.cores == 1>
start cmd /k "call set AFL_NO_SINKHOLE=1 !="!^
& call afl-fuzz.exe ^
-i "${Args.inputDir}" ^
-o "${Args.outDir}" ^
-t "${Args.timeOut}" ^
-D "${Args.DRIO}" ^
-- -coverage_module "${Args.jarName}.dll" ^
-target_module "WinAFLHarness.exe" ^
-target_method "main" ^
-fuzz_iterations "10" ^
-nargs "4" ^
-- "WinAFLHarness.exe" ^
-l "${Args.jarName}.dll" ^
-f "${Args.funcName}" ^
-i "${Args.regexToIncludeSort}" ^
-e "${Args.regexToExcludeSort}" ^
-p "@@""
</#if>

<#if (Args.cores > 1)>
start cmd /k "call set AFL_NO_SINKHOLE=1 !="!^
& call afl-fuzz.exe ^
-i "${Args.inputDir}" ^
-o "${Args.outDir}" ^
-M "fuzzer0" ^
-t "${Args.timeOut}" ^
-D "${Args.DRIO}" ^
-- -coverage_module "${Args.jarName}.dll" ^
-target_module "WinAFLHarness.exe" ^
-target_method "main" ^
-fuzz_iterations "10" ^
-nargs "4" ^
-- "WinAFLHarness.exe" ^
-l "${Args.jarName}.dll" ^
-f "${Args.funcName}" ^
-i "${Args.regexToIncludeSort}" ^
-e "${Args.regexToExcludeSort}" ^
-p "@@""

for /l %%i in (1,1,${Args.cores - 1}) do (
start cmd /k "call set AFL_NO_SINKHOLE=1 & call setlocal EnableDelayedExpansion !="!^
& call afl-fuzz.exe ^
-i "${Args.inputDir}" ^
-o "${Args.outDir}" ^
-S "fuzzer%%i" ^
-t "${Args.timeOut}" ^
-D "${Args.DRIO}" ^
-- -coverage_module "${Args.jarName}.dll" ^
-target_module "WinAFLHarness.exe" ^
-target_method "main" ^
-fuzz_iterations "10" ^
-nargs "4" ^
-- "WinAFLHarness.exe" ^
-l "${Args.jarName}.dll" ^
-f "${Args.funcName}" ^
-i "${Args.regexToIncludeSort}" ^
-e "${Args.regexToExcludeSort}" ^
-p "@@""
)
</#if>

pause
call :RC 1> ${Args.jarName}ST.txt 2>&1
exit
:RC
for /r "${Args.outDir}\crashes" %%f in (*.) do (
	call java -jar ${Args.jarFileName} %%f
)
pause