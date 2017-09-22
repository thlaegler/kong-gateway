FROM kong

LABEL maintainer "ecommerce-platform@xmdevelopments.com"
LABEL package "org.laegler.image.kong.service"
LABEL namespace "services"
LABEL version "0.0.1-SNAPSHOT"

ENV LUA_VERSION 5.1
ENV KONG_PROXY_PORT 8000
ENV KONG_ADMIN_PORT 8001
ENV KONG_CUSTOM_PLUGINS xmd-header-enforcer
ENV KONG_PG_HOST 127.0.0.1
ENV KONG_PG_PORT 5432
ENV KONG_PG_USER kong
ENV KONG_PG_PASSWORD kong
ENV KONG_PG_DATABASE kong
ENV KONG_LOG_LEVEL notice

# install some utils. Not recommendedd for production.
RUN yum install -y wget

# add the plugin(s), configuration file and the init script
#RUN mkdir /usr/local/share/lua/${LUA_VERSION}/kong/plugins/xmd-header-enforcer
#ADD plugins/xmd-header-enforcer/. /usr/local/share/lua/${LUA_VERSION}/kong/plugins/xmd-header-enforcer/.

# add configuration file and the init script
ADD kong.conf /etc/kong/
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x docker-entrypoint.sh

# Fetch Google's cloud SQL proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
	&& chmod +x cloud_sql_proxy

CMD ["/usr/local/openresty/nginx/sbin/nginx", "-c", "/usr/local/kong/nginx.conf", "-p", "/usr/local/kong/"]

EXPOSE 8000 8443 8001 8444

ENTRYPOINT ["/docker-entrypoint.sh"]