#!/usr/bin/env bash
# Inicio do container.
#
# A imagem nao tem aplicacao propria para rodar: ela existe para receber uma, de
# fora, por SCP. Entao o unico processo que ela sobe e o sshd, que e a porta de
# entrada. O container fica vivo enquanto o sshd estiver vivo.
set -euo pipefail

# Provedores de GPU (Runpod, por exemplo) entregam a chave publica do usuario na
# variavel PUBLIC_KEY. Sem ela nao ha como entrar, e isso e falha de operacao, e
# nao detalhe: o container sobe assim mesmo, mas DIZ no log o que esta faltando,
# para ninguem pagar maquina achando que vai conseguir enviar o servidor.
if [ -n "${PUBLIC_KEY:-}" ]; then
    echo "${PUBLIC_KEY}" >> /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    echo "[entrypoint] chave publica instalada em /root/.ssh/authorized_keys"
else
    echo "[entrypoint] ATENCAO: PUBLIC_KEY vazia, ninguem vai conseguir entrar por SSH neste container" >&2
fi

# Chaves de host, geradas no primeiro boot. Sem elas o sshd nao sobe.
ssh-keygen -A

# Login de root por chave, nunca por senha.
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

echo "[entrypoint] subindo o sshd na porta 22"
exec /usr/sbin/sshd -D -e
