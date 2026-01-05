FROM node:18-bullseye-slim

# 2. Instalăm doar strictul necesar de sistem
RUN apt-get update && apt-get install -y python3 make g++ gcc libvips-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 3. Copiem fișierele de bază
COPY package.json ./
# NU copiem package-lock.json pentru a evita conflictele de platformă (Windows vs Linux)

# 4. SETĂRI CRITICE pentru a opri eroarea 2:
# Forțăm npm să instaleze pachetele pentru Linux și să ignore scripturile care eșuează
RUN npm config set unsafe-perm true
RUN npm install --platform=linux --arch=x64 --libc=glibc

# 5. Copiem restul codului
COPY . .

# 6. Compilăm TypeScript (dacă ai tsc instalat ca devDependency)
RUN npm run build

EXPOSE 3000

# Pornim aplicația
CMD ["npm", "start"]
