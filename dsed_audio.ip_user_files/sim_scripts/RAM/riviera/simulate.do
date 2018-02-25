onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+RAM -L xil_defaultlib -L secureip -O5 xil_defaultlib.RAM

do {wave.do}

view wave
view structure

do {RAM.udo}

run -all

endsim

quit -force
