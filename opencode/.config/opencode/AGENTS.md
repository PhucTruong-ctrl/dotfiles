# GLOBAL-AGENTS.md - Universal AI Agent Skills & Protocols

> **Language-agnostic, framework-agnostic AI agent skills for any software project**
>
> This document provides reusable skills and protocols that can be applied to ANY codebase.
> These are distilled from: DDD, Clean Architecture, Hexagonal Architecture, CQRS, Event Sourcing,
> Claude-Code-Auditor, and industry best practices.

---

## Table of Contents

### Part I: Architecture & Design Skills
1. [clean-arch - Clean Architecture Protocol](#1-clean-arch---clean-architecture-protocol)
2. [ddd-master - Domain-Driven Design](#2-ddd-master---domain-driven-design)
3. [hexagonal-arch - Ports & Adapters](#3-hexagonal-arch---ports--adapters)
4. [cqrs-architect - Command Query Separation](#4-cqrs-architect---command-query-separation)
5. [event-sourcing - Event-Driven State](#5-event-sourcing---event-driven-state)
6. [microservices-arch - Distributed Systems](#6-microservices-arch---distributed-systems)

### Part II: Code Quality Skills
7. [code-auditor - Systematic Code Review](#7-code-auditor---systematic-code-review)
8. [refactor-master - Safe Refactoring](#8-refactor-master---safe-refactoring)
9. [anti-pattern-hunter - Code Smell Detection](#9-anti-pattern-hunter---code-smell-detection)
10. [solid-principles - SOLID Enforcement](#10-solid-principles---solid-enforcement)

### Part III: Testing & Quality Assurance
11. [tdd-master - Test-Driven Development](#11-tdd-master---test-driven-development)
12. [qa-engineer - Quality Assurance](#12-qa-engineer---quality-assurance)
13. [e2e-testing - End-to-End Testing](#13-e2e-testing---end-to-end-testing)

### Part IV: Security & Performance
14. [sec-ops - Security Operations](#14-sec-ops---security-operations)
15. [perf-engineer - Performance Engineering](#15-perf-engineer---performance-engineering)

### Part V: DevOps & Infrastructure
16. [devops-master - CI/CD & Deployment](#16-devops-master---cicd--deployment)
17. [git-commander - Git Workflow](#17-git-commander---git-workflow)
18. [docker-ninja - Containerization](#18-docker-ninja---containerization)

### Part VI: Documentation & Communication
19. [doc-writer - Technical Documentation](#19-doc-writer---technical-documentation)
20. [api-designer - API Design](#20-api-designer---api-design)

### Part VII: Agent System Reference
21. [Agent Types & Usage](#agent-types--usage)
22. [Skill Combination Patterns](#skill-combination-patterns)

---

# Part I: Architecture & Design Skills

---

## 1. clean-arch - Clean Architecture Protocol

**Trigger:** `/clean-arch`  
**Level:** Architect  
**Applies To:** Any language/framework

### The Dependency Rule

**Source code dependencies must point only inward. Nothing in an inner circle can know anything about something in an outer circle.**

```
┌─────────────────────────────────────────────────────────────┐
│                    FRAMEWORKS & DRIVERS                      │
│              (Web Framework, Database, UI)                   │
├─────────────────────────────────────────────────────────────┤
│                   INTERFACE ADAPTERS                         │
│           (Controllers, Presenters, Gateways)               │
├─────────────────────────────────────────────────────────────┤
│                   APPLICATION LAYER                          │
│              (Use Cases, Application Services)              │
├─────────────────────────────────────────────────────────────┤
│                    DOMAIN LAYER                             │
│     (Entities, Value Objects, Domain Services, Events)      │
└─────────────────────────────────────────────────────────────┘
              ↑ Dependencies point INWARD only ↑
```

### Layer Responsibilities

| Layer | Contains | Knows About |
|-------|----------|-------------|
| **Domain** | Entities, Value Objects, Domain Services, Domain Events | Nothing external |
| **Application** | Use Cases, DTOs, Port Interfaces | Domain only |
| **Interface Adapters** | Controllers, Presenters, Repository Implementations | Application, Domain |
| **Frameworks** | Framework code, External APIs, Database drivers | Everything |

### Universal Directory Structure

```
src/
├── domain/
│   ├── entities/           # Core business objects with identity
│   ├── value_objects/      # Immutable objects without identity
│   ├── services/           # Domain logic spanning multiple entities
│   ├── events/             # Domain events
│   └── ports/              # Interfaces for external services
│
├── application/
│   ├── use_cases/          # Application-specific business rules
│   ├── dto/                # Data Transfer Objects
│   └── services/           # Application services
│
├── infrastructure/
│   ├── persistence/        # Database implementations
│   ├── messaging/          # Event bus, queues
│   ├── external/           # Third-party API clients
│   └── config/             # Framework configuration
│
└── presentation/           # Entry points
    ├── web/                # REST/GraphQL controllers
    ├── cli/                # Command-line interface
    └── events/             # Event handlers
```

### Key Rules (Language-Agnostic)

1. **Domain Layer has ZERO framework imports**
   - No ORM decorators, no web framework imports
   - Only standard library and domain types

2. **Use Cases are the Application API**
   - Single entry point for each business operation
   - Orchestrate domain objects
   - Don't contain business rules (those are in domain)

3. **Dependency Injection everywhere**
   - All dependencies passed through constructor
   - Enables testing with mocks
   - Enables swapping implementations

4. **DTOs at boundaries**
   - Transform domain objects to DTOs at layer boundaries
   - Never expose domain objects directly to external layers

---

## 2. ddd-master - Domain-Driven Design

**Trigger:** `/ddd-master`  
**Level:** Architect  
**Reference:** Eric Evans, Vaughn Vernon

### Strategic DDD Patterns

#### Bounded Contexts
A Bounded Context is a boundary within which a particular model is defined and applicable.

```
┌─────────────────────────────────────────────────────────────┐
│                       E-Commerce System                      │
├──────────────────┬──────────────────┬──────────────────────┤
│   Auth Context   │  Order Context    │   Billing Context    │
├──────────────────┼──────────────────┼──────────────────────┤
│ User             │ Customer          │ Account              │
│ - credentials    │ - shipping_info   │ - balance            │
│ - permissions    │ - order_history   │ - payment_methods    │
│ - sessions       │ - preferences     │ - invoices           │
└──────────────────┴──────────────────┴──────────────────────┘
```

#### Ubiquitous Language
- Use the SAME terminology everywhere: code, docs, conversations
- If domain experts say "Order", code should say `Order`, not `Purchase` or `Transaction`

#### Context Mapping Patterns

| Pattern | Description | Use When |
|---------|-------------|----------|
| **Shared Kernel** | Two contexts share a subset of the model | Tightly coupled teams |
| **Customer-Supplier** | Upstream supplies, downstream consumes | Clear dependency |
| **Anti-Corruption Layer** | Translate between contexts | Legacy integration |
| **Published Language** | Shared language for integration | Public APIs |
| **Open Host Service** | Expose well-defined protocol | Multiple consumers |

### Tactical DDD Patterns

#### 1. Entities
- Have identity that persists across state changes
- Mutable within aggregate boundaries
- Identity defines equality

```
Entity:
  - Has unique ID
  - Mutable
  - Equality by ID
  - Contains business logic
  - Can raise domain events
```

#### 2. Value Objects
- Defined by attributes, not identity
- IMMUTABLE - create new instances for changes
- No side effects

```
Value Object:
  - No ID
  - Immutable
  - Equality by value
  - Self-validating
  - No side effects
```

#### 3. Aggregates
- Cluster of entities and value objects
- Single aggregate root
- Transactional consistency boundary
- External references only through root

```
Aggregate Rules:
  1. Root entity is the only entry point
  2. Objects inside are not directly accessible
  3. Aggregate is a transactional boundary
  4. Reference other aggregates by ID only
```

#### 4. Domain Events
- Represent something that happened
- Immutable facts
- Named in past tense

```
Domain Event:
  - Event ID
  - Aggregate ID
  - Event Type (past tense: "OrderPlaced")
  - Event Data
  - Timestamp
  - Version
```

#### 5. Repositories
- Abstract persistence
- Interface in domain, implementation in infrastructure
- One repository per aggregate root

#### 6. Domain Services
- Logic that doesn't belong to a single entity
- Stateless operations
- Named as verbs or verb phrases

### DDD Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Anemic Domain Model** | Entities are just data bags | Put behavior in entities |
| **God Aggregate** | One massive aggregate | Split into smaller aggregates |
| **Repository per Table** | One-to-one with DB tables | Repository per aggregate root |
| **Leaking Domain Logic** | Business rules in controllers | Keep logic in domain layer |
| **Big Ball of Mud** | No clear boundaries | Define bounded contexts |

---

## 3. hexagonal-arch - Ports & Adapters

**Trigger:** `/hexagonal-arch`  
**Level:** Architect  
**Alias:** Ports and Adapters

### Core Concept

The application is at the center. Everything else is an adapter.

```
                    ┌─────────────────────────────────┐
                    │         PRIMARY ADAPTERS         │
                    │   (Drive the application)        │
                    │   REST API, CLI, Message Queue   │
                    └─────────────┬───────────────────┘
                                  │ calls
                    ┌─────────────▼───────────────────┐
                    │           PORTS (In)             │
                    │    Use Case Interfaces           │
                    └─────────────┬───────────────────┘
                                  │
        ┌─────────────────────────▼─────────────────────────┐
        │                   APPLICATION                      │
        │              (Business Logic Core)                 │
        │           (NO FRAMEWORK DEPENDENCIES)              │
        └─────────────────────────┬─────────────────────────┘
                                  │
                    ┌─────────────▼───────────────────┐
                    │          PORTS (Out)             │
                    │   Repository Interfaces          │
                    └─────────────┬───────────────────┘
                                  │ implemented by
                    ┌─────────────▼───────────────────┐
                    │       SECONDARY ADAPTERS         │
                    │   (Driven by the application)    │
                    │  Database, External APIs, Email  │
                    └─────────────────────────────────┘
```

### Port Types

| Port Type | Direction | Examples |
|-----------|-----------|----------|
| **Driving (Primary)** | Inbound | REST Controller, CLI, Event Consumer |
| **Driven (Secondary)** | Outbound | Database, Email, External API |

### The Golden Rules

1. **Dependency points inward** - Application knows nothing about adapters
2. **Ports are interfaces** - Defined in application, implemented in adapters
3. **Adapters are replaceable** - Can swap implementations without changing core
4. **Application is testable in isolation** - Mock all ports for unit tests

### Adapter Implementation

**Primary Adapter (Driving):**
```
Primary Adapter:
  - Receives external requests
  - Converts to application format
  - Calls use case port
  - Converts response to external format
  - Returns to caller
```

**Secondary Adapter (Driven):**
```
Secondary Adapter:
  - Implements port interface
  - Contains framework-specific code
  - Handles external communication
  - Translates between formats
```

---

## 4. cqrs-architect - Command Query Separation

**Trigger:** `/cqrs-architect`  
**Level:** Advanced  
**Pattern:** CQRS

### Core Principle

**Commands change state. Queries read state. NEVER mix them.**

```
┌──────────────────────────────────────────────────────────────┐
│                         REQUEST                               │
└──────────────────┬────────────────────────────┬──────────────┘
                   │                            │
          ┌────────▼────────┐          ┌────────▼────────┐
          │    COMMAND      │          │     QUERY       │
          │  (Write Model)  │          │  (Read Model)   │
          └────────┬────────┘          └────────┬────────┘
                   │                            │
          ┌────────▼────────┐          ┌────────▼────────┐
          │   Write Store   │  ──sync→ │   Read Store    │
          │   (Primary DB)  │          │   (Optimized)   │
          └─────────────────┘          └─────────────────┘
```

### Command Structure

```
Command:
  - Intent to change state
  - Named as imperative: "CreateOrder", "TransferMoney"
  - Immutable data
  - Contains all needed information
  - Returns success/failure only

Command Handler:
  - Validates command
  - Loads aggregate
  - Executes domain logic
  - Persists changes
  - Publishes events
```

### Query Structure

```
Query:
  - Request for data
  - Named as question: "GetUserBalance", "FindOrdersByDate"
  - Immutable parameters
  - Returns data directly

Query Handler:
  - Optimized for reading
  - May use different data store
  - No side effects
  - Can use caching
```

### When to Use CQRS

| Use CQRS | Don't Use CQRS |
|----------|----------------|
| Complex read patterns differ from writes | Simple CRUD operations |
| High read:write ratio | Similar read/write patterns |
| Need to scale reads independently | Small application |
| Multiple read models needed | Single consistent view |
| Eventual consistency acceptable | Strong consistency required |

---

## 5. event-sourcing - Event-Driven State

**Trigger:** `/event-sourcing`  
**Level:** Advanced  
**Pattern:** ES

### Core Concept

**Don't store state. Store events. Replay to reconstruct state.**

```
Traditional:  [Current State] ← UPDATE ← [New State]
                    ↓
              We only know NOW

Event Sourced:  [Event1] → [Event2] → [Event3] → ... → [EventN]
                    ↓
              We know EVERYTHING that happened
```

### Event Store Schema

```
Event Store:
  - event_id: UUID
  - aggregate_id: UUID
  - aggregate_type: string
  - event_type: string
  - event_data: JSON
  - version: integer
  - timestamp: datetime
  - metadata: JSON (correlation_id, user_id, etc.)
```

### Event-Sourced Aggregate

```
Aggregate Lifecycle:
  1. Load events from store
  2. Replay events to rebuild state
  3. Execute command (validate)
  4. Raise new events
  5. Apply events to self
  6. Append events to store
  7. Publish events to bus
```

### Projections

Projections are read models built by replaying events.

```
Projection:
  - Subscribes to event stream
  - Builds optimized read model
  - Can be rebuilt from scratch
  - Multiple projections per aggregate
  - Eventually consistent
```

### When to Use Event Sourcing

| Use ES | Don't Use ES |
|--------|--------------|
| Need complete audit trail | Simple CRUD with no history |
| Complex domain with many state transitions | Static data |
| Need to rebuild state at any point | Real-time state is sufficient |
| Regulatory/compliance requirements | Team unfamiliar with pattern |
| Time-travel debugging needed | Simple application |

---

## 6. microservices-arch - Distributed Systems

**Trigger:** `/microservices-arch`  
**Level:** Expert  
**Pattern:** Distributed Architecture

### Service Design Principles

| Principle | Description |
|-----------|-------------|
| **Single Responsibility** | One service = one bounded context |
| **Autonomy** | Service owns its data and logic |
| **Resilience** | Handle failures gracefully |
| **Decentralization** | No central governance |
| **Observability** | Logging, metrics, tracing |

### Communication Patterns

| Pattern | Use Case | Trade-offs |
|---------|----------|------------|
| **Sync (REST/gRPC)** | Request-response needed | Tight coupling, latency |
| **Async (Events)** | Fire-and-forget | Eventual consistency |
| **Saga** | Distributed transactions | Complex, compensating actions |
| **CQRS** | Separate read/write | Dual data stores |

### Data Management

```
Service Data Rules:
  1. Each service owns its data
  2. No shared databases
  3. Communicate via APIs/events
  4. Data duplication is acceptable
  5. Eventual consistency between services
```

### Resilience Patterns

| Pattern | Purpose |
|---------|---------|
| **Circuit Breaker** | Fail fast when service is down |
| **Retry with Backoff** | Handle transient failures |
| **Bulkhead** | Isolate failures |
| **Timeout** | Prevent indefinite waiting |
| **Fallback** | Graceful degradation |

---

# Part II: Code Quality Skills

---

## 7. code-auditor - Systematic Code Review

**Trigger:** `/code-auditor`  
**Level:** Senior  
**Reference:** Claude-Code-Auditor patterns

### 4 Core Review Principles

1. **Show Diffs** - Always show before/after code changes
2. **Risk Classification** - Categorize issues by severity
3. **Syntax Validation** - Verify code compiles/runs
4. **Atomic Changes** - One concept per change

### Risk Classification

| Level | Impact | Examples |
|-------|--------|----------|
| **CRITICAL** | Data loss, security breach | SQL injection, exposed secrets |
| **HIGH** | Feature broken, performance degradation | Unhandled exceptions, N+1 queries |
| **MEDIUM** | Code smell, maintainability issues | Missing types, unclear naming |
| **LOW** | Style, minor improvements | Formatting, documentation gaps |

### Review Checklist

#### Security
- [ ] No hardcoded secrets
- [ ] All inputs validated and sanitized
- [ ] SQL uses parameterized queries
- [ ] No eval() with user input
- [ ] Proper authentication/authorization

#### Performance
- [ ] No N+1 query patterns
- [ ] Appropriate caching
- [ ] No blocking in async context
- [ ] Efficient algorithms (O(n) vs O(n²))
- [ ] Pagination for large datasets

#### Reliability
- [ ] All errors handled appropriately
- [ ] No silent failures
- [ ] Proper logging
- [ ] Transactions for multi-step operations
- [ ] Timeouts for external calls

#### Maintainability
- [ ] Full type annotations
- [ ] Clear naming
- [ ] Single responsibility
- [ ] No god classes
- [ ] Reasonable function length

### Review Output Format

```markdown
## Code Review: [File/Feature]

### Summary
[1-2 sentence overview]

### Critical Issues (Must Fix)
1. **[Issue]** - Line XX
   - Problem: [Description]
   - Risk: [Impact]
   - Fix: [Solution]

### High Priority
[...]

### Medium Priority
[...]

### Suggestions
[...]

### Positive Observations
[What's done well]
```

---

## 8. refactor-master - Safe Refactoring

**Trigger:** `/refactor-master`  
**Level:** Senior

### Core Rules

1. **Never refactor without tests**
2. **One refactor at a time**
3. **Keep tests green throughout**
4. **Verify behavior unchanged**

### Refactoring Catalog

| Refactoring | When | Risk |
|-------------|------|------|
| Rename | Unclear names | Low |
| Extract Function | Long function, duplication | Low |
| Extract Class | Class doing too much | Medium |
| Move Function | Wrong location | Medium |
| Inline | Over-abstraction | Low |
| Replace Conditional with Polymorphism | Complex if/switch | High |
| Introduce Parameter Object | Many parameters | Medium |

### Pre-Refactoring Checklist

- [ ] Tests exist and pass
- [ ] You understand current behavior
- [ ] Clear goal defined
- [ ] Can verify no behavior change
- [ ] Team notified (if large refactor)

### Common Refactoring Patterns

**Extract Function:**
```
Before: Long function with multiple responsibilities
After: Main function + extracted helper functions
Rule: Each function does one thing
```

**Introduce Parameter Object:**
```
Before: function(a, b, c, d, e, f)
After: function(RequestObject)
Rule: More than 3-4 params = consider grouping
```

**Replace Conditional with Polymorphism:**
```
Before: if type == "A" ... else if type == "B" ...
After: Interface + implementations for each type
Rule: Complex type-checking = use polymorphism
```

---

## 9. anti-pattern-hunter - Code Smell Detection

**Trigger:** `/anti-pattern-hunter`  
**Level:** Senior

### Common Anti-Patterns

#### 1. God Class
**Symptom:** One class does everything
**Detection:** 500+ lines, 10+ responsibilities
**Fix:** Split by responsibility

#### 2. Anemic Domain Model
**Symptom:** Entities are just data bags
**Detection:** All logic in services, entities have only getters/setters
**Fix:** Move behavior into entities

#### 3. Feature Envy
**Symptom:** Method uses more of another class than its own
**Detection:** Method calls another object repeatedly
**Fix:** Move method to the envied class

#### 4. Shotgun Surgery
**Symptom:** One change requires many file edits
**Detection:** Feature scatter across codebase
**Fix:** Consolidate related code

#### 5. Primitive Obsession
**Symptom:** Using primitives instead of small objects
**Detection:** Strings for IDs, floats for money
**Fix:** Create Value Objects

#### 6. Long Parameter List
**Symptom:** Functions with many parameters
**Detection:** 4+ parameters
**Fix:** Parameter Object or Builder

#### 7. Duplicate Code
**Symptom:** Same logic in multiple places
**Detection:** Copy-paste patterns
**Fix:** Extract to shared function/class

### Detection Checklist

| Smell | Question |
|-------|----------|
| God Class | >5-7 responsibilities? |
| Long Method | >20-30 lines? |
| Long Parameter List | >3-4 parameters? |
| Duplicate Code | Seen this before? |
| Dead Code | Ever executed? |
| Magic Numbers | Unexplained literals? |
| Deep Nesting | >3 indent levels? |

---

## 10. solid-principles - SOLID Enforcement

**Trigger:** `/solid-principles`  
**Level:** Senior

### The SOLID Principles

#### S - Single Responsibility
**Rule:** A class should have only one reason to change.

```
BAD: UserManager (creates, validates, saves, emails)
GOOD: UserFactory, UserValidator, UserRepository, EmailService
```

#### O - Open/Closed
**Rule:** Open for extension, closed for modification.

```
BAD: Adding features requires modifying existing code
GOOD: Adding features by adding new classes/implementations
```

#### L - Liskov Substitution
**Rule:** Subtypes must be substitutable for their base types.

```
BAD: Square extends Rectangle (changes setWidth behavior)
GOOD: Shape interface with getArea() that both implement
```

#### I - Interface Segregation
**Rule:** Many specific interfaces > one general interface.

```
BAD: IWorker with work(), eat(), sleep() (robots can't eat)
GOOD: IWorkable with work(), IFeedable with eat()
```

#### D - Dependency Inversion
**Rule:** Depend on abstractions, not concretions.

```
BAD: OrderService creates new EmailClient()
GOOD: OrderService receives INotificationService in constructor
```

### Enforcement Checklist

- [ ] Each class has single responsibility
- [ ] New features don't modify existing code
- [ ] Subclasses don't break parent behavior
- [ ] Interfaces are focused and specific
- [ ] Dependencies are injected, not created

---

# Part III: Testing & Quality Assurance

---

## 11. tdd-master - Test-Driven Development

**Trigger:** `/tdd-master`  
**Level:** Senior

### The TDD Cycle

```
RED → GREEN → REFACTOR → REPEAT

1. RED: Write a failing test
2. GREEN: Write minimal code to pass
3. REFACTOR: Improve code, keep tests green
4. REPEAT: Next test case
```

### TDD Rules

1. **Write test first** - Before any production code
2. **One test at a time** - Don't write ahead
3. **Minimal code to pass** - No more than needed
4. **Refactor relentlessly** - Clean up after green
5. **Tests are documentation** - They explain behavior

### Test Structure (AAA Pattern)

```
Arrange: Set up test data and mocks
Act: Execute the code under test
Assert: Verify the result
```

### Test Naming Convention

```
test_[unit]_[scenario]_[expected_result]

Examples:
test_transfer_insufficient_funds_raises_error
test_user_valid_email_returns_true
test_order_empty_cart_throws_exception
```

### What to Test

| Test | Don't Test |
|------|------------|
| Business logic | Framework code |
| Edge cases | Third-party libraries |
| Error handling | Trivial getters/setters |
| Integration points | Configuration |
| Critical paths | UI styling |

---

## 12. qa-engineer - Quality Assurance

**Trigger:** `/qa-engineer`  
**Level:** Senior

### Test Pyramid

```
                    ┌──────┐
                    │ E2E  │  Few, slow, expensive
                   ┌┴──────┴┐
                   │ Integ  │  Some, medium
                  ┌┴────────┴┐
                  │   Unit   │  Many, fast, cheap
                  └──────────┘
```

### Test Types

| Type | Scope | Speed | Isolation |
|------|-------|-------|-----------|
| Unit | Single function/class | Fast | Complete |
| Integration | Multiple components | Medium | Partial |
| E2E | Full system | Slow | None |
| Contract | API boundaries | Fast | Complete |
| Performance | Load/stress | Varies | Varies |

### Mocking Guidelines

```
Mock When:
  - External services (APIs, databases)
  - Non-deterministic (time, random)
  - Slow operations
  - Hard to reproduce scenarios

Don't Mock When:
  - Simple value objects
  - Pure functions
  - Things you own (prefer integration)
```

### Coverage Guidelines

| Area | Target |
|------|--------|
| Core Domain Logic | 90%+ |
| Application Services | 80%+ |
| Controllers/Adapters | 60%+ |
| UI Components | 40%+ |
| Overall | 70%+ |

---

## 13. e2e-testing - End-to-End Testing

**Trigger:** `/e2e-testing`  
**Level:** Senior

### E2E Test Principles

1. **Test user journeys** - Not individual features
2. **Use real infrastructure** - Real DB, real services
3. **Keep tests independent** - No shared state
4. **Make tests deterministic** - Same result every time
5. **Prioritize critical paths** - Login, checkout, etc.

### E2E Test Structure

```
Test Scenario: [User Journey Name]
  Given: [Initial state/conditions]
  When: [User actions]
  Then: [Expected outcomes]
  Cleanup: [Restore state]
```

### Best Practices

| Do | Don't |
|----|----|
| Test critical user flows | Test every possible path |
| Use stable selectors | Rely on CSS/XPath |
| Wait for elements | Use fixed delays |
| Clean up test data | Leave data behind |
| Run in CI pipeline | Only run manually |

---

# Part IV: Security & Performance

---

## 14. sec-ops - Security Operations

**Trigger:** `/sec-ops`  
**Standard:** OWASP Top 10

### OWASP Top 10 Prevention

| Vulnerability | Prevention |
|---------------|------------|
| Injection | Parameterized queries, input validation |
| Broken Auth | MFA, secure session management |
| Sensitive Data Exposure | Encryption, proper key management |
| XXE | Disable external entities |
| Broken Access Control | RBAC, deny by default |
| Security Misconfiguration | Hardening, remove defaults |
| XSS | Output encoding, CSP headers |
| Insecure Deserialization | Integrity checks, type constraints |
| Vulnerable Components | Regular updates, SCA tools |
| Insufficient Logging | Centralized logging, alerting |

### Input Validation Rules

```
Validation Checklist:
  1. Validate on server (not just client)
  2. Whitelist over blacklist
  3. Validate type, length, format, range
  4. Encode output for context (HTML, SQL, URL)
  5. Never trust user input (including headers)
```

### Secret Management

```
Secret Rules:
  1. Never hardcode secrets
  2. Use environment variables or secret managers
  3. Rotate secrets regularly
  4. Audit secret access
  5. Different secrets per environment
```

### Security Checklist

- [ ] All inputs validated
- [ ] All outputs encoded
- [ ] Authentication secure
- [ ] Authorization enforced
- [ ] Secrets properly managed
- [ ] Dependencies up-to-date
- [ ] Logging comprehensive
- [ ] Error messages generic

---

## 15. perf-engineer - Performance Engineering

**Trigger:** `/perf-engineer`  
**Level:** Expert

### Big O Awareness

| Pattern | Complexity | Recommendation |
|---------|------------|----------------|
| Nested loops | O(n²) | Avoid, use hash maps |
| List membership | O(n) | Use Set O(1) |
| Dict/Hash lookup | O(1) | Preferred |
| Sorting | O(n log n) | Use built-in |
| Binary search | O(log n) | For sorted data |

### Database Performance

```
Optimization Checklist:
  1. Index frequently queried columns
  2. Avoid SELECT *
  3. Use pagination (cursor-based preferred)
  4. Batch operations
  5. Use EXPLAIN ANALYZE
  6. Consider read replicas
  7. Cache frequently accessed data
```

### Caching Strategy

| Cache Type | Use Case | TTL |
|------------|----------|-----|
| Application | Computed values | Minutes |
| Distributed | Shared across instances | Hours |
| CDN | Static assets | Days |
| Database | Query results | Seconds |

### Performance Profiling

```
Profiling Steps:
  1. Identify bottleneck (profiler, APM)
  2. Measure baseline
  3. Form hypothesis
  4. Make targeted change
  5. Measure improvement
  6. Repeat until goal met
```

---

# Part V: DevOps & Infrastructure

---

## 16. devops-master - CI/CD & Deployment

**Trigger:** `/devops-master`  
**Level:** Senior

### CI/CD Pipeline Stages

```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│  Build   │→ │   Lint   │→ │   Test   │→ │  Deploy  │→ │ Monitor  │
└──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘
```

### Pipeline Requirements

| Stage | Required | Optional |
|-------|----------|----------|
| Build | Compile/bundle | Artifact caching |
| Lint | Code style | Security scanning |
| Test | Unit tests | Integration, E2E |
| Deploy | Staging | Canary, Blue/Green |
| Monitor | Health checks | APM, logging |

### Deployment Strategies

| Strategy | Risk | Rollback |
|----------|------|----------|
| Blue/Green | Low | Instant |
| Canary | Low | Fast |
| Rolling | Medium | Medium |
| Recreate | High | Slow |

### Environment Management

```
Environment Rules:
  1. Parity between environments
  2. Config via environment variables
  3. Secrets in secret manager
  4. Immutable deployments
  5. Infrastructure as Code
```

---

## 17. git-commander - Git Workflow

**Trigger:** `/git-commander`  
**Tool:** Git

### Branching Strategy

| Branch | Purpose | Protected |
|--------|---------|-----------|
| main | Production code | Yes |
| develop | Integration | Yes |
| feat/* | New features | No |
| fix/* | Bug fixes | No |
| hotfix/* | Emergency fixes | No |
| release/* | Release prep | No |

### Commit Convention

```
<type>(<scope>): <subject>

[body]

[footer]

Types: feat, fix, docs, style, refactor, test, chore, perf, ci
```

### Commit Rules

1. **Atomic commits** - One logical change per commit
2. **Present tense** - "Add feature" not "Added feature"
3. **Imperative mood** - "Fix bug" not "Fixes bug"
4. **50/72 rule** - Subject 50 chars, body wrap at 72
5. **Reference issues** - Link to tickets/PRs

### Merge vs Rebase

| Use Merge | Use Rebase |
|-----------|------------|
| Public branches | Private branches |
| Preserve history | Linear history |
| Team collaboration | Solo work |

---

## 18. docker-ninja - Containerization

**Trigger:** `/docker-ninja`  
**Tool:** Docker

### Dockerfile Best Practices

```dockerfile
# 1. Use specific base image version
FROM node:18-alpine

# 2. Create non-root user
RUN addgroup -S app && adduser -S app -G app

# 3. Set working directory
WORKDIR /app

# 4. Copy dependency files first (caching)
COPY package*.json ./

# 5. Install dependencies
RUN npm ci --only=production

# 6. Copy source code
COPY --chown=app:app . .

# 7. Switch to non-root user
USER app

# 8. Expose port
EXPOSE 3000

# 9. Health check
HEALTHCHECK CMD curl -f http://localhost:3000/health || exit 1

# 10. Set entrypoint
CMD ["node", "server.js"]
```

### Multi-Stage Builds

```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/server.js"]
```

### Container Security

- [ ] Use minimal base images (alpine)
- [ ] Run as non-root user
- [ ] Don't store secrets in images
- [ ] Scan images for vulnerabilities
- [ ] Use multi-stage builds
- [ ] Set resource limits

---

# Part VI: Documentation & Communication

---

## 19. doc-writer - Technical Documentation

**Trigger:** `/doc-writer`  
**Level:** Senior

### Documentation Types

| Type | Audience | Content |
|------|----------|---------|
| README | Developers | Quick start, installation |
| API Docs | Integrators | Endpoints, examples |
| Architecture | Architects | Design decisions |
| User Guide | End users | How to use |
| Runbook | Ops | Troubleshooting |

### README Template

```markdown
# Project Name

Brief description (1-2 sentences)

## Features
- Feature 1
- Feature 2

## Quick Start
Installation and first run steps

## Documentation
Links to detailed docs

## Contributing
How to contribute

## License
License type
```

### API Documentation

```markdown
## Endpoint Name

### Request
- Method: POST
- URL: /api/resource
- Headers: Content-Type: application/json

### Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | yes | Resource ID |

### Response
- 200: Success
- 400: Bad Request
- 401: Unauthorized

### Example
[Request/Response examples]
```

---

## 20. api-designer - API Design

**Trigger:** `/api-designer`  
**Standard:** REST, OpenAPI

### REST API Design Rules

| Principle | Rule |
|-----------|------|
| Resources | Use nouns, not verbs |
| HTTP Methods | GET=read, POST=create, PUT=replace, PATCH=update, DELETE=remove |
| Status Codes | Use appropriate codes |
| Versioning | /v1/ in URL or header |
| Pagination | Cursor or offset-based |
| Filtering | Query parameters |

### URL Design

```
Good:
  GET    /users           # List users
  GET    /users/123       # Get user 123
  POST   /users           # Create user
  PUT    /users/123       # Replace user 123
  PATCH  /users/123       # Update user 123
  DELETE /users/123       # Delete user 123

Bad:
  GET    /getUsers
  POST   /createUser
  POST   /users/delete/123
```

### Response Structure

```json
{
  "data": {},
  "meta": {
    "page": 1,
    "total": 100
  },
  "errors": []
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

---

# Part VII: Agent System Reference

---

## Agent Types & Usage

| Agent | Role | Cost | Use Case |
|-------|------|------|----------|
| `explore` | The Scout | FREE | Codebase exploration |
| `librarian` | The Researcher | CHEAP | External docs, examples |
| `frontend-ui-ux-engineer` | UI Specialist | CHEAP | Visual components |
| `document-writer` | The Scribe | CHEAP | Documentation |
| `oracle` | Deep Reasoner | EXPENSIVE | Complex problems |

### Parallel Execution

```
# Launch agents in background
background_task(agent="explore", prompt="Find patterns...")
background_task(agent="librarian", prompt="Find examples...")
# Continue working, collect results later
```

### Oracle Usage

Consult Oracle for:
- Complex architecture design
- After 2+ failed fix attempts
- Security/performance concerns
- Multi-system tradeoffs

---

## Skill Combination Patterns

### New Feature Development
```
1. /ddd-master        → Model the domain
2. /clean-arch        → Design layers
3. /tdd-master        → Write tests first
4. /code-auditor      → Review the code
```

### Performance Optimization
```
1. /perf-engineer     → Identify bottlenecks
2. /anti-pattern-hunter → Find issues
3. /refactor-master   → Apply fixes safely
4. /qa-engineer       → Verify improvements
```

### Security Review
```
1. /sec-ops           → Check vulnerabilities
2. /code-auditor      → Review code
3. /anti-pattern-hunter → Find risky patterns
```

### Architecture Review
```
1. /hexagonal-arch    → Check boundaries
2. /clean-arch        → Verify dependencies
3. /solid-principles  → Check SOLID compliance
4. /anti-pattern-hunter → Find smells
```

---

## Quick Reference Table

| Skill | Command | Use When |
|-------|---------|----------|
| clean-arch | `/clean-arch` | Layer organization |
| ddd-master | `/ddd-master` | Domain modeling |
| hexagonal-arch | `/hexagonal-arch` | Ports & adapters |
| cqrs-architect | `/cqrs-architect` | Read/write separation |
| event-sourcing | `/event-sourcing` | Audit trail, events |
| microservices-arch | `/microservices-arch` | Distributed systems |
| code-auditor | `/code-auditor` | Code review |
| refactor-master | `/refactor-master` | Safe refactoring |
| anti-pattern-hunter | `/anti-pattern-hunter` | Code smells |
| solid-principles | `/solid-principles` | SOLID enforcement |
| tdd-master | `/tdd-master` | Test-driven development |
| qa-engineer | `/qa-engineer` | Quality assurance |
| e2e-testing | `/e2e-testing` | End-to-end tests |
| sec-ops | `/sec-ops` | Security review |
| perf-engineer | `/perf-engineer` | Performance |
| devops-master | `/devops-master` | CI/CD |
| git-commander | `/git-commander` | Git workflow |
| docker-ninja | `/docker-ninja` | Containerization |
| doc-writer | `/doc-writer` | Documentation |
| api-designer | `/api-designer` | API design |

---

*GLOBAL-AGENTS.md - Universal AI Agent Skills*
*Applicable to any software project, language, or framework*
*Last Updated: January 2026*
