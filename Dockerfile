# One image for running the API and its test suite locally.
FROM ruby:3.4.12

WORKDIR /app

COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install --jobs 4 --retry 3

COPY . .

RUN useradd --create-home --uid 1000 rails \
 && chown rails:rails /app \
 && chown -R rails:rails db log tmp storage
USER rails

EXPOSE 3000
HEALTHCHECK --interval=10s --timeout=3s --retries=5 CMD curl -fsS http://localhost:3000/up || exit 1
CMD ["sh", "-c", "bin/rails db:prepare && bin/rails server -b 0.0.0.0 -p 3000"]
