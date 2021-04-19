int test_set(set conjunto){
   set conjunto2;
   conjunto2 = EMPTY;
   elem el;
   elem el2;
   el = 4;
   el2 = 5;
   elem elemento;
   if(conjunto2 == EMPTY && (test_set(elemento) || add(el in conjunto2))) {
     write("Há elemento 4 ou 5 no conjunto\n");
   }
   return 0;
}

int main(){
    int a;
    set conjuntoParaTest;
    a = 3 / 3 +2;
    test_set(conjuntoParaTest);
    return 0;
}

