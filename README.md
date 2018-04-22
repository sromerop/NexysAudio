# NexysAudio
Proyecto de la asignatura Diseño de Sistemas Electrónicos Digitales perteneciente al cuarto curso del itinerario de Sistemas Electrónicos del Grado en Ingeniería de Tecnologías y Servicios de Telecomunicación en la ETSIT de la UPM

Consiste en un sistema que, utilizando las interfaces de entrada y salida de audio de la placa Nexys 4DDR adquiere, almacena, procesa y reproduce sonidos. Se utiliza el flujo de trabajo de Vivado.

El sistema recibe la información de audio del micrófono integrado en la placa y reproduce el audio a través de la salida mono de audio integrada en la placa.

El audio se muestrea y se reproduce a una frecuencia de 20 kHz.

En cuanto al procesado, se filtra la señal grabada paso alto o paso bajo según se elija mediante un filtro FIR de 5 etapas con unos coeficientes predefinidos.
