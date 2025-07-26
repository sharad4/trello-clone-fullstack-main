# ---- Base image ----
FROM node:20-alpine AS base
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1

# ---- Dependencies ----
FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci

# ---- Build stage ----
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NODE_ENV=production
RUN npm run build

# ---- Production image ----
FROM node:20-alpine AS runner
WORKDIR /app

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Optional: You can set to 'true' to force Next.js to treat it as production
ENV NEXT_TELEMETRY_DISABLED=1

# If you're using next export (Static HTML)
# COPY --from=builder /app/out ./out

# For App Router & server components
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

# If using Edge Middleware or images
COPY --from=builder /app/.next/server ./.next/server
COPY --from=builder /app/package.json ./

EXPOSE 3000
CMD ["node", "server.js"]
