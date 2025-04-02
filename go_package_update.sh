#!/usr/bin/env bash
# Uso: ./atualiza_go_package.sh <diretorio_base>

BASE_DIR="${1:-.}"
GO_PKG_PREFIX="miguelsmuller"


find "$BASE_DIR" -type f -name '*.proto' | while read -r FILE; do
  # Faz o replace de:
  #   option go_package = "algo";
  # para
  #   option go_package = "miguelsmuller/algo;algo";
  #
  # O padrão do sed captura o texto entre as aspas
  # e o reutiliza para inserir "miguelsmuller/<captura>;<captura>".
  sed -i.bak -E "s|(option[[:space:]]+go_package[[:space:]]*=[[:space:]]*\")([^\";]+)(\";?)|\1${GO_PKG_PREFIX}/\2;\2\3|g" "$FILE"

  # Se quiser remover os arquivos de backup, descomente a linha abaixo
  rm -f "${FILE}.bak"
done

echo "Processo concluído."
