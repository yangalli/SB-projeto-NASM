#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define NUM_CAT 16

//vetor de classes
int classes[NUM_CAT];
double chiSquare[NUM_CAT];
double distChi = 0;

//declarações de funções
void inicializaClasses();
void inicializaChiSquare();
void calculaFreq();
void separaClasses(uint32_t);
void lfsr();

//corpo das funções
void inicializaClasses(){
  for (int i = 0;  i < NUM_CAT; i++) {
    classes[i] = 0;
  }
}

void inicializaChiSquare() {
  for (int i = 0;  i < NUM_CAT; i++) {
    chiSquare[i] = 0;
  }
}

void separaClasses(uint32_t a) {
  uint32_t aux = (a % NUM_CAT);
  classes[aux]++;
}

void calculaFreq(){
  double aux =0;

  for (int i = 0;  i < NUM_CAT; i++) {
    aux = (pow((classes[i] - NUM_CAT), 2)) / NUM_CAT;
    chiSquare[i] = aux;

    distChi += chiSquare[i];
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
    separaClasses(lfsr);
  } while (contador != 16777215);

  printf("\n\n\t %lu Números Gerados\n", contador);
}

int main(void){
  inicializaChiSquare();
  inicializaClasses();
  lfsr();
  calculaFreq();

  for (int i = 0; i < NUM_CAT; i++) {
    printf("Intervalo: %d, Frequência: %d, Frequência Esperada: 1048576 Chi-Square: %lf \n", i, classes[i],chiSquare[i]);
  }

  printf("---- O valor Chi-Square é %lf ----\n", distChi);

  exit(1);
}