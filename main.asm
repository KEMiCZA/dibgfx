.386
.model flat, stdcall
option casemap:none
	include \masm32\include\Comctl32.inc
	include \masm32\include\windows.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\user32.inc
	include \masm32\include\gdi32.inc
	include \masm32\include\masm32.inc
	include \masm32\include\winmm.inc
	include \masm32\include\oleaut32.inc
	include \masm32\include\ole32.inc
	include \masm32\include\Shell32.inc
	includelib \masm32\lib\masm32.lib
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\user32.lib
	includelib \masm32\lib\gdi32.lib
	includelib \masm32\lib\oleaut32.lib
	includelib \masm32\lib\ole32.lib
	includelib \masm32\lib\winmm.lib
	includelib \masm32\lib\Comctl32.lib
	includelib \masm32\lib\Shell32.lib
	include msc/ufmod.inc ;uFMOD
	includelib msc/ufmod.lib
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		DlgProc					PROTO	:DWORD,:DWORD,:DWORD,:DWORD
		DlgProchEdit			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
		WinMain 				proto 	:DWORD,:DWORD,:DWORD,:DWORD
		SetImg 					PROTO	:DWORD,:DWORD,:DWORD,:DWORD
		InitImg					PROTO	:DWORD
		SetImgTr				PROTO	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
		SetImgChar 				PROTO 	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
		SetImgString			PROTO 	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
		sincostable				PROTO	:DWORD,:DWORD
		SetChar					PROTO	:BYTE,:DWORD,:DWORD
		SetCharScrol			PROTO	:BYTE,:DWORD,:DWORD
		SetText					PROTO	:DWORD,:DWORD,:DWORD,:DWORD,:BYTE
		SetTextScrol			PROTO	:DWORD,:DWORD,:DWORD,:DWORD
		SetBitmap				PROTO	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
		SetBitmapTrans			PROTO	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
		SPixel					PROTO	:DWORD,:DWORD,:DWORD
		SPixelTr2				PROTO	:DWORD,:DWORD,:BYTE,:BYTE,:BYTE,:DWORD
		DrawFullCircle			PROTO	:DWORD,:DWORD,:DWORD,:DWORD
		congb					PROTO 	:DWORD
		DrawItem         		PROTO	:HWND,:LPARAM
		
RGB MACRO red, green, blue
        xor eax, eax
        mov ah, blue    ; blue
        mov al, green   ; green
        rol eax, 8
        mov al, red     ; red
ENDM

.data
ClassName db "SimpleWinClass",0 
AppName  db "Our First Window",0 

;**** TRAINER INFORMATION ***
dProtect       dd 00	
ReceivedBytesBuf dd 0
SlowMotion		dd 0
flgg dd 0
flgg1 dd 0
;**** GFX CRAP ******
hButPressBrush 		dd 0
hButBrush			dd 0
hButPressBrushmsc	dd 0
hButBrushmsc		dd 0
hDlgBGBrush			dd 0
hTestimg			dd 0
hImgtxt				dd 0
hImgdvt				dd 0
hImgheart			dd 0

hTestimgD			dd 0
hTestimgP			dd 0
hTestimgH			dd 0
hTestimgW			dd 0

MscFlag			db 0
InfoFlag		db 0 ;When true will show our info file
InfoYpos		dd 0 ;This will be where to position the nfo
InfoPointer		dd 0 ;The pointer to the base addr of the info data
InfoLen			dd 0 ;This is how many lines/rows there are
InfoSize		dd 0 ;Size of the file
xm_length		dd 0
xm_ptr			dd 0
transinfo		dd 0
waitfadeb1		dd 512
fadedvt			dd 0
traineractivef	dd 0
wtfgzz			dd 0		
scrollwheelflag	dd 0
cpoint			dd 10,10,10,50
timez			dd 0
clockz			dd 0

BounceIntensity 	REAL4 10.0
BounceIntensityOg	REAL4 10.0
BounceGrav			REAL4 0.2
BounceGravY			REAL4 2.0
BounceX				REAL4 20.0
BounceY				REAL4 0.0
f2_					REAL4 10.0

speedscrollsubmw	REAL4 0.2
speedscrollspeed	REAL4 0.2
speedscrollspeedc	REAL4 0.0
; max speed = 4 ? ok

BounceFlag			db 0		;0 then drops, 1 then goez up

hWinz				dd 0
hResourcez			dd 0			
.data?
CommandLine LPSTR ?
;HOTKEY GENERATOR
Stringbuf			db 512 dup (?)
HotKeyBuf db 5000 dup (?)
AmountOfOptionsBuf db 100 dup (?)
lpTempPathBuffer	db 1024 dup (?)
lpDirectoryTemp		db 1024 dup (?)
WBuf		db 30 dup (?) ;maximum 30 chars :)
hNtDll   	DWORD ?
fNtWrite 	DWORD ?
fNtFlush 	DWORD ?
fNtProt  	DWORD ?
pHandle		dd ?
pTextBuffer dd 128 dup (?)
HotkeyBuf db 512 dup (?)
Gradient dd 1024 dup (?)
CheatSignature STRUCT
	ID BYTE ?	;Holds the ID if the cheat, because we'll have more than one
	Hotkey BYTE ?
	Toggle BYTE ? ;is it a toggle cheat or just a one time injection? !0=toggle
	Flag BYTE ?
	BeginAddress DWORD ?
	PointerToDataSignature DWORD ?
	PointerToDataCave DWORD ?
	LenSearch DWORD ?
	NumOfNops BYTE ?
	ShiftAddr DWORD ?
CheatSignature ends

NumOfOptionsMax	equ 100 ;Let's say there're max 20
NumOfOptions dd ?
CheatList	dd ?

CheatToggle STRUCT ;This is used to toggle the cheats on/off after your main injection
	ID BYTE ?	;Holds the ID if the cheat, because we'll have more than one
	Hotkey BYTE ?
	Flag BYTE ?
	Address DWORD ?
CheatToggle ends

CheatNormal STRUCT ;This is used to toggle the cheats on/off after your main injection
	ID BYTE ?	;Holds the ID if the cheat, because we'll have more than one
	Hotkey BYTE ?
	Flag BYTE ?
	Address DWORD ?
CheatNormal ends

NumOfTogglesMax equ 100
NumOfToggles dd ?
ToggleList dd ?
NormalList dd ?
NumOfNormal dd ?

BeginAddressEXE dd ?
bwr dd ?
szBtnText    TCHAR     16 dup(?)
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
NumOfHeart	equ 500
NumOfBalls 	equ 500
BallTransparency equ 200 ;max = 255, the lower the more transparent

LenDll equ 2560 ;Lenght of my dll file to be written
.data	
;HOTKEY GENERATOR
hWndHotkey1 dd 0
HOTKEY_CLASS db "msctls_hotkey32",0
Empty db " ",0
ErrorInt db "Error!",0
ErrorIntText db "Please enter a valid number of options!",0
ErrorIntText2 db "You've exceeded the amount of options!",0
IniFile db "kem.ini",0

LogBrush     LOGBRUSH   <>
rect         RECT       <>
rectAll 	RECT <0,0,363,100>
BtnTxtMain			db "Main",0
BtnTxtNFO 			db "iNFO",0
BtnTxtHedit			db "hEdit",0
BtnTxtExit			db "Bye..",0
BtnTxtWww			db "www",0
BtnTxtMusicOn		db ":)",0
BtnTxtMusicOff		db ":(",0
lpNumberOfBytesWritten dd 0
lpOperation			db "open",0
lpPage 				db "https://github.com/kemicza",0
	VirtualAllocExError db "Failed to allocate free memory within games process",0ah
						 db "One or more options might not work!",0
	VirtualAllocExCap	 db "VirtualAllocEx fail!",0					 
	SndON db "SndON",0
	
	;/////////////// TRAINER CONFIGURATION //////////////////////
	trntitle	db "KEMiCZA : )",0				;declare the title/caption of the trainer
	ProcessName db "xx.exe",0	;Process name of the games exe
	DLLdev		db "kem",0
	DLLkernel	db "kernel32.dll",0
	ProcAddr	db "LoadLibraryA",0

	;/////////////// GRAHPICS CONFIGURATION //////////////////////
	opttext db "F1 ACTIVATE TRAINER        ",0ah,0ah
			db "READ THE README.TXT FiLE!",0ah
			db "Game is running: awesomegame.exe",0
			
	hotkgent	db "A file named kem.ini has been saved at the location of the trainer.",0ah
				db "To make the changes work properly you have to put this file in the",0ah
				db "same directory as your games exe. Or just put the trainer in the games "
				db "location folder and generate your desired hotkeys.",0
	hotkgenc	db "Help woooot!?! Now what :( I crap my pants ",0
	tststring 	db "kemicza proudly presents",0ah
				db "     awesome game",0ah
				db "        v1.01 ",0ah
				db "    plus xx trainer",0ah
				db "code.............kemicza",0ah
				db "gfx..............kemicza",0ah
				db "tune.............svenzzon",0

	greetstring db "f1 activate trainer ",0ah,0ah
				db "see info file for all the options",0ah
				db "see info file for all the options",0ah
				db "see info file for all the options ",0ah
				db " ",0ah
				db " ",0ah,0ah
				db "read the included info file for details",0
				
	xoptions	dd 2
	
	FlagSlow 	dd 00
	waitfadetext dd 01
	waittrans	 dd 256
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
.data?
	hInstance       HINSTANCE  	?
	hDlg            HWND       	?
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	include gfx.asm	;All our graphics procedures are in here
	
.code
start:	
GOOOOO:
	invoke InitCommonControls
    invoke	GetModuleHandle, 0
	mov hInstance,eax
	invoke	DialogBoxParam, eax, 100, 0, ADDR DlgProc, 0
	invoke	ExitProcess, 0
	
DlgProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
LOCAL msg:MSG
LOCAL crap:DWORD
LOCAL val1:DWORD
LOCAL hFile:DWORD
Wm_1:
		 cmp [uMsg],WM_INITDIALOG
		 jnz Wm_2
		 push DialogAlign
		 push hWnd
		 pop hDlg
		
		mov wtfgzz,0
		; Fill in important Bitmap elements.
		; structure to specify our format to the DIB call. 
		mov canvas.bmiHeader.biSize,sizeof canvas.bmiHeader
		mov canvas.bmiHeader.biWidth,ScreenWidthO
		mov canvas.bmiHeader.biHeight,-ScreenHeightO
		mov canvas.bmiHeader.biPlanes,1
		mov canvas.bmiHeader.biBitCount,32
		invoke GetTickCount
		invoke nseed,eax
        invoke sincostable,offset cosa_,offset sina_
		call InitScrolTable
		call InitPS3
		call InitBalls
		call InitRndmNbr
		call CreateGradient
		Invoke CreateFont,12,5,0,0,FW_NORMAL,0,0,0,OEM_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS ,DEFAULT_QUALITY,FIXED_PITCH OR FF_DONTCARE, addr fontname ;terminalez
		mov hFont,eax
		invoke SetWindowText, hWnd, addr trntitle
		Invoke LoadIcon, hInstance, 300
		invoke GetDC, hWnd
		mov hDC,eax
		invoke CreateCompatibleDC, eax
		mov [canvasDC], eax
		invoke CreateCompatibleDC, hDC
		mov [canvasDCInfo],eax
		
		invoke CreateDIBSection,hDC,ADDR canvas,DIB_RGB_COLORS, ADDR canvas_buffer, 0, 0 
		mov [canvasBmp], eax
		invoke SelectObject, [canvasDC], eax
		invoke CreateDIBSection,hDC,ADDR canvas,DIB_RGB_COLORS, ADDR canvas_bufferinfo, 0, 0 
		mov [canvasBmpInfo], eax
		invoke SelectObject, [canvasDCInfo], eax
		;invoke ReleaseDC,hDC,0
		invoke SelectObject, [canvasDC], hFont			;select terminal font
		Invoke SetBkMode, [canvasDC], TRANSPARENT		;background is transparent
		Invoke SetBkColor, [canvasDC], 00000000h  		;no idea
		Invoke SetTextColor, [canvasDC], 00FFFFFFh		;white colour
		invoke SelectObject, [canvasDCInfo], hFont			;select terminal font
		Invoke SetBkMode, [canvasDCInfo], TRANSPARENT		;background is transparent
		Invoke SetBkColor, [canvasDCInfo], 00000000h  		;no idea
		Invoke SetTextColor, [canvasDCInfo], 00FFFFFFh		;white colour
		;Load gif files
		Invoke BmpFromResource,hInstance,150             ; up
		invoke CreatePatternBrush,eax
		mov hButPressBrush,eax
		Invoke BmpFromResource,hInstance,151             ; downd
		invoke CreatePatternBrush,eax
		mov hButBrush,eax
		
		Invoke BmpFromResource,hInstance,152             ; mscup
		invoke CreatePatternBrush,eax
		mov hButPressBrushmsc,eax
		Invoke BmpFromResource,hInstance,153             ; mscdownd
		invoke CreatePatternBrush,eax
		mov hButBrushmsc,eax
		
		invoke FindResource,0,155,RT_RCDATA	;background shnizle
		mov hResourcez,eax
		invoke LoadResource,0,hResourcez
		invoke LockResource,eax
		mov hTestimg,eax
		
		invoke FindResource,0,156,RT_RCDATA	;text font
		mov hResourcez,eax
		invoke LoadResource,0,hResourcez
		invoke LockResource,eax
		mov hImgtxt,eax
		
		invoke FindResource,0,157,RT_RCDATA	;deviated start logo
		mov hResourcez,eax
		invoke LoadResource,0,hResourcez
		invoke LockResource,eax
		mov hImgdvt,eax
		
		mov LogBrush.lbColor,0
		invoke CreateBrushIndirect,ADDR LogBrush
		mov hDlgBGBrush,eax
		
		Invoke SetDlgItemText,hWnd,101,ADDR BtnTxtNFO ; Set text on all of the buttons
		Invoke SetDlgItemText,hWnd,102,ADDR BtnTxtHedit
		Invoke SetDlgItemText,hWnd,103,ADDR BtnTxtExit
		Invoke SetDlgItemText,hWnd,104,ADDR BtnTxtMusicOn
		Invoke SetDlgItemText,hWnd,115,ADDR BtnTxtWww
		;Invoke SetDlgItemText,hWnd,103,ADDR abtbtntxt
		invoke FindResource,0,200,RT_RCDATA	;xm file
		mov hResourcez,eax
		invoke SizeofResource,0,hResourcez
		mov xm_length,eax
		invoke LoadResource,0,hResourcez
		invoke LockResource,eax
		mov xm_ptr,eax
		
		;Find our NFO located in resource and get the base addr of it
		invoke FindResource,0,790,RT_RCDATA
		mov hResourcez,eax
		invoke LoadResource,0,hResourcez
		invoke LockResource,eax
		mov InfoPointer,eax
		invoke SizeofResource,0,hResourcez
		mov InfoSize,eax
		mov eax,InfoPointer
		xor ebx,ebx
		xor ecx,ecx
		.while ecx < InfoSize
			mov dl,byte ptr [eax+ecx]
			.if dl == 0Ah
				inc ebx
			.endif
			inc ecx
		.endw
		mov eax,ebx
		imul eax,10
		neg eax
		mov InfoLen,eax
				
		invoke GlobalAlloc,GMEM_ZEROINIT,2000
		mov txtchars0,eax
		invoke	SetTimer, hWnd, 1, 0, 0 	;for plotting/gfx
		invoke	SetTimer, hWnd, 2, 150, 0 ;for trainer
		mov eax,1
		
		push XM_MEMORY
		push xm_length
		push xm_ptr
		call uFMOD_PlaySong
		ret
Wm_2:
	;//////// HERE IS THE LOOP THAT CONTROLS ALL THE OPTION AND DRAWING /////////
		cmp [uMsg],WM_TIMER
		jnz Wm_3
		.if wParam == 1
			pushad
			call DrawScene
			popad
		.endif
Wm_3:
	    cmp [uMsg],WM_PAINT
        jnz Wm_4
Wm_4:
	    cmp [uMsg],WM_CLOSE
		jnz Wm_5
@exitALL:
		invoke DeleteFile,addr lpDirectoryTemp
		invoke DeleteObject,[canvasBmpInfo]
		invoke DeleteObject,[canvasBmp]
		invoke DeleteDC,[canvasDC]
		invoke DeleteDC,[canvasDCInfo]
        invoke ExitProcess, eax
Wm_5:
        cmp [uMsg],WM_LBUTTONDOWN
        jnz Wm_6
        invoke SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, NULL
Wm_6:
		cmp [uMsg],WM_RBUTTONUP
		jne Wm_7
		invoke ExitProcess,0
Wm_7:
		cmp [uMsg],WM_DRAWITEM
		jnz Wm_8
		invoke DrawItem,hWnd,lParam
		ret
Wm_8:
		cmp [uMsg],WM_ERASEBKGND
		jnz Wm_9
		Invoke GetClientRect,hDlg,ADDR rect
		Invoke FillRect,wParam,ADDR rect,hDlgBGBrush
		mov eax,1
		ret
Wm_9:
		cmp [uMsg],WM_COMMAND
		jnz Wm_10
		mov eax,wParam
		mov edx,wParam                        
		shr edx, 16
		.if dx == BN_CLICKED
			.if ax == 101 ;nfo
				.if InfoFlag == 1
					mov InfoFlag,0
					Invoke SetDlgItemText,hWnd,101,ADDR BtnTxtNFO ; Set text on all of the buttons
				.elseif InfoFlag == 0
					mov InfoFlag,1
					Invoke SetDlgItemText,hWnd,101,ADDR BtnTxtMain ; Set text on all of the buttons
				.endif
			.elseif ax == 102 ;hedit
				;invoke MessageBox,[hWnd],0,0,MB_OK
				invoke	DialogBoxParam,hInstance, 105, hWnd, ADDR DlgProchEdit, 0
			.elseif ax == 103
				jmp @exitALL
			.elseif ax == 104 ;msc
				.if MscFlag == 1
					mov MscFlag,0
					Invoke SetDlgItemText,hWnd,104,ADDR BtnTxtMusicOn ; Set text on all of the buttons
					;call uFMOD_Resume
				.elseif MscFlag == 0
					mov MscFlag,1
					Invoke SetDlgItemText,hWnd,104,ADDR BtnTxtMusicOff ; Set text on all of the buttons
					;call uFMOD_Pause
				.endif
			.elseif ax == 115 ;www
				invoke ShellExecute,hWnd,addr lpOperation, addr lpPage, NULL, NULL, SW_SHOWNORMAL
			.endif
		.endif
Wm_10:
		cmp [uMsg],WM_MOUSEWHEEL
		jnz Wm_11
		mov edx, wParam
		; LOWORD is returned in ebx, indicates if virtual key held down
		sar edx, 16
		; HIWORD is returned in edx, +ve value scroll up, -ve down
		 ;.if SDWORD PTR edx < 0
			.if SDWORD PTR edx < 0
				neg edx
				shr edx,3
				sub InfoRect.top,edx	
			.else
				shr edx,3
				add InfoRect.top,edx
			.endif
		ret
Wm_11:
		xor	eax, eax
		ret

DlgProc endp


DrawScene PROC
;THIS PROCEDURE WILL DRAW ALL THE SHIT ON SCREEN
	mov edi, [canvas_buffer]			;clear the bytes in our buffer
	mov ecx,ScreenWidthO * ScreenHeightO
	xor eax,eax
	rep stosd
	mov edi, [canvas_bufferinfo]			;clear the bytes in our buffer
	mov ecx,ScreenWidthO * ScreenHeightO
	xor eax,eax
	rep stosd	
		;invoke SetImg,hTestimg,0,0,0
		call DoPS3
		call DoBalls
		.if InfoFlag != 0
			.if transinfo != 255
				inc transinfo
				;add transinfo,5
			.endif
			call DrawInfoBiatch
		.else
			.if transinfo != 0
				call DrawInfoBiatch
				dec transinfo
				;sub transinfo,5
			.endif
			;.if transinfo < -1
			;	mov transinfo,0
			;.endif
			.if waitfadetext == 1500
				invoke RtlZeroMemory,txtchars0,1000
				mov waittrans,255
			.elseif waitfadetext == 3000
				invoke RtlZeroMemory,txtchars0,1000
				mov waitfadetext,0
				mov waittrans,255
			.elseif waitfadetext < 1500
				invoke SetImgString,hImgtxt,25,55,8,000h,waittrans,addr tststring
			.elseif waitfadetext > 1500
				invoke SetImgString,hImgtxt,25,55,8,000h,waittrans,addr greetstring
			.endif
			inc waitfadetext
			.if waitfadetext > 1200 && waitfadetext < 1500
				.if waittrans != 0
					dec waittrans
						fld speedz2
						fadd fampadd
						fstp speedz2
				.endif
			.elseif waitfadetext > 2700 && waitfadetext < 3000
				.if waittrans != 0
					dec waittrans
						fld speedz2
						fsub fampadd
						fstp speedz2
				.endif
			.endif
		.endif
		add tel,2
		.if tel >= 360
		mov tel,0
		.endif
		;call DoBorderShadow
		cmp fadeb,0
		je @dontdothispls
		dec fadeb
		mov ecx,ScreenWidth
		xor ecx,ecx
		.while ecx <= ScreenWidth
			xor ebx,ebx
			.while ebx <= ScreenHeight
				invoke SPixelTr2,ecx,ebx,0,0,0,fadeb
				inc ebx
			.endw
			inc ecx
		.endw
		@dontdothispls:
		
	xor eax,eax
	invoke BitBlt,hDC, 0, 0, ScreenWidth, ScreenHeight, [canvasDC],0, 0, SRCCOPY
	ret
DrawScene endp

DrawItem PROC hWnd: HWND, lParam: LPARAM
    push esi
    mov esi,lParam
    assume esi: ptr DRAWITEMSTRUCT
    .if [esi].itemState & ODS_SELECTED
		.if [esi].CtlID != 104 ;button for music
			invoke FillRect,[esi].hdc,ADDR [esi].rcItem,hButPressBrush
		.else
			invoke FillRect,[esi].hdc,ADDR [esi].rcItem,hButPressBrushmsc
		.endif
    .else
		.if [esi].CtlID != 104 ;button for music
			invoke FillRect,[esi].hdc,ADDR [esi].rcItem,hButBrush
		.else
			invoke FillRect,[esi].hdc,ADDR [esi].rcItem,hButBrushmsc
		.endif
    .endif

    .if [esi].itemState & ODS_SELECTED
      invoke OffsetRect,ADDR [esi].rcItem,1,1
    .endif
    ; Write the text
    invoke GetDlgItemText,hWnd,[esi].CtlID,ADDR szBtnText,SIZEOF szBtnText
    invoke SetBkMode,[esi].hdc,TRANSPARENT
    invoke SetTextColor,[esi].hdc,00ffffffh
    invoke DrawText,[esi].hdc,ADDR szBtnText,-1,ADDR [esi].rcItem,DT_CENTER 
    assume esi:nothing
    pop esi

    xor eax,eax
    inc eax
    ret
DrawItem ENDP

DlgProchEdit proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
LOCAL hwndHot:HWND
LOCAL NumOfHotkeys:DWORD
LOCAL Count:DWORD
LOCAL hWndSAVE:DWORD
LOCAL Bool1:BYTE
LOCAL Bool2:DWORD
LOCAL Signed:BYTE
LOCAL hWrite:DWORD
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	mov hWndSAVE,eax
	mov Bool1,1
	push eax
	mov ecx,xoptions
	.while ecx < 52
		mov ebx,ecx
		add ebx,1001
		push ecx
		invoke GetDlgItem,hWin,ebx
		;invoke ShowWindow,eax,SW_HIDE
		invoke	EnableWindow,eax,FALSE
		pop ecx
		inc ecx
	.endw
		;invoke GetDlgItem,hWin,1025
		;invoke	EnableWindow,eax,FALSE
	pop eax
	.elseif eax==WM_COMMAND
	mov eax,wParam
		.if eax != 0
			mov edx,wParam
			shr edx,16
			.if dx == BN_CLICKED
				.if ax == 2000
						mov Count,1001
						xor ecx,ecx
							@nexthot:
							push ecx
							invoke SendDlgItemMessage,hWin, Count, HKM_GETHOTKEY, 0, 0
							pop ecx
							cmp al,0
							je @Endofhot
							mov edx,offset HotKeyBuf
							mov byte ptr [edx+ecx],al
							;invoke MessageBox,hWin,addr HotKeyBuf,addr HotKeyBuf,MB_OK
							inc Count
							inc ecx
							jmp @nexthot
							@Endofhot:
							mov NumOfHotkeys,ecx
						invoke CreateFile,addr IniFile,GENERIC_WRITE AND GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
						mov hWrite,eax
						xor eax,eax
						mov al,Bool1
						mov Bool2,eax
						invoke WriteFile,hWrite,addr HotKeyBuf,NumOfHotkeys,addr lpNumberOfBytesWritten,0
						;If the function succeeds, the return value is an open handle to the specified file, device, named pipe, or mail slot.
						invoke CloseHandle,hWrite
						invoke MessageBox,hWin,addr hotkgent,addr hotkgenc,MB_ICONEXCLAMATION
				.endif
			.endif
		
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret
DlgProchEdit endp
end start