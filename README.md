# docker-images

Imagens Docker customizadas do Leandro (`leandrocosta91/*` no [Docker Hub](https://hub.docker.com/u/leandrocosta91)). Cada pasta contém o Dockerfile (e contexto de build, quando houver) de uma imagem base reutilizável. Dockerfiles específicos de projeto ficam no repositório de cada projeto.

Planejamento e justificativas: spec 114 no repo `lbz-site-thiago-abrahim` (`.docs/specs/114_organizacao_imagens_docker_customizadas.md`).

## Imagens

| Pasta | Imagem | Origem do Dockerfile |
|---|---|---|
| `wordpress-5-9-0-apache/` | `leandrocosta91/wordpress-5-9-0-apache` | VPS `/root/docker/docker-wordpress-5.9` |
| `wordpress-6-2-0-apache/` | `leandrocosta91/wordpress-6-2-0-apache` | **Reconstruído** via `docker history` (2026-06-10) |
| `wordpress-6-3-0-apache/` | `leandrocosta91/wordpress-6-3-0-apache` | **Reconstruído** via `docker history` (2026-06-10) — ver README da pasta |
| `wordpress-6-5-0-apache/` | `leandrocosta91/wordpress-6-5-0-apache` | VPS `/root/docker/docker-wordpress-6.5` |
| `wordpress-6-9-0-apache/` | `leandrocosta91/wordpress-6-9-0-apache` | VPS `/root/docker/docker-wordpress-6.9` |
| `php-fpm-8-3-nginx/` | `leandrocosta91/php-fpm-8-3-nginx` | VPS `/root/docker/Dockerfile/php-fpm-8-3-nginx` (contexto completo) |
| `php-fpm-8-2-nginx-nodejs/` | `leandrocosta91/php-fpm-8-2-nginx-nodejs` | VPS `/root/docker/Dockerfile/php-fpm-8-2-nginx-nodejs` — ver README da pasta |

As imagens WordPress seguem todas o mesmo padrão: `FROM wordpress:X.Y.Z-apache` oficial + extensão `pdo_mysql`.

## Pendentes de recuperação

Imagens publicadas no Docker Hub cujo Dockerfile ainda não foi localizado (recuperar via `docker history` ou localizar na máquina local):

- `nodejs-25-nginx:1.0`
- `php-fpm-8-3-nginx-nodejs-composer:1.0`
- `lbz-php-fpm-8-2-nginx-nodejs:1.0`

## Fluxo build → push → uso

```bash
cd <pasta-da-imagem>
docker build -t leandrocosta91/<imagem>:<tag> .
docker push leandrocosta91/<imagem>:<tag>
# em qualquer ambiente (local ou VPS):
docker pull leandrocosta91/<imagem>:<tag>
```

## Convenção de tags

- Imagem nova sempre recebe **tag numerada** (`1.0`, `1.1`...); `:latest` pode existir como apelido da última estável.
- `docker-compose.yml` de projeto referencia **tag numerada** — produção nunca troca de build por acidente de pull.
- Nome no padrão `<stack>-<versão>-<extras>` (ex.: `wordpress-6-9-0-apache`, `php-fpm-8-3-nginx-nodejs-composer`).
