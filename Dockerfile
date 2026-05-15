# ==========================================
# ETAPA 1: CONSTRUCCIÓN (La cocina)
# ==========================================
FROM node:18-alpine AS builder
WORKDIR /app

# Copiamos dependencias e instalamos
COPY package*.json ./
RUN npm ci

# Copiamos el resto del código y compilamos
COPY . .
# En Vite, esto generará una carpeta llamada /dist con los archivos estáticos
RUN npm run build 

# ==========================================
# ETAPA 2: PRODUCCIÓN (El comedor)
# ==========================================
# Usamos una imagen oficial de Nginx ya configurada para NO ser root
FROM nginxinc/nginx-unprivileged:alpine AS runner

# El usuario seguro (UID 101) ya viene por defecto en esta imagen, 
# cumpliendo automáticamente con la rúbrica de IE1.

# Copiamos los archivos compilados de la carpeta /dist a la carpeta pública de Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

#proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

#comentario para prueba
#comentario para evaluacion


# Esta imagen de Nginx expone por defecto el puerto 8080 (los puertos menores a 1024 requieren root)
EXPOSE 8080

# Nginx arranca automáticamente, no necesitamos un comando CMD explícito