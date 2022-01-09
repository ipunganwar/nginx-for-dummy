FROM nginx
COPY /sites/demo/ /sites/demo
RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# VOLUME /etc/nginx