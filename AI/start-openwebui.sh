#!/bin/sh

# '-e WEBUI_URL="http://localhost:3000"' is needed only if you want to integrate OpenWebUI as Browser Search Engine, you can skip it otherwise. Reference 'https://docs.openwebui.com/tutorials/integrations/browser-search-engine/'.
echo "Pulling and running OpenWebUI container from web..."
docker container run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always -e WEBUI_URL="http://localhost:3000" ghcr.io/open-webui/open-webui:main

if [ $? -eq 125 ]; then
   echo "OpenWebUI container already exists, starting existing container..."
   docker container start open-webui

   if [ $? -eq 0 ]; then
      echo "OpenWebUI container started in daemon mode. Type 'docker container stop open-webui' to stop"
   fi
elif [ $? -eq 0 ]; then
   echo "OpenWebUI container started in daemon mode. Type 'docker container stop open-webui' to stop"
else
   echo "Failed to start OpenWebUI container, exit code $?"
   exit 1
fi
