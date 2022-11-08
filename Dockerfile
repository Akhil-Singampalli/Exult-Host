# Set base image
FROM node:latest AS builder

# Set working directory
WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH
# Copy package.json and install packages
COPY package.json .
RUN npm install --force

# Copy other project files and build
COPY . /app
RUN npm run build

# Set nginx image
FROM nginx:latest

# Nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

# Static build
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port
EXPOSE 80

# Set working directory
# WORKDIR /usr/share/nginx/html
ENTRYPOINT [ "nginx" ]

# Start Nginx server
CMD [ "-g", "daemon off;"]
