# Étape de construction
FROM node:16-alpine AS builder

WORKDIR /usr/src/app

# Copie des fichiers package.json et package-lock.json
COPY package*.json ./
# Après la copie des fichiers
RUN chown -R node:node /usr/src/app
USER node

# Installation des dépendances
RUN npm install

# Copie du reste des fichiers du projet
COPY . .

# Construction de l'application
RUN npm run build

# Étape de production
FROM node:16-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "run", "start:prod"]

