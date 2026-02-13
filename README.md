# ⚔️ Three Musketeers (Social Network Engine)

A modern social network platform built with **Ruby on Rails 7**, focusing on clean architecture, scalability, and high test coverage.

## 🚀 Getting Started

### Prerequisites
- **Ruby:** 3.3.0
- **PostgreSQL:** 14+

### Installation
1. **Clone the repository:**
   git clone [https://github.com/flyman13/three_musketeers.git](https://github.com/flyman13/three_musketeers.git)
   cd three_musketeers
Install dependencies:


bundle install
Database setup:


bin/rails db:prepare
Run the server:


bin/rails s
🧪 Testing
We use RSpec to ensure code reliability. Writing tests is mandatory for every new feature.

Run all tests:


bundle exec rspec
What we test:

Model validations (including DB-level ActiveRecord::RecordNotUnique).

Associations (dependent: :destroy).

Logic of Query Objects and Scopes.

🏗 Architecture
We follow the Separation of Concerns principle:

Services: Business logic implementation (app/services).

Interactors: Complex actions with toggle or step-by-step logic (app/interactors).

Query Objects: Complex SQL queries isolated for performance and testability (app/queries).