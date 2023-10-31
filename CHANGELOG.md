# Registro de cambios
## Hasta la fecha 2023-10-25
### General
- Se reordenaron los archivos en carpetas cuyos nombres hacen referencia a los entornos de ejecución
  - `env_test/`: Testing
  - `env_homo/`: Homologación
  - `env_prod/`: Producción
### Homologación
- Se eliminó (comentó) la tarea de apertura del puerto de firewall del gestor de colas.
### Producción
- Se modificó `ha_crtrdqm.sh` para crear los scripts `drha_crtrdqm-local.sh` y `drha_crtrdqm-remoto.sh`.
  - `drha_crtrdqm-local.sh`:
    - Crea el QM primario/primario (y primario/secundario si se cuenta con SSH).
    - Otorga acceso administrativo al usuario del OS que será administrador; y al MQ Explorer.
    - Modifica el registro de autenticación (`CHCKCLNT(REQADM)` -> `CHCKCLNT(OPTIONAL)`).
  - `drha_crtrdqm-remote.sh`:
    - Crea el QM secundario/primario (y secundario/secundario si se cuenta son SSH).
- Los scripts de shell `drha_crtrdqm-*.sh` hacen log-output al archivo `~/drha_crtrdqm.log` en los hosts donde se encuentran los gestores primarios de cada sitio.