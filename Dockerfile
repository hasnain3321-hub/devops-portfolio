# Use lightweight official Nginx image
FROM nginx:alpine

# Add project website files to Nginx
COPY app/ /usr/share/nginx/html/

# Expose web server port
EXPOSE 80

# Check whether the website is responding
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
