      ;.486                                      ; create 32 bit code
          .XMM
      .model flat, stdcall                      ; 32 bit memory model
      option casemap :none                      ; case sensitive
	 
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
;include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
include \masm32\include\comctl32.inc
;include \masm32\include\commctrl.inc

includelib \masm32\lib\winmm.lib
      include \masm32\include\dialogs.inc       ; macro file for dialogs
      include \masm32\macros\macros.asm         ; masm32 macro file
          includelib \masm32\lib\gdi32.lib
     includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\Comctl32.lib
      includelib \masm32\lib\comdlg32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\oleaut32.lib
      includelib \masm32\lib\ole32.lib
      includelib \masm32\lib\msvcrt.lib
	  include \masm32\include\msvcrt.inc

	  include \masm32\include\Ws2_32.inc
includelib \masm32\lib\Ws2_32.lib
 
 include \masm32\include\ntoskrnl.inc
 includelib \masm32\lib\ntoskrnl.lib

 ;include \masm32\include\win32k.inc
 ;includelib \masm32\lib\win32k.lib

 COMMENT @
 To Do List:

 1. Animate player with sprite
 2. Put hitting sounds for player and zombie
 3. Put Options!!
 4. Put You Lose screen when player dies
 5. Put a selection of characters with different abillities
 6. Make new shop background and to be able to actually buy guns with different attributes
 7. ".	.	."

 @
.const
WM_SOCKET equ WM_USER+100
JMP_HEIGHT equ 50
JMP_SPEED equ 8
VEL_X equ 6
VEL_Y equ 6
RECT_WIDTH_BACKUP       equ     60
RECT_HEIGHT_BACKUP    equ     40
WINDOW_WIDTH    equ     1000
WINDOW_HEIGHT   equ     650
RIGHT   equ     1
DOWN    equ     2
LEFT    equ     3
UP      equ     4
VELpos  equ     3
VELneg  equ -3
MAIN_TIMER_ID equ 0
ShootingTime equ 1
ZombieTime      equ     2
ZombieAdjust equ 3
RoundEnded	equ	4
secondtimer	equ	5
Zombie_Height equ 50
Zombie_Width equ 40
Bullet_Height equ 25
Bullet_Width equ 50
Coin_Height	equ	30
Coin_Width	equ	30
Health_Pack_Width	equ	50
Health_Pack_Height	equ	65
ChanceToDropHealthPack	equ	7
Space_Between_Player_Width	equ 64
Space_Between_Player_Height	equ	52
LengthofLeaf equ 12
Distance_Between_Zombie_And_Player equ 300
.data
expectingip	db 'I am now expecting IP',0

PlayerInformation	STRUCT
x	DWORD	  200	
y	DWORD     400
CURRENTFACING	DWORD	130
CURRENTSTEP	DWORD	0
TimeStepShouldDisappear	DWORD	?
Time_Between_Steps_P	DWORD	75;In MilliSeconds
CURRENTACTION	HBITMAP	?
CURRENTACTIONMASK	HBITMAP	?
speed	DWORD	6
PlayerInformation ENDS

Player	PlayerInformation<>
Player2	PlayerInformation<400,400,?,?,?,?,?,?,?>
 deadmsg BYTE "You Have Been Eaten By My Lovely Zombies",0dh,0ah,0dh,0dh,0dh,"You Tried	 .	 .	 .",0dh,0ah,0dh,"That's Something	.	.	.",0
 deadcaption BYTE "Game Over",0
 Found	DWORD	0
 FoundForSound	DWORD	0
 Number_To_Spawn DWORD	1
 zombiebr	HBITMAP	0
RECT_WIDTH       DWORD    40
RECT_HEIGHT       DWORD    60
RECT_WIDTH2       DD     30
RECT_HEIGHT2       DD     20
PlayerX DWORD   200
PlayerX2 DWORD   600
PlayerY DWORD   400
PlayerY2 DWORD   400
ClassName       DB      "TheClass",0
windowTitle     DB      "A Game!",0
msgB db "I GOT INTO HERE",0
caption db "HELP MEH!",0
jmpingDown db 0
jmpingDown2 db 0
jmpingUp db 0
jmpingUp2 db 0
StartY DWORD ?
StartY2 DWORD ?
dstY DWORD ?
dstY2 DWORD ?
path db "IDB_myimg",0
bullets DWORD 1000 dup(-999)
enemybullets	DWORD 1000 dup(-999)
zombies DWORD 2000 dup(-999)
coins DWORD	1000	dup(-999)
Packs	DWORD	1000	dup(-999)
Zombie_Spawning_Time DWORD 1000
BulletX DWORD   ?
BulletY DWORD   ?
ZombieX DWORD   ?
ZombieY DWORD   ?
ShootX  DWORD   ?
ShootY  DWORD   ?
VELFINALX       DWORD   ?
VELFINALY       DWORD   ?
buffer DWORD 20 dup(0)
buffer2 DWORD 3 dup(0)
 VEL REAL4 10.0
 VELZ REAL4 4.0
 ADDINGZ REAL4 0.2
 threepointzero	REAL4	30.0
 WINPLACE WINDOWPLACEMENT       <>
 Player_Life	DWORD 500
 randombuffer   DWORD   ?
 ZombStartY DWORD       ?
 ZombStartX DWORD       ?
 savingnewzombieplace   DWORD   ?
 icursor	HCURSOR		?
 hCoinColour	HBITMAP ?
 hCoinMask	HBITMAP	?
 hHealthPackColour	HBITMAP	?
 hHealthPackMask	HBITMAP	?
 Money	DWORD	0
 NewGame	HBITMAP	?
 NewGameMasked	HBITMAP	?
 Options	HBITMAP	?
 OptionsMasked	HBITMAP	?
 Exiting	HBITMAP	?
 ExitingMasked	HBITMAP	?
 StartScreenBK HBITMAP	?
 StartScreenState	DWORD	1
 HighlightBIT	HBITMAP	?
 HighlightBITMasked HBITMAP	?
 Highlight	DWORD	0
 FramesSinceLastClick	DWORD	0
 SoundPath	BYTE	"shootsound.wav",0
 ;SoundPathBite	BYTE	"bite.wav",0
 volume	DWORD	003f003fh
 ;volumebite	DWORD 5fff5fffh
 Time_Between_Steps	DWORD	500;In Milliseconds
 Store	DWORD	0
 TimeTillRoundEnds	DWORD	120000
 cost	HBITMAP	?
 costMasked	HBITMAP	?
 StoreBK	HBITMAP	?
 score	HBITMAP	?
 scoreMasked	HBITMAP	?
 scoreNum	DWORD	0
 MyFont	HFONT	?
 scoreBuffer	BYTE	100 dup(0)
 timeBuffer BYTE	100	dup(0)
 doubledot BYTE	":"
 realtimetillend	DWORD	120
 AnimClassName	BYTE	"ANIMATE_CLASS",0
 AnimWindowName	BYTE	"theAnimWinName",0
 angle DWORD 2 dup(?)
 realangle	DWORD	?
 anglePlayer	DWORD	2 dup(?)
 realanglePlayer	DWORD	?
 selectedimgz HBITMAP	?
 selectedimgzMask	HBITMAP	?
 selectedimg	DWORD	?
 Leftz HBITMAP	?
 LeftzMask	HBITMAP	?
  Rightz HBITMAP	?
 RightzMask	HBITMAP	?
  Frontz HBITMAP	?
 FrontzMask	HBITMAP	?
  Backz HBITMAP	?
 BackzMask	HBITMAP	?
 hWalk	HBITMAP	?
 hWalkMask	HBITMAP	?
 OptionScreenhbitmap HBITMAP ?
 sprintmeter	DWORD	500
 OptionsBOOL	BYTE	0
 STATUS	BYTE	0
 offsetToEndofArray	dword	?
 leaf STRUCT
 location POINT <0,0>
 priority dd	?
 leaf ENDS

queueArr DWORD (WINDOW_WIDTH*WINDOW_HEIGHT/80) dup(0)


sin sockaddr_in <>
clientsin sockaddr_in <>
IPAddress db "212.179.222.94",0 
Port dd 30001                    
text db "placeholder",0
textoffset DWORD ?
pleaseconnectus db "please connect us!!!",0
doyouwanttoconnect db "Yes do you want to connect with your friend?",0
yesiamsure db "yes i am sure",0
get_ready_for_ip db "Get ready for IP.",0
expecting_IP db FALSE
expecting_PORT db FALSE
wsadata WSADATA <>
clientip db 20 dup(0)
clientport dd 0





infobuffer db 1024 dup(0)
hMemory db 100 dup(0)                ; handle to memory block 
buffer_for_sock db 1024 dup(0)                       ; address of the memory block 
available_data db 1024 dup(0)        ; the amount of data available from the socket 
actual_data_read db 1024 dup(0)    ; the actual amount of data read from the socket 
connected_to_friend db FALSE
sock DWORD ?
captionyesiwanttoconnect	db 'yes i am sure',0
host	db	FALSE
you_are_host db 'You are the host!!!',0
you_are_not_host db 'You are not the host!!!',0
iamhost db 'I am the host',0
iamnothost db 'I am NOT the host',0
recievingzombies db 'I am RECIEVING zombies',0
sendingzombies db 'I am SENDING zombies',0
recievingbullets db 'I am RECIEVING bullets',0
recievingxy db 'I am RECIEVING xy',0
connectedtopeer db 'I am now CONNECTED TO PEER',0
irecievedsomething db 'I recieved SOMETHING',0
createbulleting db 'I am creating a bullet',0
sendingxy	db 'I am SENDING xy'
buffer_for_strings db 100 dup(0)
buffer_for_FPU db 1000 dup(0)
player2_health_to_add DWORD 0
Online HBITMAP	?
OnlineMask HBITMAP	?
two_Players BYTE FALSE
not_two_players db 'Other player disconnected',0
Waiting_cut_x DWORD 0
Waiting_zomb_x DWORD 50
Waiting_zomb_y DWORD 200
Time_Between_Steps_waiting DWORD 75 ;In milliseconds
Time_Step_Should_End DWORD ?
WaitingScreenBMP HBITMAP ?
WaitingScreenBMPMask HBITMAP ?
Waiting_player_x DWORD -Distance_Between_Zombie_And_Player
Waiting_player_cut_x DWORD 0
Waiting_player_y DWORD 200
Time_Step_Should_End_Player DWORD ?
Time_Between_Steps_waiting_player DWORD 75
xForm XFORM <>
sin_angle_world REAL4 0.866
cos_angle_world	REAL4 0.5
minus_sin_angle_world REAL4 -0.5
ZeroPointZero REAL4 0.0
OnePointZero REAL4 1.0
normal_xForm XFORM <>
Minus1 REAL4 -1.0
ArrowBMP HBITMAP ?
ArrowBMPMask HBITMAP ?
.code

 sendlocation PROC, paramter:DWORD
	local send_what:BYTE
	mov send_what,0
	again:
	mov ebx, offset infobuffer
	cmp send_what,0
	jne nosendplayer

	;cmp host,TRUE
	;je no_need_to_debug_sending
	;invoke MessageBox,0,offset sendingxy,offset sendingxy,MB_OK
	;no_need_to_debug_sending:

	mov byte ptr [ebx],0
	inc ebx

	
	mov eax, Player.x
	mov [ebx], eax
	add ebx, 4

	mov eax, Player.y
	mov [ebx], eax
	add ebx, 4

	mov eax,Player.CURRENTFACING
	mov [ebx], eax
	add ebx, 4
	
	mov eax,Player.CURRENTSTEP
	mov [ebx], eax
	add ebx, 4
	
	mov eax,Player.CURRENTACTION
	mov [ebx], eax
	add ebx, 4

	mov eax,Player.CURRENTACTIONMASK
	mov [ebx], eax
	add ebx,4

	push ebx
	invoke RtlMoveMemory,ebx,offset bullets,24*40
	pop ebx
	add ebx,24*40

	cmp host,FALSE
	je nosend_health_and_score

	mov eax,scoreNum
	mov [ebx],eax
	add ebx,4

	mov eax,player2_health_to_add
	mov dword ptr [ebx],eax
	mov player2_health_to_add,0
	nosend_health_and_score:
		
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	jmp endofsendlocation
	nosendplayer:

	cmp send_what,1
	jne nosendbullets

	
	mov byte ptr [ebx],1
	inc ebx
	push ebx
	mov esi,offset bullets
	add esi,24*40
	invoke RtlMoveMemory ,ebx,esi,24*40
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	pop ebx
	jmp endofsendlocation

	nosendbullets:

	cmp host,FALSE
	je nosendzombies
	cmp send_what,2
	jne nosendzombies

	mov byte ptr [ebx],2
	inc ebx
	invoke RtlMoveMemory ,ebx,offset zombies,25*36
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	;invoke MessageBox,0,offset sendingzombies,offset sendingzombies,MB_OK
	
	jmp endofsendlocation
	nosendzombies:

	cmp host,FALSE
	je nosendzombies2
	cmp send_what,3
	jne nosendzombies2
	mov byte ptr [ebx],3
	inc ebx
	mov esi,offset zombies
	add esi,25*36
	invoke RtlMoveMemory,ebx,esi,25*36
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	


	jmp endofsendlocation
	nosendzombies2:
	

	cmp host,FALSE
	je nosendpacks
	cmp send_what,4
	jne nosendpacks

	mov byte ptr [ebx],4
	inc ebx

	invoke RtlMoveMemory,ebx,offset coins,50*12
	add ebx,50*12
	invoke RtlMoveMemory,ebx,offset Packs,10*16
	invoke sendto,sock, offset infobuffer, 1024, 0, offset clientsin, sizeof clientsin
	jmp endofsendlocation
	nosendpacks:

	endofsendlocation:
	cmp host,FALSE
	je different_inc
	;---------increment-----------------
	inc send_what
	cmp send_what,4
	jng no_need_to_reset1
	mov send_what,0
	no_need_to_reset1:
	;---------increment-----------------
	jmp real_endofsendlocation
	different_inc:
	;---------increment-----------------
	inc send_what
	cmp send_what,1
	jng no_need_to_reset2
	mov send_what,0
	no_need_to_reset2:
	;---------increment-----------------

	real_endofsendlocation:
	invoke Sleep,3
	jmp again

	ret
sendlocation ENDP

getParent PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,LengthofLeaf
xor edx,edx
idiv ebx
mov ebx,2
xor edx,edx
idiv ebx
mov ebx,LengthofLeaf
imul ebx
;================================================================================
ret
getParent ENDP

getLeftChild	PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,2
imul ebx
;================================================================================
ret
getLeftChild ENDP

getRightChild	PROC,index:DWORD
;--------------------------------------------------------------------------------
mov eax,index
mov ebx,2
imul ebx
add eax,LengthofLeaf
;================================================================================
ret
getRightChild	ENDP

switch_leafs PROC,to:DWORD,from:DWORD
;--------------------------------------------------------------------------------
local temp:DWORD
local tempto:DWORD
local tempfrom:DWORD
mov ebx,offset queueArr
add ebx,to

mov esi,offset queueArr
add esi,from


mov eax,[ebx]
mov temp,eax
mov eax,[esi]
mov [ebx],eax
mov eax,temp
mov [esi],eax

mov eax,[ebx+4]
mov temp,eax
mov eax,[esi+4]
mov [ebx+4],eax
mov eax,temp
mov [esi+4],eax

mov eax,[ebx+8]
mov temp,eax
mov eax,[esi+8]
mov [ebx+8],eax
mov eax,temp
mov [esi+8],eax

;================================================================================
ret
switch_leafs ENDP

insertPriority PROC,x:DWORD,y:DWORD,priority:DWORD
;--------------------------------------------------------------------------------
mov ebx,offsetToEndofArray
mov eax,x
mov [queueArr+ebx],eax
mov eax,y
mov [queueArr+ebx+4],eax
mov eax,priority
mov [queueArr+ebx+8],eax

checkagainifparentsmaller: 
cmp ebx,LengthofLeaf
jle  noswitch
push ebx
invoke getParent,ebx
pop ebx
mov ecx,[queueArr+eax+8]
mov esi,priority
cmp ecx,esi;if parent_priority<=priority_inserted ==> noswitch:
jle noswitch

push eax
invoke switch_leafs,eax,ebx
pop eax
mov ebx,eax
jmp checkagainifparentsmaller
noswitch:
add offsetToEndofArray,LengthofLeaf
;================================================================================
ret
insertPriority	ENDP

removeMax	PROC,lppt:DWORD
;--------------------------------------------------------------------------------

cmp offsetToEndofArray,LengthofLeaf
je endofremoveMax
mov esi,LengthofLeaf
mov eax,[queueArr+esi]
mov ebx,lppt
mov dword ptr [ebx],eax
mov eax,[queueArr+esi+4]
mov dword ptr [ebx+4],eax

pusha
mov esi,offsetToEndofArray
sub esi, LengthofLeaf
invoke switch_leafs,LengthofLeaf,esi
popa
mov esi,offsetToEndofArray
sub esi,LengthofLeaf
mov queueArr[esi],0
mov queueArr[esi+4],0
mov queueArr[esi+8],0
sub offsetToEndofArray,LengthofLeaf

mov esi,LengthofLeaf

checkagain:
invoke getLeftChild,esi
cmp eax,offsetToEndofArray
jge endofremoveMax
mov edi,eax
mov ebx,offset queueArr
add ebx,edi
mov ebx,[ebx+8]
push ebx
push edi
invoke getRightChild,esi
cmp eax,offsetToEndofArray
jge leftissmaller;jge endofremoveMax
pop edi
pop ebx
mov ecx,[queueArr+eax+8]
cmp ebx,ecx
jl leftissmaller

rightissmaller:
pusha
mov esi,dword ptr [queueArr+esi+8]
cmp esi,[queueArr+eax+8]
jle endofremoveMax_withpopa;maybe jl
popa
push eax
invoke switch_leafs,esi,eax
pop eax
mov esi,eax
cmp esi,offsetToEndofArray
jge endofremoveMax
jmp checkagain

leftissmaller:
pusha
mov esi,dword ptr [queueArr+esi+8]
cmp esi,[queueArr+edi+8]
jle endofremoveMax_withpopa;maybe jl
popa
pusha
invoke switch_leafs,esi,edi
popa
mov esi,edi
cmp esi,offsetToEndofArray
jl checkagain
endofremoveMax_withpopa:
popa
endofremoveMax:
;================================================================================
ret
removeMax ENDP

BUILDRECT       PROC,   x:DWORD,        y:DWORD, h:DWORD,       w:DWORD,        hdc:HDC,        brush:HBRUSH
;--------------------------------------------------------------------------------
LOCAL rectangle:RECT
mov eax, x
mov rectangle.left, eax
add eax, w
mov     rectangle.right, eax
 
mov eax, y
mov     rectangle.top, eax
add     eax, h
mov rectangle.bottom, eax
 
invoke FillRect, hdc, addr rectangle, brush
;================================================================================
ret
BUILDRECT ENDP
 
Get_Handle_To_Mask_Bitmap	PROC,	hbmColour:HBITMAP,	crTransparent:COLORREF
;--------------------------------------------------------------------------------
local hdcMem:HDC
local hdcMem2:HDC
local hbmMask:HBITMAP
local bm:BITMAP
local hold:HBITMAP
local hold2:HBITMAP

invoke GetObject,hbmColour,SIZEOF(BITMAP),addr bm
invoke CreateBitmap,bm.bmWidth,bm.bmHeight,1,1,NULL
mov hbmMask,eax


invoke CreateCompatibleDC,NULL
mov hdcMem,eax
invoke CreateCompatibleDC,NULL
mov hdcMem2,eax

invoke SelectObject,hdcMem,hbmColour
invoke SelectObject,hdcMem2,hbmMask


invoke SetBkColor,hdcMem, crTransparent
invoke BitBlt,hdcMem2, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem, 0, 0, SRCCOPY
invoke BitBlt,hdcMem, 0, 0, bm.bmWidth, bm.bmHeight, hdcMem2, 0, 0, SRCINVERT

invoke DeleteDC,hdcMem
invoke DeleteDC,hdcMem2

mov eax,hbmMask

;================================================================================
ret
Get_Handle_To_Mask_Bitmap ENDP

GetRandomNumber PROC,   blen:BYTE,PointToBuffer:PLONG
;--------------------------------------------------------------------------------
local hprovide:HANDLE
invoke CryptAcquireContext, addr hprovide,0,0,PROV_RSA_FULL,CRYPT_VERIFYCONTEXT or CRYPT_SILENT
invoke CryptGenRandom, hprovide, blen, PointToBuffer
invoke CryptReleaseContext,hprovide,0
;================================================================================
ret
GetRandomNumber ENDP

CloseProcess	PROC
;--------------------------------------------------------------------------------
		cmp two_Players,FALSE
		je dont_send_two_players_over
		invoke sendto,sock, offset not_two_players, 1024, 0, offset clientsin, sizeof clientsin
		dont_send_two_players_over:
		invoke closesocket, sock
		invoke WSACleanup 
        invoke ExitProcess, 0
;================================================================================
ret
CloseProcess ENDP

DrawImage_fast PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD

local hdcMem:HDC
local HOld:HBITMAP
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  invoke SelectObject, hdcMem, img
  mov HOld, eax
  ;invoke SetStretchBltMode,hdc,COLORONCOLOR
  invoke BitBlt,hdc,x,y,w,h,hdcMem,x2,y2,SRCCOPY
  invoke SelectObject,hdcMem,HOld
  invoke DeleteDC,hdcMem 
  invoke DeleteObject,HOld


ret
DrawImage_fast ENDP


DrawImage_fast_WithMask PROC, hdc:HDC, img:HBITMAP,maskedimg:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD
local hdcMem:HDC
local HOld:HDC
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  ;invoke SetGraphicsMode,hdcMem,GM_ADVANCED
  ; mov edi,lp_xForm
  ;invoke SetWorldTransform,hdcMem,edi
  invoke SelectObject, hdcMem, maskedimg
  mov HOld,eax
   
  
  invoke BitBlt,hdc,x,y,w,h,hdcMem,x2,y2,SRCAND
		
  invoke SelectObject, hdcMem, img
  invoke BitBlt ,hdc,x,y,w,h,hdcMem,x2,y2,SRCPAINT

  invoke SelectObject,hdcMem,HOld
  invoke DeleteObject,HOld

        invoke DeleteDC,hdcMem 

ret
DrawImage_fast_WithMask ENDP
DrawImage PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD,wstrech:DWORD,hstrech:DWORD
;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HBITMAP
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  invoke SelectObject, hdcMem, img
  mov HOld, eax
  invoke SetStretchBltMode,hdc,COLORONCOLOR
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCCOPY
  invoke SelectObject,hdcMem,HOld
  invoke DeleteDC,hdcMem 
  invoke DeleteObject,HOld
;================================================================================
ret
DrawImage ENDP

DrawImage_WithMask PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD,w:DWORD,h:DWORD,x2:DWORD,y2:DWORD,wstrech:DWORD,hstrech:DWORD,lp_xForm:DWORD
;--------------------------------------------------------------------------------
local hdcMem:HDC
local HOld:HDC
  invoke CreateCompatibleDC, hdc
  mov hdcMem, eax
  ;invoke SetGraphicsMode,hdcMem,GM_ADVANCED
  ; mov edi,lp_xForm
  ;invoke SetWorldTransform,hdcMem,edi
  invoke SelectObject, hdcMem, maskedimg
  mov HOld,eax
  invoke SetStretchBltMode,hdc,COLORONCOLOR
 
  
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCAND
		
  invoke SelectObject, hdcMem, img
  invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCPAINT

  invoke SelectObject,hdcMem,HOld
  invoke DeleteObject,HOld

        invoke DeleteDC,hdcMem 
;================================================================================
ret
DrawImage_WithMask ENDP


WaitingScreen PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,WaitingScreenBMP,0,0,0,0,1024,1024,WINDOW_WIDTH,WINDOW_HEIGHT

invoke DrawImage_WithMask,hdc,Rightz,RightzMask,Waiting_zomb_x,Waiting_zomb_y,30,40,Waiting_cut_x,0,Zombie_Width*5,Zombie_Height*5,offset normal_xForm
invoke DrawImage_WithMask,hdc,hWalk,hWalkMask,Waiting_player_x,Waiting_player_y,75,105,Waiting_player_cut_x,385,Zombie_Width*5,Zombie_Height*5,offset normal_xForm

;---------------------------ZOMBIE---------------------------------
invoke GetTickCount
cmp Time_Step_Should_End,eax
jg no_need_to_advance_zomb
cmp Waiting_cut_x,70
jl noend_zomb
mov Waiting_cut_x,0
invoke GetTickCount
add eax,Time_Between_Steps_waiting
mov Time_Step_Should_End,eax
add Waiting_zomb_x,20
jmp no_need_to_advance_zomb
noend_zomb:
add Waiting_cut_x,35
invoke GetTickCount
add eax,Time_Between_Steps_waiting
mov Time_Step_Should_End,eax
add Waiting_zomb_x,20
no_need_to_advance_zomb:


cmp Waiting_zomb_x,WINDOW_WIDTH+Distance_Between_Zombie_And_Player; Player_x on purpose
jl dont_reset_zomb
mov Waiting_zomb_x,-Zombie_Width*5; Player_x on purpose
dont_reset_zomb:
;---------------------------PLAYER---------------------------------
invoke GetTickCount
cmp Time_Step_Should_End_Player,eax
jg no_need_to_advance
cmp Waiting_player_cut_x,1000
jl noend
mov Waiting_player_cut_x,0
invoke GetTickCount
add eax,Time_Between_Steps_waiting_player
mov Time_Step_Should_End_Player,eax
add Waiting_player_x,20
jmp no_need_to_advance
noend:
add Waiting_player_cut_x,127
invoke GetTickCount
add eax,Time_Between_Steps_waiting_player
mov Time_Step_Should_End_Player,eax
add Waiting_player_x,20
no_need_to_advance:


cmp Waiting_player_x,WINDOW_WIDTH
jl dont_reset
mov Waiting_player_x,-Zombie_Width*5-Distance_Between_Zombie_And_Player
dont_reset:

;================================================================================
ret
WaitingScreen ENDP



DrawOptionScreenButtons PROC,hdc:HDC,Highlighted:DWORD
;--------------------------------------------------------------------------------

;================================================================================
ret
DrawOptionScreenButtons ENDP

OptionsScreen PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,OptionScreenhbitmap,0,0,0,0,1920,1040,WINDOW_WIDTH,WINDOW_HEIGHT

;invoke DrawOptionScreenButtons,hdc,Highlight
;================================================================================
ret
OptionsScreen ENDP

DrawStartScreenButtons PROC,hdc:HDC,Highlighted:DWORD
;--------------------------------------------------------------------------------
mov esi,WINDOW_HEIGHT/5
mov eax,Highlighted
imul eax,WINDOW_HEIGHT/5
add esi,eax
invoke DrawImage_WithMask,hdc,HighlightBIT,HighlightBITMasked,(WINDOW_WIDTH*3)/4,esi,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10,offset normal_xForm
mov edx,WINDOW_HEIGHT/5

push edx
invoke DrawImage_WithMask,hdc,NewGame,NewGameMasked,(WINDOW_WIDTH*3)/4,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10,offset normal_xForm
pop edx
add edx,WINDOW_HEIGHT/5

push edx
invoke DrawImage_WithMask,hdc,Online,OnlineMask,(WINDOW_WIDTH*3)/4,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10,offset normal_xForm
pop edx
add edx,WINDOW_HEIGHT/5

push edx
invoke DrawImage_WithMask,hdc,Options,OptionsMasked,(WINDOW_WIDTH*3)/4,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10,offset normal_xForm
pop edx
add edx,WINDOW_HEIGHT/5
invoke DrawImage_WithMask,hdc,Exiting,ExitingMasked,(WINDOW_WIDTH*3)/4,edx,240,60,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/10,offset normal_xForm



;================================================================================
ret
DrawStartScreenButtons ENDP

connect_to_server PROC,hWnd:HWND

 mov textoffset, offset text

invoke WSAStartup, 101h,addr wsadata 
.if eax!=NULL 
    invoke ExitProcess, 1;<An error occured> 
.else 
    xor eax, eax ;<The initialization is successful. You may proceed with other winsock calls> 
.endif

invoke socket,AF_INET,SOCK_DGRAM,0     ; Create a stream socket for internet use 
.if eax!=INVALID_SOCKET 
    mov sock,eax 
.else 
    invoke ExitProcess, 1
.endif

invoke WSAAsyncSelect, sock, hWnd,WM_SOCKET, FD_READ 
            ; Register interest in connect, read and close events. 
.if eax==SOCKET_ERROR 
	invoke WSAGetLastError
    invoke ExitProcess, 1;<put your error handling routine here> 
.else 
    xor eax, eax  ;........ 
.endif


mov sin.sin_family, AF_INET 
invoke htons, Port                    ; convert port number into network byte order first 
mov sin.sin_port,ax                  ; note that this member is a word-size param. 
invoke inet_addr, addr IPAddress    ; convert the IP address into network byte order 
mov sin.sin_addr,eax 
invoke crt_strlen, offset pleaseconnectus
invoke sendto,sock, offset pleaseconnectus, eax, 0, offset sin, sizeof sin
invoke WSAGetLastError

ret
connect_to_server ENDP

StartScreen PROC,hdc:HDC,hWnd:HWND
;--------------------------------------------------------------------------------
inc	FramesSinceLastClick
invoke DrawImage,hdc,StartScreenBK,0,0,0,0,1000,605,WINDOW_WIDTH,WINDOW_HEIGHT
invoke DrawStartScreenButtons,hdc,Highlight
cmp FramesSinceLastClick,5
jl finishbutton
mov FramesSinceLastClick,0
invoke GetAsyncKeyState,VK_RETURN
cmp eax,0
je idown
cmp Highlight,0
jne next
mov STATUS,1
invoke SetTimer, hWnd, RoundEnded, TimeTillRoundEnds, NULL ;Set the time til the store
jmp finishbutton
next:
cmp Highlight,1
jne next2
invoke connect_to_server,hWnd
;mov two_Players,TRUE
invoke GetTickCount
mov Time_Step_Should_End,eax
mov Time_Step_Should_End_Player,eax
mov STATUS,4
jmp finishbutton
next2:
cmp Highlight,2
jne next3
mov STATUS,3
mov Highlight,0
jmp finishbutton
next3:
cmp Highlight,3
jne idown
invoke CloseProcess

jmp finishbutton
idown: 
invoke GetAsyncKeyState,VK_DOWN
cmp eax,0
je iup
inc Highlight
cmp Highlight,3
jng nevermind
mov Highlight,0
nevermind:
jmp finishbutton
iup:
invoke GetAsyncKeyState,VK_UP
cmp eax,0
je finishbutton
dec Highlight
cmp Highlight,0
jnl finishbutton
mov Highlight,2
finishbutton:
;================================================================================
ret
StartScreen ENDP

DrawStoreStands	PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage_WithMask,hdc,cost,costMasked,760,400,182,60,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/7,offset normal_xForm
invoke DrawImage_WithMask,hdc,cost,costMasked,760,600,182,60,0,0,WINDOW_WIDTH/4,WINDOW_HEIGHT/7,offset normal_xForm

;================================================================================
ret
DrawStoreStands	ENDP

DrawStore	PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage,hdc,StoreBK,0,0,0,0,1504,910,WINDOW_WIDTH,WINDOW_HEIGHT
invoke DrawStoreStands,hdc
;================================================================================
ret
DrawStore	ENDP

itoa PROC,num:DWORD,stringP:DWORD,radix:DWORD
;--------------------------------------------------------------------------------
local counting:DWORD
local savingNum:DWORD
mov eax,0
mov savingNum,eax
mov counting,eax
mov eax,num
mov savingNum,eax
mov ebx,stringP
loopingcheckingifzero:

mov eax,savingNum
mov ecx,10
xor edx,edx
idiv ecx
mov savingNum,eax
add dl,"0"
push edx
inc counting
cmp savingNum,0
jne loopingcheckingifzero

mov ecx,counting

looppoping:
pop edx
mov byte ptr [ebx],dl
inc ebx
loop looppoping
mov byte ptr [ebx],0
mov eax,counting

;================================================================================
ret
itoa	ENDP

DrawScore	PROC,hdc:HDC
;--------------------------------------------------------------------------------
invoke DrawImage_WithMask,hdc,score,scoreMasked,20,20,150,56,0,0,WINDOW_WIDTH/6,WINDOW_HEIGHT/8,offset normal_xForm
invoke itoa,scoreNum,offset scoreBuffer,10
push eax

invoke SelectObject,hdc,MyFont
invoke SetBkMode,hdc,TRANSPARENT
invoke SetTextColor,hdc,000045f7h
pop eax
invoke TextOut,hdc,(WINDOW_WIDTH/6)+20,20+40,offset scoreBuffer,eax
mov ecx,60
mov eax,realtimetillend
xor edx,edx
idiv ecx
push edx
invoke itoa,eax,offset timeBuffer,10
invoke TextOut,hdc,450,20+40,offset timeBuffer,eax

invoke TextOut,hdc,550,20+40,offset doubledot,1
pop edx
invoke itoa,edx,offset timeBuffer,10
invoke TextOut,hdc,600,20+40,offset timeBuffer,eax
invoke SetBkMode,hdc,OPAQUE
invoke SetTextColor,hdc,00000000
;================================================================================
ret
DrawScore	ENDP

Check_If_Bullet_Hit_And_Destroy_Zombie PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD,lp_zombies:DWORD
;--------------------------------------------------------------------------------
local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,lp_zombies
mov ecx,50
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next

found:
popa;------------------------------------------
inc dword ptr [ebx+16]
cmp dword ptr [ebx+16],3
jl noaddscore
add scoreNum,50
noaddscore:
mov eax,1;Found
jmp endingsearching

next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
mov eax,0
endingsearching:
;================================================================================
ret
Check_If_Bullet_Hit_And_Destroy_Zombie ENDP
 
 Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin PROC,x:DWORD,y:DWORD
 ;--------------------------------------------------------------------------------
 local PlayerRect:RECT
 local CoinRect:RECT
 local junkrect:RECT
 mov eax,x
 mov PlayerRect.left,eax
 add eax,RECT_WIDTH
 mov PlayerRect.right,eax
 mov eax,y
 mov PlayerRect.top,eax
 add eax,RECT_HEIGHT
 mov PlayerRect.bottom,eax

 mov ebx,offset coins
 mov ecx,50
loopcheckingforcoinhits:
cmp dword ptr [ebx],-999
pusha
je DeadCoin
popa
mov eax,dword ptr [ebx]
mov CoinRect.left,eax
add eax,Coin_Width
mov CoinRect.right,eax
mov eax,dword ptr [ebx+4]
mov CoinRect.top,eax
add eax,Coin_Height
mov CoinRect.bottom,eax
pusha
invoke IntersectRect,addr junkrect,addr PlayerRect,addr CoinRect
cmp eax,0
je DeadCoin
popa
mov dword ptr [ebx],-999
inc Money
add scoreNum,20
pusha
DeadCoin:
popa
add ebx,12
dec ecx
jnz loopcheckingforcoinhits 
 ;================================================================================
 ret
 Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin ENDP

 Push_Zombies	PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD
 ;-------------------------------------------------------------------------------
 local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,offset zombies
mov ecx,80
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next


found:
popa;------------------------------------------
movss xmm0,dword ptr [ebx+12]
mulss xmm0,threepointzero
movss xmm1,dword ptr [ebx]
subss xmm1,dword ptr [ebx+12]
movss dword ptr [ebx],xmm1
movss xmm0, dword ptr [ebx+8]
mulss xmm0,threepointzero
movss xmm1,dword ptr [ebx+4]
subss xmm1,xmm0
movss dword ptr [ebx+4],xmm1
pusha


next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
endingsearching:
 ;================================================================================
 ret
 Push_Zombies	ENDP

 Check_If_Player_Hit_And_Remove_Life PROC,x:DWORD,y:DWORD,w:DWORD,h:DWORD
;--------------------------------------------------------------------------------
local rect:RECT
local rectz:RECT
local junkrect:RECT
mov eax,x
mov rect.left,eax
add eax,w
mov rect.right,eax
mov eax,y
mov rect.top,eax
add eax,h
mov rect.bottom,eax
 
mov ebx,offset zombies
mov ecx,80
 
searchingforhits:
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov eax,dword ptr [ebx]
cmp eax,-999
je next

popa;------------------------------------------
pusha;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cvtss2si eax,dword ptr [ebx]
mov rectz.left,eax
add eax,Zombie_Width
mov rectz.right,eax
cvtss2si eax,dword ptr [ebx+4]
mov rectz.top,eax
add eax,Zombie_Height
mov rectz.bottom,eax
invoke IntersectRect,addr junkrect,addr rectz,addr rect
cmp eax,0
je next


found:
popa;------------------------------------------
dec Player_Life
mov FoundForSound,1
mov Found,1
pusha


next:
popa;------------------------------------------
add ebx,36
loop searchingforhits
endingsearching:

;================================================================================
ret
Check_If_Player_Hit_And_Remove_Life ENDP

Check_If_Player_Hit_Pack_And_Remove_Pack	PROC,x:DWORD,y:DWORD,lp_life:DWORD
;--------------------------------------------------------------------------------

local PlayerRect:RECT
 local PackRect:RECT
 local junkrect:RECT
 mov eax,x
 mov PlayerRect.left,eax
 add eax,RECT_WIDTH
 mov PlayerRect.right,eax
 mov eax,y
 mov PlayerRect.top,eax
 add eax,RECT_HEIGHT
 mov PlayerRect.bottom,eax

 mov ebx,offset Packs
 mov ecx,10
loopcheckingforpackhits:
cmp dword ptr [ebx],-999
pusha
je DeadPack
popa
mov eax,dword ptr [ebx]
mov PackRect.left,eax
add eax,Health_Pack_Width
mov PackRect.right,eax
mov eax,dword ptr [ebx+4]
mov PackRect.top,eax
add eax,Health_Pack_Height
mov PackRect.bottom,eax
pusha
invoke IntersectRect,addr junkrect,addr PlayerRect,addr PackRect
cmp eax,0
je DeadPack
popa
mov dword ptr [ebx],-999
mov edi,lp_life
add dword ptr [edi],50;add Player_Life,50
pusha
DeadPack:
popa
add ebx,16
dec ecx
jnz loopcheckingforpackhits 


;================================================================================
ret
Check_If_Player_Hit_Pack_And_Remove_Pack ENDP

DropCoin	PROC,	x:DWORD,y:DWORD
;--------------------------------------------------------------------------------
mov ebx,offset coins
mov ecx,50
loopingcheckingifemptyc:
cmp dword ptr [ebx],-999
jne CoinTaken
mov eax,x
mov dword ptr [ebx],eax
mov eax,y
mov dword ptr [ebx+4],eax
invoke GetTickCount
add eax,8000
mov dword ptr [ebx+8],eax
jmp EndDropCoin
CoinTaken:
add ebx,12
dec ecx
jnz loopingcheckingifemptyc


EndDropCoin:
;================================================================================
ret
DropCoin ENDP


DrawCoin	PROC,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
  local hdcMem1:HDC
  local hOld:HBITMAP

mov ebx,offset coins
mov ecx,50
loopdrawingcoins:
push ecx
cmp dword ptr [ebx],-999
je NoCoin
pop ecx
push ecx
cmp host,FALSE
je ContinueDrawingCoins
invoke GetTickCount
cmp dword ptr [ebx+8],eax
jg ContinueDrawingCoins
pop ecx
push ecx
mov dword ptr [ebx],-999
jmp NoCoin
ContinueDrawingCoins:
	pop ecx
	push ecx
	
	invoke DrawImage_WithMask,hdc,hCoinColour,hCoinMask,dword ptr [ebx],dword ptr [ebx+4],Coin_Width,Coin_Height,0,0,Coin_Width,Coin_Height,offset normal_xForm;CHANGE TO WINDO_WIDTH/X AND WINDOW_HEIGHT/Y
	COMMENT @
	invoke CreateCompatibleDC,hdc
	mov hdcMem1,eax
	invoke SelectObject,hdcMem1,hCoinMask
	mov hOld,eax
	

	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Coin_Width,Coin_Height,hdcMem1,0,0,SRCAND
	
	
	invoke SelectObject,hdcMem1,hCoinColour
	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Coin_Width,Coin_Height,hdcMem1,0,0,SRCPAINT

	invoke SelectObject,hdcMem1,hOld
	invoke DeleteDC,hdcMem1
	@
	pop ecx
	push ecx
NoCoin:
	pop ecx
	add ebx,12
	dec ecx
	jnz loopdrawingcoins
endloopdrawingcoins:
;================================================================================
ret
DrawCoin ENDP


Maybe_Drop_Pack	PROC,x:DWORD,y:DWORD
;--------------------------------------------------------------------------------
 invoke GetRandomNumber,4,offset randombuffer 
 mov eax, randombuffer
 mov ecx,ChanceToDropHealthPack
 xor edx,edx
 div ecx
 cmp edx,0
 jne End_Maybe_Drop_Health_Pack 
 mov ebx,offset Packs
 mov ecx,10
 loopingcheckingifemptypacks:
 cmp dword ptr [ebx],-999
 jne nextPack
 mov eax,x
 mov dword ptr [ebx],eax
 mov eax,y
 mov dword ptr [ebx+4],eax
 invoke GetTickCount
add eax,8000
mov dword ptr [ebx+8],eax
mov dword ptr [ebx+12],0;For now it will be zero later I will add different packs so it will be random 0-somenumber
jmp End_Maybe_Drop_Health_Pack
 nextPack:
 add ebx,16
 loop loopingcheckingifemptypacks
 End_Maybe_Drop_Health_Pack:
;================================================================================
ret
Maybe_Drop_Pack	ENDP

Draw_Packs	PROC,hdc:HDC
;--------------------------------------------------------------------------------
local hdcMem:HDC
local hOld:HBITMAP

mov ebx,offset Packs
mov ecx,10
loopingdrawingpacks:
push ecx
cmp dword ptr [ebx],-999
je nopack
pop ecx
push ecx
invoke GetTickCount
cmp dword ptr [ebx+8],eax
jg ContinueDrawingPacks
pop ecx
push ecx
mov dword ptr [ebx],-999
jmp nopack

ContinueDrawingPacks:

    invoke DrawImage_WithMask,hdc,hHealthPackColour,hHealthPackMask,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,0,0,Health_Pack_Width,Health_Pack_Height,offset normal_xForm;CHANGE TO WINDO_WIDTH/X AND WINDOW_HEIGHT/Y

	COMMENT @
	invoke CreateCompatibleDC,hdc
	mov hdcMem,eax
	invoke SelectObject,hdcMem,hHealthPackMask
	mov hOld,eax
	

	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,hdcMem,0,0,SRCAND
	
	
	invoke SelectObject,hdcMem,hHealthPackColour
	
	invoke BitBlt,hdc,dword ptr [ebx],dword ptr [ebx+4],Health_Pack_Width,Health_Pack_Height,hdcMem,0,0,SRCPAINT

	invoke SelectObject,hdcMem,hOld
	invoke DeleteDC,hdcMem
	@
	pop ecx
	push ecx

nopack:
pop ecx
add ebx,16
dec ecx
jnz loopingdrawingpacks
;================================================================================
ret
Draw_Packs	ENDP

AdvanceZombie_and_CheckIfDead	PROC,hWnd:HWND
;--------------------------------------------------------------------------------
mov ebx,offset zombies
mov ecx,50

loopingzomb:
pusha;-----------------------------------------------
mov eax,dword ptr [ebx]
cmp eax,-999
je next
mov eax,dword ptr [ebx+16];hit count
cmp eax,3
jge deadz
movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12]
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8]
movss dword ptr [ebx+4],xmm1
jmp next
deadz:
;add scoreNum,50
sub Time_Between_Steps,50
pusha;--------------------------------
cvtss2si eax,dword ptr [ebx]
mov ZombieX,eax
cvtss2si edx,dword ptr [ebx+4]
mov ZombieY,edx
invoke Maybe_Drop_Pack,ZombieX,ZombieY
invoke DropCoin,ZombieX,ZombieY

popa;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mov dword ptr [ebx],-999
cmp Zombie_Spawning_Time,500
jle next
mov eax,Zombie_Spawning_Time
sub eax,60
mov Zombie_Spawning_Time,eax
;inc Number_To_Spawn
invoke SetTimer, hWnd, ZombieTime, Zombie_Spawning_Time , NULL ;Set the zombie time
movss xmm0,ADDINGZ
movss xmm1,VELZ
addss xmm1,xmm0
movss VELZ,xmm1

next:
popa;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
add ebx,36
dec ecx
jnz loopingzomb;loop loopingzomb
;================================================================================
ret
AdvanceZombie_and_CheckIfDead ENDP

BITMAP_ID_TO_HBITMAP	PROC,id:DWORD
mov eax,Frontz
mov edx,FrontzMask

cmp id,113
jne notIDB_Front
mov eax,Frontz
mov edx,FrontzMask
notIDB_Front:

cmp id,114
jne notIDB_Right
mov eax,Rightz
mov edx,RightzMask
notIDB_Right:

cmp id,115
je notIDB_Left
mov eax,Leftz
mov edx,LeftzMask
notIDB_Left:

cmp id,116
jne notIDB_Back
mov eax,Backz
mov edx,BackzMask
notIDB_Back:


ret
BITMAP_ID_TO_HBITMAP	ENDP

DrawZombie PROC,hdc:HDC,brush:HBRUSH,hWnd:HWND
;--------------------------------------------------------------------------------
mov ebx,offset zombies
mov ecx,50
 
loopingzomb:
pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
mov eax,dword ptr [ebx+16];hit count
cmp eax,3
jge deadz
movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12]
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8]
movss dword ptr [ebx+4],xmm1
 
cvtss2si eax,xmm0
mov ZombieX,eax
cvtss2si eax,xmm1
mov ZombieY,eax
mov edx,dword ptr [ebx+28]
;DOES NOT WORK WITH ONLINE - BITMAPS ARE LOADED DIFFERENTLY IN DIFFERENT PROGRAMS----------------------------
;SOLUTION: MAKE A FUNCTION THAT RECIEVES BITMAP_ID,AND CREATES IT'S BITMAP
invoke BITMAP_ID_TO_HBITMAP,dword ptr [ebx+20]
 invoke DrawImage_WithMask,hdc,eax,edx,ZombieX,ZombieY,30,40,dword ptr [ebx+28],0,Zombie_Width,Zombie_Height,offset normal_xForm ;,WINDOW_WIDTH/25,WINDOW_HEIGHT/22
 ;invoke BUILDRECT,       ZombieX,        ZombieY,        Zombie_Height,Zombie_Width,hdc,brush
invoke GetTickCount
cmp dword ptr [ebx+32],eax
jg next
cmp dword ptr [ebx+28],70
jl noend
mov dword ptr [ebx+28],0
invoke GetTickCount
add eax,Time_Between_Steps
mov dword ptr [ebx+32],eax
jmp next
noend:
add dword ptr [ebx+28],35
invoke GetTickCount
add eax,Time_Between_Steps
mov dword ptr [ebx+32],eax
jmp next
deadz:
;add scoreNum,50
sub Time_Between_Steps,50
pusha
cvtss2si eax,dword ptr [ebx]
mov ZombieX,eax
cvtss2si edx,dword ptr [ebx+4]
mov ZombieY,edx
invoke Maybe_Drop_Pack,ZombieX,ZombieY
invoke DropCoin,ZombieX,ZombieY
popa
mov dword ptr [ebx],-999
cmp Zombie_Spawning_Time,500
jle next
mov eax,Zombie_Spawning_Time
sub eax,60
mov Zombie_Spawning_Time,eax
;inc Number_To_Spawn
invoke SetTimer, hWnd, ZombieTime, Zombie_Spawning_Time , NULL ;Set the zombie time
movss xmm0,ADDINGZ
movss xmm1,VELZ
addss xmm1,xmm0
movss VELZ,xmm1
next:
popa
add ebx,36
dec ecx
jnz loopingzomb;loop loopingzomb
;================================================================================
ret
DrawZombie ENDP
 
 closest_player PROC,lp_x:DWORD,lp_y:DWORD,zomb_x:DWORD,zomb_y:DWORD

 mov esi,Player.x
 sub esi,zomb_x

 mov ebx,Player.y
 sub ebx,zomb_y

 xor edx,edx
 imul esi,esi

 xor edx,edx
 imul ebx,ebx

 add esi,ebx


 mov ebx,Player2.x
 sub ebx,zomb_x
 mov edi,Player2.y
 sub edi,zomb_y
 xor edx,edx
 imul ebx,ebx
 xor edx,edx
 imul edi,edi
 add ebx,edi
 
 cmp esi,ebx
 jl firstisbigger

 secondisbigger:
 mov edi,lp_x
 mov eax,Player2.x
 mov dword ptr [edi],eax
 mov edi,lp_y
 mov eax,Player2.y
 mov dword ptr [edi],eax

 jmp endofclosest_player

 firstisbigger:
 mov edi,lp_x
 mov eax,Player.x
 mov dword ptr [edi],eax
 mov edi,lp_y
 mov eax,Player.y
 mov dword ptr [edi],eax

 endofclosest_player:

 ret
 closest_player ENDP

 adjustzombie	PROC
 local closest_x:DWORD
 local closest_y:DWORD
 FNINIT
    mov ebx,offset zombies
                mov ecx,80
        loopingAdjustment:
		 push ecx
				mov eax,dword ptr [ebx]
				cmp eax,-999
				je DeadNoAdjust
				pusha
				cmp two_Players,FALSE
				je use_player1
				cvtss2si eax,dword ptr [ebx]
				cvtss2si edx,dword ptr [ebx+4]
				invoke closest_player,addr closest_x,addr closest_y ,eax,edx
				jmp end_of_closest
				use_player1:
				mov eax,Player.x
				mov closest_x,eax
				mov eax,Player.y
				mov closest_y,eax
				end_of_closest:
				popa
                mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,closest_x
            cvtss2si edx,dword ptr [ebx]
           sub ecx,edx
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,closest_y
           cvtss2si edx,dword ptr [ebx+4]
           sub eax,edx
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
       
            FLD dword ptr [esi+8]
         
           FLD dword ptr [esi]
           FPATAN
		   mov edi,offset angle
		   FST qword ptr [edi]
		   cvtsd2ss xmm0,qword ptr [edi]
		   movss realangle,xmm0
		   cvtss2si eax,xmm0
		   mov realangle,eax
		   
           FSINCOS
           FMUL VELZ
           FSTP qword ptr [esi];VELZ IN X
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+12],xmm0
           
           FMUL VELZ
           FSTP qword ptr [esi];VELZ IN Y
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+8],xmm0


		 

		   mov eax,realangle
		
		 
		   cmp eax,-0;0
		   je right

		   cmp eax,-1;1
		   je up

		   cmp eax,-2
		   je up

		   cmp eax,-3
		   je left

		   cmp eax,-4
		   je left

	
		   cmp eax,0;0
		   je right

		   cmp eax,1;1
		   je down

		   cmp eax,2
		   je down

		   cmp eax,3
		   je left

		   cmp eax,4
		   je left

		   ;jmp endgame
		   
		  
		 


		   right:
			
		    mov eax,114
			mov dword ptr [ebx+20],eax
			mov eax,114
			mov dword ptr [ebx+24],eax


	
		   jmp DeadNoAdjust

		   down:
		 
		     mov eax,113
			mov dword ptr [ebx+20],eax
			mov eax,113
			mov dword ptr [ebx+24],eax


		  jmp DeadNoAdjust

		  left:
		 
		    mov eax,115
			mov dword ptr [ebx+20],eax
			mov eax,115
			mov dword ptr [ebx+24],eax
		  jmp DeadNoAdjust

		  up:
		
		    mov eax,116
			mov dword ptr [ebx+20],eax
			mov eax,116
			mov dword ptr [ebx+24],eax
		
		   DeadNoAdjust:
           pop ecx
           add ebx,36
             dec ecx
			 jnz loopingAdjustment	;loop loopingAdjustment

 ret
 adjustzombie	ENDP

 enemybullet PROC,hdc:HDC,brush:HBRUSH,lp_bullets_array:DWORD
;--------------------------------------------------------------------------------
local rc:RECT
FNINIT
mov ebx,lp_bullets_array
mov ecx,50
 
loopingbull:
 pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
  
movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12]
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8]
movss dword ptr [ebx+4],xmm1
 
cvtss2si eax,xmm0
mov BulletX,eax
mov rc.left,eax
add eax,Bullet_Width
mov rc.right,eax
cvtss2si eax,xmm1
mov BulletY,eax
mov rc.top,eax
add eax,Bullet_Height
mov rc.bottom,eax
 pusha
 
 ;invoke Ellipse,hdc,rc.left,rc.top,rc.right,rc.bottom

;invoke BUILDRECT,       BulletX,        BulletY,        Bullet_Width,Bullet_Height,hdc,brush
pusha
cmp host,FALSE
je continueon
invoke Check_If_Bullet_Hit_And_Destroy_Zombie,BulletX,BulletY,Bullet_Width,Bullet_Height,offset zombies

cmp eax,1
jne continueon
popa
mov dword ptr [ebx],-999
pusha
continueon:
popa
invoke GetPixel,hdc,BulletX,BulletY
cmp eax, 0FFFFFFFFh
jne next
deadb:
mov dword ptr [ebx],-999
next:
popa
add ebx,40
dec ecx
jnz loopingbull;loop loopingbull
;================================================================================
ret
enemybullet ENDP

GetSinAndCos PROC,lp_sin:DWORD,lp_cos:DWORD,lp_minus_sin:DWORD,muled_sin:DWORD,muled_cos:DWORD
;--------------------------------------------------------------------------------
 movss xmm0,muled_sin
 divss xmm0,VEL
 mov edi,lp_sin
 movss dword ptr [edi],xmm0
 
 movss xmm0,muled_cos
 divss xmm0,VEL
 mov edi,lp_cos
 movss dword ptr [edi],xmm0


 movss xmm0,muled_sin
 divss xmm0,VEL
 mulss xmm0,Minus1
 mov edi,lp_minus_sin
 movss dword ptr [edi],xmm0
;================================================================================
ret
GetSinAndCos ENDP

bullet PROC,hdc:HDC,brush:HBRUSH,lp_bullets_array:DWORD,hWnd:HWND
;--------------------------------------------------------------------------------
local rc:RECT
local testrc:RECT
FNINIT
;invoke SetGraphicsMode,hdc,GM_ADVANCED
mov ebx,lp_bullets_array
mov ecx,48
 
loopingbull:
 pusha
mov eax,dword ptr [ebx]
cmp eax,-999
je next
  

 pusha
 
 pusha

  mov eax,Bullet_Height/2
 cvtsi2ss xmm4,eax
 addss xmm4,dword ptr [ebx+4];was adss

  ;xmm4 is y0
 mov eax,Bullet_Width/2
 cvtsi2ss xmm0,eax
 addss xmm0,dword ptr [ebx];was adss
 ;movss xmm0,ZeroPointZero
 ;xmm0 is x0
 movss xmm1,dword ptr [ebx+16]
 mulss xmm1,xmm0;xmm1=cos*x0
 movss xmm2,dword ptr [ebx+20]
 mulss xmm2,xmm4;xmm2=sin*y0
 movss xmm3,xmm0
 subss xmm3,xmm1
 addss xmm3,xmm2
 movss dword ptr [ebx+32],xmm3
 movss xmm1,dword ptr [ebx+16]
 mulss xmm1,xmm4;xmm1=cos*y0
 movss xmm2,dword ptr [ebx+20]
 mulss xmm2,xmm0;xmm2=sin*x0
 movss xmm3,xmm4
 subss xmm3,xmm1
 subss xmm3,xmm2
 movss dword ptr [ebx+36],xmm3
 
  movss xmm0, dword ptr [ebx]
movss xmm1, dword ptr [ebx+4]
addss xmm0,dword ptr [ebx+12];VEL IN X
movss dword ptr [ebx],xmm0
addss xmm1, dword ptr [ebx+8];VEL IN Y
movss dword ptr [ebx+4],xmm1
 
cvtss2si eax,xmm0
mov BulletX,eax
mov rc.left,eax
add eax,Bullet_Width
mov rc.right,eax
cvtss2si eax,xmm1
mov BulletY,eax
mov rc.top,eax
add eax,Bullet_Height
mov rc.bottom,eax
mov eax,ebx
add eax,16
 invoke SetWorldTransform,hdc,eax;WORKS GREAT--------------------------------------------
 
 
 ;invoke Ellipse,hdc,rc.left,rc.top,rc.right,rc.bottom
 invoke DrawImage_fast_WithMask,hdc,ArrowBMP,ArrowBMPMask,BulletX,BulletY,0,0,60,18
 ;invoke DrawImage,hdc,ArrowBMP,BulletX,BulletY,0,0,1591,153,Bullet_Width,Bullet_Height
  ;invoke DrawImage_WithMask,hdc,ArrowBMP,ArrowBMPMask,BulletX,BulletY,1591,153,0,0,Bullet_Width,Bullet_Height,offset xForm
 ;invoke DrawImage_WithMask,hdc,Rightz,RightzMask,BulletX,BulletY,30,40,0,0,Zombie_Width,Zombie_Height,offset xForm
 invoke SetWorldTransform,hdc,offset normal_xForm;WORKS GREAT--------------------------------------------  
 popa

pusha

invoke Check_If_Bullet_Hit_And_Destroy_Zombie,BulletX,BulletY,Bullet_Width,Bullet_Height,offset zombies

cmp eax,1
jne continueon
popa
mov dword ptr [ebx],-999
pusha
continueon:
popa
invoke GetPixel,hdc,BulletX,BulletY
cmp eax, 0FFFFFFFFh
jne next
deadb:
mov dword ptr [ebx],-999
next:
popa
add ebx,40
dec ecx
jnz loopingbull;loop loopingbull
;================================================================================
ret
bullet ENDP

Draw_Player_Health_Bar	PROC,x:DWORD,y:DWORD,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
;The Width Would Be 50 Pixels Long Because The Player's Life is 500

invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   00000000FF00h
mov brush,eax

mov ebx,y
sub ebx,20;Testing
mov eax,Player_Life
mov ecx,10
xor edx,edx
idiv ecx
cmp Player_Life,500
jle NoShield
mov eax,50
NoShield:
mov ecx,x
sub ecx,10
pusha
invoke BUILDRECT,ecx,ebx,5,eax,hdc,brush
invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   0000000000ffh
mov brush,eax
popa

add ecx,eax
mov edx,50
sub edx,eax
cmp Player_Life,500
jle NoShield2
pusha
invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   000000ff0000h
mov brush,eax
popa
mov eax,Player_Life
sub eax,500
mov esi,10
xor edx,edx
idiv esi
mov edx,eax
add ebx,5
sub ecx,50
NoShield2:


invoke BUILDRECT,ecx,ebx,5,edx,hdc,brush


;================================================================================
ret
Draw_Player_Health_Bar ENDP


;Draw_Zombie_Health_Bar

Draw_Sprint_Bar	PROC,x:DWORD,y:DWORD,hdc:HDC,brush:HBRUSH
;--------------------------------------------------------------------------------
;The Width Would Be 50 Pixels Long Because The Player's Life is 500

invoke SelectObject,hdc,brush
invoke SetDCBrushColor, hdc,   000000ff00ffh
mov brush,eax

mov ebx,y
sub ebx,10;Testing
mov eax,sprintmeter
mov ecx,10
xor edx,edx
idiv ecx
;cmp Player_Life,500
;jle NoShield
;mov eax,50
NoShield:
mov ecx,x
sub ecx,10
;pusha
invoke BUILDRECT,ecx,ebx,5,eax,hdc,brush
;invoke SelectObject,hdc,brush
;invoke SetDCBrushColor, hdc,   0000000000ffh
;mov brush,eax
;popa

;add ecx,eax
;mov edx,50
;sub edx,eax
;cmp Player_Life,500
;jle NoShield2
;pusha
;invoke SelectObject,hdc,brush
;invoke SetDCBrushColor, hdc,   000000ff0000h
;mov brush,eax
;popa
;mov eax,Player_Life
;sub eax,500
;mov esi,10
;xor edx,edx
;idiv esi
;mov edx,eax
;add ebx,5
;sub ecx,50
;NoShield2:


;invoke BUILDRECT,ecx,ebx,5,edx,hdc,brush


;================================================================================
ret
Draw_Sprint_Bar ENDP

 createbullet PROC
 ;--------------------------------------------------------------------------------
		local pt:POINT 
			FNINIT
            invoke GetCursorPos,addr pt
			
			 mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,pt.x
           sub ecx,ShootX
           mov edx,WINPLACE.rcNormalPosition.left
           sub ecx,edx
           sub ecx,40
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,pt.y
           sub eax,ShootY
           mov edx,WINPLACE.rcNormalPosition.top
           sub eax,edx
           sub eax,40
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
         
            FLD dword ptr [esi+8]

           FLD dword ptr [esi]
		     
         
 
           FPATAN
           FSINCOS
		   FMUL VEL
           FSTP qword ptr [esi];VEL IN X
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+12],xmm0
		 
           FMUL VEL
           FSTP qword ptr [esi];VEL IN Y
           CVTSD2SS xmm0,qword ptr [esi]
           movss dword ptr [ebx+8],xmm0
              
			  

           cvtsi2ss xmm0,ShootX
           movss dword ptr [ebx],xmm0
           cvtsi2ss xmm1,ShootY
           movss dword ptr [ebx+4],xmm1

		   
 invoke GetSinAndCos,offset sin_angle_world,offset cos_angle_world,offset minus_sin_angle_world,dword ptr [ebx+8],dword ptr [ebx+12]
 movss xmm0,cos_angle_world
 movss dword ptr [ebx+16],xmm0
 movss xmm0,sin_angle_world
 movss dword ptr [ebx+20],xmm0
 movss xmm0,minus_sin_angle_world
 movss dword ptr [ebx+24],xmm0
 movss xmm0,cos_angle_world
 movss dword ptr [ebx+28],xmm0


 

 
		   
	;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
    ;invoke PlaySound, offset SoundPath, NULL,SND_ASYNC;	Special Thanks To Tal Bortman
;================================================================================
 ret
 createbullet ENDP
 
 GetPlayerAngleAndFix	PROC,hWnd:HWND
 ;--------------------------------------------------------------------------------
 	local pt:POINT 
		FNINIT
        invoke GetWindowPlacement,hWnd,OFFSET WINPLACE
            invoke GetCursorPos,addr pt
			
			 mov esi, offset buffer
           ;=====================DELTA X=================================
           mov ecx,pt.x
           sub ecx,ShootX
           mov edx,WINPLACE.rcNormalPosition.left
           sub ecx,edx
           sub ecx,40
           cvtsi2ss xmm2,ecx
           movss dword ptr [esi],xmm2
           ;-------------------------------------------------------------
           ;=====================DELTA Y=================================
           mov eax,pt.y
           sub eax,ShootY
           mov edx,WINPLACE.rcNormalPosition.top
           sub eax,edx
           sub eax,40
           cvtsi2ss xmm3,eax
           movss dword ptr [esi+8],xmm3
           ;-------------------------------------------------------------
 
         
            FLD dword ptr [esi+8]
         
           FLD dword ptr [esi]
           FPATAN
		    mov edi,offset anglePlayer
		   FST qword ptr [edi]
		   cvtsd2ss xmm0,qword ptr [edi]
		   movss realanglePlayer,xmm0
		   cvtss2si eax,xmm0
		   mov realanglePlayer,eax
		   
		   mov eax,realanglePlayer
		
		
		 
		   cmp eax,-0;0
		   je right

		   cmp eax,-1;1
		   je up

		   cmp eax,-2
		   je up

		   cmp eax,-3
		   je left

		   cmp eax,-4
		   je left

	
		   cmp eax,0;0
		   je right

		   cmp eax,1;1
		   je down

		   cmp eax,2
		   je down

		   cmp eax,3
		   je left

		   cmp eax,4
		   je left


		   right:
		   mov Player.CURRENTFACING,385
		   jmp endGetPlayerAngleAndFix
		   left:
		   mov Player.CURRENTFACING,130
		   jmp endGetPlayerAngleAndFix
		   down:
		   mov Player.CURRENTFACING,260
		   jmp endGetPlayerAngleAndFix
		   up:
		   mov Player.CURRENTFACING,0
		   endGetPlayerAngleAndFix:
		   
 ;================================================================================
 ret
 GetPlayerAngleAndFix	ENDP

ProjectWndProc  PROC,   hWnd:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
        local paint:PAINTSTRUCT
        local hdc:HDC
        local brushcolouring:HBRUSH
                local brushcolouring2:HBRUSH
            local hdcMem:HDC
                local hbmOld:HBITMAP
                local bm:BITMAP
                local rectforpic:RECT   
               local hdcBuffer:HDC
				local hbmBuffer:HBITMAP
				local hOldBuffer:HBITMAP
				local testrc:RECT
        cmp     message,        WM_PAINT
        je      painting
		cmp message,	WM_RBUTTONDOWN
		je pushing
        cmp message,    WM_CLOSE
        je      closing     
        cmp message,    WM_TIMER
        je      timing
		cmp message,WM_ERASEBKGND
		je returnnonzero
		cmp message, WM_SOCKET
		je handlesocket
        cmp message,	WM_CREATE
		je create     
        jmp OtherInstances
       
	   returnnonzero:
	   mov eax,1
	   ret

	   handlesocket:
	   mov eax,lParam 
        .if ax==FD_CONNECT            ; the low word of lParam contains the event code. 
            shr eax,16                              ; the error code (if any) is in the high word of lParam 
            .if ax==NULL 
                ;<no error occurs so proceed> 
            .else 
					invoke ExitProcess, 1
            .endif 
        .elseif    ax==FD_READ 
            shr eax,16 
            .if ax==NULL 
				 invoke ioctlsocket, sock, FIONREAD, addr available_data 
				 .if eax==NULL 				    
					invoke recvfrom, sock, offset buffer_for_sock, 1024, 0,NULL,NULL
					;invoke MessageBox, hWnd,offset irecievedsomething,offset irecievedsomething,MB_OK
					.if connected_to_friend == TRUE
					invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					cmp eax,0
					je you_are_the_host

					invoke crt_strcmp,offset buffer_for_sock,offset not_two_players
					cmp eax,0
					jne two_players_yes
					mov connected_to_friend,FALSE
					mov two_Players,FALSE
					jmp endofrecieve
					two_players_yes:
						mov ebx, offset buffer_for_sock
						cmp byte ptr [ebx],0
						jne norecieveplayer

						inc ebx
						mov eax, [ebx]
						mov Player2.x, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.y, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTFACING, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTSTEP, eax
						
						add ebx, 4
						mov eax, [ebx]
						mov Player2.CURRENTACTION, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTACTIONMASK, eax
						
						add ebx,4
						invoke RtlMoveMemory,offset enemybullets,ebx,24*40
						cmp host,TRUE
						je dont_recieve_player2_life_and_score
						
						add ebx,4
						mov eax,[ebx]
						mov scoreNum,eax
						
						add ebx,4
						mov eax,dword ptr [ebx]
						add Player_Life,eax
						dont_recieve_player2_life_and_score:
						jmp endofrecieve
						
						norecieveplayer:
						
						
						cmp byte ptr [ebx],1
						jne norecievebullets
						
						;cmp host,TRUE
						;je no_need_to_check_if_recieved_bullets
						;invoke MessageBox,0,offset recievingbullets,offset recievingbullets,MB_OK 
						;no_need_to_check_if_recieved_bullets:
								

						inc ebx
						invoke RtlMoveMemory ,offset enemybullets,ebx,24*40

						jmp endofrecieve

						norecievebullets:

						cmp host,TRUE
						je norecievezombies
						cmp byte ptr [ebx],2
						jne norecievezombies
						;invoke MessageBox, hWnd,offset recievingzombies,offset recievingzombies,MB_OK
						inc ebx
						invoke RtlMoveMemory,offset zombies,ebx,25*36
						jmp endofrecieve
						norecievezombies:


						cmp host,TRUE
						je norecievezombies2
						cmp byte ptr [ebx],3
						jne norecievezombies2
						;invoke MessageBox, hWnd,offset recievingxy,offset recievingxy,MB_OK
						inc ebx
						mov esi,offset zombies
						add esi,25*36
						invoke RtlMoveMemory,esi,ebx,25*36
						jmp endofrecieve
						norecievezombies2:

						cmp host,TRUE
						je norecievecoins
						cmp byte ptr [ebx],4
						jne norecievecoins

						inc ebx
						invoke RtlMoveMemory,offset coins,ebx,50*12
						add ebx,50*12
						invoke RtlMoveMemory,offset Packs,ebx,10*16
						jmp endofrecieve
						norecievecoins:

						endofrecieve:
						ret
					.endif
					

					invoke crt_strcmp, offset buffer_for_sock, offset doyouwanttoconnect
					cmp eax, 0
					je sendyes

					invoke crt_strcmp, offset buffer_for_sock, offset get_ready_for_ip
					cmp eax, 0
					je getreadyforip

					invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					cmp eax,0
					je you_are_the_host

					;invoke crt_strcmp,offset buffer_for_sock,offset you_are_not_host
					;cmp eax,0
					;je you_are_not_the_host


					.if expecting_PORT == TRUE
				     invoke crt_atoi, offset buffer_for_sock
					 mov clientport, eax
					 mov expecting_PORT, FALSE

					 
					 mov clientsin.sin_family, AF_INET 
					 invoke htons, clientport                    ; convert port number into network byte order first 
					 mov clientsin.sin_port,ax                  ; note that this member is a word-size param. 
			     	 invoke inet_addr, addr clientip    ; convert the IP address into network byte order 
			 		 mov clientsin.sin_addr,eax 
					 

					 invoke CreateThread, NULL, NULL, offset sendlocation,offset clientsin, NULL, NULL
					 mov connected_to_friend, TRUE
					 mov two_Players,TRUE
					 mov STATUS,1
					 ;invoke MessageBox, hWnd,offset connectedtopeer,offset connectedtopeer,MB_OK
					.endif


					.if expecting_IP == TRUE
						;invoke crt_strcmp,offset buffer_for_sock,offset you_are_host
					;cmp eax,0
					;je you_are_the_host
					
						 invoke crt_strcpy, offset clientip, offset buffer_for_sock
						 mov textoffset, offset clientip
						 mov expecting_PORT, TRUE
						 mov expecting_IP, FALSE
					.endif	
					COMMENT @				
						mov ebx, offset buffer_for_sock
						mov eax, [ebx]
						mov Player2.x, eax
			
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.y, eax

						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTFACING, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTSTEP, eax
						
						add ebx, 4
						mov eax, [ebx]
						mov Player2.CURRENTACTION, eax
						
						add ebx, 4
						mov eax, [ebx]		
						mov Player2.CURRENTACTIONMASK, eax
						@
				.endif
                ;<no error occurs so proceed> 
            .else 
				invoke ExitProcess, 1
            .endif 
        .elseif   ax==FD_CLOSE 
            shr eax,16 
            .if ax==NULL 
                ;<no error occurs so proceed> 
            .else 
				invoke ExitProcess, 1
            .endif 
        .endif 
		ret


		getreadyforip:
		mov expecting_IP, TRUE
		;invoke MessageBox, 0,offset expectingip,offset expectingip,MB_OK
 
		ret


		sendyes:
		invoke crt_strlen, offset yesiamsure
		invoke sendto,sock, offset yesiamsure, eax, 0, offset sin, sizeof sin
		mov expecting_IP, TRUE
		;invoke MessageBox, hWnd,offset captionyesiwanttoconnect,offset captionyesiwanttoconnect,MB_OK
		ret
		
		you_are_the_host:
		mov host,TRUE
		cmp two_Players,TRUE
		je nosetx
		mov Player.x,600
		nosetx:
		invoke MessageBox, 0,offset iamhost,offset iamhost,MB_OK
		ret


		you_are_not_the_host:
		mov host,FALSE
		;invoke MessageBox, hWnd,offset iamnothost,offset iamnothost,MB_OK
		ret

	   pushing:
	   invoke Push_Zombies, Player.x,Player.y,RECT_WIDTH,RECT_HEIGHT
	   ret

       create:
	   movss xmm0,cos_angle_world
 movss xForm.eM11,xmm0
 movss xmm0,sin_angle_world
 movss xForm.eM12,xmm0
 movss xmm0,minus_sin_angle_world
 movss xForm.eM21,xmm0
 movss xmm0,cos_angle_world
 movss xForm.eM22,xmm0
 movss xmm0,ZeroPointZero
 movss xForm.ex,xmm0
 movss xmm0,ZeroPointZero
 movss xForm.ey,xmm0

 movss xmm0,OnePointZero
 movss normal_xForm.eM11,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.eM12,xmm0
movss xmm0,ZeroPointZero
 movss normal_xForm.eM21,xmm0
movss xmm0,OnePointZero
 movss normal_xForm.eM22,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.ex,xmm0
 movss xmm0,ZeroPointZero
 movss normal_xForm.ey,xmm0


	   mov offsetToEndofArray,LengthofLeaf
	   invoke CreateFont,56,50,180,90,FW_BOLD,FALSE,FALSE,FALSE,ANSI_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH or FF_DECORATIVE,NULL
	   mov MyFont,eax
	   invoke GetModuleHandle,NULL
       invoke LoadBitmap,eax,101
       mov zombiebr,eax

	   invoke GetModuleHandle,NULL
	   invoke LoadBitmap,eax,117
	   mov hWalk,eax

	   invoke Get_Handle_To_Mask_Bitmap,	hWalk,	00ffffffh
	   mov hWalkMask,eax

	   invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,121
		mov WaitingScreenBMP,eax

		invoke Get_Handle_To_Mask_Bitmap,	WaitingScreenBMP,	00ffffffh
		mov WaitingScreenBMPMask,eax
		
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,120
		mov Online,eax

		invoke Get_Handle_To_Mask_Bitmap,	Online,	00ffffffh
		mov OnlineMask,eax
		
		 invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,122
		mov ArrowBMP,eax

		invoke Get_Handle_To_Mask_Bitmap,	ArrowBMP,	00ffffffh
		mov ArrowBMPMask,eax
		

		mov eax,hWalk
		mov Player.CURRENTACTION,eax
		mov eax,hWalkMask
		mov Player.CURRENTACTIONMASK,eax

		invoke GetTickCount
		mov Player.TimeStepShouldDisappear,eax
		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,102
		mov hCoinColour,eax

		invoke Get_Handle_To_Mask_Bitmap,	hCoinColour,	00ffffffh
		mov hCoinMask,eax

		invoke GetModuleHandle,NULL
		invoke LoadBitmap,eax,103
		mov hHealthPackColour,eax

		
		invoke Get_Handle_To_Mask_Bitmap,	hHealthPackColour,	00ffffffh
		mov hHealthPackMask,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,104
        mov NewGame,eax

		invoke Get_Handle_To_Mask_Bitmap,	NewGame,	00ffffffh
		mov NewGameMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,105
        mov Options,eax

		invoke Get_Handle_To_Mask_Bitmap,	Options,	00ffffffh
		mov OptionsMasked,eax

		
		; invoke GetModuleHandle,NULL
        ;invoke LoadBitmap,eax,106
        ;mov HighScores,eax

		;invoke Get_Handle_To_Mask_Bitmap,	HighScores,	00ffffffh
		;mov HighScoresMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,118
        mov OptionScreenhbitmap,eax

		

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,107
        mov Exiting,eax

		invoke Get_Handle_To_Mask_Bitmap,	Exiting,	00ffffffh
		mov ExitingMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,108
        mov StartScreenBK,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,109
        mov HighlightBIT,eax
		invoke Get_Handle_To_Mask_Bitmap,	HighlightBIT,	00ffffffh
		mov HighlightBITMasked,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,110
        mov StoreBK,eax

		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,111
        mov cost,eax
		invoke Get_Handle_To_Mask_Bitmap,	cost,	00ffffffh
		mov costMasked,eax

		
		 invoke GetModuleHandle,NULL
        invoke LoadBitmap,eax,112
        mov score,eax
		invoke Get_Handle_To_Mask_Bitmap,	score,	00ffffffh
		mov scoreMasked,eax

		invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,114
			mov Rightz,eax
			invoke Get_Handle_To_Mask_Bitmap,	Rightz,	00ffffffh
		mov RightzMask,eax


		invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,113
			mov Frontz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Frontz,	00ffffffh
		mov FrontzMask,eax


		 invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,115
			mov Leftz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Leftz,	00ffffffh
		mov LeftzMask,eax

		 invoke GetModuleHandle,NULL
			invoke LoadBitmap,eax,116
			mov Backz,eax
				invoke Get_Handle_To_Mask_Bitmap,	Backz,	00ffffffh
		mov BackzMask,eax

        invoke LoadCursor,NULL,IDC_CROSS
        mov icursor,eax
			
	   ret
       
        closing:
		cmp two_Players,FALSE
	je nosend_host_close
	cmp host,FALSE
	je nosend_host
	invoke sendto,sock, offset you_are_host, 1024, 0, offset clientsin, sizeof clientsin
	mov connected_to_friend,FALSE
	nosend_host_close:
		invoke CloseProcess	
 
 
        painting:
				
		        invoke  BeginPaint,     hWnd,   addr paint
				mov hdc, eax
				invoke SetGraphicsMode,hdc,GM_ADVANCED
				invoke CreateCompatibleDC,hdc
				mov hdcBuffer,eax
				invoke CreateCompatibleBitmap,hdc,WINDOW_WIDTH,WINDOW_HEIGHT
				mov hbmBuffer,eax
				invoke SelectObject,hdcBuffer,hbmBuffer
				mov hOldBuffer,eax
				invoke SetGraphicsMode,hdcBuffer,GM_ADVANCED
				invoke SetCursor,icursor
				cmp STATUS,0
				jne noStart
				invoke StartScreen,hdcBuffer,hWnd
				jmp endingofpainting
				noStart:

				cmp STATUS,2
				jne noStore
				invoke DrawStore,hdcBuffer
				jmp endingofpainting
				ret
				noStore:
				
				cmp STATUS,3
				jne noOptions
				invoke OptionsScreen,hdcBuffer
				jmp endingofpainting
				noOptions:
				
				cmp STATUS,4
				jne noWaitingForOtherPlayer
				invoke WaitingScreen,hdcBuffer
				jmp endingofpainting
				noWaitingForOtherPlayer:

                cmp RECT_WIDTH,RECT_WIDTH_BACKUP
                je iflat
                mov eax,RECT_HEIGHT_BACKUP/2
                add eax,Player.x
                mov ShootX,eax
                mov eax,RECT_WIDTH_BACKUP/2
                add eax,Player.y
                mov ShootY,eax
                jmp fin
                iflat:
                mov eax,RECT_WIDTH_BACKUP/2
                add eax,Player.x
                mov ShootX,eax
                mov eax,RECT_HEIGHT_BACKUP/2
                add eax,Player.y
                mov ShootY,eax
                fin:
				
				
				;invoke SetWorldTransform,hdcBuffer,offset xForm;WORKS GREAT--------------------------------------------
				;invoke SetWorldTransform,hdcBuffer,offset xForm
				invoke DrawImage,hdcBuffer,zombiebr,0,0,0,0, 1504,910 ,WINDOW_WIDTH,WINDOW_HEIGHT
				;invoke SetWorldTransform,hdcBuffer,offset normal_xForm;WORKS GREAT--------------------------------------------
				invoke GetPlayerAngleAndFix,hWnd
				
 pusha
 
 invoke SetWorldTransform,hdcBuffer,offset xForm;WORKS GREAT
 invoke GetClientRect,hWnd,addr testrc
 invoke DPtoLP,hdcBuffer,addr testrc,2
 invoke GetStockObject,WHITE_BRUSH
 invoke SelectObject,hdcBuffer,eax
 mov eax,testrc.right
 sub eax,100
 mov ebx,testrc.bottom
 add ebx,100
 mov ecx,testrc.right
 add ecx,100
 mov edx,testrc.bottom
 sub edx,100
 invoke Ellipse,hdcBuffer,eax,ebx,ecx,edx

 mov eax,testrc.right
 sub eax,94
 mov ebx,testrc.bottom
 add ebx,94
 mov ecx,testrc.right
 add ecx,94
 mov edx,testrc.bottom
 sub edx,94
 invoke Ellipse,hdcBuffer,eax,ebx,ecx,edx

 mov eax,testrc.right
 sub eax,13
 mov ebx,testrc.bottom
 add ebx,113
 mov ecx,testrc.right
 add ecx,13
 mov edx,testrc.bottom
 add edx,50
 invoke Rectangle,hdcBuffer,eax,ebx,ecx,edx

 mov eax,testrc.right
 sub eax,13
 mov ebx,testrc.bottom
 add ebx,96
 mov ecx,testrc.right
 add ecx,13
 mov edx,testrc.bottom
 sub edx,50
 invoke Rectangle,hdcBuffer,eax,ebx,ecx,edx

 mov eax,testrc.bottom
 sub eax,150
 invoke MoveToEx,hdcBuffer,testrc.right,eax,NULL
 mov eax,testrc.bottom
 sub eax,16
 invoke LineTo,hdcBuffer,testrc.right,eax

 mov eax,testrc.bottom
 sub eax,13
 invoke MoveToEx,hdcBuffer,testrc.right,eax,NULL
 mov eax,testrc.bottom
 add eax,13
 invoke LineTo,hdcBuffer,testrc.right,eax

 
 mov eax,testrc.bottom
 add eax,16
 invoke MoveToEx,hdcBuffer,testrc.right,eax,NULL
 mov eax,testrc.bottom
 add eax,150
 invoke LineTo,hdcBuffer,testrc.right,eax
 invoke SetWorldTransform,hdcBuffer,offset normal_xForm;WORKS GREAT

 popa


				;DrawImage_WithMask PROC, hdc:HDC, img:HBITMAP, maskedimg:HBITMAP,  x:DWORD, y:DWORD,w:DWORD,h:DWORD,x2:DWORD,y2:DWORD,wstrech:DWORD,hstrech:DWORD
				invoke DrawImage_WithMask,hdcBuffer, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,Player.x,Player.y,75,105,Player.CURRENTSTEP,Player.CURRENTFACING,RECT_WIDTH,RECT_HEIGHT,offset normal_xForm
				;do cmp two players
				;make a function that gets a code for an img and returns the hbitmap for that image #for drawing the second player in, you can't send hbitmaps because they are loaded differently in each run of the program
				cmp two_Players,FALSE
				je dontdrawplayer2
				invoke DrawImage_WithMask,hdcBuffer, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,Player2.x,Player2.y,75,105,Player2.CURRENTSTEP,Player2.CURRENTFACING,RECT_WIDTH,RECT_HEIGHT,offset normal_xForm
				dontdrawplayer2:
				invoke DrawScore,hdcBuffer
				invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
               
                invoke SelectObject, hdcBuffer,brushcolouring
				
        invoke SetDCBrushColor, hdcBuffer,   0000000000FFh
        mov brushcolouring, eax
			;invoke BUILDRECT,EnemyX,EnemyY,30,30,hdcBuffer,brushcolouring
				COMMENT @
                  invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
               
                invoke SelectObject, hdcBuffer,brushcolouring
				
        invoke SetDCBrushColor, hdcBuffer,   0000000000FFh
        mov brushcolouring, eax
		
        invoke BUILDRECT, hdc, Player.CURRENTACTION,  Player.CURRENTACTIONMASK,  RECT_WIDTH,     hdcBuffer,  brushcolouring
				@

                invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
		invoke SelectObject, hdcBuffer,brushcolouring
                invoke SetDCBrushColor, hdcBuffer, 000000F0870Fh
                mov brushcolouring,eax
                
                invoke bullet,hdcBuffer,brushcolouring,offset bullets,hWnd;MAYBE REMOVE
				invoke SetDCBrushColor,hdcBuffer,0000000F87FFh
				invoke bullet,hdcBuffer,brushcolouring,offset enemybullets,hWnd;MAYBE REMVOE
               invoke SetWorldTransform,hdcBuffer,offset normal_xForm
			    
               
                invoke GetStockObject,  DC_BRUSH
        mov brushcolouring, eax
                invoke SetDCBrushColor, hdcBuffer, 0077ff00h
                mov brushcolouring,eax
				;cmp host,TRUE
				;je noadvance
				;invoke AdvanceZombie_and_CheckIfDead,hWnd
				;noadvance:
                invoke DrawZombie,hdcBuffer,brushcolouring,hWnd
				invoke DrawCoin,hdcBuffer,brushcolouring
				invoke Draw_Packs,hdcBuffer
				invoke Draw_Player_Health_Bar,Player.x,Player.y,hdcBuffer,brushcolouring
	
				invoke Draw_Sprint_Bar,Player.x,Player.y,hdcBuffer,brushcolouring
				endingofpainting:
				invoke BitBlt,hdc,0,0,WINDOW_WIDTH,WINDOW_HEIGHT,hdcBuffer,0,0,SRCCOPY
	invoke SelectObject,hdcBuffer,hOldBuffer
	invoke DeleteObject,hbmBuffer
	invoke DeleteDC,hdcBuffer
	invoke crt_strlen, textoffset
				invoke TextOut, hdc, 0,0,textoffset,eax
 
        invoke EndPaint, hWnd,  addr paint
		cmp STATUS,1
		jne realend
		cmp Player_Life,0       
		jle endgame
		cmp two_Players,FALSE
		je needtocheck
		cmp host,FALSE
		je noneedtocheck
		
		
		invoke Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin,Player2.x,Player2.y
		invoke Check_If_Player_Hit_Pack_And_Remove_Pack,Player2.x,Player2.y,offset player2_health_to_add
		needtocheck:
		invoke Check_If_Player_Hit_Coin_Add_Money_And_Remove_Coin,Player.x,Player.y
		invoke Check_If_Player_Hit_Pack_And_Remove_Pack,Player.x,Player.y,offset Player_Life
		noneedtocheck:

		invoke Check_If_Player_Hit_And_Remove_Life,Player.x,Player.y,RECT_WIDTH,RECT_HEIGHT
		cmp Found,1
		je endmovement
		
		
	
        invoke GetAsyncKeyState,41h;A Key
        cmp eax, 0
        jne moveleft
        invoke GetAsyncKeyState,44h;D Key
        cmp eax, 0
        jne moveright
        jumpingcheck:
        cmp jmpingUp, 1
        je jmpUp
        cmp jmpingDown, 1
        je jmpDown
        invoke GetAsyncKeyState, VK_SPACE
        cmp eax, 0
        jne startjmp
        checkupdown:
        invoke GetAsyncKeyState, 57h ;W Key
        cmp eax, 0
        jne moveup
        invoke GetAsyncKeyState, 53h;S Key
        cmp eax, 0
        jne movedown
       
        jmp endmovement
        startjmp:        
        mov jmpingUp, 1        
                mov eax, Player.y
        mov StartY, eax
                sub eax, JMP_HEIGHT
                mov dstY, eax
        jmp endmovement
                hello:
                dec PlayerX2
                jmp jumpingcheck
jmpUp:
    mov ecx, dstY
    cmp Player.y, ecx
    jng startJmpingDown
    cmp Player.y, 5
    jng startJmpingDown
    mov eax, Player.y
    sub eax, JMP_SPEED
    mov Player.y, eax
    jmp endmovement
startJmpingDown:
    mov jmpingUp, 0
    mov jmpingDown, 1
    jmp endmovement
jmpDown:
        mov ecx, StartY
    cmp Player.y, ecx
    jnl stopJmping
   mov eax, Player.y
    add eax, JMP_SPEED
    mov Player.y, eax
    jmp endmovement
stopJmping:
    mov jmpingDown, 0
    jmp endmovement
   
moveleft:
		
      				invoke GetAsyncKeyState,VK_LSHIFT;A Key
		cmp eax,0
        je noSprint
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint1
		jmp noSprint
		NoSprint1:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint:
    ;mov RECT_HEIGHT, RECT_HEIGHT_BACKUP
    ;mov RECT_WIDTH, RECT_WIDTH_BACKUP
        mov eax, Player.speed
        sub Player.x, eax
		invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext1
		cmp Player.CURRENTSTEP,1000
		jl NoMax1
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext1
		NoMax1:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext1:
        jmp jumpingcheck
moveright:
						invoke GetAsyncKeyState,VK_LSHIFT;A Key
		cmp eax,0
        je noSprint1
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint2
		jmp noSprint1
		NoSprint2:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint1:
		;mov RECT_HEIGHT, RECT_HEIGHT_BACKUP
		;mov RECT_WIDTH, RECT_WIDTH_BACKUP
        mov eax, Player.speed
        add Player.x, eax
		invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext2
		cmp Player.CURRENTSTEP,1000
		jl NoMax2
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext2
		NoMax2:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext2:
        jmp jumpingcheck
movedown:
		
        cmp jmpingUp, 1
        je endmovement
        cmp jmpingDown, 1
        je endmovement
					invoke GetAsyncKeyState,VK_LSHIFT;A Key
		cmp eax,0
        je noSprint2
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint3
		jmp noSprint2
		NoSprint3:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint2:
    ;mov RECT_HEIGHT, RECT_WIDTH_BACKUP
    ;mov RECT_WIDTH, RECT_HEIGHT_BACKUP
    mov eax, Player.speed
    add Player.y,eax    
	invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext3
		cmp Player.CURRENTSTEP,1000
		jl NoMax3
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext3
		NoMax3:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext3:  
    jmp endmovement
moveup:
        cmp jmpingUp, 1
        je endmovement
        cmp jmpingDown, 1
        je endmovement
					invoke GetAsyncKeyState,VK_LSHIFT;A Key
		cmp eax,0
        je noSprint3
		mov Player.speed,8
		sub sprintmeter,10
		cmp sprintmeter,0
		jle NoSprint4
		jmp noSprint3
		NoSprint4:
		mov sprintmeter,0
		mov Player.speed,6
		noSprint3:	
    ;mov RECT_HEIGHT, RECT_WIDTH_BACKUP
    ;mov RECT_WIDTH, RECT_HEIGHT_BACKUP
    mov eax, Player.speed
    sub Player.y,eax
     invoke GetTickCount
		cmp Player.TimeStepShouldDisappear,eax
		jg DontChangeToNext4
		cmp Player.CURRENTSTEP,1000
		jl NoMax4
		mov Player.CURRENTSTEP,0
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		jmp DontChangeToNext4
		NoMax4:
		add Player.CURRENTSTEP,127
		invoke GetTickCount
		add eax,Player.Time_Between_Steps_P
		mov Player.TimeStepShouldDisappear,eax
		DontChangeToNext4:
endmovement:
 xor eax,eax
 mov Found,eax
 mov Player.speed,6
 cmp sprintmeter,500
 jl incsprint
 mov sprintmeter,500
 jmp noincsprint
 incsprint:
 inc sprintmeter
 noincsprint:
 
endhere:
        cmp Player.y, WINDOW_HEIGHT
        jg BottomBorder
        cmp Player.y, 0
        jl TopBorder
        cmp Player.x, WINDOW_WIDTH
        jg RightBorder
        cmp Player.x, 0
        jl LeftBorder
        jmp realend
BottomBorder:
        mov eax,RECT_HEIGHT;0+RECT_HEIGHT
        mov Player.y, eax
        jmp realend
TopBorder:
        mov eax, WINDOW_HEIGHT
		sub eax,RECT_HEIGHT
        mov Player.y, eax
        jmp realend
RightBorder:
        mov eax, 0
        mov Player.x, eax
        jmp realend
LeftBorder:
        mov eax, WINDOW_WIDTH
		sub eax,RECT_WIDTH
        mov Player.x, eax
      
realend:
	
        ret
 
 
timing:
                cmp wParam,secondtimer
				je secondtiming
				cmp wParam,RoundEnded
				je EndingRound
				cmp wParam,ZombieTime
                je ZombieSpawn
                cmp wParam,ZombieAdjust
                je ZombieAdjusting
                cmp wParam,ShootingTime
                jne PaintingTime

				cmp STATUS,1
				jne EndingTime

                invoke GetAsyncKeyState, VK_LBUTTON
            cmp eax,0
            je EndingTime
			invoke GetWindowPlacement,hWnd,OFFSET WINPLACE
			mov ebx, offset bullets
			mov ecx,48
			loopingcheckingempty:
		   cmp dword ptr [ebx],-999
		   jne nexting
		   ;cmp host,TRUE
		   ;je noneedtodebug
		   ;invoke MessageBox,0,offset createbulleting,offset createbulleting,MB_OK
		   ;noneedtodebug:
		   invoke createbullet
		   jmp EndingTime
		   nexting:
		   add ebx,40
		   loop loopingcheckingempty
         endnexting:
       
          jmp EndingTime
 
		
		secondtiming:
		
		cmp STATUS,1
		jne EndingTime
		cmp FoundForSound,1
		jne nobite
		;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
	    ;invoke PlaySound, offset SoundPathBite, NULL,SND_ASYNC;	Special Thanks To Tal Bortman
		mov FoundForSound,0
nobite:

		;invoke waveOutSetVolume, NULL , volume;	Special Thanks To Tal Bortman
		;invoke PlaySound,offset SoundPath,NULL,SND_ASYNC
		sub realtimetillend,1
		jmp EndingTime

ZombieAdjusting:
				
				cmp STATUS,1
				jne EndingTime
				cmp two_Players,FALSE
				je dontcheck_host1
				cmp host,FALSE
				je EndingTime
				dontcheck_host1:
				invoke adjustzombie
             
              jmp EndingTime
 
 
 
                ZombieSpawn:
                ;---------------------------------------------------------
				
			
				cmp STATUS,1
				jne EndingTime
				cmp two_Players,FALSE
				je dontcheck_host2
				cmp host,FALSE
				je EndingTime
				dontcheck_host2:
				mov ecx,Number_To_Spawn
				spawningloop:
				push ecx
                 mov ebx,offset zombies
				 mov ecx,80
               loopcheckingifemptyz:
			   mov eax,dword ptr [ebx]
			   cmp eax,-999
			   jne nextzing
			   jmp endloopcheckingifemptyz
			   nextzing:
			   add ebx,36
			   loop loopcheckingifemptyz
			   jmp EndingTime
			   endloopcheckingifemptyz:
			 
             
       mov dword ptr [ebx+16],0
	   mov dword ptr [ebx+28],0
	   push ebx
	   invoke GetTickCount
	   add eax,Time_Between_Steps
	   mov dword ptr [ebx+32],eax
	   pop ebx
           mov savingnewzombieplace,ebx
         pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov ebx,4
           xor edx,edx
           div ebx
           cmp edx,0
           je lefti
           cmp edx,1
           je upi
           cmp edx,2
           je righti
           bottomi:
           mov ebx,savingnewzombieplace
           mov eax,WINDOW_HEIGHT
		   cvtsi2ss xmm0,eax
		   movss dword ptr [ebx+4],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_WIDTH
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx],xmm0
		   invoke adjustzombie
           jmp endi

           lefti:
           mov ebx,savingnewzombieplace
		   xor eax,eax
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_HEIGHT
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx+4],xmm0
		   invoke adjustzombie
          jmp endi
 
           upi:
           mov ebx,savingnewzombieplace
		   xor eax,eax
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx+4],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_WIDTH
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx],xmm0
		   invoke adjustzombie
           jmp endi
 
           righti:
           mov ebx,savingnewzombieplace
		   mov eax,WINDOW_WIDTH
		   cvtsi2ss xmm0,eax
           movss dword ptr [ebx],xmm0
           pusha
           invoke GetRandomNumber,4,offset randombuffer
           popa
           mov eax,randombuffer
           mov edi,WINDOW_HEIGHT
           xor edx,edx
           div edi
		   cvtsi2ss xmm0,edx
           movss dword ptr [ebx+4],xmm0
		   invoke adjustzombie
           endi:
           pop ecx
		   dec ecx
		   jnz spawningloop;loop spawningloop
		   
           
            jmp EndingTime
            ;=====================================================================
               
			   EndingRound:
			   mov STATUS,2
			   mov eax,TimeTillRoundEnds
			   mov ecx,1000
			   idiv ecx
			   mov realtimetillend,eax
			   jmp EndingTime

                PaintingTime:
        invoke InvalidateRect, hWnd, NULL, FALSE
                EndingTime:
        ret
OtherInstances:
        invoke DefWindowProc, hWnd, message, wParam, lParam
        ret

	endgame:
	cmp two_Players,FALSE
	je nosend_host
	cmp host,FALSE
	je nosend_host
	invoke sendto,sock, offset you_are_host, 1024, 0, offset clientsin, sizeof clientsin
	mov connected_to_friend,FALSE
	nosend_host:
	invoke MessageBox, hWnd,offset deadmsg,offset deadcaption,MB_OK
	invoke CloseProcess
ProjectWndProc  ENDP
 
main PROC
 
 
LOCAL wndcls:WNDCLASSA ; Class struct for the window
LOCAL hWnd:HWND ;Handle to the window
LOCAL msg:MSG
LOCAL animcls:WNDCLASSA
invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class
mov eax, offset ClassName
mov wndcls.lpszClassName, eax ;Set the class name
invoke GetStockObject, BLACK_BRUSH
mov wndcls.hbrBackground, eax ;Set the background color as black
mov eax, ProjectWndProc
mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
invoke RegisterClassA, addr wndcls ;Register the class
invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 100, 100, WINDOW_WIDTH, WINDOW_HEIGHT, 0, 0, 0, 0 ;Create the window
mov hWnd, eax ;Save the handle
invoke ShowWindow, eax, SW_SHOW ;Show it

COMMENT @
invoke RtlZeroMemory, addr animcls, SIZEOF wndcls ;Empty the window class
;mov eax, offset AnimClassName
mov animcls.lpszClassName, offset AnimClassName ;Set the class name
invoke GetStockObject, BLACK_BRUSH
mov animcls.hbrBackground, eax ;Set the background color as black
;mov eax, ProjectWndProc
;mov animcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
invoke RegisterClassA, addr animcls ;Register the class

invoke GetModuleHandle,NULL 
invoke CreateWindowEx , ANIMATE_CLASSA, addr AnimWindowName,	hWnd,200,ACS_AUTOPLAY,eax
invoke ShowWindow, eax, SW_SHOW ;Show it


;CreateWindow(ANIMATE_CLASS,NULL,s,0,0,0,0,w,(HMENU)(i),hI,NULL)
;invoke GetModuleHandle,NULL
;invoke Animate_Create,hWnd,200,ACS_AUTOPLAY,eax
@
invoke SetTimer, hWnd, MAIN_TIMER_ID, 20, NULL ;Set the repaint timer
invoke SetTimer, hWnd, ShootingTime, 125, NULL ;Set the shooting time
invoke SetTimer, hWnd, ZombieTime, Zombie_Spawning_Time , NULL ;Set the zombie time
invoke SetTimer, hWnd, ZombieAdjust, 15, NULL ;Set the zombie adjustment time
invoke SetTimer, hWnd, secondtimer, 1000, NULL ;Set the zombie adjustment time


mov WINPLACE.iLength,SIZEOF WINPLACE

 
 mov textoffset, offset text

COMMENT @
invoke WSAStartup, 101h,addr wsadata 
.if eax!=NULL 
    invoke ExitProcess, 1;<An error occured> 
.else 
    xor eax, eax ;<The initialization is successful. You may proceed with other winsock calls> 
.endif

invoke socket,AF_INET,SOCK_DGRAM,0     ; Create a stream socket for internet use 
.if eax!=INVALID_SOCKET 
    mov sock,eax 
.else 
    invoke ExitProcess, 1
.endif

invoke WSAAsyncSelect, sock, hWnd,WM_SOCKET, FD_READ 
            ; Register interest in connect, read and close events. 
.if eax==SOCKET_ERROR 
	invoke WSAGetLastError
    invoke ExitProcess, 1;<put your error handling routine here> 
.else 
    xor eax, eax  ;........ 
.endif


mov sin.sin_family, AF_INET 
invoke htons, Port                    ; convert port number into network byte order first 
mov sin.sin_port,ax                  ; note that this member is a word-size param. 
invoke inet_addr, addr IPAddress    ; convert the IP address into network byte order 
mov sin.sin_addr,eax 
invoke crt_strlen, offset pleaseconnectus
invoke sendto,sock, offset pleaseconnectus, eax, 0, offset sin, sizeof sin
invoke WSAGetLastError
@
msgLoop:
 ; PeekMessage
invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window
invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure
jmp msgLoop
invoke ExitProcess, 1
main ENDP
end main