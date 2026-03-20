FROM ruby :3.3 - alpine AS builder


RUN apk add --no cache \
    build base \
    git \
    libxml2-dev \
    libyaml-dev \
    nodejs \
    npm \
    imagesick \
    imagemagick-dev 


WORKDIR / site
COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

COPY . .

RUN bundle exec jekyll build --destination ./_site

FROM nginx:1:27-alpine AS serve

COPY --from=builder /site/_site /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]