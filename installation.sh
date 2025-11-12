#!/bin/bash
set -e

echo "[*] Actualizando lista de paquetes..."
sudo apt update

echo "[*] Instalando nmap, hydra y cliente SSH (openssh-client)..."
# Nota: para instalar servidor SSH usa "openssh-server" (solo si lo necesitas y en un entorno controlado)
sudo apt install -y --no-install-recommends nmap hydra openssh-client

echo "[*] Comprobando instalaciones..."
# comprobaciones por herramienta (con variantes según la herramienta)
if command -v nmap &> /dev/null; then
  echo "[+] nmap está instalado correctamente."
  nmap --version | head -n 1
else
  echo "[-] ERROR: nmap NO está instalado."
fi

if command -v hydra &> /dev/null; then
  echo "[+] hydra está instalado correctamente."
  hydra -h | head -n 1 || true
else
  echo "[-] ERROR: hydra NO está instalado."
fi

if command -v ssh &> /dev/null; then
  echo "[+] ssh (cliente) está instalado correctamente."
  ssh -V 2>&1 | head -n 1
else
  echo "[-] ERROR: ssh NO está instalado."
fi

echo "[*] Proceso completado."
