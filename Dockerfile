FROM nginx:mainline-alpine

COPY nginx/conf.d etc/nginx/
COPY nginx/snippets etc/nginx/
