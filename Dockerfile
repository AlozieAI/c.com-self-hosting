# Step 1: Use an official Node.js base image with the appropriate version
FROM node:18-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy all the project files into the working directory
COPY . .

# Step 4: Expose the port that Cal.com will run on (default is 3000, adjust if necessary)
EXPOSE 3000

# Step 5: Run only 'yarn dx' or the production version of it
CMD ["yarn", "dx"]
