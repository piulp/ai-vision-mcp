# Folosim o versiune mai stabilă (nu Alpine, pentru a evita lipsa librăriilor C++)
FROM node:18-bullseye-slim

# 1. Instalăm utilitarele de build pentru sistemele Debian (mult mai stabile decât Alpine pentru 'sharp')
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Setăm variabile de mediu pentru a ignora erorile de permisiuni ale npm
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NPM_CONFIG_FUND=false

# 3. Copiem fișierele de configurare
COPY package*.json ./
COPY tsconfig.json ./

# 4. EXTREM DE IMPORTANT: Ștergem orice urmă de configurare locală și instalăm curat
# Folosim --unsafe-perm pentru a permite rularea scripturilor de build ale pachetelor
RUN npm install --unsafe-perm

# 5. Copiem restul codului
COPY . .

# 6. Build aplicație
RUN npm run build

# 7. Permisiuni de execuție pentru MCP
RUN chmod +x dist/index.js

EXPOSE 3000

CMD ["npm", "start"]
