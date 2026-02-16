FROM docker.io/alpine/git:latest AS novnc
RUN git clone --depth 1 --branch v1.5.0 https://github.com/novnc/noVNC.git /novnc \
 && git clone --depth 1 --branch v0.12.0 https://github.com/novnc/websockify.git /novnc/utils/websockify \
 && rm -rf /novnc/.git /novnc/utils/websockify/.git

FROM ghcr.io/openclaw/openclaw:latest

USER root
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN node /app/node_modules/playwright-core/cli.js install-deps chromium \
 && su node -c "node /app/node_modules/playwright-core/cli.js install chromium" \
 && ln -s "$PLAYWRIGHT_BROWSERS_PATH"/chromium-*/chrome-linux64/chrome /usr/bin/chromium

RUN apt-get update \
 && apt-get install -y --no-install-recommends xvfb x11vnc \
 && rm -rf /var/lib/apt/lists/*

COPY --from=novnc /novnc /opt/noVNC

USER node

COPY --chown=node:node openclaw.json /home/node/.openclaw/openclaw.json
COPY --chown=node:node SETUP.md /home/node/.openclaw/workspace/SETUP.md
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
