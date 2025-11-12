#!/bin/bash
#SÓLO PAA EL SERVER, NO TOCAR
# Ejecutar como root
if [ "$EUID" -ne 0 ]; then
  echo "[!] Ejecuta este script como root."
  exit 1
fi

# Configuración
USUARIO="mateo.dev3812"
CLAVE="coding#7906"
MAX_CONEXIONES=200

# --- Actualizar sistema e instalar OpenSSH ---
echo "[*] Instalando servidor OpenSSH..."
apt update && apt install -y openssh-server

# --- Crear usuario si no existe ---
if ! id "$USUARIO" &>/dev/null; then
    echo "[*] Creando usuario $USUARIO..."
    useradd -m -s /bin/bash "$USUARIO"
    echo "$USUARIO:$CLAVE" | chpasswd
    echo "[+] Usuario creado."
else
    echo "[*] El usuario ya existe. Estableciendo/verificando contraseña..."
    echo "$USUARIO:$CLAVE" | chpasswd
fi

# --- BackUp del archivo sshd_config ---
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# --- Aplicar configuraciones ---
echo "[*] Aplicando configuraciones SSH..."

{
    echo ""
    echo "# === Configuración personalizada === #"
    echo "MaxStartups 200:30:250"
    echo "MaxSessions $MAX_CONEXIONES"
    echo "PasswordAuthentication yes"
    echo "PermitRootLogin yes"         # Permite login root
    echo "AllowUsers *"                # Sin restricción de usuarios
} >> /etc/ssh/sshd_config

# --- Reiniciar servicio SSH ---
echo "[*] Reiniciando servicio SSH..."
systemctl restart ssh

# --- Verificar estado ---
if systemctl is-active --quiet ssh; then
    echo "[✔] Servidor SSH configurado y corriendo."
else
    echo "[✘] Hubo un problema al iniciar el servicio SSH."
    exit 1
fi

# Mostrar resumen final
echo ""
echo "======= RESUMEN ======="
echo "Usuario permitido: $USUARIO"
echo "Contraseña: $CLAVE"
echo "Conexiones máximas: $MAX_CONEXIONES"
echo "Puerto por defecto: 22"
echo "======================="
echo ""
