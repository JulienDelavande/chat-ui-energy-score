# read the doc: https://huggingface.co/docs/hub/spaces-sdks-docker
# you will also find guides on how best to write your Dockerfile

FROM node:19

WORKDIR /app

COPY . .

RUN npm i

RUN chown -R 1000:1000 /code

# RUN npm run build

CMD ["npm", "run", "preview", "--", "--port", "7860"]