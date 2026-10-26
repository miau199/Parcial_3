# Parcial 3: Diseño y Verificación de ALU+ (FPGA & ASIC Flow)
**Universidad del Istmo** | Arquitectura de Computadoras y Microcontroladores 1  
**Estudiante:** Diego Andrés Rueda Minera  
**Fecha:** 26 de octubre de 2026  

---


## 📂 Estructura del Repositorio

* `Docs/`: Informe técnico formal con la memoria de cálculo, evidencias visuales y capturas.
* `Parcial_3.srcs/`: Proyecto y fuentes de la Parte 1 implementada en Vivado.
* `Parte2_ASIC/`:
  * `rtl/`: Descripción en SystemVerilog de la ALU+, Prefix Adder y el wrapper registrado síncrono (`alu_top.sv`).
  * `scripts/`: Scripts en Tcl y SDC para síntesis (`run_dc.tcl`) e implementación física (`run_icc2.tcl`).
  * `outputs/`: Netlists sintetizados, exportación SDC y archivo final para fabricación **GDSII** (`alu_top.gds`).
  * `reports/`: Registros de timing (QoR, Setup/Hold), consumo de potencia (SAIF), área y reportes de DRC/LVS.

---

## 📊 Métricas Principales del ASIC (M31 150nm)

| Métrica | Síntesis Lógica (Design Compiler) | Implementación Física (IC Compiler II) |
| :--- | :---: | :---: |
| **Tecnología** | M31 150nm (7.5T Low-Leakage) | M31 150nm (5 Capas de Metal) |
| **Frecuencia de Operación** | 100 MHz ($T = 10.0\text{ ns}$) | 100 MHz ($T = 10.0\text{ ns}$) |
| **Área Total de Silicio** | $24\,114.59\ \mu\text{m}^2$ | $\approx 26\,200\ \mu\text{m}^2$ |
| **Celdas Físicas** | 1,225 (1,048 comb. / 177 seq.) | 1,225 + Buffers de CTS |
| **Worst Negative Slack (WNS)** | $+1.12\text{ ns}$ (Cumple) | Margen Positivo (Cumple) |
| **Total Negative Slack (TNS)** | $0.00\text{ ns}$ | $0.00\text{ ns}$ |
| **Potencia Dinámica (SAIF)** | $1.1156\text{ mW}$ | Calculada con R/C extraído |
| **Potencia de Fuga (Leakage)** | $828.03\text{ pW}$ | $828\text{ pW}$ |
| **Verificación Física** | — | Clean: 0 Opens, 0 Shorts, 100% LVS |

---

## 🛠️ Herramientas Utilizadas
* **Parte 1:** AMD Vivado Design Suite
* **Parte 2:** Synopsys VCS, Verdi, Design Compiler (`dc_shell`), Library Manager (`icc2_lm_shell`) e IC Compiler II (`icc2_shell`)