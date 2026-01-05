FROM node:18-bullseye-slim

# Instalăm dependințele de sistem necesare
RUN apt-get update && apt-get install -y \
    python3 make g++ gcc libc6-dev libvips-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiem DOAR package.json (NU și package-lock.json)
COPY package.json ./
COPY tsconfig.json ./

# SETĂRI CRITICE:
# 1. Forțăm instalarea ignorând lockfile-ul local care cauzează eroarea 2
# 2. Mărim limita de memorie pentru procesul de instalare
ENV NODE_OPTIONS="--max-old-space-size=2048"

RUN npm install --no-package-lock --unsafe-perm

# Acum copiem restul fișierelor
COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
