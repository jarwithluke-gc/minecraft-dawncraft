FROM itzg/minecraft-server:java17

# Optional helper image if you want to bake DawnCraft server files into an image.
# This is NOT required if you use bind-mount ./data and copy server files there.
#
# Usage idea:
# 1) Put DawnCraft server archive contents into ./server-files/ (next to this Dockerfile)
# 2) Build: docker build -t dawncraft-server:local .
# 3) Change docker-compose.yml image to dawncraft-server:local

COPY server-files/ /data/
