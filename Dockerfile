# Base Image
FROM node:21-alpine

RUN npm install -g nodemon 
# creates new directory in image
WORKDIR /app

# caches package.json first for npm install
COPY package.json .

# installing dependencies
RUN npm install

# copy current directory where Dockerfile is located, to current WORKDIR
COPY . .

# exposes port 3000 for mapping with local device port 3000
EXPOSE 3000

# run command, strings are seperated
CMD ["npm", "run", "dev"]