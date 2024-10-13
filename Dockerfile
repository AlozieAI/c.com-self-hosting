# Use an official Node.js image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install only production dependencies
RUN yarn workspaces focus --production 2>&1 | tee /tmp/yarn-build.log


# Build the project for production
RUN yarn build

# Expose the port (default is 3000, but change it if you use a different port)
EXPOSE 3000

# Start the production server
CMD ["yarn", "start"]

