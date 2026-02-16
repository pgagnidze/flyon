FROM ghcr.io/openclaw/openclaw:latest

USER root
RUN node /app/node_modules/playwright-core/cli.js install --with-deps chromium
USER node

COPY --chown=node:node openclaw.json /home/node/.openclaw/openclaw.json
COPY --chown=node:node SETUP.md /home/node/.openclaw/workspace/SETUP.md

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789", "--allow-unconfigured"]
