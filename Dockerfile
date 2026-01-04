# 1. Specificăm imaginea de bază
FROM node:18-alpine

# 2. Setează directorul de lucru (trebuie să fie DUPĂ FROM)
WORKDIR /app

# 3. Instalăm utilitarele de build necesare pentru Alpine (pentru erori de tip exit code 2)
# Alpine folosește 'apk' în loc de 'apt-get'
RUN apk add --no-cache python3 make g++ 

# 4. Copiem fișierele de configurare
COPY package*.json ./
COPY tsconfig.json ./

# 5. Instalăm dependențele
RUN npm install

# 6. Copiem restul codului sursă
COPY . .

# 7. Generăm folderul /dist (compilăm TypeScript)
RUN npm run build

# 8. Expunem portul
EXPOSE 3000

# 9. Comanda de start
CMD ["npm", "start"]
