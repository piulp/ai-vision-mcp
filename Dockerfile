# Folosim imaginea completă, care are deja utilitarele de build necesare
FROM node:18-bullseye

WORKDIR /app

# Setăm variabile pentru a forța instalarea binarelor pre-compilate pentru Linux
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1
ENV npm_config_arch=x64
ENV npm_config_platform=linux

# Copiem doar package.json
COPY package.json ./
COPY tsconfig.json ./

# Ștergem orice urmă de cache și instalăm curat
# Folosim --legacy-peer-deps în caz de conflicte între pachetele Google AI și MCP
RUN npm cache clean --force
RUN npm install --include=dev --legacy-peer-deps

# Copiem restul fișierelor
COPY . .

# Compilăm TypeScript
RUN npm run build

# Expunem portul 3000 pentru Health Check
EXPOSE 3000

CMD ["npm", "start"]
