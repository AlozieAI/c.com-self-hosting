# Step 1: Use an official Node.js image as the base
FROM node:18-alpine

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the necessary project files to the container
COPY . .

# Step 4: Install dependencies with yarn
RUN yarn install --frozen-lockfile

# Step 5: Add ts-node as a dev dependency in case it is needed in production builds
RUN yarn add ts-node --dev

# Step 6: Install production dependencies and build the project
RUN yarn workspaces focus --production 2>&1 | tee /tmp/yarn-build.log

# Step 7: Build the project (production build)
RUN yarn build

# Step 8: Expose the port the app will run on (default is 3000)
EXPOSE 3000

# Step 9: Start the application using the appropriate production script
CMD ["yarn", "start"]


