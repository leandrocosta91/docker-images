# whisperx-3-8-6-cuda-12-8

Ambiente pronto para transcrever audio com [WhisperX](https://github.com/m-bain/whisperX)
em GPU, para ser alugado por hora em provedor de nuvem.

**Imagem:** `leandrocosta91/whisperx-3-8-6-cuda-12-8:1.0`

## O que ela tem

| Item | Versao | Por que esta aqui |
|---|---|---|
| Base | `pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime` | o WhisperX 3.8.6 exige torch `~=2.8.0` e CUDA 12.8, e o ctranslate2 >= 4.5 exige cuDNN 9 |
| WhisperX | 3.8.6 | ultima estavel no PyPI; a assinatura do `DiarizationPipeline` muda entre versoes, entao a versao fica presa |
| PyAV | 18.1.0, preso | o PyAV 19 removeu o argumento `metadata_errors`, que o `faster-whisper` usa ao abrir o audio |
| ffmpeg | do Debian | o proprio WhisperX chama o ffmpeg para ler o audio |
| openssh-server | do Debian | e por ele que a aplicacao entra no container para enviar o seu servidor |

## O que ela NAO tem, de proposito

- **Nenhum codigo de aplicacao.** A imagem e generica: quem a usa envia o proprio
  servidor por SCP depois que o container sobe, e o inicia por SSH.
- **Nenhuma chave, token ou segredo.** Tudo isso entra em tempo de execucao, por
  variavel de ambiente.
- **Nenhum peso de modelo.** O `large-v3` sozinho e cerca de 3 GB, e os modelos de
  alinhamento e de diarizacao somam mais. Eles sao baixados no primeiro uso, para
  `HF_HOME` (`/modelos`), que deve ser um volume quando se quer reaproveitar entre
  execucoes.

E por nao ter nada disso que esta imagem pode ser publica.

## Como usar

O container sobe apenas o `sshd`. A chave publica de quem vai entrar e lida da
variavel de ambiente `PUBLIC_KEY`, que e o nome que os provedores de GPU usam.

```bash
docker run -d \
  -e PUBLIC_KEY="$(cat ~/.ssh/minha_chave.pub)" \
  -p 2222:22 -p 9000:9000 \
  --gpus all \
  leandrocosta91/whisperx-3-8-6-cuda-12-8:1.0
```

Depois, de fora:

```bash
scp -P 2222 servidor.py root@<host>:/app/servidor.py
ssh -p 2222 root@<host> 'cd /app && nohup python servidor.py >/var/log/servidor.log 2>&1 &'
```

A porta 9000 fica exposta para o servidor que voce enviou; a imagem em si nao
escuta nada nela.

## Diarizacao

Os modelos de diarizacao do `pyannote` sao fechados por licenca: exigem conta no
HuggingFace, aceite das condicoes nos repositorios do pyannote e um token de
leitura, passado ao processo em tempo de execucao. A imagem nao carrega token
nenhum.

## Como reconstruir

```bash
docker build -t leandrocosta91/whisperx-3-8-6-cuda-12-8:1.0 .
docker push leandrocosta91/whisperx-3-8-6-cuda-12-8:1.0
```
