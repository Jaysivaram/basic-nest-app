FROM node:22 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

#prod

FROM node:22-alpine AS production

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

COPY --chown=node:node --from=builder /app/dist ./dist

USER node

EXPOSE 3000

#HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node","dist/main.js"]
