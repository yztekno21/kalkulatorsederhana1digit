	LIST p=16f877a 			
	#include "P16f877a.inc"	

; 0x36,0x35 digunakan untuk menyimpan nomor masing-masing
; 0x37  digunakan untuk menyimpan kondisi tersebut
; 0x38, 0x39 digunakan untukmenyimpan variabel loop
 

;----------------------------------------------------------------------------------------------------------------
; mengkonvigurasi sebagian I/O
	bsf STATUS, RP0 			;	pilih 1
	;FOR KEYPAD
	movlw b'11110000' 			
	movwf TRISB 				

	;FOR LCD CONFIG
	movlw b'11111000'
	movwf TRISD

	;FOR LCD OUTPUT
	movlw 0x00					
	movwf TRISC					

	bcf STATUS, RP0 			;	pilih 0
;-----------------------------------------------------------------------------------------------------------------




;Main
;--------------------------------------------------------------------------------------------------------------
begin:						
	call check_keypad		
goto begin				
;--------------------------------------------------------------------------------------------------------------



;bagian pemindai keypad
;--------------------------------------------------------------------------------------------------------------
 check_keypad					;	memindai keypad setiap di tekan.

		bsf PORTB, 0			;  memindahkan kolom pertama kunci 		
;--------------------------------------------------------------------------------------------------------------
		btfsc PORTB, 4			;	scan  tombol on/off
		call ON
	
		btfsc PORTB, 5			;	scan  tombol 1
		call  ONE
		
		btfsc PORTB, 6			;	scan  tombol 4
		call FOUR	
		
		btfsc PORTB, 7			;	scan  tombol 7
		call SEVEN
	
		bcf PORTB, 0			;	selesai kolom 1

	
		bsf PORTB, 1			;	scaning kolom ke 2
;--------------------------------------------------------------------------------------------------------------
		btfsc PORTB, 4			;	scan  tombol 0
		CALL ZERO				
		
		btfsc PORTB, 5			;	scan tombol 2
		CALL TWO				
	
		btfsc PORTB, 6			;	scan tombol 5
		CALL FIVE				
	
		btfsc PORTB, 7			;	scan  tombol 8
		CALL EIGHT				
	
		bcf PORTB, 1			;	kolom 2 beres

	
		bsf PORTB, 2			; scan kolom 3
;--------------------------------------------------------------------------------------------------------------
		btfsc PORTB, 4			;	scan  tombol =
		CALL EQUAL				
		
		btfsc PORTB, 5			;	scan  tombol 3
		CALL THREE				
		
		btfsc PORTB, 6			;	scan tombol 6
		CALL SIX				
		
		btfsc PORTB, 7			;	scan tombol 9
		CALL NINE				
	
		bcf PORTB, 2			;	kolom 3 beres


		bsf PORTB, 3			;   scan kolom ke 4
;--------------------------------------------------------------------------------------------------------------
		btfsc PORTB, 4			;	scan  tombol +
		call PLUS				
	
		btfsc PORTB, 5			;	scan  tombol -
		call MINUS				
	
		btfsc PORTB, 6			;	scan  tombol *
		call MULT				
	
		btfsc PORTB, 7			;	scan  tombol /
		call DIV				
	
		bcf PORTB, 3			;	kolom 4 beres


	return							
;----------------------------------------------------------------------------------------------------------------





;----------------------------------------------------------------------------------------------------------------
;fungsi kunci tombol
ZERO:
movlw 0x00
movwf 0x35
movlw 0x30
call display_digit
return 


ONE:
movlw 0x01
movwf 0x35
movlw 0x31
call display_digit
return 

TWO:
movlw 0x02
movwf 0x35
movlw 0x32
call display_digit
return 

THREE:
movlw 0x03
movwf 0x35
movlw 0x33
call display_digit
return 

FOUR:
movlw 0x04
movwf 0x35
movlw 0x34
call display_digit
return 

FIVE:
movlw 0x05
movwf 0x35
movlw 0x35
call display_digit
return 

SIX:
movlw 0x06
movwf 0x35
movlw 0x36
call display_digit
return 

SEVEN:
movlw 0x07
movwf 0x35
movlw 0x37
call display_digit
return 

EIGHT:
movlw 0x08
movwf 0x35
movlw 0x38
call display_digit
return 

NINE:
movlw 0x09
movwf 0x35
movlw 0x39
call display_digit
return 





;--------------------------------------------------------------------------------------------------------------
	PLUS:
	;penyimpanan operasi pertama ke 0x36
	;operasi kedua akan menjadi  0x35
	movf 0x35,w
	movwf 0x36
	
	;mengirim nilai 00 untuk operasi penjumlahan
	;0x37 variabel yang menyimpan kondisi
	movlw 0x00
	movwf 0x37
	
	movlw 0x2B
	call display_digit
	return
;--------------------------------------------------------------------------------------------------------------
	



;--------------------------------------------------------------------------------------------------------------
	MINUS:
	movf 0x35,w
	movwf 0x36
	
	movlw 0x01
	movwf 0x37
	
	movlw 0x2D
	call display_digit
	return
;--------------------------------------------------------------------------------------------------------------



;--------------------------------------------------------------------------------------------------------------
	MULT:
	movf 0x35,w
	movwf 0x36
	
	movlw 0x02
	movwf 0x37
	
	movlw 0x2A
	call display_digit
	return
;--------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------
	DIV:
	movf 0x35,w
	movwf 0x36
	
	movlw 0x03
	movwf 0x37
	
	movlw 0x2F
	call display_digit
	return
;--------------------------------------------------------------------------------------------------------------


EQUAL:
movlw 0x3D
call display_digit

;bagian perhitungan 
;--------------------------------------------------------------------------------------------------------------
BTFSS 0X37,1
GOTO TCOND0 ;0X
GOTO TCOND1 ;1X

TCOND0:
BTFSS 0X37,0
GOTO COND00
GOTO COND01

TCOND1:
BTFSS 0X37,0
GOTO COND10
GOTO COND11

;penjumlahan
COND00:
MOVF 0X36,W
ADDWF 0X35,W
addlw 0x30  
call display_digit 
RETURN

;pengurangan
COND01:
SUBSTRACTION:
MOVF 0X35,W
SUBWF 0X36,W
addlw 0x30  
call display_digit
RETURN

;perkalian
COND10:
MOVLW 0X00 
LOOP2:
ADDWF 0X36,W
DECF 0X35,F
BTFSS STATUS,Z
GOTO LOOP2
addlw 0x30  
call display_digit
RETURN 

;pembagian  0x36/0x35
COND11:
MOVF 0X35,W
LP1:
SUBWF 0X36,W
BTFSS STATUS,DC
GOTO LP1

addlw 0x30  
call display_digit
RETURN 
;akhir perhitungan
;--------------------------------------------------------------------------------------------------------------

return





ON:
movlw 0x01
call DISPLAY

clrf 0x35
clrf 0x36
clrf 0x37
return
;----------------------------------------------------------------------------------------------------------------




; instalasi lcd
    		;Jika
		; RS = 0 Perintah instruksi Register kode dipilih, memungkinkan pengguna untuk mengirim perintah
		; RS = 1 Register data dipilih untuk memungkinkan pengiriman data yang harus ditampilkan.

		; R \ W = 0 Membaca
		; R \ W = 1 Menulis
		; E- Aktifkan

		; Pin aktif digunakan oleh LCD untuk mengunci informasi pada pin datanya. Saat data dipasok ke pin data,
		; pulsa tinggi ke rendah harus diterapkan ke pin ini agar LCD mengunci data yang ada di pin data.
		; E harus Toggle

		; Mode Data: RS = 1, R \ W = 0, E = 1 \ 0


		;Data Mode:  RS=1, R\W=0, E=1\0

display_digit:
		BSF PORTD,0; kontrol sinyal ke RS
		BCF PORTD,1; kontrol sinyal ke  R/W
		BSF PORTD,2; kontrol sinyal ke 'E'
		
		;nilai yang tersimpan di W reg di kirim ke DISPLAY	
		call DISPLAY

		MOVLW 0X38  ;menginstalasi tampilan
		CALL DISPLAY
		
		MOVLW 0X0E ; jangan mengedipkan kursor
		CALL DISPLAY

		BSF PORTD,0
		RETURN

DISPLAY:   
   		MOVWF PORTC

		BCF PORTD,2
		CALL DELAY1

		BSF PORTD,2
		CALL DELAY1

		BCF PORTD,0
		RETURN

DELAY1:	
		MOVLW	D'13'	 ;delay sangat kecil
		MOVWF	0X38
		MOVLW	D'251'
		MOVWF	0X39
		LOOP:	DECFSZ	0X39
				GOTO	LOOP
				DECFSZ	0X38
				GOTO	LOOP
		RETURN
		RETURN	

	return					

	end						
;-----------------------------------------------------------------------------------------------------------------------------
;referensi
;LCD
;http://www.instructables.com/id/Build-yourself-flashing-message-on-PIC16F877A-with/
;http://www.edaboard.com/thread237649.html

;keypad
;http://www.bradsprojects.com/pic-assembly-tutorial-6-interfacing-a-keypad-to-your-microcontroller/	