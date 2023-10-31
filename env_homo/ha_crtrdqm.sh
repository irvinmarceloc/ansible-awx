#!/bin/bash

# $1: Nombre QM
# $2: IP flotante
# $3: Puerto QM
# $4: Nombre interfaz de IP flotante
# $5: Tamaño QM = ${5:-1024M}
# $6: Nombre Canal de comunicación = ${6:-SYSTEM.ADMIN.SVRCONN}
# $7: Nombre Usuario Administrador = ${7:-mquser}

NOMBRE_QM={{nombre_gestor_colas}}
IP_FLOTANTE={{ip_flotante}}
PUERTO_QM={{puerto}}
INTERFAZ={{interfaz}}
TAMANO_QM={{tam_m}}M
NOMBRE_CANAL={{canal_de_conexion}}
USUARIO_ADMINISTRADOR={{usuario}}

set -e

echo -e "\e[96m====[ CREANDO RDQM $NOMBRE_QM ]=====\e[0m"
echo "IP Flotante:                  $IP_FLOTANTE"
echo "Puerto:                       $PUERTO_QM"
echo "Interfaz de red:              $INTERFAZ"
echo "Tamaño del QM:                $TAMANO_QM"
echo "Nombre del canal de conexión: $NOMBRE_CANAL"
echo "Usuario administrador:        $USUARIO_ADMINISTRADOR"

/opt/mqm/bin/crtmqm -p $PUERTO_QM -fs $TAMANO_QM -sx $NOMBRE_QM
/opt/mqm/bin/rdqmint -m $NOMBRE_QM -a -f $IP_FLOTANTE -l $INTERFAZ

# Crear el canal
echo "DEFINE CHANNEL($NOMBRE_CANAL) CHLTYPE(SVRCONN) TRPTYPE(TCP)" | runmqsc -e $NOMBRE_QM

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

# Los siguientes mandatos proporcionan acceso administrativo para MQ Explorer.
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n SYSTEM.MQEXPLORER.REPLY.MODEL -t q -g "$USUARIO_ADMINISTRADOR" +dsp +inq +get
/opt/mqm/bin/setmqaut -m $NOMBRE_QM -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g "$USUARIO_ADMINISTRADOR" +dsp +inq +put



# Actualizar políticas de seguridad
echo "REFRESH SECURITY(*)" | runmqsc $NOMBRE_QM

echo -e "\e[92m====[ RDQM $NOMBRE_QM CREADO ]=====\e[0m"
