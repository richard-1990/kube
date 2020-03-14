FROM node:lts
EXPOSE 9000
COPY server.js .
CMD [ "node", "server.js" ]