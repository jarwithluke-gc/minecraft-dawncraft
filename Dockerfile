FROM itzg/minecraft-server:java17

# Optional helper image if you want to bake a modpack/server files into an image.
# This is NOT required if you use bind-mount ./data and AUTO_CURSEFORGE.
#
# Usage idea:
# 1) Put server archive contents into ./server-files/ (next to this Dockerfile)
# 2) Build: docker build -t modpack-server:local .
# 3) Change docker-compose.yml image to modpack-server:local

COPY server-files/ /data/
