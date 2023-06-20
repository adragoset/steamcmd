############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:bullseye-slim as build_stage

LABEL maintainer="walentinlamonos@gmail.com"
ARG PUID=1000
ENV USER steam
ENV HOMEDIR "root"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6=10.2.1-6 \
		lib32gcc-s1=10.2.1-6 \
		ca-certificates=20210119 \
		nano=5.4-2+deb11u2 \
		curl=7.74.0-1.3+deb11u7 \
		locales=2.31-13+deb11u5
RUN useradd -u "${PUID}" -m "${USER}"
	
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	# Create unprivileged user
	&& mkdir -p "${STEAMCMDDIR}"  \
	&& curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C "${STEAMCMDDIR}" \
	&& "./${STEAMCMDDIR}/steamcmd.sh" +quit \
	&& mkdir -p "${HOMEDIR}/.steam/sdk32" \
	&& ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "${HOMEDIR}/.steam/sdk32/steamclient.so" \
	&& ln -s "${STEAMCMDDIR}/linux32/steamcmd" "${STEAMCMDDIR}/linux32/steam" \
	&& ln -s "${STEAMCMDDIR}/steamcmd.sh" "${STEAMCMDDIR}/steam.sh" \
	# Symlink steamclient.so; So misconfigured dedicated servers can find it
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"

FROM build_stage AS bullseye-root
WORKDIR ${STEAMCMDDIR}

FROM bullseye-root AS bullseye
ENV DATA_DIR="/DATA" \
USERNAME="test" \
PASSWORD="password" \
APPID="1110990"

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
