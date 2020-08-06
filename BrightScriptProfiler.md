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

