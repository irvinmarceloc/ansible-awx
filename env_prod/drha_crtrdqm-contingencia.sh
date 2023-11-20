#!/bin/bash

NOMBRE_QM={{ nombre_gestor_colas }}
IP_FLOTANTE={{ ip_flotante }}
PUERTO_QM={{ puerto }}
INTERFAZ={{ interfaz }}
TAMANO_QM={{ tam_m }}M
NOMBRE_GRUPO_DR={{ nombre_grupo_dr }}
PUERTO_DR={{ puerto_dr }}
NOMBRE_CANAL={{ canal_de_conexion }}
USUARIO_ADMINISTRADOR={{ usuario }}
LOG_FILE=/home/rdqmadmin/drha_crtrdqm.log

# Nótese la diferencia con el sitio principal
DR_LOCAL_IPS={{ dr_contingencia_ips }}
DR_REMOTO_IPS={{ dr_principal_ips }}
PUERTO_DR={{ puerto_dr }}

set -e

echo -e "\e[96m====[ CREANDO RDQM $NOMBRE_QM ]=====\e[0m"
echo "[$(date +%F%_H:%M:%S.%N)] ==================== Iniciada creación $NOMBRE_QM" >> $LOG_FILE
echo "IP Flotante:                  $IP_FLOTANTE"
echo "Puerto:                       $PUERTO_QM"
echo "Interfaz de red:              $INTERFAZ"
echo "Tamaño del QM:                $TAMANO_QM"
echo "Nombre del canal de conexión: $NOMBRE_CANAL"
echo "Usuario administrador:        $USUARIO_ADMINISTRADOR"

# Creación DR/HA RDQM e IP flotante
/opt/mqm/bin/crtmqm -sx -rr s -rl $DR_LOCAL_IPS -ri $DR_REMOTO_IPS -rp $PUERTO_DR -fs $TAMANO_QM $NOMBRE_QM
echo "[$(date +%F%_H:%M:%S.%N)] Manejador de colas $NOMBRE_QM creado" >> $LOG_FILE

echo -e "\e[92m====[ RDQM $NOMBRE_QM CREADO ]=====\e[0m"
echo "[$(date +%F%_H:%M:%S.%N)] ==================== Finalizada creación $NOMBRE_QM" >> $LOG_FILE
