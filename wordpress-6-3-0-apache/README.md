# wordpress-6-3-0-apache

Imagem que roda o site `thiagoabrahim.com.br` em produção (container `wp_thiago_abrahim`).

**Dockerfile reconstruído** em 2026-06-10: o original se perdeu (na VPS só existem as pastas das versões 5.9, 6.4, 6.5 e 6.9). A reconstrução foi feita por `docker history` da imagem em produção:

1. `FROM wordpress:6.3.0-apache` + `pdo_mysql` — mesmo padrão das demais imagens WordPress deste repo;
2. uma camada final `COPY` sobrescrevendo `/usr/local/etc/php` — o conteúdo de `config/php/` foi extraído da própria imagem (`docker cp`) e inclui `php.ini` completo e `conf.d/` com `error-logging.ini` e `opcache-recommended.ini` customizados.

**Atenção:** um rebuild a partir deste Dockerfile gera imagem funcionalmente equivalente, mas com digest diferente da publicada no Hub. Antes de substituir a de produção, validar comparando o comportamento (ou manter a tag atual do Hub como canônica e usar este Dockerfile apenas como documentação/contingência).
