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
platformCount	BYTE 8
platforms		BYTE 10, 25, 15   ; Platform 1
				BYTE 35, 22, 12   ; Platform 2
				BYTE 55, 20, 10   ; Platform 3
				BYTE 75, 18, 15   ; Platform 4
				BYTE 95, 23, 12   ; Platform 5
				BYTE 115, 21, 10  ; Platform 6
				BYTE 135, 19, 15  ; Platform 7
				BYTE 155, 24, 12  ; Platform 8

; Coin data (x, y, collected)
coinCount		BYTE 10
coins			BYTE 15, 24, 0    ; Coin 1
				BYTE 40, 21, 0    ; Coin 2
				BYTE 60, 19, 0    ; Coin 3
				BYTE 80, 17, 0    ; Coin 4
				BYTE 100, 22, 0   ; Coin 5
				BYTE 120, 20, 0   ; Coin 6
				BYTE 140, 18, 0   ; Coin 7
				BYTE 160, 23, 0   ; Coin 8
				BYTE 50, 27, 0    ; Coin 9
				BYTE 90, 27, 0    ; Coin 10

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
inst6			BYTE "  X - Exit Game",0
inst7			BYTE "Press any key to return to menu...",0

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
	
	; Reset all coins
	call ResetCoins

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
		
		; Draw player
		call DrawPlayer
		
		; Draw HUD
		call DrawHUD
		
		; Handle gravity and jumping
		call HandlePhysics
		
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
		
		cmp inputChar, "a"
		je moveLeft
		
		cmp inputChar, "d"
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
		call ResetCoins
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
		call ResetCoins
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
	
	; Set yellow color for prompt
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 20
	mov dh, 17
	call Gotoxy
	mov edx, OFFSET inst7
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