#!/bin/bash

NOMBRE_QM={{nombre_gestor_colas}}
NOMBRE_CANAL="SYSTEM.ADMIN.SVRCONN"
USUARIO_ADMINISTRADOR={{usuario}}

set -e

echo -e "\e[96m====[ CREANDO RDQM $NOMBRE_QM ]=====\e[0m"
echo "Nombre del canal de conexión: $NOMBRE_CANAL"
echo "Usuario administrador:        $USUARIO_ADMINISTRADOR"

# Crear el canal
#echo "DEFINE CHANNEL($NOMBRE_CANAL) CHLTYPE(SVRCONN) TRPTYPE(TCP)" | /opt/mqm/bin/runmqsc $NOMBRE_QM

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
echo "REFRESH SECURITY(*)" | /opt/mqm/bin/runmqsc $NOMBRE_QM

echo -e "\e[92m====[ RDQM $NOMBRE_QM CREADO ]=====\e[0m"
