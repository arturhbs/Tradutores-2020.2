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
    float a;
    set conjuntoParaTest;
    a=3.2;
    if(a > 2 || a +3 < 3 || test_set(conjuntoParaTest) <44){
        a = 3 / 3 - 2.5 * test_set(conjuntoParaTest);
    }
    else return 1;
    return 0;
}

