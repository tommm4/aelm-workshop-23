FROM golang:1.21

WORKDIR /app

COPY bin/workshop /app/bin/workshop

# This makes sure that the application will run correctly on Openshift
RUN chgrp -R 0 /app/bin/workshop && \
    chmod +x /app/bin/workshop && \
    chmod -R g=u /app/bin/workshop

# This a documentation line, it does not actually open up port 3000
EXPOSE 3000

# Command that is executed when running the container
CMD ["/app/bin/workshop"]
