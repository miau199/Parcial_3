set BASE_DIR  "$env(HOME)/parcial3_parte2/pdk/M31LLSC750GL150MS_00.01.000/M31LLSC750GL150MS_00.01.000"
set TECH_FILE "$BASE_DIR/M31LLSC750GL150MS.0.01/milkyway_techfiles/tech/GL150M_5M1T_9K.tf"
set TECH_LEF  "$BASE_DIR/M31LLSC750GL150MS.0.01/lef_techfiles/tech/GL150M_5M1T_9K.lef"
set CELL_LEF  "$BASE_DIR/M31LLSC750GL150MS.0.01/lef/M31LLSC750GL150MS.lef"
set DB_FILE   "$BASE_DIR/ccs_db/M31LLSC750GL150MS_25CTT1P8_ctyp_ccs.db"

create_workspace M31_workspace -technology $TECH_FILE -flow normal
read_db  $DB_FILE
read_lef $TECH_LEF
read_lef $CELL_LEF

check_workspace -allow_missing
commit_workspace -output M31LLSC750GL150MS.ndm
exit
