# Ambiente pronto para transcricao com WhisperX em GPU.
#
# Esta imagem e GENERICA de proposito: ela carrega o ambiente e NADA do produto
# que a usa. Nenhum codigo de aplicacao, nenhuma chave, nenhum dado. Quem usa a
# imagem envia o proprio servidor para dentro do container depois que ele sobe,
# por SCP, e o inicia por SSH. E por isso que ela pode ser publica.
#
# A base ja traz torch 2.8.0, CUDA 12.8 e cuDNN 9, que e exatamente o que o
# WhisperX 3.8.6 pede (torch ~=2.8.0, CUDA 12.8) e o que o ctranslate2 >= 4.5
# precisa (cuDNN 9). Instalar o torch pelo pip em cima de uma base limpa
# baixaria 2,5 GB a mais e abriria a porta para a versao errada de cuDNN, que e
# o erro classico do faster-whisper ("Unable to load libcudnn_ops").
FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime

# ffmpeg: o proprio WhisperX chama o ffmpeg para ler o audio (load_audio). Sem
#   ele a imagem sobe e falha no primeiro trabalho.
# openssh-server: e por ele que o servidor da aplicacao entra no container, por
#   SCP, depois que a maquina sobe. Sem sshd instalado, provedor de GPU nenhum
#   consegue abrir SSH nesta imagem.
# curl: usado para conferir a saude do processo de dentro do proprio container.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg openssh-server curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd /root/.ssh \
    && chmod 700 /root/.ssh

WORKDIR /app

# As dependencias de transcricao ficam instaladas na imagem, e nao no pod. Era
# isso que se pagava antes: com a imagem crua do provedor, cada maquina gastava
# tempo de GPU instalando centenas de MB antes de transcrever o primeiro
# segundo de audio.
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Os pesos dos modelos ficam em volume ou sao baixados no primeiro uso, e NAO
# entram na imagem: o large-v3 sozinho e cerca de 3 GB, e os de alinhamento e
# diarizacao somam mais. Uma imagem com eles dentro levaria isso em cada push e
# em cada pull, toda vez.
ENV HF_HOME=/modelos \
    PYTHONUNBUFFERED=1

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22 9000

CMD ["/usr/local/bin/entrypoint.sh"]
