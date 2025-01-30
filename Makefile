principal: transmisor_simulaciones mostrar_resultados
	@echo ""
	@echo "Todo listo :)"

transmisor_simulaciones:
	@# Esta función compila los archivos de verilog
	@echo "A. Compilación y simulación de la máquina del transmisor."
	@# Crea directorio
	mkdir 'transmisor_simulaciones'

	@echo "A-[0/2]	Directorio creado"

	@# Archivos base y script de yosys
	cp *.v ./transmisor_simulaciones
	
	@echo "A-[1/2]	Código fuente copiado al directorio de simulaciones"

	@# Ejecuta la simulación
	cd 'transmisor_simulaciones' && iverilog -g2005-sv -o transmisor_sim.out testbench.v
	cd 'transmisor_simulaciones' && vvp transmisor_sim.out >> Resultados_sim_transmisor.txt

	@echo "A-[2/2]	Simulación lista"

	@echo "";

mostrar_resultados:
	@echo "B-[2/2]	Con todo listo, se muestran los resultados de las simulaciones."
	cd 'transmisor_simulaciones' && gtkwave transmisor_output.vcd
	@echo "";
	

clean:
	@echo "Se borrarán todo lo creado para limpiar el directorio."
	rm -rdf transmisor_simulaciones
