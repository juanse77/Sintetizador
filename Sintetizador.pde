import arb.soundcipher.*;
import processing.serial.*;
//import gifAnimation.*;

//GifMaker ficherogif;

SoundCipher sc = new SoundCipher(this);
SCScore score;

int tiempo_nota = 0;
int tiempo_inicio_grabacion = 0;

boolean modoAutomatico = true;
boolean grabar = false;

final int ALTO_MENU = 25;
final int ANCHO_BOTON = 96;

final boolean NATURAL = true;
final boolean ALTERADA = false;

int cod_instrumento = 0;

float[] instrumentos ={ SoundCipher.PIANO, SoundCipher.CELLO, SoundCipher.GUITAR, SoundCipher.FLUTE, SoundCipher.TRUMPET, SoundCipher.ACCORDION, SoundCipher.XYLOPHONE };

String[] notas = {"Do3", "Do#3", "Re3", "Re#3", "Mi3", "Fa3", "Fa#3", "Sol3", "Sol#3", "La3", "La#3", "Si3",
                  "Do4", "Do#4", "Re4", "Re#4", "Mi4", "Fa4", "Fa#4", "Sol4", "Sol#4", "La4", "La#4", "Si4", "Do5"};
int[] midiNaturalSequence = { 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84 };
int[] midiAlteradaSequence = { 61, 63, 66, 68, 70, 73, 75, 78, 80, 82 };

double[] pitches = {76, 75, 76, 75, 76, 71, 74, 72, 69, 60, 64, 69, 71, 64, 69, 71, 72, 64, 76, 75, 76, 75, 76, 71, 74, 72, 69, 60, 64, 69, 71, 64, 72, 71, 69};
double dynamic = 64;
double[] durations = {1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 6};


final int ANCHO = 675;
final int ALTO = 180 + ALTO_MENU;

int i = 0;
HashMap <Integer,Tecla> teclado = new HashMap <Integer,Tecla>();

void setup() {
  size(675, 250);
  background(255);
  
  //ficherogif = new GifMaker( this, "Sintetizador.gif");
  //ficherogif.setRepeat(0);
  
  stroke(1);
  fill(0);
  frameRate(3);
  confTeclado();

}      

void confTeclado(){
   
  for(int i = 0; i < 15; i++){
    teclado.put(new Integer(midiNaturalSequence[i]), new Tecla(i*45, NATURAL, midiNaturalSequence[i], i));
  }
  
  for(int i = 0, j = 0; i < 13; i++){
    if(i != 2 && i != 6 && i != 9){
      teclado.put(new Integer(midiAlteradaSequence[j]), new Tecla(i*45 + 33, ALTERADA, midiAlteradaSequence[j], j));
      j++;
    }
  }
}

void dibuja_menu(){
  
  fill(128);
  rect(0, 0, ANCHO, ALTO_MENU);
  
  textAlign(CENTER, TOP);
  textFont(createFont("Arial", 12));
  
  fill(0, 128, 255);
  rect(ANCHO_BOTON * cod_instrumento, 0, ANCHO_BOTON, ALTO_MENU);
  
  fill(255);
  text("Piano", ANCHO_BOTON/2, 5);
  text("Chelo", 3*ANCHO_BOTON/2, 5);
  text("Guitarra", 5*ANCHO_BOTON/2, 5);
  text("Flauta", 7*ANCHO_BOTON/2, 5);
  text("Trompeta", 9*ANCHO_BOTON/2, 5);
  text("Acordeón", 11*ANCHO_BOTON/2, 5);
  text("Xilófono", 13*ANCHO_BOTON/2, 5);
  
  fill(128);
  rect(0, 200, ANCHO, 50);
  fill(255);
    
  if(modoAutomatico){
    text("Para cambiar a modo manual pulse la tecla c", ANCHO/2, 225);
  }else{
    text("Para cambiar a modo automático pulse la tecla c", ANCHO/2, 210);
    
    if(grabar){
      text("Para finalizar la grabación pulse la tecla r", ANCHO/2, 230);
    }else{
      text("Para iniciar la grabación pulse la tecla r", ANCHO/2, 230);
    }
  }
}


void draw() {
 
  if(modoAutomatico){
    if(i > 0){
      delay((int)durations[i-1] * 600);
    }else{
      delay((int)durations[34] * 600);
    }
  }
  
  background(255);
  noFill();
  
  dibuja_menu();
  
  fill(255);
  // dibuja las notas naturales
  for(int i = 0; i < 15; i++){
    rect(i*45, ALTO_MENU, 45, 180, 0, 0, 5, 5);
  }
  
  fill(0);

  // dibuja las notas alteradas
  for(int i = 0; i < 13; i++){
    if(i != 2 && i != 6 && i != 9){
      rect(i*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
    }
  }
 
  if(modoAutomatico){
    
    accionaTecla(teclado.get((int)pitches[i]), i);
    println(notas[(int)pitches[i]-60]);
    
    i++;
    if(i > 34){
      i = 0;
    }
    
  }else{
    i = 0;
  }

  //for(int j = 0; j < 8; j++){
  //  ficherogif.addFrame();
  //}

}

void accionaTecla(Tecla t, int i){
  fill(0, 128, 255);
  textAlign(CENTER, TOP);
  textFont(createFont("Arial", 10));
  
  if(!t.getNatural()){
    // pinta la nota alterada
    rect(t.getPosX(), ALTO_MENU, 24, 110, 0, 0, 5, 5);
    fill(0);
    text(notas[t.getTono()-60], t.getPosX() + 12, ALTO_MENU + 160);
    
  }else{
    
    // pinta la nota natuaral
    rect(t.getPosX(), ALTO_MENU, 45, 180, 0, 0, 5, 5);   
    fill(0);
    
    text(notas[t.getTono()-60], t.getPosX()+22, ALTO_MENU + 160);
    
    int tecla = t.getPosTecla();
    switch(tecla){
      case 0:
      case 3:
      case 7:
      case 10:
        rect(tecla*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);      
        break;
    
      case 2:
      case 6:
      case 9:
      case 13:
        rect((tecla-1)*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
        break;
      
      case 14:
        break;
      
      default:
        rect(tecla*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
        rect((tecla-1)*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
    }
  }
  
  sc.playNote(0, 2, instrumentos[cod_instrumento], pitches[i], dynamic, durations[i], 3, 64);
}

void coloreaTecla(int tecla, int cod_nota_natural, int cod_nota){
  fill(0, 128, 255);
  textAlign(CENTER, TOP);
  textFont(createFont("Arial", 10));
  
  if(cod_nota_natural != cod_nota){
    
    // pinta la nota alterada
    if(cod_nota > cod_nota_natural){
    
      rect(tecla*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);    
      fill(0);
      text(notas[cod_nota-60], (tecla+1)*45, ALTO_MENU + 160);    
    
    }else{
      rect((tecla-1)*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
      fill(0);
      text(notas[cod_nota-60], (tecla)*45, ALTO_MENU + 160);
    }
    
  }else{
    
    // pinta la nota natuaral
    rect(tecla*45, ALTO_MENU, 45, 180, 0, 0, 5, 5);   
    fill(0);
    
    text(notas[cod_nota-60], tecla*45+22, ALTO_MENU + 160);
    
    switch(tecla){
      case 0:
      case 3:
      case 7:
      case 10:
        rect(tecla*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);      
        break;
    
      case 2:
      case 6:
      case 9:
      case 13:
        rect((tecla-1)*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
        break;
      
      case 14:
        break;
      
      default:
        rect(tecla*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
        rect((tecla-1)*45 + 33, ALTO_MENU, 24, 110, 0, 0, 5, 5);
    }
  }
}

void mousePressed() {
  
  if(!modoAutomatico && mouseY > ALTO_MENU){
    int tecla = (int)(mouseX/45);
    
    int cod_nota = midiNaturalSequence[tecla];
    int cod_nota_natural = cod_nota;
    
    int resto = mouseX % 45;
    if(mouseY < 110 + ALTO_MENU){
      
      if(resto > 33 && tecla < 14){
      
        cod_nota = (int)(cod_nota + midiNaturalSequence[tecla+1])/2; 
      
      }else if(resto < 12 && tecla > 0){
        
        float nota_alterada = (cod_nota + midiNaturalSequence[tecla-1])/2f;
        if(nota_alterada % 1 > 0){
          cod_nota = (int)nota_alterada + 1;
        }else{
          cod_nota = (int)nota_alterada;
        }
        
      }
      
    }
  
    println(notas[cod_nota-60]);
    
    coloreaTecla(tecla, cod_nota_natural, cod_nota);
    
    sc.playNote(0, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    if(grabar){
      tiempo_nota = millis();
      double intervalo = (double)(tiempo_nota - tiempo_inicio_grabacion);
      
      score.addNote(intervalo/1000, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    }
  }
  
  if(mouseY <= ALTO_MENU){
    cod_instrumento = (int)(mouseX/ANCHO_BOTON);
    if(cod_instrumento > instrumentos.length - 1){
      cod_instrumento = instrumentos.length - 1;
    }
  }
}

void keyPressed(){
  if(key == 'c' || key == 'C'){
    if(modoAutomatico){
      modoAutomatico = false;
    }else{
      modoAutomatico = true;
    }
  }
  
  if(!modoAutomatico){
    if(key == 'r' || key == 'R'){
      if(grabar){
        score.play();
        score.writeMidiFile("melodia.mid");
        grabar = false;
      }else{
        score = new SCScore();
        tiempo_inicio_grabacion = millis();
        grabar = true;
      }
    }
    
  }
  
  //if(key == 't'){
  //  ficherogif.finish();
  //}
}

void stop() {
  sc.stop();
}
