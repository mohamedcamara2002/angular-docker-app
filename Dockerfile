# ===== Stage 1: Build Angular =====
FROM node:20-alpine AS build
WORKDIR /app

# Installer dépendances
COPY package*.json ./
RUN npm ci --no-audit --no-fund

# Copier tout le code et builder Angular
COPY . .
RUN npm run build -- --configuration production

# ===== Stage 2: Nginx pour servir l'app =====
FROM nginx:1.27-alpine

# Copier la configuration Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers Angular dans Nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]