FROM node:18-alpine

WORKDIR /app

# Copiem fișierele de configurare
COPY package*.json ./
COPY tsconfig.json ./

# Instalăm toate dependențele (inclusiv cele de build)
RUN npm install

# Copiem restul codului sursă
COPY . .

# IMPORTANT: Generăm folderul /dist (compilăm codul)
RUN npm run build

# Expunem portul (Northflank are nevoie de el)
EXPOSE 3000

# Pornim aplicația folosind scriptul configurat de tine
CMD ["npm", "start"]
