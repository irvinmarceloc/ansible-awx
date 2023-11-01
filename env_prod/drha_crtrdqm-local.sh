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
/opt/mqm/bin/crtmqm -sx -rr p -rn $NOMBRE_GRUPO_DR -rp $PUERTO_DR -fs "$TAMANO_QM"M -p $PUERTO_QM $NOMBRE_QM
echo "[$(date +%F%_H:%M:%S.%N)] Manejador de colas $NOMBRE_QM creado" >> $LOG_FILE

# Asignación IP flotante 
/opt/mqm/bin/rdqmint -m $NOMBRE_QM -a -f $IP_FLOTANTE -l $INTERFAZ
echo "[$(date +%F%_H:%M:%S.%N)] IP flotante $IP_FLOTANTE ($INTERFAZ) asignado a $NOMBRE_QM" >> $LOG_FILE

# Crear el canal
echo "DEFINE CHANNEL($NOMBRE_CANAL) CHLTYPE(SVRCONN) TRPTYPE(TCP)" | runmqsc -e $NOMBRE_QM
echo "[$(date +%F%_H:%M:%S.%N)] Canal $NOMBRE_CANAL creado" >> $LOG_FILE

# Estos mandatos otorgan a grupo '$USUARIO_ADMINISTRADOR' acceso administrativo completo en IBM MQ para UNIX y Linux.
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -t qmgr -g "$USUARIO_ADMINISTRADOR" +connect +inq +alladm
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t q -g "$USUARIO_ADMINISTRADOR" +alladm +crt +browse
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t topic -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t channel -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t process -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t namelist -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t authinfo -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t clntconn -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t listener -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t service -g "$USUARIO_ADMINISTRADOR" +alladm +crt
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n "**" -t comminfo -g "$USUARIO_ADMINISTRADOR" +alladm +crt
echo "[$(date +%F%_H:%M:%S.%N)] Otorgado acceso administrativo a $USUARIO_ADMINISTRADOR" >> $LOG_FILE

# Los siguientes mandatos proporcionan acceso administrativo para MQ Explorer.
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n SYSTEM.MQEXPLORER.REPLY.MODEL -t q -g "$USUARIO_ADMINISTRADOR" +dsp +inq +get
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g "$USUARIO_ADMINISTRADOR" +dsp +inq +put
echo "[$(date +%F%_H:%M:%S.%N)] Otorgado acceso administrativo para MQ Explorer" >> $LOG_FILE

# Modificar registro de autenticación
echo "ALTER AUTHINFO(SYSTEM.DEFAULT.AUTHINFO.IDPWOS) AUTHTYPE(IDPWOS) CHCKCLNT(OPTIONAL)" | runmqsc -e $NOMBRE_QM
echo "[$(date +%F%_H:%M:%S.%N)] Registro de autenticación modificado" >> $LOG_FILE

# Actualizar políticas de seguridad
echo "REFRESH SECURITY(*)" | runmqsc -e $NOMBRE_QM
echo "[$(date +%F%_H:%M:%S.%N)] Políticas de seguridad actualizadas" >> $LOG_FILE

echo -e "\e[92m====[ RDQM $NOMBRE_QM CREADO ]=====\e[0m"
echo "[$(date +%F%_H:%M:%S.%N)] ==================== Finalizada creaación $NOMBRE_QM" >> $LOG_FILE
