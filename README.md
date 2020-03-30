<h1>Sintetizador:</h1>

<p>En esta práctica se ha reproducido el comportamiento de un sintetizador muy básico en el cual se puede alternar entre la reproducción automática de una melodía o la activación del teclado manual. En el modo manual también se ha habilitado la posibilidad de grabar en un fichero midi la ejecución que se realice en el teclado.</p>

<p>Como no se buscaba crear un sintetizador con una batería extensa de melodías en el modo automático, se ha almacenado en memoria una sola melodía. En caso de que cualquiera quisiera añadir más melodías lo podría hacer fácilmente editando el código. La melodía escogida fue el tema principal de la bagatela de Beethoven 'Para Elisa'.</p>

<p>Al ser un sintetizador, aunque sea básico, permite la activación de distintos instrumentos. Se han escogido los instrumentos de modo que las notas que puede reproducir el sintetizador concuerden con la tesitura natural de estos. La tesitura del sintetizador se extiende desde el Do3 al Do5 (ambos incluidos), y los instrumentos escogidos han sido: piano, chelo, guitarra, flauta, trompeta, acordeón y xilófono.</p>

<p>Para la realización del proyecto se ha utilizado la biblioteca SoundCipher para Processing.</p>

<h2>Detalles de implementación:</h2>

<p>El sintetizador se presenta con un menú de etiquetas para seleccionar el instrumento que se desee reproducir. Además, puede alternar entre el modo automático y el modo manual pulsando la tecla (c). La opción de grabación se activa únicamente en el modo manual pulsando la tecla (v). Para finalizar la grabación se puede pulsar de nuevo la tecla (v).</p>

<p>Existe la posibilidad de grabar varias veces sin necesidad de reiniciar la aplicación, solo que el archivo que quedará registrado será el de la última grabación. Después de la grabación se reproduce automáticamente el resultado de la misma, de modo que el usuario pueda saber si la grabación tiene la calidad suficiente o si requiere de un nuevo proceso de grabación. El fichero que se genera tiene el nombre de "melodia.mid" y se guarda en la raíz del programa processing, no en la raíz del proyecto.</p>

<h3>El modo automático:</h3>

<p>Para la generación de la melodía del modo automático se han utilizado tres variables: pitches, dynamic, y durations. Pitches almacenará la secuencia de tonos midi en un vector de tamaño 35. La variable dynamic contendrá el valor de volumen que será 64, igual para todos los tonos. La última variable será un vector, durations, que almacenará en las posiciones correspondientes a las figuras de corchea el valor 1 y en las posiciones de figuras de negra con puntillo el valor de 3. Los valores de este último vector establecen la duración del sonido en segundos. Para que el flujo natural del bucle del programa permita notas de tanta duración sin que se solapen o se silencien entre ellas se ha situado un comando delay proporcional al valor de duración de la nota. Se probaron varios valores para el factor multiplicativo y finalmente se decidió dejarlo con valor 600.</p>

```java
if(modoAutomatico){
  if(i > 0){
    delay((int)durations[i-1] * 600);
  }else{
    delay((int)durations[34] * 600);
  }
}
```

<p>Un poco más abajo, en el método draw, se hace la llamada al método iluminaTecla1 que será el que se encargue de iluminar la tecla que resonará, seguido de la llamada al método playNote que se encarga de emitir el sonido. La melodía se repite infinitamente recorriendo la secuencia de tonos de modo circular.</p>

<p>El método iluminaTecla1 recibe como parámetros un objeto Tecla. La clase Tecla almacenará información útil para la ejecución de diferentes secciones dentro del método. En concreto almacena: la posición en el eje X de la esquina superior izquierda de la tecla; si es una nota natural o alterada; su tono en codificación midi; y la posición relativa de la nota entre las de su misma naturaleza, esto es, si son naturales o alteradas. Además, almacenará una variable buleana para saber si se encuentra pusada o no. Esto será útil en los casos en los que se accione la tecla mediante teclado de modo que se impida el rebote de la nota.</p>

<p>Los objetos tecla se almacenarán en una estructura HashMap de modo que puedan ser accedidos por su clave, que será su código midi de tono. La variable HashMap toma el nombre de 'teclado' y se carga una sola vez en el método setup.</p>

<p>En el método iluminaTecla1 se pintan de azul las teclas accionadas dependiendo de si son naturales o alteradas, de su posición en el eje X y de su posición relativa de entre las teclas de igual naturaleza. Además, se pinta una etiqueta en la parte inferior de la tecla centrada en la misma con el nombre de la nota que se acciona. Acto seguido se llama al método playNote que producirá el sonido.</p>

```java
[...]
  // Ciclo infinito que reproduce cada nota en cada iteración de draw
  if(modoAutomatico){
    
    iluminaTecla1(teclado.get((int)pitches[i]));
    sc.playNote(0, 2, instrumentos[cod_instrumento], pitches[i], dynamic, durations[i], 3, 64);
    
    i++;
    if(i > 34){
      i = 0;
    }
    
  }else{
    i = 0;
  }
[...]
```

```java
void iluminaTecla1(Tecla t){
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
    int tecla = t.getPosTecla();
    switch(tecla){
      case 0:
      case 3:
      case 7:
      case 10:
        rect(t.getPosX(), ALTO_MENU, 33, 110, 0, 0, 5, 5);      
        break;
    
      case 2:
      case 6:
      case 9:
      case 13:
        rect(t.getPosX() + 12, ALTO_MENU, 33, 110, 0, 0, 5, 5);
        break;
      
      case 14:
        rect(t.getPosX(), ALTO_MENU, 45, 110, 0, 0, 5, 5);
        break;
      
      default:
        rect(t.getPosX() + 12, ALTO_MENU, 21, 110, 0, 0, 5, 5);
        
    }
    
    rect(t.getPosX(), 110 + ALTO_MENU, 45, 70, 0, 0, 5, 5);

    // Borra la linea de unión    
    stroke(0, 128, 255);
    line(t.getPosX(), ALTO_MENU + 110, t.getPosX() + 45, ALTO_MENU + 110);
    stroke(0);
      
    fill(0);
    text(notas[t.getTono()-60], t.getPosX()+22, ALTO_MENU + 160);
    
  }
  
}
```

<p>La posición relativa de la tecla se utiliza para pintar las notas naturales. Las notas naturales a diferencia de las alteradas tienen distinta forma dependiendo de si tienen teclas alteradas a su izquierda, a su derecha, a su izquierda y derecha, o no tiene ninguna como en el caso de la última tecla natural.</p> 

<h3>El modo manual:</h3>

<p>Para la correcta visualización de la iluminación de la tecla al ser accionada, fue necesario reducir el frame rate a 3, de modo que la iluminación tuviese un tiempo suficiente para ser apreciada.</p>

<p>La lógica principal para esta funcionalidad se centra en los eventos mousePressed, keyPressed y keyReleased.</p>

<h4>Pulsación de tecla mediante ratón:</h4>

<p>Para el caso de las pulsaciones mediante el ratón se procedió del modo siguiente. Como todas las notas naturales tienen un ancho igual a 45, lo primero que se hace es detectar en qué franja de nota natural se realizó la pulsación. Luego se comprueba si la pulsación se realizó a la altura de las teclas alteradas. Y por último, si la pulsación se realizó en el margen derecho o izquierdo, lo que significaría que la pusación podría ser sobre una tecla alterada. Las teclas alteradas tienen un ancho de 24, por lo que los márgenes serán de 12 por cada lado.</p>

<p>Para detectar el tono adecuado que se corresponde con la pulsación de ratón se utilizó dos variables: cod_nota y cod_nota_natural. En el caso en el que cod_nota y cod_nota_natural sean distintas se sabrá con seguridad que la nota es realmente una nota alterada.</p>

<p>Por último en el caso de que se pulse en el margen izquierdo de una tecla natural que a su izquierda tiene otra nota natural se le suma 1, que sería equivalente a hacer un redondeo superior. Con esta información se realiza la llamada al método iluminaTecla2, y finalmente se pasa a emitir el sonido y a guardarlo en un objeto SCScore para volcarlo a un fichero midi. Este último paso solo funcionará en el caso de que la grabación se haya activado.</p>

<p>Se comprueba que al pulsar en el margen izquierdo de la tecla inicial no se intente acceder a la tecla de su izquierda ya que no existe y se produciría un overflow. El mismo caso se chequea para la última nota si se pulsa en el margen derecho.</p>

```java

[...]
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

    iluminaTecla2(tecla, cod_nota_natural, cod_nota);
    
    sc.playNote(0, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    if(grabar){
      tiempo_nota = millis();
      int intervalo = tiempo_nota - tiempo_inicio_grabacion;
      
      score.addNote(intervalo/1000, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    }
[...]

```

<p>El método iluminaTecla2 es similar a el método iluminaTecla1 con lo que no requiere mayor explicación.</p>

```java
void iluminaTecla2(int tecla, int cod_nota_natural, int cod_nota){
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
    switch(tecla){
      case 0:
      case 3:
      case 7:
      case 10:
        rect(tecla*45, ALTO_MENU, 33, 110, 0, 0, 5, 5);      
        break;
    
      case 2:
      case 6:
      case 9:
      case 13:
        rect(tecla*45 + 12, ALTO_MENU, 33, 110, 0, 0, 5, 5);
        break;
      
      case 14:
        rect(tecla*45, ALTO_MENU, 45, 110, 0, 0, 5, 5);
        break;
      
      default:
        rect(tecla*45 + 12, ALTO_MENU, 21, 110, 0, 0, 5, 5);
    }
    
    rect(tecla*45, ALTO_MENU + 110, 45, 70, 0, 0, 5, 5);
    
    // Borra la linea de unión
    stroke(0, 128, 255);
    line(tecla*45, ALTO_MENU + 110, tecla*45 + 45, ALTO_MENU + 110);
    stroke(0);
    
    fill(0);
    text(notas[cod_nota-60], tecla*45+22, ALTO_MENU + 160);
  }
}
```
<h4>Pulsación de tecla mediante teclado:</h4>

<p>La captura de teclas permanece activada únicamente en el modo manual. Las teclas del teclado que accionarán las teclas del sintetizador son:

<ul>

<li>a -> Do3; w -> Do#3; s -> Re3; e -> Re#3</li>
<li>d -> Mi3; f -> Fa3; t -> Fa#3; g -> Sol3</li>
<li>y -> Sol#3; h -> La3; u -> La#3; j -> Si3</li>
<li>A -> Do4; W -> Do#4; S -> Re4; E -> Re#4</li>
<li>D -> Mi4; F -> Fa4; T -> Fa#4; G -> Sol4</li>
<li>Y -> Sol#4; H -> La4; U -> La#4; J -> Si4; K -> Do5</li>

</ul>

</p>

```java
[...]
    if(
    key == 'a' || key == 'w' || key == 's' || key == 'e' || key == 'd' || key == 'f' || key == 't' || key == 'g' || key == 'y' || key == 'h' || key == 'u' || key == 'j' ||
    key == 'A' || key == 'W' || key == 'S' || key == 'E' || key == 'D' || key == 'F' || key == 'T' || key == 'G' || key == 'Y' || key == 'H' || key == 'U' || key == 'J' ||
    key == 'K'){
      
      Tecla t = null;
      
      if(key == 'a') t = teclado.get(60);
      if(key == 'w') t = teclado.get(61);
      if(key == 's') t = teclado.get(62);
      if(key == 'e') t = teclado.get(63);
      if(key == 'd') t = teclado.get(64);
      if(key == 'f') t = teclado.get(65);
      if(key == 't') t = teclado.get(66);
      if(key == 'g') t = teclado.get(67);
      if(key == 'y') t = teclado.get(68);
      if(key == 'h') t = teclado.get(69);
      if(key == 'u') t = teclado.get(70);
      if(key == 'j') t = teclado.get(71);
      if(key == 'A') t = teclado.get(72);
      if(key == 'W') t = teclado.get(73);
      if(key == 'S') t = teclado.get(74);
      if(key == 'E') t = teclado.get(75);
      if(key == 'D') t = teclado.get(76);
      if(key == 'F') t = teclado.get(77);
      if(key == 'T') t = teclado.get(78);
      if(key == 'G') t = teclado.get(79);
      if(key == 'Y') t = teclado.get(80);
      if(key == 'H') t = teclado.get(81);
      if(key == 'U') t = teclado.get(82);
      if(key == 'J') t = teclado.get(83);
      if(key == 'K') t = teclado.get(84);

      if(!t.getPulsada()){
        
        iluminaTecla1(t);
        sc.playNote(0, 2, instrumentos[cod_instrumento], t.tono, 64, 0.5, 3, 64);
        println(notas[(int)pitches[i]-60]);
  
        if(grabar){
          tiempo_nota = millis();
          double intervalo = (double)(tiempo_nota - tiempo_inicio_grabacion);
          score.addNote(intervalo/1000, 2, instrumentos[cod_instrumento], t.tono, 64, 0.5, 3, 64);
        }
        
        t.setPulsada(true);
      
      }
    
    }
[...]
```

<h4>Salvado de la ejecución:</h4>

<p>Para la funcionalidad de salvado del fichero "melodia.mid" se utilizan tres variables: la bandera grabar y dos marcas de tiempo. Las marcas de tiempo serán la del inicio de la grabación y otra variable que se utilizará para obtener la marca de tiempo de cada pulsación, que luego servirá para hacer el cálculo de startBeat del método addNote.</p>

```java
[...]
  if(!modoAutomatico){
    if(key == 'v' || key == 'V'){
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
[...]
```

<div align="center">
	<p><img src="./Sintetizador.gif" alt="Sintetizador" /></p>
</div>

<p>Esta aplicación se ha desarrollado como séptima práctica evaluable para la asignatura de "Creando Interfaces de Usuarios" de la mención de Computación del grado de Ingeniería Informática de la Universidad de Las Palmas de Gran Canaria en el curso 2019/20 y en fecha de 29/3/2020 por el alumno Juan Sebastián Ramírez Artiles.</p>

<p>Referencias a los recursos utilizados:</p>

- Modesto Fernando Castrillón Santana, José Daniel Hernández Sosa: [Creando Interfaces de Usuario. Guion de Prácticas](https://cv-aep.ulpgc.es/cv/ulpgctp20/pluginfile.php/126724/mod_resource/content/25/CIU_Pr_cticas.pdf).
- Processing Foundation: [Processing Reference.](https://processing.org/reference/).
- Biblioteca SoundCipher: [Home Page](http://explodingart.com/soundcipher/index.html)