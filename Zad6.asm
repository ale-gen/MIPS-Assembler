.data 
		.align 2
	ciagB: .space 100
	ciagC: .space 100
	n: .asciiz "Podaj dlugosc ciagow B i C - n: "
	element: .asciiz "Podaj wartosc elementu "
	ciagBelement: .asciiz " dla ciagu B: "
	ciagCelement: .asciiz " dla ciagu C: "
	powtorka: .asciiz "\nCzy chcesz powtorzyc cwiczenie? 1 - TAK: "
	dwukropek: .asciiz ": "
	.eqv DATA_SIZE 4
	spacja: .asciiz " "
	enter: .asciiz "\n"
	suma: .asciiz "Suma elementow pod przekatna: "
.text
	main: 
	jal tworzenieMacierzy
	jal drukowanieMacierzy
	jal sumaPodPrzekatna
	
	# Komunikat o powtorzeniu cwiczenia
	li $v0, 4
	la $a0 powtorka
	syscall
	
	# Pobranie odpowiedzi od uzytkwonika
	li $v0, 5
	syscall
	
	beq $v0, 1, main
	
	# Zakonczenie programu
	li $v0, 10
	syscall
	
	tworzenieMacierzy:
	# Komunikat o podaniu n
	li $v0, 4
	la $a0, n
	syscall
	
	# Pobranie wartosci od uzytkwonika i umieszczenie w t8 = n
	li $v0, 5
	syscall
	move $t8, $v0
	
	# Zaladowanie do s4 adresu poczatku ciagA
	la $s4, ciagB
	
	# Licznik elementow ciaguB
	li $t7, 1
	
	tworzenieCiagB:
	# Dodawanie elementow ciagu
	li $v0, 4
	la $a0, element
	syscall
	
	li $v0, 1
	move $a0, $t7
	syscall
	
	li $v0, 4
	la $a0, ciagBelement
	syscall
	
	li $v0, 4
	la $a0, dwukropek
	syscall
	
	# Pobranie wartosci od uzytkwonika
	li $v0, 5
	syscall
	sw $v0, ($s4)
	
	# Przesuniecie sie o slowo w ciagu
	addi $s4, $s4, 4
	# Inkrementacja licznika
	addi $t7, $t7, 1
	
	ble $t7, $t8, tworzenieCiagB
	
	# Zaladowanie do s5 poczatku ciagu C
	la $s5, ciagC
	
	# Licznik elementow ciagu C
	li $t7, 1
	
	tworzenieCiagC:
	# Dodawanie elementow ciagu
	li $v0, 4
	la $a0, element
	syscall
	
	li $v0, 1
	move $a0, $t7
	syscall
	
	li $v0, 4
	la $a0, ciagCelement
	syscall
	
	li $v0, 4
	la $a0, dwukropek
	syscall
	
	# Pobranie wartosci od uzytkwonika
	li $v0, 5
	syscall
	move $t5, $v0
	sw $t5, ($s5)
	
	# Przesuniecie sie o slowo w ciagu
	addi $s5, $s5, 4
	# Inkrementacja licznika
	addi $t7, $t7, 1
	
	ble $t7, $t8, tworzenieCiagC
	
	# Tworzenie macierzy nxn
	# Wyliczenie ile pamieci potrzebuje macierz
	mul $t2, $t8, $t8
	mul $t2, $t2, 4
	
	# Alokacja pamieci na macierz
	li $v0, 9
	move $a0, $t2
	syscall
	
	# Zapamietanie adresu poczatkowego macierzy w s3
	move $s3, $v0
	
	# Ustawienie indexu wiersza na 0
	li $t0, 0
	
	dodawanieWierszy: 
	# Ustawienie indexu kolumny na 0
	li $t1, 0
	# Zaladowanie ciagu B
	la $s4, ciagB
	# Zaladowanie ciagu c
	la $s5, ciagC
	
		dodawanieKolumny:
		# Wyliczenie indexu macierzy
		mul $t3, $t0, $t8         # indexWiersza * liczbaKolumn
		add $t3, $t3, $t1         # ... + indexKolumny
		mul $t3, $t3, DATA_SIZE   # ... * typDanych
		add $t3, $t3, $s3         # ... + adresPoczatkowyMacierzy
		
		#Zaladowanie wartosci z ciaguB do t5
		lw $t5, ($s4)
		
		# Zaladowanie wartosci z ciaguC do t4
		lw $t4, ($s5)
		
		blt $t0, $t1, korzystajCiagB
		bgt $t0, $t1, korzystajCiagC
		
		# Dodajemy element obu ciagow
		add $s6, $t5, $t4
		sw $s6, ($t3)
		
		j kontynuuj
		
			korzystajCiagB:
			sw $t5, ($t3)
			
			j kontynuuj
			
			korzystajCiagC: 
			sw $t4, ($t3)
			
		kontynuuj: 
		# Przesuniecie o kolumne
		addi $t1, $t1, 1
		
		# Przesuwamy sie w ciagu o slowo
		addi $s4, $s4, 4
		addi $s5, $s5, 4
		
		blt $t1, $t8, dodawanieKolumny
		
	# Przesuniecie o wiersz
	addi $t0, $t0, 1
	
	blt $t0, $t8, dodawanieWierszy
	
	jr $ra
	
	drukowanieMacierzy:
	# Ustawienie indexu wiersza na poczatek
	li $t0, 0
	
	drukowanieWiersze: 
	# Ustawienie indexu kolumny na poczatek
	li $t1, 0
	
		drukowanieKolumny:
		# Wyliczenie indexu macierzy
		mul $t3, $t0, $t8           # indexWiersza * liczbaKolumn
		add $t3, $t3, $t1           # ... + indexKolumny
		mul $t3, $t3, DATA_SIZE     # ... * typDanych
		add $t3, $t3, $s3           # ... + adresPoczatkowyMacierzy
		
		# Pobranie wartosci i wydrukowanie jej
		lw $a0, ($t3)
		li $v0, 1
		syscall
		
		# Wydrukowanie spacji
		li $v0, 4
		la $a0, spacja
		syscall
		
		# Przesuniecie sie o kolumne
		addi $t1, $t1, 1
		
		blt $t1, $t8, drukowanieKolumny
		
	# Przesuniecie sie o wiersz
	addi $t0, $t0, 1
	
	# Przejscie do nowej linii
	li $v0, 4
	la $a0, enter
	syscall
	
	blt $t0, $t8, drukowanieWiersze
	
	jr $ra
		
	sumaPodPrzekatna: 
	# Ustawienie sumy na s7
	li $s7, 0
	
	# Ustawienie indexu wiersza na poczatek
	li $t0, 0
	
	sumaWiersze: 
	# Ustawienie indexu kolumny na poczatek
	li $t1, 0
		sumaKolumny:
		# Wyliczenie indexu macierzy
		mul $t3, $t0, $t8           # indexWiersza * liczbaKolumn
		add $t3, $t3, $t1           # ... + indexKolumny
		mul $t3, $t3, DATA_SIZE     # ... * typDanych
		add $t3, $t3, $s3           # ... + adresPoczatkowyMacierzy
		
		ble $t0, $t1, nieDodawaj
		
		# Dodajemy do sumy
		lw $t4, ($t3)
		add $s7, $s7, $t4
		
		nieDodawaj: 
		
		# Przesuniecie o kolumne
		addi $t1, $t1, 1
		
		blt $t1, $t8, sumaKolumny
		
	# Przesuniecie o wiersz 
	addi $t0, $t0, 1
	
	blt $t0, $t8, sumaWiersze
	
	# Komunikat o wyswietleniu dumy elementow pod przekatna
	li $v0, 4
	la $a0, suma
	syscall
	
	# Wyswietlenie sumy elementow pod przekatna
	li $v0, 1
	move $a0, $s7
	syscall
	
	jr $ra
		
		
		
	
	