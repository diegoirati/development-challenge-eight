# Usa uma imagem base do servidor HTTP
FROM nginx:latest

# Copia o arquivo index.html para o diretório raiz do servidor HTTP
COPY index.html /usr/share/nginx/html

# Expõe a porta 80 para acesso externo
EXPOSE 80
