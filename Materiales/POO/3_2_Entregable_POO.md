# GAME OF CLASSES

Vamos a crear un juego de batalla por turnos en el que dos ejércitos se enfrentarán en una simulación. Cada ejército estará compuesto por **cinco guerreros**, cada uno de una **subclase** específica. Los guerreros tendrán atributos y habilidades únicas que los diferenciarán en combate.


![la guerra](https://images.immediate.co.uk/production/volatile/sites/7/2024/07/VIKINGS301Unit01400RC.jpgVIKINGS301Unit01400RC-acd0da5.jpg?quality=90&resize=980,654
)


# Requisitos

## **Superclase  Guerrero**:

Esta será la clase base de la cual heredarán todos los tipos de guerreros. Los atributos de cada guerrero serán asignados aleatoriamente dentro de un rango definido por la subclase específica.

`Atributos comunes`:

- nombre (string): Nombre del guerrero.
- salud (int): Cantidad de puntos de vida. Este valor será asignado de forma aleatoria dentro de un rango, dependiendo del tipo de guerrero.
- fuerza (int): Define el poder de ataque. Valor aleatorio dentro de un rango específico.
- defensa (int): Indica cuánto daño puede bloquear el guerrero.
- velocidad (int): Determina qué guerrero ataca primero en un turno.


`Métodos comunes`:
- atacar(objetivo): Realiza un ataque a otro guerrero. Este método será redefinido en las subclases.
- defender(daño): Reduce el daño recibido en función del atributo defensa.
- sigue_vivo(): Devuelve True si la salud del guerrero es mayor que 0, de lo contrario False.
- mostrar_estadisticas(): Muestra los atributos actuales del guerrero.


## **Subclases de Guerrero**:

Cada subclase tendrá un rango específico para los atributos de salud, fuerza, defensa y velocidad. Los valores serán generados aleatoriamente dentro de estos rangos al instanciar cada guerrero. Los métodos atacar() y defender() también serán personalizados para cada subclase.

### `Caballero`

`Atributos`:  
```  
    - salud: Entre 100 y 150.
    - fuerza: Entre 30 y 40.
    - defensa: Entre 50 y 70.
    - velocidad: Entre 10 y 20.
```

`Métodos`:
-   **atacar**(objetivo): El Caballero realiza un ataque directo basado en su fuerza.
***Fórmula de daño: daño = fuerza * 1.2***
- **defender**(daño): El Caballero bloquea un porcentaje del daño recibido, basado en su defensa.
***Fórmula: daño_recibido = daño - (defensa * 0.6)***.


### `Arquero`

`Atributos`:
```
    - salud: Entre 70 y 100.
    - fuerza: Entre 25 y 35.
    - defensa: Entre 20 y 30.
    - velocidad: Entre 40 y 60.
```
`Métodos`:
- **atacar**(objetivo): El Arquero tiene una probabilidad del 30% de realizar un ataque que ignore el 50% de la defensa del oponente.
***Fórmula de daño normal: daño = fuerza * 1.0***.
***Fórmula de ataque especial (30% probabilidad): daño = fuerza * 1.0, pero se reduce la defensa del objetivo a la mitad.***
- **defender**(daño): Tiene una probabilidad del **20%** de esquivar completamente el ataque.
Si no esquiva, el daño recibido es: ***daño_recibido = daño - (defensa * 0.4)***.
### `Mago`

`Atributos`:
```
    - salud: Entre 50 y 80.
    - fuerza: Entre 40 y 60.
    - defensa: Entre 10 y 20.
    - velocidad: Entre 20 y 30.
```
`Métodos`:
- **atacar**(objetivo): El Mago tiene un 10% de lanzar un ataque mágico que afecta a todos los enemigos en vez de a uno solo.
Ataque simple: ***daño = fuerza * 1.5 a un solo enemigo.***
Ataque masivo: ***daño = fuerza * 0.8 a todos los enemigos.***
- **defender**(daño): Tiene una probabilidad del 10% de esquivar el ataque y curar a un aliado 15 puntos de salud
Si no esquiva, el daño recibido es: ***daño_recibido = daño - (defensa * 0.4)***

### `Asesino`
`Atributos`:
```
    - salud: Entre 60 y 90.
    - fuerza: Entre 35 y 45.
    - defensa: Entre 15 y 25.
    - velocidad: Entre 50 y 70.
```
`Métodos`:
- **atacar**(objetivo): Tiene una probabilidad del 25% de realizar un ataque crítico que inflige el doble de daño.
***Fórmula de ataque normal: daño = fuerza * 1.0.***
***Fórmula de ataque crítico: daño = fuerza * 2.0.***
- **defender**(daño): Probabilidad del 30% de evitar completamente el daño.Sino el daño recibido es: ***daño_recibido = daño - (defensa * 0.15)***.

### `Curandero`
`Atributos`:
```
    - salud: Entre 80 y 120.
    - fuerza: Entre 10 y 20.
    - defensa: Entre 20 y 30.
    - velocidad: Entre 30 y 40.
```

`Métodos`:
- **atacar**(objetivo): El Curandero realiza un ataque básico.
***Fórmula de daño: daño = fuerza * 0.8.***
- **curar**(objetivo): En lugar de atacar, el Curandero puede curar a sí mismo o a un aliado.
***Fórmula de curación: curación = 30 puntos de salud.***
- **defender**(daño): Tiene una defensa mágica que reduce el daño recibido.
***Fórmula: daño_recibido = daño - (defensa * 0.5).***



## **Reglas de la simulación**
### 1 - Creación de ejércitos:

Se crearán **dos ejércitos**, cada uno compuesto por cinco guerreros, uno de **cada subclase**.
Los atributos de los guerreros serán generados aleatoriamente dentro de los rangos establecidos.

### Batalla por turnos:

Empezará a atacar el ejército con el guerrero más rápido.

El orden de los turnos dentro del mismo ejéŕcito se determinará por el atributo velocidad de cada guerrero. El guerrero con la velocidad más alta atacará primero hasta llegar al más lento.

Los guerreros elegirán un oponente al azar para atacar, o realizarán una acción específica en función de su subclase.(Podemos hacer que el jugador elija a quien atacar, que decida la acción en función de la subclase, o que sea aleatorio)

Cada turno jugará un guerrero de cada equipo de manera secuencial, un guerrero de un ejército no puede atacar 2 veces antes de que todos sus compañeros de ejército hayan completado al menos 1 ataque.

La simulación terminará cuando todos los guerreros de un ejército sean derrotados (salud <= 0).


### Condición de victoria:

El ejército que quede con al menos un guerrero vivo ganará la batalla.


***TIP para que la salida de tu código no se llene recuerda que puedes usar de la librería IPython.display la función clear_output***

***La cual usada así clear_output(wait=True)
vacía la salida de nuestro código una vez tiene más texto que mostrar por pantalla***