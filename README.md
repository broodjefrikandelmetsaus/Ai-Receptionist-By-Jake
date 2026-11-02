# AI Receptionist By Jake

Multilingual AI receptionist prototype (Dutch/English) on Cloudflare Workers + Workers AI + D1.

## Live demo

https://ai-receptionist-by-jake.jakedereus.workers.dev

Cloudflare deployment version: `5fa8fe9d-b873-4b00-8f6b-ba8c2449ff5f` (100% traffic assigned by Cloudflare deployment record).

## Current release: 0.2.0

- Email/password registration and login
- Hashed passwords (PBKDF2-SHA-256, per-user salt)
- Hashed opaque session tokens in D1, HttpOnly/Secure/SameSite cookie, 7-day expiry
- Basic IP-based signup/login attempt throttling
- Tenant-scoped business and receptionist settings
- Tenant-scoped service creation/listing
- Dutch/English dashboard

## Previous release: 0.1.0
- Public demo dashboard
- Stateless AI chat using `@cf/zai-org/glm-4.7-flash`
- Browser speech recognition and speech synthesis (browser-dependent)
- EU-jurisdiction D1 database schema for multi-tenant businesses, agents, services, opening hours, contacts, appointments, conversations and phone configuration
- Hard cap of 10 AI requests/day for this public demo

## Important limitations
This is a demo, not a production SaaS. Authentication, tenant authorization, real booking workflows, phone/SIP routing, call recording consent, and production abuse controls are not enabled. Do not enter real customer or sensitive personal data. Browser speech recognition may use browser-vendor services and is not guaranteed to be offline. No phone number is provisioned.

## Stack
- Cloudflare Workers (Free plan)
- Workers AI (10,000 neurons/day free allocation; requests can fail after quota)
- Cloudflare D1 (EU jurisdiction)
- GitHub

## Deploy
1. Install Node.js LTS.
2. Clone this repository.
3. Run `npm install`.
4. Authenticate with `npx wrangler login`.
5. Apply schema: `npx wrangler d1 migrations apply ai-receptionist-by-jake-db --remote`.
6. Deploy: `npx wrangler deploy`.

Do not enable Workers Paid or add billing if maintaining a strict €0 budget.

## API
- `GET /` dashboard
- `GET /api/health` service status
- `POST /api/chat` JSON body: `{"message":"Hello","language":"en"}`

## Database
Migration `0001_initial_schema.sql` is applied to the remote EU D1 database.
