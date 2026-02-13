# ⚔️ Three Musketeers (Social Network Engine)

A high-performance social networking engine built with **Ruby on Rails 7**. Designed with a focus on Clean Architecture, Service Objects, and TDD (Test-Driven Development).

---

## 🏗 System Architecture

We strictly follow the **Separation of Concerns** principle to keep the codebase maintainable:

- **Services (`app/services`)**: Dedicated objects for business logic (e.g., creating posts, processing media).
- **Interactors (`app/interactors`)**: Encapsulates actions that involve multiple steps or state toggling (e.g., `TogglePostLike`).
- **Query Objects (`app/queries`)**: Optimized SQL queries isolated from models to handle complex data fetching (e.g., Personalized Feeds).
- **Scopes**: Model-level filters for common database queries.

---

## 📊 Database Schema

### Core Entities:
- **Accounts**: User profiles, authentication (Devise), and identity.
- **Posts**: Content creation with body text and timestamps.
- **Reactions**: Polymorphic-ready system for likes and interactions.
- **Comments**: Hierarchical or flat interaction on posts.
- **Relationships**: Follower/Followed system for social graph.
- **MediaAssets**: Polymorphic storage for images and videos.

---

## 🧪 Testing Suite

Quality is ensured via **RSpec**. We maintain high coverage across all layers.

- **Unit Tests**: Validations, associations, and custom model logic.
- **Service Specs**: Testing business rules in isolation.
- **Database Integrity**: Testing uniqueness constraints and `dependent: :destroy` behavior.

**Run the test suite:**
bundle exec rspec
🚀 Installation & Setup
Prerequisites
Ruby 3.3.0

PostgreSQL 14+

Redis (for background processing)

Setup Steps
Clone & Install:


git clone [https://github.com/flyman13/three_musketeers.git](https://github.com/flyman13/three_musketeers.git)
cd three_musketeers
bundle install
Configuration:
Copy the example env file and fill in your details:


cp .env.example .env
Database Initialization:


bin/rails db:prepare
Start the Engine:


bin/rails s
🤝 Development Workflow
Pull latest changes: git pull origin main

Create feature branch: git checkout -b feature/your-feature

Verify code quality: Run bundle exec rspec before committing.

Submit PR: Open a Pull Request for code review.