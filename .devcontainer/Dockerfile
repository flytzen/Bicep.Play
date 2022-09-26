FROM mcr.microsoft.com/dotnet/runtime:latest
#FROM debian:buster-slim

#RUN npm install --global npm
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN  bash /tmp/library-scripts/azcli-debian.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
RUN az bicep install
