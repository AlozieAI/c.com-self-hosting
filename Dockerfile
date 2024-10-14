# Step 1: Use a specific Node.js version (Debian-based to avoid Alpine issues)
FROM node:18-slim

# Step 2: Install necessary system dependencies for Prisma and native modules
RUN apt-get update && apt-get install -y \
    openssl \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Set the working directory inside the container
WORKDIR /app

# Step 4: Copy the necessary project files to the container
COPY . .

# Step 5: Set environment variables
ENV NODE_ENV=production

# Step 6: Clean Yarn cache and node_modules
RUN yarn cache clean && rm -rf node_modules

# Step 7: Install production dependencies for the current workspace
RUN yarn install --production 2>&1 | tee /tmp/yarn-install.log  > /dev/null 2>&1

# Step 8: Ensure ts-node is available for production
RUN yarn add ts-node --dev  > /dev/null 2>&1

# Step 9: Update Prisma packages to the latest version
RUN yarn add @prisma/client@latest prisma@latest

# Step 10: Generate Prisma client
RUN yarn prisma generate

# **Step 11:** Run database migrations before the build
RUN yarn prisma migrate deploy

# Step 12: Build the project with increased memory limit, limit output to last 100 lines
RUN node --max_old_space_size=8192 ./node_modules/.bin/yarn build 2>&1 | tee /tmp/yarn-build-full.log && tail -n 100 /tmp/yarn-build-full.log

# Step 13: Expose the port the app will run on (default is 3000)
EXPOSE 3000

# Step 14: Start the application using the appropriate production script
CMD ["yarn", "start"]




