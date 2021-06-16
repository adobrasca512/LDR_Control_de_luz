 ; finalizado
.dseg
valor: .db 1

.cseg 
ldi r16,0xff
out ddrd,r16
rcall config_adc

loopGeneral:
LDS R17,ADCSRA
ORI R17,(1<<ADSC)
STS ADCSRA,R17
esperaADC:
clr r17
lds r17,ADCSRA
SBRC R17,ADSC
RJMP esperaADC
; recojo el valor del ldr
LDS R16,ADCH

;aqui viene la parte que es mi teoria:
;aqui formule la teoria de si tenia que usar pwm pero no lo use
; ¿Sera que la analogica digital me dara el porcentaje en si? si me da una señal analogica..interpretada en digital...seria lo logico
;que el adc me diera una aproximacion...sera que uso el pwm?
;CALCULOS DEL PORCENTAJE
;El 100% es 255 que son los bits que recibo en la parte alta
;viendo el 33% de su maxima capacidad que es 255=84.15
;viendo el 66% de su maxima capacidad que es 255=168.3
;comparo con 33%
;mi ldr esta semi dañado porque el 66% lo ve como de un 100% de luz q le paso desde mi linternita 
;o quizas sea el codigo lo cual espero q no sea asi :(

sts valor,r16
cpi r16,84
;si es menor que el 33 encendemos todas
brlo encendertodas
brsh encendercuatro; si es mayor encendemos cuatro
rjmp fin
encendertodas:
push r20
ser r20
out portb,r20
pop r20
rjmp fin
encendercuatro:
push r20
push r21
lds r20,valor
cpi r20,168
brlo continuar
rjmp fin
continuar:
ldi r21,0b00001111
out portb,r21
pop r21
pop r20



fin:
 rjmp loopGeneral

config_adc:
push r16
ldi r16,(1<<ADEN)
ori r16,(0<<ADATE)
ori r16,(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0)
STS ADCSRA, R16
LDI R16, (0<<ADTS2)|(0<<ADTS1)|(1<<ADTS0)
STS ADCSRB,R16
;aqui coloco la entrada A1
LDI R16,(1<<MUX0)
ORI R16,(0<<REFS1)|(1<<REFS0)
ORI R16,(1<<ADLAR)
STS ADMUX,R16
LDI R16,(1<<ADC1D)
STS DIDR0,R16
LDI R16,(0<<PRADC)
STS PRR,R16
pop r16
RET
