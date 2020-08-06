# BrightScript Profiler
BrightScript Profiler es una herramienta creada para recopilar y analizar métricas de canal que se pueden utilizar para determinar dónde se pueden realizar mejoras de rendimiento y eficiencias en el canal.

El generador de perfiles de BrightScript proporciona las siguientes métricas para un canal: 
- Uso de CPU: Determina dónde está ocurriendo la ejecución del código de BrightScript 
- Tiempo de reloj de pared(Wall-Clock time): Determina dónde se pasa la mayor parte del tiempo (ejecución y espera) cuando se ejecuta un canal 
- Cuenta de llamadas de función (Function call counts)
- Uso de memoria,  incluida la detección de pérdidas de memoria: disponible desde Roku OS 9 

Cada una de las métricas anteriores se puede utilizar para diagnosticar problemas y proporcionar orientación al desarrollador del canal para mejorar el rendimiento del canal.

# USO
El flujo de trabajo de BrightScript Profiler es el siguiente: 
1. Agregue al menos las entradas de manifest requeridas al canal para ejecutar el generador de perfiles 
2. Ejecute y luego salga del canal para generar datos y métricas 
3. Guarde los datos de creación de perfiles en el dispositivo o transmítalos a la máquina (PC) que está utilizando para el desarrollo 
4. Analizar los datos de creación de perfiles según sea necesario 

# Entradas del manifest
## Adding to manifest file

Si este valor ***local***, los datos de creación de perfiles se recopilan en el dispositivo y se pueden descargar desde el Instalador de aplicaciones una vez que finaliza el canal(esta por default).
Si este valor es ***network***, los datos de perfil se envían a través de la red en lugar de almacenarse en el dispositivo. 

> Consulte la sección sobre recuperación de datos de creación de perfiles para obtener más detalles.

    bsprof_data_dest=network 

Activa el perfil de BrightScript cuando el canal se está ejecutando.  Este es el indicador maestro y debe establecerse en ***1*** para que cualquier otra opción de creación de perfiles surta efecto.

    bsprof_enable=1

Recopila datos de memoria y CPU para cada línea de código fuente de BrightScript.  Esto facilita identificar problemas de uso de memoria y CPU.  Este valor se establece en 0 de forma predeterminada, lo que significa que se recopilan datos para cada función de BrightScript en su conjunto.  

> Habilitar esta función puede tener un impacto significativo en el rendimiento del dispositivo.  Requiere que se habilite la creación de perfiles de BrightScript ***(bsprof_enable = 1)*** y que la ***versión de RSG se establezca en 1.2 (rsg_version = 1.2)***.  Disponible desde Roku OS 9.1.

    bsprof_enable_lines=1

Turns on memory profiling.
- Requires BrightScript profiling to be enabled ***(bsprof_enable=1)***.
If this is enabled, the ***bsprof_sample_ratio is automatically set to 1.0.***

    bsprof_enable_mem=1

Establece con qué frecuencia se toman muestras de perfiles, mientras el canal se está ejecutando.  Solo tiene efecto si ***bsprof_enable = 1***. Si la creación de perfiles de memoria está habilitada (***bsprof_enable_mem = 1***), este valor se establece automáticamente en 1.0.  

El bs_prof_sample_ratio se puede ajustar de 0,001 a 1,0.  Una proporción de muestra de 1.0 es la predeterminada y proporciona los datos más precisos porque se mide cada declaración de BrightScript.  Sin embargo, una relación de muestra de 1.0 puede ralentizar el rendimiento del dispositivo, pero generalmente no afecta la usabilidad del canal.  Si se observa un rendimiento más lento del dispositivo, reduzca la proporción para disminuir la sobrecarga del perfilador.

    bsprof_sample_ratio=1.0

Para usar el perfil de nivel de línea(bsprof_enable_lines), debe establecerse en 1.2 (***rsg_version = 1.2***).  Si no se establece en 1.2, la creación de perfiles seguirá funcionando correctamente;  sin embargo, no se generarán datos a nivel de línea.  
> rsg_version 1.2 proporciona importantes mejoras de rendimiento;  por lo tanto, debe establecerlo en 1.2 independientemente de si su canal está usando perfiles de nivel de línea.  
> Consulte el Manifiesto del canal Roku para obtener más información.
>https://developer.roku.com/es-mx/docs/developer-program/getting-started/architecture/channel-manifest.md

    rsg_version=1.2

# Running the profiler on a channel
Para iniciar el generador de perfiles de memoria, cargue, ejecute y luego salga del canal.  Los datos de creación de perfiles se completan solo después de que sale el canal.

## Pausing and resuming profiling

La creación de perfiles de canales se puede pausar y reanudar en cualquier momento.  Utilice los siguientes comandos en el puerto 8080 para pausar o reanudar el generador de perfiles de memoria: 

    bsprof-pause 
    bsprof-resume 

Si el generador de perfiles está en pausa, se escriben muy pocos datos independientemente del destino de los datos.  Esto permite que los datos de creación de perfiles (generalmente, los datos relevantes para partes específicas de la interfaz de usuario de un canal u otra operación) se recopilen y analicen más tarde.  

>Estos dos comandos son particularmente útiles cuando se combinan con la entrada de manifiesto ***bsprof_pause_on_start.***  Entrada de manifiesto: ***bsprof_pause_on_start = 1***

Por ejemplo, si el inicio de la reproducción de video es lento o parece causar pérdidas de memoria, la entrada ***bsprof_pause_on_start = 1*** se puede configurar en el manifiesto del canal.  Después de iniciar el canal, pero antes de la reproducción del video, ejecute el comando bsprof-resume en el puerto 8080 para comenzar a recopilar datos de creación de perfiles.  

Después de realizar las operaciones de IU que se van a perfilar, ejecute el comando bsprof-pause para suspender la operación de almacenamiento de los datos de perfilado.  Luego, salga del canal para que los datos de perfil estén disponibles para su análisis.  En este escenario, los datos del perfil pertenecerán específicamente a las operaciones realizadas entre ***bsprof-resume*** y ***bsprof-pause.***

# Port 8080 Commands
These profiling commands exist on port 8080 (Roku OS Versions 9 and later):
- bsprof-status: Get the status of BrightScript profiling
- bsprof-pause:	Pause the generation of profiling data
- bsprof-resume: Resume the generation of profiling data

# Collecting the data 

La entrada del manifiesto del canal bsprof_data_dest determina cómo se recuperan los datos de creación de perfiles del dispositivo.  Los datos se pueden almacenar localmente en el dispositivo y descargar después de que el canal termina de ejecutarse y sale, o se pueden transmitir a través de una conexión de red mientras el canal se está ejecutando.  La transmisión consume significativamente menos memoria en el dispositivo mientras se ejecuta el canal.  Además, si el canal falla, los datos de la memoria se habrán recopilado con precisión hasta el momento del bloqueo (los datos de la CPU, sin embargo, generalmente se pierden si ocurre una falla).

# Ver datos de creación de perfiles


Después de descargar el archivo ***.bsprof***, los datos se pueden ver con la herramienta de visualización BrightScript Profiler.  La herramienta enumera las llamadas a funciones en cada hilo.  Para las aplicaciones SceneGraph, cada hilo corresponde al main BrightScript thread o a una única instancia de un < component >.  

Por ejemplo, si tiene un nodo Task del que se crean instancias varias veces, cada instancia aparecerá como un hilo independiente.  Los resultados son los mismos para cualquier < component > personalizado en el canal que se instancia varias veces.  El main BrightScript thread (Thread main) también se representa como un solo subproceso, aunque no tiene < component >.

Para cada función enumerada en la herramienta, puedes expandirla para profundizar más en su ruta de llamada y obtener datos más detallados sobre la función.  Si habilitas line-level profiling para el canal, también puede hacer clic en las elipses a la derecha de una función para ver los datos de generación de perfiles para las líneas individuales de código dentro de una función.

## EJEMPLO PAGINA

<p align="center"> 
<img src="/images/Threads.png"/> 
</p> 

## Ejemplo TimeGridView

### CPU
La pestaña CPU enumera el ***CPU time***, el ***wall-clock time***, las estadísticas de recuento de llamadas para cada función observada y para la ruta de llamada asociada a la función (expanda una función para ver su ruta de llamada.

***CPU time*** se refiere al número de operaciones que cada función necesita para completarse;  este número debe ser igual en los dispositivos Roku de gama baja y alta.  El ***wall-clock time*** se refiere al tiempo que tarda una función en completarse en el mundo real.  

>Este valor puede variar entre diferentes dispositivos Roku.Por ejemplo, una función puede requerir la misma cantidad de operaciones para completarse en diferentes dispositivos Roku, pero los dispositivos Roku de gama baja pueden tomar más tiempo en el mundo real para completar una operación que un dispositivo Roku de gama alta.

Las columnas ***CPU time*** y **wall-clock time** ademas estan separadas en secciones self, callees, and total:
- self. The CPU/wall-clock time the function consumes itself.
- callees. The amount of CPU/wall-clock time consumed by any functions called by the original function.
- total. The amount of CPU/wall-clock time consumed by the original function (self) and any callee functions.

<table >
  <tr>
    <th>Etiqueta</th>
    <th>Descripcion</th>
  </tr>
  <tr>
    <td>CPU self</td>
    <td>Time consumed by the CPU process.</td>
  </tr>
  <tr>
    <td>CPU callees</td>
    <td>CPU time of any other functions that are called.</td>
  </tr>
  <tr>
    <td>CPU total</td>
    <td>Total amount of CPU time consumed. CPU (Self + Callees)</td>
  </tr>
    <tr>
    <td>TIME self</td>
    <td>Wall clock time that a function takes to complete</td>
  </tr>
  <tr>
    <td>TIME callees</td>
    <td>Wall clock time of any other functions that are called.</td>
  </tr>
  <tr>
    <td>TIME total</td>
    <td>Total wall clock time. Time (Self + Callees)</td>
  </tr>
  <tr>
    <td>Calls</td>
    <td>Number of times that function was called during channel run.</td>
  </tr>
</table>

<p align="center"> 
<img src="/images/CPU.png"/> 
</p> 

### MEMORY GRAPH
La pestaña Gráfico de memoria visualiza el consumo de memoria para cada hilo en la aplicación del canal.  Mueva el puntero del mouse sobre una columna para ver la memoria asignada, libre y no liberada para el hilo.

<p align="center"> 
<img src="/images/Memory.png"/> 
</p> 

### MEMORY 
The Memory tab lists allocated, freed, and unfreed memory statistics for each function observed (self) and for the function's associated call path (total).See Profiling Values for more information on the memory statistics displayed in this tab.

La pestaña Memoria enumera las estadísticas de memoria asignada, liberada y no liberada para cada función observada (self) y para la ruta de llamada asociada a la función (total). Consulte Profiling Values para obtener más información sobre las estadísticas de memoria que se muestran en esta pestaña.

<p align="center"> 
<img src="/images/Memory2.png"/> 
</p> 

#### Perfiles de nivel de línea 
Puede recopilar datos de perfil para cada línea de código fuente de BrightScript para identificar mejor el uso elevado de CPU y memoria.  Para hacer esto, habilite la creación de perfiles ***(bsprof_enable = 1)***, la creación de perfiles a nivel de línea ***(bsprof_enable_lines = 1)*** y RSG versión 1.2 ***(rsg_version = 1.2)*** en el manifiesto del canal.  En la pestaña CPU o Memoria, haga clic en los puntos suspensivos a la derecha de la función para profundizar en sus líneas individuales de código.

<p align="center"> 
<img src="/images/Memory3.png"/> 
</p> 

### TOP OFFENDERS

La pestaña Top Offenders muestra las funciones o rutas de llamadas de función que utilizaron la mayor cantidad de CPU, memoria o tiempo.  Esta pestaña suele ser el mejor lugar para comenzar a diagnosticar posibles problemas de rendimiento.  Las 10 funciones principales con la menor cantidad de memoria disponible se enumeran de forma predeterminada.  Puede cambiar el informe a una lista de los 20, 100, 500 principales o ingresar una profundidad personalizada, y puede seleccionar qué métrica ver.  Por ejemplo, los 5 métodos principales con el tiempo de CPU total más alto se muestran en la siguiente imagen:

<p align="center"> 
<img src="/images/top.png"/>
</p>  

>Click Show call paths to open the CPU or Memory tab with more detailed profiling data for the selected function and metric.


<p align="center"> 
<img src="/images/top2.png"/>
</p>  


### DEVICE MONITORING
Monitoring tab contains a real-time chart of memory usage.

<p align="center"> 
<img src="/images/Device.png"/> 
</p> 

# Using this data
A continuación, se muestran algunos puntos clave sobre cómo utilizar estos datos para mejorar el rendimiento del canal:
<table >
  <tr>
    <th>Data Type</th>
    <th>Definition and Best Use</th>
  </tr>
  <tr>
    <td>High wall-clock time but low CPU time</td>
    <td>Este patrón muestra que una función está esperando constantemente, ya sea para una entrada o una respuesta de una fuente externa.  Estas funciones son más adecuadas para los nodos de tareas para que no bloqueen el hilo principal.</td>
  </tr>
  <tr>
    <td>Funciones complejas</td>
    <td>Intenta simplificar lo más posible.  Si una función maneja varias tareas, considere dividirla en varias funciones para aislar aún más la cantidad de CPU o tiempo de reloj de pared que consume cada tarea.</td>
  </tr>
  <tr>
    <td>Functions that consume a large amount of CPU or wall-clock time</td>
    <td>Mueva las funciones a los nodos de tareas, si están constantemente esperando.  Se puede determinar que una función está esperando si su wall-clock time es alto, pero su costo de CPU es bajo</td>
  </tr>
   
</table>
