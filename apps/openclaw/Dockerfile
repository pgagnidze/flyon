FROM ghcr.io/openclaw/openclaw:latest

USER root
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/ms-playwright
RUN node /app/node_modules/playwright-core/cli.js install-deps chromium \
 && su node -c "node /app/node_modules/playwright-core/cli.js install chromium" \
 && ln -s "$PLAYWRIGHT_BROWSERS_PATH"/chromium-*/chrome-linux64/chrome /usr/bin/chromium
USER node

COPY --chown=node:node openclaw.json /home/node/.openclaw/openclaw.json
COPY --chown=node:node SETUP.md /home/node/.openclaw/workspace/SETUP.md

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789", "--allow-unconfigured"]
