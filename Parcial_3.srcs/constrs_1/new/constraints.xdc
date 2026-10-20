# Restricción de Reloj principal (100 MHz = 10.0 ns)
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]