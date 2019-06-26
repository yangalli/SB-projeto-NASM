// Compilação -> gcc lfsr-c.c -o lfsr -g -lm

#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define NUM_INT 16
#define NUM_OBS 16777215

//vetor de intervalos
int intervalos[NUM_INT];
double chiSquare[NUM_INT];
double distChiSquare = 0;

//declarações de funções
void separaIntervalos(uint32_t);
void calculaFreq();
void inicializaChiSquare();
void inicializaIntervalos();
void lfsr();

// Pega o estado inicial e faz o módulo pelo número de intervalos 
void separaIntervalos(uint32_t a) {
  uint32_t aux = (a % NUM_INT);
  intervalos[aux]++;
}

// Calculo matemático do Chi-Square -> (i=1->k)Σ (x-m)^2/m
void calculaFreq(){
  double aux =0;

  for (int i = 0;  i < NUM_INT; i++) {
    aux = ((pow((intervalos[i] - NUM_INT), 2)) / NUM_INT) / sqrt(NUM_OBS);
    chiSquare[i] = aux;

    distChiSquare += chiSquare[i];
  }
}

// Incialmente Zera os valores chi-quadrado para cada intervalo
void inicializaChiSquare()
{
  for (int i = 0; i < NUM_INT; i++)
  {
    chiSquare[i] = 0;
  }
}

// Incialmente Zera todos os intervalos
void inicializaIntervalos()
{
  for (int i = 0; i < NUM_INT; i++)
  {
    intervalos[i] = 0;
  }
}

void lfsr(){
  uint32_t start_state = 0x0001;  /* Estado inicial != 0 */
  uint32_t lfsr = start_state;
  uint32_t bit;                    /* Começa com 32 Bits -> irá para 24 bits (shift 8) */
  unsigned period = 0;

  unsigned long int contador = 0;

  do
  {
    // Fibonacci -> 24 + 23 + 22 + 17 + 1
    /* o feedback polinomial será dado por: x^24 + x^23 + x^22 + x^17 + 1 */
    bit = ((lfsr >> 0) ^ (lfsr >> 1) ^ (lfsr >> 2) ^ (lfsr >> 5) ^ (lfsr >> 8)) & 1;
    lfsr =  (lfsr >> 1) | (bit << 23);
    ++period;
    contador++;
    lfsr = lfsr & 0x00FFFFFF; //16777215
    separaIntervalos(lfsr);
  } while (contador != NUM_OBS); //16777215

  printf("\n\n\t %lu Números Gerados\n", contador);
}

int main(void){
  float porcentagem;
  inicializaChiSquare();
  inicializaIntervalos();
  lfsr();
  calculaFreq();

  // Printa os intervalos, suas frequências e o valor chi-square do intervalo
  for (int i = 0; i < NUM_INT; i++) {
    printf("Intervalo: %d, Frequência: %d, Frequência Esperada: 1048576 Chi-Square: %lf \n", i, intervalos[i], chiSquare[i]);
  }

  porcentagem = distChiSquare / NUM_OBS;
  // Retorna o valor total do chi-quadrado
  printf("---- O valor Chi-Square é %lf ----\n", distChiSquare);

  printf("---- Porcentagem em relação a 16777215: %f ----\n", porcentagem);

  exit(1);
}