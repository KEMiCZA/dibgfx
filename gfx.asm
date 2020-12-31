.data
	ScreenWidth		equ 400
	ScreenHeight	equ 250
	ScreenWidthO	equ 400
	ScreenHeightO	equ 300
	HalfScreenW		equ 180
	HalfScreenH		equ	125
	
    DialogAlign		equ 600
	FontWidth		equ 8
	FontHeigth		equ 6
	FontLength		equ 512
	FontWidthScrol	equ 16
	FontHeigthScrol	equ 20
	FontLengthScrol	equ 896      	
	NumOfPixels		equ 100000
	cong_seed 		dd 380116160

PS3 STRUCT
	MaxBright	BYTE ?
	x			REAL4 ?
	y			REAL4 ?
	Brightness	BYTE ?
	Flag		BYTE ?
	Speed		BYTE ?
	SpeedWait	BYTE ?
	colour		DWORD ?
	Speedz		REAL4 ?
	radius		DWORD ?
	MoveSpeedx	REAL4 ?
	MoveSpeedy	REAL4 ?
	x360		DWORD ?
PS3 ENDS

Ball STRUCT
	x DWORD ?
	y REAL4 ?
	y1 DWORD ?
	z DWORD ?
	speed REAL4 ?
	colour DWORD ?
Ball ends

	include gfx/BmpFrom.inc

.data?
	Seed		dd	 ?
	BallList	dd	 ?
	PS3List		dd	 ?
	
	hFont 				dd 	?
	canvasDC	  		dd	?
	canvasBmp	  		dd	?
    hDC           		dd  	?
	canvas_buffer 		dd	?
	
	canvasDCInfo  		dd	?
	canvasBmpInfo 		dd	?
	canvas_bufferinfo	dd	?
    
	ps		  PAINTSTRUCT	<>
	canvas	  BITMAPINFO	<>
	
	cosa_		dd 1200 dup (?)
	sina_		dd 1200 dup (?)
	sinscrol 	dd 1200 dup (?)
	sinscrolZ 	dd 1200 dup (?)
	sinscrolZ2 	dd 1200 dup (?)
	sinscrolZ3 	dd 1200 dup (?)
	
	;txtchars0	dd 1200 dup (0)
	
.data
	txtchars0	 dd 0
	txtcharswait dd 0
	InfoRect	 RECT <1,0,400,100>
	textRECTc    RECT <250,100,85,60>	 
	textRECToptz  RECT <25,25,500,500>	
	textRECTc2   RECT <4,243,85,60>
	fpsRECT		 RECT <10,10,85,60>
	
	fontname db "Terminal",0
	fnttxt db "ABCDEFGHIJKLMNOPQRSTUVWXYZ ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",0
	fntscrol db "ABCDEFGHIJKLMNOPQRSTUVWXYZ|0123456789*-!o:.,\?-+=$^x()' ",0
	txtchars db " abcdefghijklmnopqrstuvwxyz1234567890.:,;''(!?)+-/=",0
			  
	txtcnt	dd 0
	xtxtf	dd 0
	ytxtf	dd 0
	
	ball_p  db 00,00,00,00		;the balls pallette
			db 255,255,255,00
	ball_g  db 00,01,01,00		;the balls data
			db 01,01,01,01
			db 01,01,01,01
			db 00,01,01,00
			
 	colourmix1 		db 0
	colourmix2 		db 0
	colourmix3 		db 0
	colourmixflag 	db 0
	msc				db 0
	mscd			dd 0

	tel				dd 0
	sizescroltext 	dd 0
	xscrolwait 		db 5
	xscrol			dd 370
	yscrol			dd 0
	starflag		db 0
	starflag2		db 0
	
	PauseMusic 		db 0
	PauseMusicPause db 0
	PauseMusicResume db 1
	
	fadeb			dd 255	
	gradientcounter		dd 0
	gradientcounterf	dd 0
	gradientcounterw	dd 10
	freqbal		real4 12.0
	ampbal		real4 50.0
	balval		real4 0.1
	
	zscrl 		REAL4 20.0	;amp
	amplitude	real4 1.0
	amplitudeADD real4 1.0
	frequency	real4 30.514588411
	PI180		REAL4 0.0174533
	minone		REAL4 -1.0
	vier_		REAL4 4.0
	f2			REAL4 12.0
	PI			REAL4 19.14159
	Pi3			REAL4 3.1415
	f100		Real4 1000.0
	f2n			REAL4 2.0
	
	;InfoRecty	REAL4 0.0
	InfoRecty	dd 0
	InfoRectyf	dd 0
	InfoRectyz	dd 0
	fampadd		REAL4 -0.009
	speedz2		REAL4 1.0
.code

DoBorderShadow PROC
LOCAL colr:DWORD
LOCAL x:DWORD
LOCAL y:DWORD
	pushad
	mov colr,200
	mov ecx,ScreenHeight
	.while ecx > 200
		xor edx,edx
		.while edx < ScreenWidth
		
			invoke SPixelTr2,edx,ecx,5,0,0,colr
			; push ecx
			; neg ecx
			; add ecx,ScreenHeight
			; invoke SPixelTr2,edx,ecx,50,0,0,colr
			; pop ecx
			inc edx
		.endw
		dec ecx
		sub colr,4
	.endw
	popad
	ret
DoBorderShadow ENDP

InitPS3 PROC
LOCAL x:DWORD
LOCAL y:DWORD
LOCAL MaxB:BYTE
LOCAL speed:BYTE
LOCAL colour:DWORD
LOCAL radius:DWORD
LOCAL movespeed:DWORD
LOCAL movespeedy:DWORD
	pushad
	invoke GlobalAlloc,GPTR,NumOfHeart*SIZEOF PS3
	mov PS3List,eax
	mov edi,eax
	assume edi:PTR PS3
	xor ecx,ecx
	.while ecx < NumOfHeart
		pushad
		invoke nrandom,ScreenWidth;+100
		;sub eax,100
		mov x,eax
		invoke nrandom,ScreenHeight;-200
		;add eax,50
		mov y,eax
		popad
		pushad
		@lfgfd:
		invoke nrandom,150
		cmp al,2
		jle @lfgfd
		mov MaxB,al
		popad
		pushad
		@nohehe:
		invoke nrandom,3
		cmp eax,1
		jle @nohehe
		mov speed,al
		popad
		pushad
		@gf6:
		invoke nrandom,0FFFFFFh
		mov colour,eax
		@gf:
		invoke nrandom,25
		cmp eax,2
		je @gf
		mov radius,eax
		popad
		pushad
		@faga:
		invoke nrandom,700
		cmp eax,100
		jle @faga
		mov movespeed,eax
		popad
		pushad
		@fagaz:
		invoke nrandom,700
		cmp eax,100
		jle @fagaz
		mov movespeedy,eax
		popad
		
		fild movespeed
		fdiv f100
		fstp REAL4 ptr [edi].MoveSpeedx
		fild movespeedy
		fdiv f100
		fstp REAL4 ptr [edi].MoveSpeedy
		mov eax,radius
		mov [edi].radius,eax
		mov eax,colour
		mov [edi].colour,eax
		
		fild x
		fstp [edi].x
		fild y
		fstp [edi].y
		;mov eax,x
		;mov [edi].x,eax
		;mov eax,y
		;mov [edi].y,eax
		
		mov [edi].x360,0
		mov al,speed
		mov [edi].Speed,al
		mov al,MaxB
		mov [edi].MaxBright,al
		mov [edi].Flag,0
		mov [edi].SpeedWait,0
		add edi,SIZEOF PS3	;we config the next ball
		inc ecx
	.endw
	assume edi:nothing
	popad
	ret
InitPS3 ENDP

InitBalls PROC
LOCAL x:DWORD
LOCAL y:DWORD
LOCAL z:DWORD
LOCAL speed:DWORD
LOCAL colour:DWORD
	pushad
	invoke GlobalAlloc,GPTR,NumOfBalls*SIZEOF Ball
	mov BallList,eax
	mov edi,eax
	assume edi:PTR Ball
	xor ecx,ecx
	.while ecx < NumOfBalls
		pushad
		hmm:
		invoke nrandom,180
		cmp eax,175
		jl hmm
		mov x,eax
		popad
		pushad
		nozeropls:
		invoke nrandom,50
		cmp eax,0
		je nozeropls
		mov speed,eax
		popad
		pushad
		invoke nrandom,50
		mov y,eax
		popad
		pushad
		invoke nrandom,6
		mov z,eax
		popad
		
		pushad
		invoke nrandom,0FFFFFFh
		mov colour,eax
		popad
		
		mov eax,colour
		mov [edi].colour,eax
		
		mov eax,z
		mov [edi].z,eax
		mov [edi].y,-10
		
		fild y
		fstp [edi].y
		
		mov [edi].y1,eax
		mov eax,x
		mov [edi].x,eax
		
		fild speed
		;fdiv zscrl
		fdiv vier_
		fstp [edi].speed
		add edi,SIZEOF Ball	;we config the next ball
		inc ecx
	.endw
	assume edi:nothing
	popad
	ret
InitBalls ENDP

DoPS3 PROC
LOCAL x:DWORD
LOCAL y:DWORD
LOCAL MaxB:BYTE
LOCAL speed:BYTE
;LOCAL tempcolour:DWORD
LOCAL z:DWORD
LOCAL cv:REAL4
LOCAL sv:REAL4
LOCAL br:DWORD
LOCAL speedz:DWORD
	pushad
	mov edi,PS3List
	assume edi:PTR PS3
	mov esi,offset ball_p
	mov eax,[esi+4]
	xor ecx,ecx
	.while ecx < NumOfHeart
		mov dl,[edi].MaxBright
		.if [edi].Brightness <= 1
			pushad
			invoke nrandom,ScreenWidth;-200
			;add eax,100
			mov x,eax
			invoke nrandom,ScreenHeight;-200
			;add eax,100
			mov y,eax
			popad
			fild x
			fstp [edi].x
			fild y
			fstp [edi].y
			mov [edi].Flag,0
			mov [edi].x360,0
		.elseif [edi].Brightness >= dl ;maxb
			mov [edi].Flag,1
		.endif
		
		.if [edi].Flag == 0
				 fld [edi].y
				 fsub [edi].MoveSpeedy
				 fstp [edi].y
			mov al,[edi].Speed
			.if [edi].SpeedWait == al
				inc [edi].x360
				inc [edi].Brightness
				mov [edi].SpeedWait,0
			.endif
		.else
				 fld [edi].y
				 fsub [edi].MoveSpeedy
				 fstp [edi].y
			mov al,[edi].Speed
			.if [edi].SpeedWait == al
				inc [edi].x360
				dec [edi].Brightness
				mov [edi].SpeedWait,0
			.endif
		.endif
		xor eax,eax
		mov al,[edi].Speed
		mov speedz,eax
		xor eax,eax
		mov eax,[edi].x360
		mov br,eax
		fild br		;cos(angle)
		fdiv PI
		fidiv speedz
		fdiv [edi].MoveSpeedx
		fcos
		fimul [edi].radius
		fmul f2n
		fistp x		;our x
		fild br
		fdiv PI
		fidiv speedz
		fdiv [edi].MoveSpeedx
		fsin
		fimul [edi].radius;sin(angle)
		fistp y		;save y
		inc [edi].SpeedWait
		xor eax,eax
		mov al,[edi].Brightness
		mov br,eax
		fld [edi].x
		fiadd x
		fistp x
		fld [edi].y
		fiadd y
		fistp y
		invoke SPixelTr2,x,y,255,255,255,br
		; inc x
		; invoke SPixelTr2,x,y,150,150,150,br
		add edi,SIZEOF PS3
		inc ecx
	.endw
	popad
	ret
DoPS3 ENDP

DoBalls PROC
LOCAL colour:DWORD
LOCAL z:DWORD
LOCAL y:DWORD
LOCAL tempcolour:DWORD
	pushad
	mov edi,BallList
	assume edi:PTR Ball
	mov ebx,offset ball_p
	mov eax,[ebx+4]
	mov tempcolour,eax
	xor ecx,ecx
	.while ecx < NumOfBalls
		fld [edi].y
		fistp y
		.if y > ScreenHeight
			mov eax,[edi].y1
			mov [edi].y,eax
		.else
			fld [edi].y
			fadd [edi].speed
			fstp [edi].y
		.endif
		mov edx,[edi].x		;edx = x
		;mov esi,mscd
		;shl esi,10
		mov eax,[edi].colour
		;sub eax,esi
		mov [ebx+4],eax
		fld [edi].y
		fdiv freqbal
		fsin
		fmul ampbal
		fmul speedz2
		fdiv [edi].speed
		fistp z
		fild [edi].x
		fdiv freqbal
		fcos
		fmul ampbal
		fmul speedz2
		fmul [edi].speed
		fadd [edi].y
		fistp y
		;add y,edx
		;add z,181 ;half of the screenwi
		;sar edx,1
		add z,edx
		add z,120

		invoke SetBitmapTrans,offset ball_g, offset ball_p,z,y,4,4,0000000h,BallTransparency
		add edi,SIZEOF Ball
		inc ecx
	.endw
	mov eax,tempcolour
	mov [ebx+4],eax
	popad
	ret
DoBalls ENDP

InitScrolTable PROC
LOCAL i:DWORD
LOCAL j:DWORD
	pushad
	mov i,0
	mov edx,offset sinscrol
	mov ebx,offset sinscrolZ
	mov eax,offset sinscrolZ2
	mov esi,offset sinscrolZ3
	.while i <= 1200
		mov ecx,i
		fild i
		fdiv frequency
		FSIN
		fdiv zscrl
		fadd amplitudeADD
		fmul amplitude
		fstp REAL4 ptr [ebx+ecx*4]
		
		fild j
		fmul REAL4 ptr [ebx+ecx*4]
		fistp DWORD ptr [eax+ecx*4]
		
		fild DWORD ptr [edx+ecx*4]
		fdiv REAL4 ptr [ebx+ecx*4]
		fistp DWORD ptr [esi+ecx*4]
				
		inc i
	.endw

	popad
	ret
InitScrolTable endp

sincostable PROC cosa____:DWORD,sina____:DWORD
LOCAL i:DWORD
	pushad
	mov i,0
	.while i <= 1200
		mov edx,cosa____
		mov ebx,i
		shl ebx,2
		fld PI180
		fimul i
		fcos
		;FYL2X
		fstp REAL4 ptr [edx+ebx]

		mov edx,sina____
		mov ebx,i
		shl ebx,2
		fld PI180
		fimul i
		fsin
		fstp REAL4 ptr [edx+ebx]
		
		inc i
	.endw

	popad
	ret
sincostable endp

SPixelTr2 PROC x:DWORD, y:DWORD, r:BYTE, g:BYTE, b:BYTE, alpha:DWORD
LOCAL xy:DWORD
	pushad
	mov edi, [canvas_buffer]
	.if x >= 0 && x < ScreenWidth && y >= 0 && y < ScreenHeight
		mov eax,y
		imul eax,ScreenWidth
		add eax,x
		shl eax,2
		add edi,eax
		mov eax, dword ptr [edi] 	;this contains our current pixel colour
		push edi
		mov edx,eax					;==> VALUE
		RGB r,g,b
		mov ecx,eax					;==> new_pixel
		mov edi,alpha				;==> alpha
		mov esi,100h				;or 256
		mov eax,edx
		mov ebx,ecx
		sub esi,edi
		and eax,0FF00FFh
		and ebx,0FF00FFh
		imul eax,esi
		imul ebx,edi
		add eax,ebx
		mov ebx,edx
		and ebx,0FF00h
		and ecx,0FF00h
		imul ebx,esi
		imul ecx,edi
		add ebx,ecx
		and eax,0FF00FF00h
		and ebx,0FF0000h
		;and edx,0FF000000h
		add eax,ebx
		shr eax,8h
		;add eax,edx
		pop edi
		mov dword ptr [edi], eax	;Put our transparent pixel
	.endif
	popad
	ret
SPixelTr2 endp

SPixel PROC x:DWORD, y:DWORD, colour:DWORD
	pushad
	mov	edi, [canvas_buffer]
	.if x >= 0 && x < ScreenWidth && y >= 0 && y < ScreenHeight
		mov eax,y
		imul eax,ScreenWidth
		add eax,x
		shl eax,2
		add edi,eax
		mov eax,colour
		mov dword ptr [edi],eax
	.endif
	popad
	ret
SPixel endp

SetBitmap PROC parray:DWORD, palette:DWORD, x_position:DWORD, y_position:DWORD, p_width:DWORD, p_height :DWORD, p_trans:DWORD
LOCAL colour:DWORD
LOCAL red:BYTE
LOCAL blue:BYTE
LOCAL green:BYTE
LOCAL x:DWORD
LOCAL y:DWORD
LOCAL pld:DWORD
LOCAL nrnd:DWORD
	;//////////////////generate our colour overlay//////////////////
	.if colourmixflag == 0
		.if colourmix1 < 255
			inc colourmix1
		.elseif colourmix2 < 255 && colourmix1 > 250
			inc colourmix2
		.elseif colourmix3 < 255 && colourmix2 > 250 && colourmix1 > 250
			inc colourmix3
		.endif
	.elseif
		.if colourmix3 > 0
			dec colourmix3
		.elseif colourmix2 > 0 && colourmix3 < 5
			dec colourmix2
		.elseif colourmix1 > 0 && colourmix2 < 5 && colourmix3 < 5
			dec colourmix1
		.endif
	.endif 
	
	.if colourmix3 == 254
		mov colourmixflag,1
	.elseif colourmix1 == 1
		mov colourmixflag,0
	.endif
	;//////////////////generate our colour overlay//////////////////
	
	pushad                            ; Save all registers.
	xor ebx,ebx;ebx = y
	xor ecx,ecx;ecx = x
                    
	mov esi,parray 
	mov edx,palette          		  ; edx = pointer to raw pallete data.

	.while ebx < p_height
		mov eax,ebx
		imul eax,p_width
		add eax,ecx
		movzx eax,byte ptr [esi+eax]
		mov eax,[edx+eax*4]               ; Move the indexed palette color into eax.
		mov colour,eax
		
		.if eax != p_trans
			add ecx,x_position
			add ebx,y_position
			mov x,ecx
			mov y,ebx
			.if mscd < 3
				mov mscd,3
			.endif
				mov eax,mscd
				mov pld,eax
				pushad
				mov ebx,pld
				call GetRndmNbr
				shr eax,1
				mov pld,eax
				mov ebx,2
				call GetRndmNbr
				mov nrnd,eax
				popad
				push ecx
				push ebx
				.if nrnd == 1
					sub ecx,pld
					add ebx,pld
				.else
					add ecx,pld
					;sub ebx,pld
				.endif 
				invoke SPixel,ecx,ebx,colour
				invoke SPixelTr2,ecx,ebx,colourmix1,20,colourmix3,50
				
				pop ebx
				pop ecx
			@la:
			sub ecx,x_position
			sub ebx,y_position
		.endif
		
		inc ecx
		
		.if ecx >= p_width 
			inc ebx
			xor ecx,ecx
		.endif
	.endw

    popad                             ; Restore all registers.
    ret                               ; Exit the function.

SetBitmap endp

SetBitmapTrans PROC parray:DWORD, palette:DWORD, x_position:DWORD, y_position:DWORD, p_width:DWORD, p_height :DWORD, p_trans:DWORD, t:DWORD
LOCAL x		:DWORD
LOCAL y		:DWORD
LOCAL red	:BYTE
LOCAL green	:BYTE
LOCAL blue	:BYTE
	pushad                            ; Save all registers.
	xor ebx,ebx;ebx = y
	xor ecx,ecx;ecx = x
	
	mov esi,parray 
	mov edx,palette          		  ; edx = pointer to raw pallete data.

	.while ebx < p_height
	
		mov eax,x_position
		add eax,ecx
		mov x,eax
		
		mov eax,y_position
		add eax,ebx
		mov y,eax
	
		mov eax,ebx
		imul eax,p_width
		add eax,ecx
		movzx eax,byte ptr [esi+eax]
		mov eax,[edx+eax*4]               ; Move the indexed palette color into eax.
		.if eax != p_trans && x >=0 && x <= ScreenWidth && y >=0 && y <= ScreenHeight
				mov red,al  ; red
				ror eax,8
				mov green,al
				ror eax,8
				mov blue,al
			add ecx,x_position
			add ebx,y_position
			invoke SPixelTr2,ecx,ebx,red,green,blue,t
			sub ecx,x_position
			sub ebx,y_position;
			.endif		
		inc ecx
		.if ecx >= p_width 
			inc ebx
			xor ecx,ecx
		.endif
	.endw		
   popad                             ; Restore all registers.
   ret                               ; Exit the function.
SetBitmapTrans endp


InitRndmNbr PROC
		push ecx
		push edx

		invoke GetTickCount
		test eax,eax		; ) to be sure it's not zero (it's possible ! if you launch the program 48 days after you've started the computer, lol)
		jnz Label1		; ) (and depending of the radom number routine, some really don't like zeros...)
		mov eax,123456789	; )
Label1:	mov Seed,eax		; save the seed

		pop edx
		pop ecx
	ret
InitRndmNbr ENDP

GetRndmNbr PROC
		push edx
		mov eax,987654321	; a x value
		mul Seed			; multiply eax by your Seed
		;bswap eax			; swap bytes (to not have a too easy suit)
		xor eax,078787878h	; apply a mask
		mov Seed,eax		; save the new RndmNbr as Seed, for next use
; a range ?
		inc ebx
		jz Label2			; if not jump Label2
; here a range :
		mul ebx			; mul by range+1
		mov eax,edx		; return the result in eax
; exit
Label2:	dec ebx			; restore ebx

		pop edx
	ret
GetRndmNbr ENDP

SetImg PROC hImg:DWORD, x:DWORD, y:DWORD, trans:DWORD;, tr:BYTE
 LOCAL Widthi:DWORD
 LOCAL Heighti:DWORD
 ;LOCAL Sizebmp:DWORD
 LOCAL BytesWidth:DWORD
	pushad						;save reg stack
	mov edx,hImg				;edx = base img	
	mov eax,dword ptr [edx+12h]	;edx+12h = width		
	mov Widthi,eax
	mov eax,dword ptr [edx+16h]	;edx+16h = height
	mov Heighti,eax
	;mov eax,dword ptr [edx+22h]	;edx+22h = size of data img
	;mov Sizebmp,eax
	;mov eax,dword ptr [edx+1Eh] ; No compression
	add edx,36h					; Start of our img data
	mov eax,3					; Calculate the amount of bytes horizontally per line
	imul eax,Widthi 			; eax = 4*Width
	mov BytesWidth,eax			; eax = BytesWidth
	push edx					;Determine the modulo
	xor edx,edx					;used for 4byte alignment
	mov eax,Widthi				;-
	mov ecx,4					;-
	div ecx						;
	add BytesWidth,edx			;
	pop edx						;
	mov ecx,Heighti
	.while ecx > 0				
		xor ebx,ebx
		xor esi,esi
		.while ebx < Widthi
			mov eax,dword ptr [edx+esi]
			;dec ecx
			.if eax != trans
				push ebx
				push ecx
				add ebx,x
				add ecx,y
				push edx
				invoke SPixel,ebx,ecx,eax;x,y,color
				mov eax, offset Gradient
				mov edx, gradientcounter
				mov eax, [eax+edx*4]
				mov edx,eax
				shr eax,8
				invoke SPixelTr2,ebx,ecx,dh,dl,ah,10
				pop edx
				pop ecx
				pop ebx
			.endif
			;invoke SPixelTr2,ebx,ecx,clr1,clr2,clr3,255
			;inc ecx
			add esi,3
			inc ebx
		.endw
		add edx,BytesWidth			;http://en.wikipedia.org/wiki/BMP_file_format
		dec ecx
	.endw
	.if gradientcounter == ScreenHeight-70
		mov gradientcounterf,1
	.elseif gradientcounter == 0
		mov gradientcounterf,0
	.endif
	
	.if gradientcounterw == 10
		.if gradientcounterf == 0
			inc gradientcounter
		.else
			dec gradientcounter
		.endif
		mov gradientcounterw,0
	.endif
	add gradientcounterw,2
	popad;load reg stack
	ret	
SetImg ENDP

SetImgTr PROC hImg:DWORD, x:DWORD, y:DWORD, trans:DWORD, tr:DWORD
 LOCAL Widthi:DWORD
 LOCAL Heighti:DWORD
 LOCAL BytesWidth:DWORD
 LOCAL clr1:BYTE 
 LOCAL clr2:BYTE
 LOCAL clr3:BYTE
	pushad						;save reg stack
	mov edx,hImg				;edx = base img	
	mov eax,dword ptr [edx+12h]	;edx+12h = width		
	mov Widthi,eax
	mov eax,dword ptr [edx+16h]	;edx+16h = height
	mov Heighti,eax
	add edx,36h					; Start of our img data
	mov eax,3					; Calculate the amount of bytes horizontally per line
	imul eax,Widthi 			; eax = 4*Width
	mov BytesWidth,eax			; eax = BytesWidth
	push edx					;Determine the modulo
	xor edx,edx					;used for 4byte alignment
	mov eax,Widthi				;-
	mov ecx,4					;-
	div ecx						;
	add BytesWidth,edx			;
	pop edx						;
	mov ecx,Heighti
	.while ecx > 0				
		xor ebx,ebx
		xor esi,esi
		.while ebx < Widthi
			mov eax,dword ptr [edx+esi]
			;dec ecx
			.if eax != trans
				push ebx
				push ecx
				push edx
				add ebx,x
				add ecx,y
				mov edx,eax
				shr eax,8
				invoke SPixelTr2,ebx,ecx,dl,dh,ah,tr
				pop edx
				pop ecx
				pop ebx
			.endif
			add esi,3
			inc ebx
		.endw
		add edx,BytesWidth			;http://en.wikipedia.org/wiki/BMP_file_format
		dec ecx
	.endw
	ret
	popad					;load reg stack
SetImgTr ENDP

SetImgString PROC hImg:DWORD, x:DWORD, y:DWORD, charwidth:DWORD, skipcolor:DWORD, tr:DWORD, pString:DWORD
;pString 
LOCAL xr:DWORD
LOCAL yr:DWORD
LOCAL slen:DWORD
LOCAL sinyy:DWORD
LOCAL sinxy:DWORD
LOCAL sinyx:DWORD
LOCAL sinxx:DWORD
	pushad
	mov xr,0
	mov yr,0
	mov ebx,offset txtchars
	mov edx,pString
	mov slen, SIZEOF pString
	xor ecx,ecx
	.while ecx < 1000 ;assume we have a max 1000 char string
		mov al,byte ptr [edx+ecx] ;al holds our current character to print on screeeeenz
		cmp al,0 ;if we reach the end of our string then we're finished
		je @endcharimg__
		.if al == 0ah ;if we approach end of line
			add yr,13 ;inc y pos, charheight
			mov xr,0
			jmp @nextchar2__
		.endif
		xor esi,esi
		.while esi < 51 ;51 different character choices
			mov ah,byte ptr [ebx+esi]
			.if ah == al
				push eax
				push edx
				push ebx
				mov edi,xr
				add edi,x
				mov eax,yr
				add eax,y
				mov edx,txtchars0
				mov ebx,dword ptr [edx+ecx*4]
				.if esi != ebx
					inc txtcharswait
					;invoke SetImgChar,hImg,edi,eax,esi,8,skipcolor,tr
					.if txtcharswait == 10
						inc dword ptr [edx+ecx*4]
						mov txtcharswait,0
					.endif
				.endif
				inc ebx
				mov sinyy,eax
				mov sinxy,edi
				fild sinxy
				fiadd tel
				fmul PI180
				fsin
				fmul f2n
				fmul f2n
				fmul f2n
				fiadd sinyy
				fistp sinyy
				mov sinyx,eax
				mov sinxx,edi
				fild sinyx
				fiadd tel
				fmul PI180
				fsin
				fmul f2n
				fmul f2n
				fiadd sinxx
				fistp sinxx
				mov edi,sinxx
				mov eax,sinyy
				invoke SetImgChar,hImg,edi,eax,ebx,8,skipcolor,tr
				pop ebx
				pop edx
				pop eax
				jmp @nextchar__
			.endif
			inc esi
		.endw
@nextchar__:
		add xr,8 ;inc x pos for next char
@nextchar2__:		
		inc ecx
	.endw
@endcharimg__:
	;inc txtcharswait
	popad
	ret
SetImgString ENDP

SetImgChar PROC hImg:DWORD, x:DWORD, y:DWORD, charn:DWORD, charwidth:DWORD, skipcolor:DWORD, tr:DWORD
;Used to put a character from a bmp file on the canvas
;You need to supply the height and width of ratio between every char
;charn >= 1, defines what character we're going to use, the first,second,third,etc
 LOCAL Widthi:DWORD
 LOCAL Heighti:DWORD
 ;LOCAL Sizebmp:DWORD
 LOCAL BytesWidth:DWORD
 LOCAL xmin:DWORD
 LOCAL xmax:DWORD
	pushad
	;hTestimg, check BITMAPHEADERFILE
	dec charn
	mov eax,charn
	imul eax,charwidth
	mov xmin,eax
	add eax,charwidth
	mov xmax,eax
	mov edx,hImg				;edx = base img	
	mov eax,dword ptr [edx+12h]	;edx+12h = width		
	mov Widthi,eax
	mov eax,dword ptr [edx+16h]	;edx+16h = height
	mov Heighti,eax
	add edx,36h					; Start of our img data
	mov eax,3					; Calculate the amount of bytes horizontally per line
	imul eax,Widthi 			; eax = 4*Width
	mov BytesWidth,eax			; eax = BytesWidth
	push edx					;Determine the modulo
	xor edx,edx					;used for 4byte alignment
	mov eax,Widthi
	mov ecx,4
	div ecx
	add BytesWidth,edx
	pop edx
	mov ecx,Heighti
	.while ecx > 0
		xor ebx,ebx
		xor esi,esi
		.while ebx < Widthi
			.if ebx >= xmin && ebx < xmax
				mov eax,dword ptr [edx+esi]
				dec ecx
				mov edi,eax
				shr edi,8
				.if edi != skipcolor
					push ebx
					push ecx
					push edx
					sub ebx,xmin
					add ebx,x
					add ecx,y
					mov edx,eax
					shr eax,8
					invoke SPixelTr2,ebx,ecx,dl,dh,ah,tr
					pop edx
					pop ecx
					pop ebx
				.endif
				inc ecx
			.endif
			add esi,3
			inc ebx
		.endw
		add edx,BytesWidth			;http://en.wikipedia.org/wiki/BMP_file_format
		dec ecx
	.endw
	popad
	ret
SetImgChar ENDP

CreateGradient PROC
LOCAL red:BYTE
LOCAL green:BYTE
LOCAL blue:BYTE
	pushad
	mov edi,offset Gradient
	xor ecx,ecx
	xor edx,edx
	mov ebx,0FF0000h
	mov red,0FFh
	mov green,0
	mov blue,0
	.while ecx < ScreenHeight
		 ; .if ecx < 100
		.if ecx < 36
			add blue,7
		.elseif ecx > 36 && ecx < 72
			sub red,7
		.elseif ecx > 72 && ecx < 108
			add green,7
		.elseif ecx > 108 && ecx < 144
			sub blue,7
		.elseif ecx > 144 && ecx < 180
			add red,7
		.elseif ecx > 180 && ecx < 216
			sub green,7
		.endif
			;mov eax,ecx
			;add ebx,eax
			RGB red,green,blue
			mov dword ptr [edi+ecx*4],eax
		 ; .elseif ecx < 200 && ecx > 100
			; mov ebx,00FF00h
			; mov eax,ecx
			; add ebx,eax
			; mov dword ptr [edi+ecx*4],ebx
		; .elseif ecx > 300
			; mov ebx,00FFh
			; mov eax,ecx
			; add ebx,eax
			; mov dword ptr [edi+ecx*4],ebx
		; .endif
		inc ecx
	.endw
	popad
	ret
CreateGradient Endp

DrawInfoBiatch PROC
LOCAL rndx:DWORD
LOCAL rndy:DWORD
LOCAL crap:DWORD
	mov rndx,0
	mov rndy,0
	Invoke DrawText, [canvasDCInfo], InfoPointer, -1, addr InfoRect, DT_NOCLIP OR DT_NOPREFIX ;options text
	mov edi,[canvas_bufferinfo]
	mov esi,offset Gradient
	xor ecx,ecx
	xor ebx,ebx
	.while ecx < ScreenHeight
		mov eax,ecx
		imul eax,ScreenWidth
		add eax,ebx	
		shl eax,2 ;(y*screenwidth+x)*4
		.if dword ptr [edi+eax] == 00FFFFFFh
			mov eax,dword ptr [esi+ecx*4]
			;invoke SPixel,ebx,ecx,eax
			pushad
			mov eax,transinfo
			sub eax,255
			neg eax
			.if eax != 0
				push eax
				invoke nrandom,eax
				mov rndx,eax
				pop eax
				invoke nrandom,eax
				sub eax,rndx
				mov rndy,eax
				sub eax,rndy
				mov rndx,eax
			.endif
			popad
			push ebx
			push ecx
			add ebx,rndx
			add ecx,rndy
			mov edx,eax
			shr edx,8
			invoke SPixelTr2,ebx,ecx,dh,ah,al,transinfo
			inc ebx
			inc ecx
			.if transinfo > 250
				invoke SPixel,ebx,ecx,0
			.endif
			pop ecx
			pop ebx
		.endif
		inc ebx
		.if ebx == ScreenWidth
			xor ebx,ebx
			inc ecx
		.endif
	.endw
	
	mov eax,traineractivef
	.if eax == hDlg
		invoke GetAsyncKeyState,VK_UP
		.if eax !=0
			;.if InfoRect.top >= 5
					add InfoRect.top,2
				;inc InfoRect.top
			;.endif
		.else
			.if InfoRectyf == 0
				mov InfoRectyz,0
			.endif
		.endif
		invoke GetAsyncKeyState,VK_DOWN
		.if eax!=0
			mov ebx,InfoLen
			;.if InfoRect.top != ebx
				sub InfoRect.top,2
			;.endif
		.endif
	.endif
	
	mov ebx,InfoLen
	.if SDWORD ptr InfoRect.top > 0
		mov InfoRect.top,0
	.elseif SDWORD ptr InfoRect.top < ebx
		mov InfoRect.top,ebx
	.endif
		ret
DrawInfoBiatch ENDP
