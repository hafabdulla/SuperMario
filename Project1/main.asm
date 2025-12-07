INCLUDE Irvine32.inc

.data

ground			BYTE "------------------------------------------------------------------------------------------------------------------------",0

strScore		BYTE "Your score is: ",0
strLives		BYTE " Lives: ",0
score			DWORD 0
lives			BYTE 3

xPos			BYTE 40  ; Player fixed at center of screen
yPos			BYTE 28  ; Start at ground level
groundLevel		BYTE 28  ; Ground level for Mario

inputChar		BYTE ?
jumpHeight		BYTE 5   ; How high Mario jumps
isJumping		BYTE 0   ; 0 = not jumping, 1 = jumping
jumpCounter		BYTE 0
isGrounded		BYTE 1   ; 1 = on ground/platform, 0 = in air
jumpCount		BYTE 0   ; Tracks number of jumps (0, 1, or 2)
isPaused		BYTE 0   ; 0 = playing, 1 = paused

; Camera/World offset
worldOffset		WORD 0   ; How far the world has scrolled

; Platform data (x, y, width)
; Format: xPos, yPos, width
platformCount	BYTE 20
platforms		BYTE 10, 26, 8    ; Platform 1
				BYTE 22, 24, 6    ; Platform 2
				BYTE 35, 26, 10   ; Platform 3
				BYTE 50, 23, 8    ; Platform 4
				BYTE 65, 25, 12   ; Platform 5
				BYTE 82, 24, 7    ; Platform 6
				BYTE 95, 26, 10   ; Platform 7
				BYTE 110, 23, 8   ; Platform 8
				BYTE 125, 25, 12  ; Platform 9
				BYTE 142, 24, 8   ; Platform 10
				BYTE 155, 26, 10  ; Platform 11
				BYTE 170, 23, 9   ; Platform 12
				BYTE 185, 25, 11  ; Platform 13
				BYTE 200, 24, 8   ; Platform 14
				BYTE 215, 26, 10  ; Platform 15
				BYTE 230, 23, 12  ; Platform 16
				BYTE 245, 25, 8   ; Platform 17
				BYTE 5, 24, 10    ; Platform 18
				BYTE 18, 26, 9    ; Platform 19
				BYTE 28, 23, 12   ; Platform 20

; Coin data (x, y, collected)
coinCount		BYTE 30
coins			BYTE 15, 25, 0    ; Coin 1
				BYTE 25, 23, 0    ; Coin 2
				BYTE 40, 25, 0    ; Coin 3
				BYTE 55, 22, 0    ; Coin 4
				BYTE 70, 24, 0    ; Coin 5
				BYTE 85, 23, 0    ; Coin 6
				BYTE 100, 25, 0   ; Coin 7
				BYTE 115, 22, 0   ; Coin 8
				BYTE 130, 24, 0   ; Coin 9
				BYTE 145, 23, 0   ; Coin 10
				BYTE 160, 25, 0   ; Coin 11
				BYTE 175, 22, 0   ; Coin 12
				BYTE 190, 24, 0   ; Coin 13
				BYTE 205, 23, 0   ; Coin 14
				BYTE 220, 25, 0   ; Coin 15
				BYTE 235, 22, 0   ; Coin 16
				BYTE 250, 24, 0   ; Coin 17
				BYTE 8, 23, 0     ; Coin 18
				BYTE 20, 25, 0    ; Coin 19
				BYTE 33, 22, 0    ; Coin 20
				BYTE 12, 27, 0    ; Coin 21 (ground level)
				BYTE 45, 27, 0    ; Coin 22
				BYTE 78, 27, 0    ; Coin 23
				BYTE 105, 27, 0   ; Coin 24
				BYTE 138, 27, 0   ; Coin 25
				BYTE 172, 27, 0   ; Coin 26
				BYTE 208, 27, 0   ; Coin 27
				BYTE 242, 27, 0   ; Coin 28
				BYTE 48, 27, 0    ; Coin 29
				BYTE 92, 27, 0    ; Coin 30

; Goomba data (x, y, direction, alive)
; direction: 0 = left, 1 = right
; alive: 0 = dead, 1 = alive
goombaCount     BYTE 10
goombas         BYTE 30, 28, 0, 1    ; Goomba 1
                BYTE 75, 28, 1, 1    ; Goomba 2
                BYTE 120, 28, 0, 1   ; Goomba 3
                BYTE 165, 28, 1, 1   ; Goomba 4
                BYTE 210, 28, 0, 1   ; Goomba 5
                BYTE 250, 28, 1, 1   ; Goomba 6
                BYTE 58, 25, 1, 1    ; Goomba 7 (on platform)
                BYTE 130, 25, 0, 1   ; Goomba 8 (on platform)
                BYTE 195, 25, 1, 1   ; Goomba 9 (on platform)
                BYTE 240, 24, 0, 1   ; Goomba 10 (on platform)

goombaSpeed     BYTE 1
goombaTimer     BYTE 0
goombaDelay     BYTE 5   ; Move every 5 frames

; Starting screen strings
title1			BYTE "  _____ _    _ _____  ______ _____  ",0
title2			BYTE " / ____| |  | |  __ \|  ____|  __ \ ",0
title3			BYTE "| (___ | |  | | |__) | |__  | |__) |",0
title4			BYTE " \___ \| |  | |  ___/|  __| |  _  / ",0
title5			BYTE " ____) | |__| | |    | |____| | \ \ ",0
title6			BYTE "|_____/ \____/|_|    |______|_|  \_\",0

mario1			BYTE "  _    _          _____  _____ ____  ",0
mario2			BYTE " | |  | |   /\   |  __ \|_   _/ __ \ ",0
mario3			BYTE " | |__| |  /  \  | |__) | | || |  | |",0
mario4			BYTE " |  __  | / /\ \ |  _  /  | || |  | |",0
mario5			BYTE " | |  | |/ ____ \| | \ \ _| || |__| |",0
mario6			BYTE " |_|  |_/_/    \_\_|  \_\_____\____/ ",0

pressKey		BYTE "Press any key to continue...",0

; Menu strings
menuTitle		BYTE "=== GAME MENU ===",0
menuOption1		BYTE "1. Start Game",0
menuOption2		BYTE "2. Instructions",0
menuOption3		BYTE "3. Exit",0
menuPrompt		BYTE "Select an option (1-3): ",0

; Instructions strings
instTitle		BYTE "=== INSTRUCTIONS ===",0
inst1			BYTE "Objective: Collect coins and reach the end!",0
inst2			BYTE "Controls:",0
inst3			BYTE "  SPACE - Jump",0
inst4			BYTE "  A - Move Left",0
inst5			BYTE "  D - Move Right",0
inst6			BYTE "  P - Pause Game",0
inst7			BYTE "  X - Exit Game",0
inst8			BYTE "Jump on Goombas (G) to defeat them!",0
inst9			BYTE "Press any key to return to menu...",0

; Pause Menu strings
pauseTitle		BYTE "=== GAME PAUSED ===",0
pauseOption1	BYTE "1. Resume Game",0
pauseOption2	BYTE "2. Restart Level",0
pauseOption3	BYTE "3. Exit to Main Menu",0
pausePrompt		BYTE "Select an option (1-3): ",0

.code
main PROC
	call ShowStartScreen
	call ShowGameMenu
	
	call Randomize
	
	; Initialize game
	mov worldOffset, 0
	mov score, 0
	mov lives, 3
	mov isJumping, 0
	mov isGrounded, 1
	mov jumpCount, 0
	mov isPaused, 0
	mov goombaTimer, 0
	
	; Reset all coins and goombas
	call ResetCoins
	call ResetGoombas

	gameLoop:
		; Check if paused
		cmp isPaused, 1
		je handlePause
		
		call Clrscr
		
		; Draw ground
		mov dl, 0
		mov dh, 29
		call Gotoxy
		mov eax, green + (black * 16)
		call SetTextColor
		mov edx, OFFSET ground
		call WriteString
		
		; Draw platforms
		call DrawPlatforms
		
		; Draw coins
		call DrawCoins
		
		; Update and draw goombas
		call UpdateGoombas
		call DrawGoombas
		
		; Draw player
		call DrawPlayer
		
		; Draw HUD
		call DrawHUD
		
		; Handle gravity and jumping
		call HandlePhysics
		
		; Check goomba collision
		call CheckGoombaCollision
		
		; Get input (non-blocking check)
		mov eax, 50
		call Delay
		
		call ReadKey
		jz noInput
		
		mov inputChar, al
		
		; exit game if user types 'x':
		cmp inputChar, "x"
		je exitGame
		
		; pause game if user presses 'p':
		cmp inputChar, "p"
		je pauseGame
		
		; jump if user presses space (ASCII 32)
		cmp inputChar, 32
		je startJump
		
		cmp inputChar, "j"
		je moveLeft
		
		cmp inputChar, "l"
		je moveRight
		
		noInput:
		jmp gameLoop
		
		pauseGame:
		mov isPaused, 1
		jmp gameLoop
		
		handlePause:
		call ShowPauseMenu
		; Check what user selected in pause menu
		cmp inputChar, "1"
		je resumeGame
		cmp inputChar, "2"
		je restartLevel
		cmp inputChar, "3"
		je exitToMenu
		jmp gameLoop
		
		resumeGame:
		mov isPaused, 0
		jmp gameLoop
		
		restartLevel:
		; Reset game state
		mov worldOffset, 0
		mov score, 0
		mov lives, 3
		mov isJumping, 0
		mov isGrounded, 1
		mov jumpCount, 0
		mov isPaused, 0
		mov goombaTimer, 0
		mov yPos, 28
		call ResetCoins
		call ResetGoombas
		jmp gameLoop
		
		exitToMenu:
		call ShowGameMenu
		; Reset game after returning from menu
		mov worldOffset, 0
		mov score, 0
		mov lives, 3
		mov isJumping, 0
		mov isGrounded, 1
		mov jumpCount, 0
		mov isPaused, 0
		mov goombaTimer, 0
		mov yPos, 28
		call ResetCoins
		call ResetGoombas
		jmp gameLoop
		
		startJump:
		; Check if we can still jump (max 2 jumps)
		mov al, jumpCount
		cmp al, 2
		jge noInput  ; Already used both jumps
		
		; Check if currently in middle of a jump
		cmp isJumping, 1
		je noInput  ; Can't start new jump while one is in progress
		
		; Start jump (first or second)
		mov isJumping, 1
		mov jumpCounter, 0
		inc jumpCount
		mov isGrounded, 0
		jmp noInput
		
		moveLeft:
		; Scroll world right (move platforms/coins right)
		call UpdatePlayer
		mov ax, worldOffset
		cmp ax, 0
		jle noInput
		dec worldOffset
		call ScrollWorld
		jmp noInput
		
		moveRight:
		; Scroll world left (move platforms/coins left)
		call UpdatePlayer
		inc worldOffset
		call ScrollWorld
		jmp noInput

	exitGame:
	exit
main ENDP

HandlePhysics PROC
	push eax
	push ecx
	
	; First, check if on surface to update grounded state
	call CheckOnSurface
	cmp al, 1
	jne notOnSurface
	
	; On surface - reset jump count if not currently jumping
	cmp isJumping, 0
	jne notOnSurface
	mov isGrounded, 1
	mov jumpCount, 0
	
	notOnSurface:
	
	cmp isJumping, 1
	je handleJump
	
	; Apply gravity if not on surface
	call CheckOnSurface
	cmp al, 1
	je onSurface
	
	; Fall down
	cmp yPos, 28
	jge onSurface
	inc yPos
	mov isGrounded, 0
	jmp donePhysics
	
	handleJump:
	mov cl, jumpCounter
	cmp cl, jumpHeight
	jge startFalling
	
	; Jump up - check if hit platform from below
	push ecx
	call CheckOnSurface
	cmp al, 1
	pop ecx
	je hitPlatformWhileRising
	
	; Jump up
	dec yPos
	inc jumpCounter
	mov isGrounded, 0
	jmp donePhysics
	
	hitPlatformWhileRising:
	; Hit platform while going up, start falling immediately
	mov cl, jumpHeight
	mov jumpCounter, cl
	jmp donePhysics
	
	startFalling:
	; Check if landed on platform while falling
	push ecx
	mov al, yPos
	inc al
	mov ah, yPos
	mov yPos, al
	call CheckOnSurface
	mov yPos, ah
	cmp al, 1
	pop ecx
	je landOnPlatform
	
	mov cl, jumpCounter
	sub cl, jumpHeight
	cmp cl, jumpHeight
	jge endJump
	
	; Fall down
	inc yPos
	inc jumpCounter
	jmp donePhysics
	
	landOnPlatform:
	; Landed on platform mid-jump
	mov isJumping, 0
	mov jumpCounter, 0
	mov isGrounded, 1
	mov jumpCount, 0
	jmp donePhysics
	
	endJump:
	mov isJumping, 0
	mov jumpCounter, 0
	
	; Check if landed on surface
	call CheckOnSurface
	cmp al, 1
	jne donePhysics
	mov isGrounded, 1
	mov jumpCount, 0
	
	onSurface:
	donePhysics:
	pop ecx
	pop eax
	ret
HandlePhysics ENDP

CheckOnSurface PROC
	push ebx
	push ecx
	push edx
	
	; Check if on ground
	mov al, yPos
	cmp al, 28
	je isOnSurface
	
	; Check if on platform
	mov ecx, 0
	movzx ecx, platformCount
	lea ebx, platforms
	
	checkPlatformLoop:
	push ecx
	
	; Get platform data
	movzx edx, BYTE PTR [ebx]      ; platform x
	movzx ecx, BYTE PTR [ebx+1]    ; platform y
	movzx eax, BYTE PTR [ebx+2]    ; platform width
	
	; Adjust for world offset
	mov esi, edx
	sub si, worldOffset
	
	; Check if player is on this platform
	; Y position check (standing on platform)
	mov dl, yPos
	inc dl
	cmp dl, cl
	jne nextPlatform
	
	; X position check
	movzx edx, xPos
	cmp edx, esi
	jl nextPlatform
	
	add eax, esi
	cmp edx, eax
	jge nextPlatform
	
	; On this platform
	pop ecx
	jmp isOnSurface
	
	nextPlatform:
	add ebx, 3
	pop ecx
	loop checkPlatformLoop
	
	; Not on surface
	mov al, 0
	jmp doneCheck
	
	isOnSurface:
	mov al, 1
	
	doneCheck:
	pop edx
	pop ecx
	pop ebx
	ret
CheckOnSurface ENDP

ScrollWorld PROC
	; Platforms and coins are stored with absolute positions
	; They don't need to be modified - we just use worldOffset when drawing
	ret
ScrollWorld ENDP

DrawPlatforms PROC
	push eax
	push ebx
	push ecx
	push edx
	
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov ecx, 0
	movzx ecx, platformCount
	lea ebx, platforms
	
	drawPlatformLoop:
	push ecx
	
	; Get platform data
	movzx edx, BYTE PTR [ebx]      ; platform x
	movzx ecx, BYTE PTR [ebx+1]    ; platform y
	movzx eax, BYTE PTR [ebx+2]    ; platform width
	
	; Adjust for world offset
	sub dx, worldOffset
	
	; Check if platform is on screen
	cmp dx, 0
	jl skipPlatform
	cmp dx, 120
	jge skipPlatform
	
	; Draw platform
	mov dh, cl
	push eax
	push ebx
	
	drawPlatformWidth:
	push eax
	call Gotoxy
	mov al, "="
	call WriteChar
	inc dl
	pop eax
	dec eax
	cmp eax, 0
	jg drawPlatformWidth
	
	pop ebx
	pop eax
	
	skipPlatform:
	add ebx, 3
	pop ecx
	loop drawPlatformLoop
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
DrawPlatforms ENDP

DrawCoins PROC
	push eax
	push ebx
	push ecx
	push edx
	
	mov eax, yellow + (red * 16)
	call SetTextColor
	
	mov ecx, 0
	movzx ecx, coinCount
	lea ebx, coins
	
	drawCoinLoop:
	push ecx
	
	; Check if collected
	movzx eax, BYTE PTR [ebx+2]
	cmp al, 1
	je skipCoin
	
	; Get coin position
	movzx edx, BYTE PTR [ebx]      ; coin x
	movzx ecx, BYTE PTR [ebx+1]    ; coin y
	
	; Adjust for world offset
	sub dx, worldOffset
	
	; Check if coin is on screen
	cmp dx, 0
	jl skipCoin
	cmp dx, 120
	jge skipCoin
	
	; Check if player collected coin
	movzx eax, xPos
	cmp dx, ax
	jne drawThisCoin
	movzx eax, yPos
	cmp cx, ax
	jne drawThisCoin
	
	; Collect coin
	mov BYTE PTR [ebx+2], 1
	add score, 10
	jmp skipCoin
	
	drawThisCoin:
	mov dh, cl
	call Gotoxy
	mov al, "O"
	call WriteChar
	
	skipCoin:
	add ebx, 3
	pop ecx
	loop drawCoinLoop
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
DrawCoins ENDP

UpdateGoombas PROC
	push eax
	push ebx
	push ecx
	push edx
	
	; Check timer for movement delay
	mov al, goombaTimer
	inc al
	mov goombaTimer, al
	movzx ecx, al
	movzx eax, goombaDelay
	cmp ecx, eax
	jl skipGoombaUpdate
	mov goombaTimer, 0
	
	; Update each goomba
	mov ecx, 0
	movzx ecx, goombaCount
	lea ebx, goombas
	
	updateGoombaLoop:
	push ecx
	
	; Check if alive
	movzx eax, BYTE PTR [ebx+3]
	cmp al, 0
	je skipThisGoomba
	
	; Get goomba data
	movzx edx, BYTE PTR [ebx]      ; x position
	movzx eax, BYTE PTR [ebx+1]    ; y position
	movzx ecx, BYTE PTR [ebx+2]    ; direction
	
	; Move goomba based on direction
	cmp cl, 0
	je moveGoombaLeft
	
	moveGoombaRight:
	inc dl
	; Check if hit wall or edge
	cmp dl, 170
	jge reverseGoombaDirection
	jmp updateGoombaPos
	
	moveGoombaLeft:
	cmp dl, 5
	jle reverseGoombaDirection
	dec dl
	jmp updateGoombaPos
	
	reverseGoombaDirection:
	; Reverse direction
	xor ecx, 1
	mov BYTE PTR [ebx+2], cl
	jmp skipThisGoomba
	
	updateGoombaPos:
	mov BYTE PTR [ebx], dl
	
	skipThisGoomba:
	add ebx, 4
	pop ecx
	loop updateGoombaLoop
	
	skipGoombaUpdate:
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
UpdateGoombas ENDP

DrawGoombas PROC
	push eax
	push ebx
	push ecx
	push edx
	
	mov eax, brown + (black * 16)
	call SetTextColor
	
	mov ecx, 0
	movzx ecx, goombaCount
	lea ebx, goombas
	
	drawGoombaLoop:
	push ecx
	
	; Check if alive
	movzx eax, BYTE PTR [ebx+3]
	cmp al, 0
	je skipDrawGoomba
	
	; Get goomba position
	movzx edx, BYTE PTR [ebx]      ; goomba x
	movzx ecx, BYTE PTR [ebx+1]    ; goomba y
	
	; Adjust for world offset
	sub dx, worldOffset
	
	; Check if goomba is on screen
	cmp dx, 0
	jl skipDrawGoomba
	cmp dx, 120
	jge skipDrawGoomba
	
	; Draw goomba
	mov dh, cl
	call Gotoxy
	mov al, "G"
	call WriteChar
	
	skipDrawGoomba:
	add ebx, 4
	pop ecx
	loop drawGoombaLoop
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
DrawGoombas ENDP

CheckGoombaCollision PROC
	push ebx
	push ecx
	push edx
	
	; Check collision with each goomba
	mov ecx, 0
	movzx ecx, goombaCount
	lea ebx, goombas
	
	checkCollisionLoop:
	push ecx
	
	; Check if alive
	movzx eax, BYTE PTR [ebx+3]
	cmp al, 0
	je skipCollisionCheck
	
	; Get goomba position
	movzx edx, BYTE PTR [ebx]      ; goomba x
	movzx ecx, BYTE PTR [ebx+1]    ; goomba y
	
	; Adjust for world offset
	mov esi, edx
	sub si, worldOffset
	
	; Check if player is at same position
	movzx edx, xPos
	cmp edx, esi
	jne skipCollisionCheck
	
	movzx eax, yPos
	
	; Check if jumping on top (player above goomba)
	mov edi, ecx
	dec edi
	cmp eax, edi
	je defeatedGoomba
	
	; Check if hit from side (player at same height)
	cmp eax, ecx
	je playerHit
	
	skipCollisionCheck:
	add ebx, 4
	pop ecx
	loop checkCollisionLoop
	
	; No collision
	jmp doneCollisionCheck
	
	defeatedGoomba:
	; Kill goomba
	mov BYTE PTR [ebx+3], 0
	add score, 100
	
	; Make Mario bounce
	mov isJumping, 1
	mov jumpCounter, 0
	mov al, jumpHeight
	shr al, 1  ; Half jump height for bounce
	
	pop ecx
	jmp doneCollisionCheck
	
	playerHit:
	; Player loses a life
	mov al, lives
	dec al
	mov lives, al
	
	; Reset position
	mov yPos, 28
	mov worldOffset, 0
	
	pop ecx
	
	doneCollisionCheck:
	pop edx
	pop ecx
	pop ebx
	ret
CheckGoombaCollision ENDP

ResetGoombas PROC
	push eax
	push ebx
	push ecx
	
	mov ecx, 0
	movzx ecx, goombaCount
	lea ebx, goombas
	
	resetGoombaLoop:
	mov BYTE PTR [ebx+3], 1  ; Set alive
	add ebx, 4
	loop resetGoombaLoop
	
	pop ecx
	pop ebx
	pop eax
	ret
ResetGoombas ENDP

DrawHUD PROC
	push eax
	push edx
	
	mov eax, white + (black * 16)
	call SetTextColor
	
	; Draw score
	mov dl, 0
	mov dh, 0
	call Gotoxy
	mov edx, OFFSET strScore
	call WriteString
	mov eax, score
	call WriteDec
	
	; Draw lives
	mov edx, OFFSET strLives
	call WriteString
	movzx eax, lives
	call WriteDec
	
	pop edx
	pop eax
	ret
DrawHUD ENDP

ResetCoins PROC
	push eax
	push ebx
	push ecx
	
	mov ecx, 0
	movzx ecx, coinCount
	lea ebx, coins
	
	resetLoop:
	mov BYTE PTR [ebx+2], 0
	add ebx, 3
	loop resetLoop
	
	pop ecx
	pop ebx
	pop eax
	ret
ResetCoins ENDP

DrawPlayer PROC
	push eax
	push edx
	
	mov eax, red + (black * 16)
	call SetTextColor
	
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, "M"
	call WriteChar
	
	pop edx
	pop eax
	ret
DrawPlayer ENDP

UpdatePlayer PROC
	push eax
	push edx
	
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	mov al, " "
	call WriteChar
	
	pop edx
	pop eax
	ret
UpdatePlayer ENDP

ShowStartScreen PROC
	call Clrscr
	
	; Set red color for "SUPER"
	mov eax, red + (black * 16)
	call SetTextColor
	
	mov dl, 20
	mov dh, 5
	call Gotoxy
	mov edx, OFFSET title1
	call WriteString
	
	mov dl, 20
	mov dh, 6
	call Gotoxy
	mov edx, OFFSET title2
	call WriteString
	
	mov dl, 20
	mov dh, 7
	call Gotoxy
	mov edx, OFFSET title3
	call WriteString
	
	mov dl, 20
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET title4
	call WriteString
	
	mov dl, 20
	mov dh, 9
	call Gotoxy
	mov edx, OFFSET title5
	call WriteString
	
	mov dl, 20
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET title6
	call WriteString
	
	; Set green color for "MARIO"
	mov eax, green + (black * 16)
	call SetTextColor
	
	mov dl, 20
	mov dh, 12
	call Gotoxy
	mov edx, OFFSET mario1
	call WriteString
	
	mov dl, 20
	mov dh, 13
	call Gotoxy
	mov edx, OFFSET mario2
	call WriteString
	
	mov dl, 20
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET mario3
	call WriteString
	
	mov dl, 20
	mov dh, 15
	call Gotoxy
	mov edx, OFFSET mario4
	call WriteString
	
	mov dl, 20
	mov dh, 16
	call Gotoxy
	mov edx, OFFSET mario5
	call WriteString
	
	mov dl, 20
	mov dh, 17
	call Gotoxy
	mov edx, OFFSET mario6
	call WriteString
	
	; Set yellow color for "Press any key"
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 28
	mov dh, 20
	call Gotoxy
	mov edx, OFFSET pressKey
	call WriteString
	
	; Reset to white color
	mov eax, white + (black * 16)
	call SetTextColor
	
	; Wait for key press
	call ReadChar
	mov inputChar, al
	
	; Check if user pressed 'x' to exit
	cmp inputChar, "x"
	je exitFromStart
	
	call Clrscr
	ret
	
	exitFromStart:
	exit
ShowStartScreen ENDP

ShowGameMenu PROC
	menuLoop:
	call Clrscr
	
	; Set cyan color for menu title
	mov eax, cyan + (black * 16)
	call SetTextColor
	
	mov dl, 30
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET menuTitle
	call WriteString
	
	; Set white color for menu options
	mov eax, white + (black * 16)
	call SetTextColor
	
	mov dl, 30
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET menuOption1
	call WriteString
	
	mov dl, 30
	mov dh, 13
	call Gotoxy
	mov edx, OFFSET menuOption2
	call WriteString
	
	mov dl, 30
	mov dh, 15
	call Gotoxy
	mov edx, OFFSET menuOption3
	call WriteString
	
	; Set yellow color for prompt
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 25
	mov dh, 18
	call Gotoxy
	mov edx, OFFSET menuPrompt
	call WriteString
	
	; Reset to white color
	mov eax, white + (black * 16)
	call SetTextColor
	
	; Get user choice
	call ReadChar
	mov inputChar, al
	
	cmp inputChar, "1"
	je startGame
	
	cmp inputChar, "2"
	je showInstructions
	
	cmp inputChar, "3"
	je exitGame
	
	; Invalid input, loop again
	jmp menuLoop
	
	showInstructions:
	call ShowInstructions
	jmp menuLoop
	
	startGame:
	call Clrscr
	ret
	
	exitGame:
	exit
ShowGameMenu ENDP

ShowInstructions PROC
	call Clrscr
	
	; Set cyan color for instructions title
	mov eax, cyan + (black * 16)
	call SetTextColor
	
	mov dl, 28
	mov dh, 5
	call Gotoxy
	mov edx, OFFSET instTitle
	call WriteString
	
	; Set white color for instructions
	mov eax, white + (black * 16)
	call SetTextColor
	
	mov dl, 15
	mov dh, 8
	call Gotoxy
	mov edx, OFFSET inst1
	call WriteString
	
	mov dl, 15
	mov dh, 10
	call Gotoxy
	mov edx, OFFSET inst2
	call WriteString
	
	; Set green color for controls
	mov eax, green + (black * 16)
	call SetTextColor
	
	mov dl, 15
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET inst3
	call WriteString
	
	mov dl, 15
	mov dh, 12
	call Gotoxy
	mov edx, OFFSET inst4
	call WriteString
	
	mov dl, 15
	mov dh, 13
	call Gotoxy
	mov edx, OFFSET inst5
	call WriteString
	
	mov dl, 15
	mov dh, 14
	call Gotoxy
	mov edx, OFFSET inst6
	call WriteString
	
	mov dl, 15
	mov dh, 15
	call Gotoxy
	mov edx, OFFSET inst7
	call WriteString
	
	; Set yellow color for tip
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 15
	mov dh, 17
	call Gotoxy
	mov edx, OFFSET inst8
	call WriteString
	
	; Set yellow color for prompt
	mov dl, 20
	mov dh, 20
	call Gotoxy
	mov edx, OFFSET inst9
	call WriteString
	
	; Reset to white color
	mov eax, white + (black * 16)
	call SetTextColor
	
	; Wait for key press
	call ReadChar
	
	ret
ShowInstructions ENDP

ShowPauseMenu PROC
	; Save current screen by drawing pause overlay
	mov eax, white + (blue * 16)
	call SetTextColor
	
	; Draw pause box background
	mov ecx, 10
	mov dh, 10
	drawPauseBox:
	push ecx
	mov dl, 25
	mov ecx, 35
	call Gotoxy
	drawPauseLine:
	mov al, " "
	call WriteChar
	loop drawPauseLine
	inc dh
	pop ecx
	loop drawPauseBox
	
	; Set cyan color for pause title
	mov eax, cyan + (blue * 16)
	call SetTextColor
	
	mov dl, 32
	mov dh, 11
	call Gotoxy
	mov edx, OFFSET pauseTitle
	call WriteString
	
	; Set white color for pause options
	mov eax, white + (blue * 16)
	call SetTextColor
	
	mov dl, 30
	mov dh, 13
	call Gotoxy
	mov edx, OFFSET pauseOption1
	call WriteString
	
	mov dl, 30
	mov dh, 15
	call Gotoxy
	mov edx, OFFSET pauseOption2
	call WriteString
	
	mov dl, 30
	mov dh, 17
	call Gotoxy
	mov edx, OFFSET pauseOption3
	call WriteString
	
	; Set yellow color for prompt
	mov eax, yellow + (blue * 16)
	call SetTextColor
	
	mov dl, 27
	mov dh, 19
	call Gotoxy
	mov edx, OFFSET pausePrompt
	call WriteString
	
	; Reset to white color
	mov eax, white + (black * 16)
	call SetTextColor
	
	; Get user choice
	call ReadChar
	mov inputChar, al
	
	ret
ShowPauseMenu ENDP

END main