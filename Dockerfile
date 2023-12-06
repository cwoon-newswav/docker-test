# Base Image
FROM node:21-alpine

# creates new directory in image
WORKDIR /app

# copy current directory where Dockerfile is located, to current WORKDIR
COPY . .

# installing dependencies
RUN npm install

# exposes port 3000 for mapping with local device port 3000
EXPOSE 3000

# run command, strings are seperated
CMD ["npm", "run", "dev"]