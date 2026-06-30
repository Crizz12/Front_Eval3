FROM public.ecr.aws/docker/library/maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN printf "BACKEND_USERS_URL=\nBACKEND_PRODUCTS_URL=\n" > .env
RUN mvn clean compile exec:java

FROM public.ecr.aws/nginx/nginx:alpine
COPY --from=build /build/output/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
