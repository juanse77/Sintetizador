<h1>Sintetizador:</h1>

<p>En esta pr�ctica se ha reproducido en comportamiento de un sintetizador muy b�sico en el cual se puede alternar entre la reproducci�n autom�tica de una melod�a o la activaci�n del teclado manual. En el modo manual tambi�n se ha habilitado la posibilidad de grabar en un fichero midi la ejecuci�n que realice en el teclado.</p>

<p>Como no se buscaba crear un sintetizador con una bater�a extensa de melod�as en el modo autom�tico, se ha almacenado en memoria una sola melod�a. En caso de que cualquiera quisiera a�adir m�s melod�as lo podr�a hacer f�cilmente editando el c�digo. La melod�a escog�da fue el tema principal de la bagatela de Beethoven 'Para Elisa'.</p>

<p>Al ser un sintetizador, aunque sea b�sico, permite la activaci�n de distintos instrumentos. Se han escogido los instrumentos de modo que las notas que puede reproducir el sintetizador concuerden con la tesitura natural de estos. La tesitura del sintetizador se extiende desde el Do3 al Do5 (ambos incluidos), y los instrumentos escogidos han sido: el piano, el chelo, la guitarra, la flauta, la trompeta, y el xil�fono.</p>

<p>Para la realizaci�n del proyecto se ha utilizado la biblioteca SoundCipher para Processing.</p>

<h2>Detalles de implementaci�n:</h2>

<p>El sintetizador se presenta con un men� de etiquetas para seleccionar el instrumento que se desee reproducir. Adem�s, puede alternar entre el modo autom�tico y el modo manual pulsando la tecla (c). La opci�n de grabaci�n se activa �nicamente en el modo manual pulsando la tecla (r). Para finalizar la grabaci�n se puede pulsar de nuevo la tecla (r).</p>

<p>Existe la posibilidad de grabar varias veces sin necesidad de reiniciar la aplicaci�n, solo que el archivo que quedar� registrado ser� el de la �ltima grabaci�n. Despu�s de la grabaci�n se reproduce autom�ticamente el resultado de la misma, de modo que el usuario pueda saber si la grabaci�n tiene la calidad suficiente o si requiere de un nuevo proceso de grabaci�n. El fichero que se genera tiene el nombre de "melodia.mid" y se guarda en la ra�z del programa processing, no en la ra�z del proyecto.</p>

<h3>El modo autom�tico:</h3>

<p>Para la generaci�n de la melod�a del m�do autom�tico se han utilizado tres vectores: pitches, dynamics, y durations. Pitches almacenara la secuencia de tonos midi en un vector de tama�o 35. El vector dynamics es de igual dimensi�n que pitches y almacena para todas sus posiciones un valor medio de 64. El �ltimo vector, durations, almacenar� en las posiciones correspondientes a las figuras de corchea el valor 1 y en las posiciones de figuras de negra con puntillo el valor de 3. Estos valores establecen la duraci�n del sonido en segundos. Para que el flujo natural del bucle del programa permita notas de tanta duraci�n sin que se solapen y se silencien entre ellas se ha situado un comando delay proporcional al valor de duraci�n de la nota. Se porbaron varios valores para el factor multiplicativo y finalmente se decidi� dejarlo con valor 600.</p>

```java
if(modoAutomatico){
	if(i > 0){
		delay((int)durations[i-1] * 600);
	}else{
		delay((int)durations[34] * 600);
	}
}
```

<p>Un poco m�s abajo, en el m�todo draw, se hace la llamada al m�todo accionaTecla que ser� el que se encargue de iluminar la tecla que resonar� y de emitir el sonido. La melod�a se repite infinitamente recorriendo los vectores anteriormente descritos de modo circular.</p>

<p>El m�todo acciona tecla recibe como par�metros un objeto Tecla y el valor del �ndice del recorrido por los vectores. La clase Tecla almacenar� informaci�n �til para la ejecuci�n de diferentes secciones dentro del m�todo accionaTecla. En concreto almacena: la posici�n en el eje X de la esquina superior izquierda de la tecla; si es una nota natural o alterada; su tono en codificaci�n midi; y su posici�n relativa a las notas de igual naturaleza, esto es si son naturales o alteradas.</p>

<p>Los objetos tecla se almacenar�n en una estructura HashMap de modo que puedan ser accedidos por su clave, que ser� su c�digo midi de tono. La variable HashMap toma el nombre de teclado y se carga una sola vez en el m�todo setup.</p>

```java
// Ciclo infinito que reproduce cada nota en cada iteraci�n de draw 
if(modoAutomatico){
    
	accionaTecla(teclado.get((int)pitches[i]), i);
    
	i++;
	if(i > 34){
		i = 0;
	}
    
}else{
	i = 0;
}
```

<p>En el m�todo accionaTecla se pintan de azul las teclas accionadas dependiendo de si son naturales o alteradas, de su posici�n en el eje X y de su posici�n relativa dentro de las teclas de su naturaleza. Adem�s, se pinta una etiqueta en la parte inferior de la tecla centrada en la misma con el nombre de la nota que se acciona. Finalmente en el m�todo se hace la llamada al m�todo que producir� el sonido.</p>

```java
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
  
  sc.playNote(0, 2, instrumentos[cod_instrumento], pitches[i], dynamics[i], durations[i], 3, 64);
}
```

<p>La posici�n relativa de la tecla se utiliza para pintar las notas alteradas que pueden situarse a la derecha, a la izquierda, o a la derecha e izquierda de cada tecla natural, o en el caso de la �ltima tecla natural, la 14, en el que no es necesario pintar ninguna tecla alterada a su alrededor. La posici�n relativa es �nicamente necesaria en los casos en los que se pinte la tecla natural.</p> 

<h3>El modo manual:</h3>

<p>Para que la animaci�n de la tecla iluminada al ser accionada, fue necesario reducir el frame rate a 3, de modo que la iluminaci�n tuviese un tiempo suficiente para ser apreciada.</p>

<p>La l�gica principal para esta funcionalidad se centra en el evento mousePressed. Como todas las notas naturales tienen un ancho igual a 45, lo primero que se hace es detectar en qu� franja de nota natural se realiz� la pulsci�n. Luego se comprueba si la pulsaci�n se realiz� a la altura de las teclas alteradas. Y por �ltimo, si la pulsaci�n se realiz� en el margen derecho o izquierdo, lo que significar�a que la pusaci�n podr�a ser sobre una tecla alterada. Las teclas alteradas tienen un ancho de 24, por lo que los margenes ser�n de 12 por cada lado.</p>

<p>Para detectar que tono adecuado se corresponde con la pulsaci�n de rat�n se utiliz� dos variables: cod_nota y cod_nota_natural. En el caso en el que cod_nota y cod_nota_natural sean distintas se sabr� con seguridad que la nota es realmente una nota alterada.</p>

<p>Por �ltimo en el caso de que se pulse en el margen izquierdo de una tecla natural que a su izquierda tiene otra nota natural se le suma 1, que ser�a equivalente a hacer un redondeo superior. Con esta informaci�n se realiza la llamada al m�todo coloreaTecla, y finalmente se pasa a emitir el sonido y a guardarlo en un objeto SCScore para volcarlo a un fichero midi. Este �ltimo pasa solo funcionar� en el caso de que la grabaci�n se haya activado.</p>

<p>Se comprueba que al pulsar en el margen izquierdo de la tecla inicial no se intente acceder a la tecla de su izquierda ya que no existe y se producir�a un overflow. El mismo caso se chequea para la �ltima nota si se pulsa en el margen derecho.</p>

```java

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

    coloreaTecla(tecla, cod_nota_natural, cod_nota);
    
    sc.playNote(0, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    if(grabar){
      tiempo_nota = millis();
      int intervalo = tiempo_nota - tiempo_inicio_grabacion;
      
      score.addNote(intervalo/1000, 2, instrumentos[cod_instrumento], cod_nota, 64, 0.5, 3, 64);
    }
```

<p>El m�todo coloreaTecla es similar a el m�todo accionaTecla con lo que no requiere mayor explicaci�n.</p>

```java
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
```

<p>Para la funcionalidad de salvado del fichero "melodia.mid" se utilizan tres variables: la bandera grabar y dos marcas de tiempo. Las marcas de tiempo ser�n la de el inicio de la grabaci�n y la otra variable se utilizar� para obtener la marca de tiempo de cada pulsaci�n que luego servir� para hacer el c�lculo de startBeat del m�todo addNote.</p>

```java
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

```

<div align="center">
	<p><img src="./Sintetizador.gif" alt="Sintetizador" /></p>
</div>

<p>Esta aplicaci�n se ha desarrollado como s�ptima pr�ctica evaluable para la asignatura de "Creando Interfaces de Usuarios" de la menci�n de Computaci�n del grado de Ingenier�a Inform�tica de la Universidad de Las Palmas de Gran Canaria en el curso 2019/20 y en fecha de 28/3/2020 por el alumno Juan Sebasti�n Ram�rez Artiles.</p>

<p>Referencias a los recursos utilizados:</p>

- Modesto Fernando Castrill�n Santana, Jos� Daniel Hern�ndez Sosa: [Creando Interfaces de Usuario. Guion de Pr�cticas](https://cv-aep.ulpgc.es/cv/ulpgctp20/pluginfile.php/126724/mod_resource/content/25/CIU_Pr_cticas.pdf).
- Processing Foundation: [Processing Reference.](https://processing.org/reference/).
- Biblioteca SoundCipher: [Home Page](http://explodingart.com/soundcipher/index.html)