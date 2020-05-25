.data
		.align 2
	ciag1: .space 100
	ciag2: .space 100
	polecenie: .asciiz "\n1 - Wczytaj liczby i utworz dwa ciagi \n2 - Wydrukuj ciagi \n3 - Zakoncz program \nCo chcesz zrobic? "
	n: .asciiz "Ile chcesz wczytac elementow? "
	a: .asciiz "Podaj wartosc parametru a: "
	b: .asciiz "Podaj wartosc parametru b: "
	pobierz: .asciiz "Podaj liczbe "
	dwukropek: .asciiz ": "
	spacja: .asciiz " "
	elementyCiagu1: .asciiz "\nElementy ciagu nalezacego do przedzialu <a, b>: "
	elementyCiagu2: .asciiz "\nElementy ciagu nie nalezacego do danego przedzialu: "
	nieWczytano: .asciiz "Nie wprowadzono liczb, najpierw wprowadz 1"
	pozaZakresem: .asciiz "Wprowadzono liczbe poza zakresem, sprobuj jeszcze raz"
	rozmiar1: .asciiz "  Liczba elementow ciagu 1: "
	rozmiar2: .asciiz "  Liczba elementow ciagu 2: "
.text
	main: 
		# Drukowanie polecenia
		li $v0, 4
		la $a0, polecenie
		syscall
		
		# Pobieranie odpowiedzi od uzytkownika i umieszczenie w t0
		li $v0, 5
		syscall
		move $t0, $v0
		
		beq $t0, 1, wybor1
		beq $t0, 2, wybor2
		beq $t0, 3, koniec
		
		li $v0, 4
		la $a0, pozaZakresem
		syscall
		
		j main
		
		wybor1:
			jal wprowadzLiczby
			j main
			
		wybor2: 
			beq $s6, 0, nieWczytanoLiczb
			jal wydrukujCiagi
			j main
			
			nieWczytanoLiczb: 
				li $v0, 4
				la $a0, nieWczytano
				syscall
				
				j main
				
		koniec: 
			li $v0, 10
			syscall
			
		wprowadzLiczby: 
			# Ładowanie ciagu1 do s0
			la $s0, ciag1
			
			# Ładowanie ciagu2 do s1
			la $s1, ciag2
			
			# Drukowanie komunikatu o n wprowadzanych liczbach 
			li $v0, 4
			la $a0, n
			syscall
			
			# Pobranie wartosci od uzytkownika i umieszczenie w t1
			li $v0, 5
			syscall
			move $t1, $v0
			
			# Ustalenie przedzialu a i b
			li $v0, 4
			la $a0, a
			syscall
			
			# a = $t2
			li $v0, 5
			syscall
			move $t2, $v0
			
			li $v0, 4
			la $a0, b
			syscall
			
			# b = $t3
			li $v0, 5
			syscall
			move $t3, $v0
			
			# Jesli b < a to przedzial bedzie <b, a>
			ble $t2, $t3, nieZamieniaj
			
			move $t5, $t2
			move $t2, $t3
			move $t3, $t5
			
			nieZamieniaj:
			
			# Licznik elementow wprowadzanych
			li $t4, 1
			
			# Licznik elementow ciagu 1
			li $t7, 0
			
			#Licznik elementow ciagu 2
			li $t8, 0
			
			pobieranieLiczb: 
				# Drukowanie komunikatu o pobranie liczby
				li $v0, 4
				la $a0, pobierz
				syscall
				
				li $v0, 1
				move $a0, $t4
				syscall
				
				li $v0, 4
				la $a0, dwukropek
				syscall
				
				# Pobranie wartosci
				li $v0, 5
				syscall
				
				bgt $v0, $t3, dodajDoDrugiego
				blt $v0, $t2, dodajDoDrugiego
				
				# Dodaj do pierwszego ciagu, liczba nalezy do przedzialu
				sw $v0, ($s0)
				addi $t7, $t7, 1
				# Przesuwamy sie w pamieci o slowo
				addi $s0, $s0, 4
				
				j kontynuuj 
				
					dodajDoDrugiego:
						sw $v0, ($s1)
						addi $t8, $t8, 1
						# Przesuwamy sie w pamieci o slowo
						addi $s1, $s1, 4
						
				kontynuuj: 
					addi $t4, $t4, 1
					ble $t4, $t1, pobieranieLiczb
					
					# Rejestr informujacy ze liczby wprowadzono
					li $s6, 1
					
					jr $ra
					
		wydrukujCiagi: 
			# Drukowanie ciagu z przedzialu
			li $v0, 4
			la $a0, elementyCiagu1
			syscall
			
			# Powrot na poczatek ciagu1
			la $s0, ciag1
			
			# Powrot na poczatek ciagu2
			la $s1, ciag2
			
			# Licznik wydrukowanych elementow ciagu 1
			li $t1, 0
			
			# Licznik wydrukowanych elementow ciagu 2
			li $t2, 0
			
			drukowanieCiagu1:
				# Pobranie wartosci z ciagu i umieszczenie w konsoli
				bge $t1, $t7, koniecDrukowaniaCiagu1
				
				lw $a0, ($s0)
				li $v0, 1
				syscall
				
				# Drukowanie spacji
				li $v0, 4
				la $a0, spacja
				syscall
				
				addi $t1, $t1, 1
				# Przemieszczenie sie w pamieci o slowo
				addi $s0, $s0, 4
				
				j drukowanieCiagu1
				
				koniecDrukowaniaCiagu1:
					# Wypisanie liczby elementow ciagu 1
					li $v0, 4
					la $a0, rozmiar1
					syscall
					
					li $v0, 1
					move $a0, $t7
					syscall
					
					# Rozpoczecie drukowania ciagu 2
					li $v0, 4
					la $a0, elementyCiagu2
					syscall
					
					drukowanieCiagu2: 
						bge $t2, $t8, koniecDrukowaniaCiagu2
						
						# Pobranie elementu i jego wydrukowanie
						lw $a0, ($s1)
						li $v0, 1
						syscall
						
						# Drukowanie spacji
						li $v0, 4
						la $a0, spacja
						syscall
						
						addi $t2, $t2, 1
						# Przesuniecie sie w pamieci o slowo
						addi $s1, $s1, 4
						
						j drukowanieCiagu2
						
						koniecDrukowaniaCiagu2: 
							# Wypisanie liczby elementow ciagu 2
							li $v0, 4
							la $a0, rozmiar2
							syscall
							
							li $v0, 1
							move $a0, $t8
							syscall
							
							jr $ra
