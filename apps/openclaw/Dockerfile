FROM ghcr.io/openclaw/openclaw:latest

USER root
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN node /app/node_modules/playwright-core/cli.js install-deps chromium \
 && su node -c "node /app/node_modules/playwright-core/cli.js install chromium" \
 && ln -s "$PLAYWRIGHT_BROWSERS_PATH"/chromium-*/chrome-linux64/chrome /usr/bin/chromium

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc git \
 && git clone --depth 1 --branch v1.5.0 https://github.com/novnc/noVNC.git /opt/noVNC \
 && git clone --depth 1 --branch v0.12.0 https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify \
 && rm -rf /opt/noVNC/.git /opt/noVNC/utils/websockify/.git \
 && apt-get purge -y git && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
USER node

COPY --chown=node:node openclaw.json /home/node/.openclaw/openclaw.json
COPY --chown=node:node SETUP.md /home/node/.openclaw/workspace/SETUP.md
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
