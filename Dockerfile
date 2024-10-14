# Step 1: Use an official Node.js image as the base
FROM node:18-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the necessary project files to the container
COPY . .

# Step 4: Install production dependencies for workspaces and log the output
RUN yarn workspaces focus --production 2>&1 | tee /tmp/yarn-build.log

# Step 5: Ensure ts-node is available for production
RUN yarn add ts-node --dev

# Step 6: Build the project with increased memory limit
RUN NODE_OPTIONS=--max_old_space_size=8192 yarn build 2>&1 | tee /tmp/yarn-build-full.log && tail -n 100 /tmp/yarn-build-full.log

# Step 7: Expose the port the app will run on (default is 3000)
EXPOSE 3000

# Step 8: Start the application using the appropriate production script
CMD ["yarn", "start"]




