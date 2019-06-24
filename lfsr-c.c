#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define NUM_CAT 16

//vetor de intervalos
int intervalos[NUM_CAT];
double chiSquare[NUM_CAT];
double distChiSquare = 0;

//declarações de funções
void inicializaIntervalos();
void inicializaChiSquare();
void calculaFreq();
void separaIntervalos(uint32_t);
void lfsr();

//corpo das funções
void inicializaIntervalos(){
  for (int i = 0;  i < NUM_CAT; i++) {
    intervalos[i] = 0;
  }
}

void inicializaChiSquare() {
  for (int i = 0;  i < NUM_CAT; i++) {
    chiSquare[i] = 0;
  }
}

void separaIntervalos(uint32_t a) {
  uint32_t aux = (a % NUM_CAT);
  intervalos[aux]++;
}

void calculaFreq(){
  double aux =0;

  for (int i = 0;  i < NUM_CAT; i++) {
    aux = (pow((intervalos[i] - NUM_CAT), 2)) / NUM_CAT;
    chiSquare[i] = aux;

    distChiSquare += chiSquare[i];
  }
}


void lfsr(){
  uint32_t start_state = 0x0001;  /* Estado inicial != 0 */
  uint32_t lfsr = start_state;
  uint32_t bit;                    /* 16 bits */
  unsigned period = 0;

  unsigned long int contador = 0;

  do
  {
    /* o feedback polinomial será dado por: x^16 + x^14 + x^13 + x^11 + 1 */
    bit  = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ^ (lfsr >> 8) ^(lfsr >> 13) ^(lfsr >> 21)) & 1;
    lfsr =  (lfsr >> 1) | (bit << 23);
    ++period;
    contador++;
    lfsr = lfsr & 0x00FFFFFF;
    separaIntervalos(lfsr);
  } while (contador != 16777215);

  printf("\n\n\t %lu Números Gerados\n", contador);
}

int main(void){
  inicializaChiSquare();
  inicializaIntervalos();
  lfsr();
  calculaFreq();

  for (int i = 0; i < NUM_CAT; i++) {
    printf("Intervalo: %d, Frequência: %d, Frequência Esperada: 1048576 Chi-Square: %lf \n", i, intervalos[i],chiSquare[i]);
  }

  printf("---- O valor Chi-Square é %lf ----\n", distChiSquare);

  exit(1);
}