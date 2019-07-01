:: Programmed by hXR16F
:: hXR16F.ar@gmail.com

@echo off
mode 80,38 & color 0f & title Teletext Client
reg add "HKCU\Console" /V "ForceV2" /T "REG_DWORD" /D "0x00000000" /F > nul
bg font 5 & bg cursor 0

:: Type of teletext
set "type=TVP"

(set page=1&set "subpage=0"&set "change-subpage=0")
if exist "files" (pushD files&(del /s /q *.png > nul)&popD) else (md files)
batbox /g 73 36 /d "hXR16F"

if /i "%type%" equ "TVP" (
	goto :main-tvp
) else (
	exit
)

:main-tvp
	if %page% equ 1 (set file=0001) else (if %page% equ 2 (set file=0002) else (if %page% equ 3 (set file=0003) else (if %page% equ 4 (set file=0004) else (if %page% equ 5 (set file=0005) else (if %page% equ 6 (set file=0006) else (if %page% equ 7 (set file=0007) else (if %page% equ 8 (set file=0008) else (if %page% equ 9 (set file=0009) else (if %page% equ 10 (set file=0010) else (if %page% equ 11 (set file=0011) else (if %page% equ 12 (set file=0012) else (if %page% equ 13 (set file=0013) else (if %page% equ 14 (set file=0014) else (if %page% equ 15 (set file=0015) else (if %page% equ 16 (set file=0016))))))))))))))))

	if "%subpage%" equ "0" (
		batbox /g 0 0 & curl -o files/%file%.png http://www.telegazeta.pl/sync/ncexp/TG1/100/100_%file%.png
		insertpng files/%file%.png:32:54:110
	) else (
		batbox /g 0 0 & curl -o files/%change-subpage%.png http://www.telegazeta.pl/sync/ncexp/TG1/%change-subpage:~0,1%00/%change-subpage%_0001.png
		insertpng files/%change-subpage%.png:32:54:110
	)
	batbox /g 0 34 /d "Page: %page%/16 " /g 16 34 /d "Subpage: %change-subpage%     " /g 6 35 /d " (up)" /g 6 36 /d " (down)" /g 25 35 /d " (change subpage)" /g 25 36 /d " (back)"
	
	:loop-tvp
		batbox /k
		if %errorlevel% equ 327 if not %page% leq 1 set /a page-=1 & goto :main-tvp
		if %errorlevel% equ 335 if not %page% geq 16 set /a page+=1 & goto :main-tvp
		if %errorlevel% equ 330 set "subpage=0" & set "change-subpage=0" & goto :main-tvp
		if %errorlevel% equ 332 (
			bg cursor 1
			batbox /g 24 34 /d "     " /g 25 34
			set /p "change-subpage="
			bg cursor 0
			set subpage=1
			goto :main-tvp
		)
		goto :loop-tvp
		