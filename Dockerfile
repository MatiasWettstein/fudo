FROM ruby:3.4

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 9292

# Command to run the application
CMD ["rackup", "--host", "0.0.0.0", "-s", "webrick"]
