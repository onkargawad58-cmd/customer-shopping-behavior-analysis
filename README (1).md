# CareAlert+ : Medical Web Application

A healthcare web application that lets patients book appointments, manage medication reminders and view prescription history, while doctors manage patients and admins manage the platform. Built as my final-year B.Sc. IT project (University of Mumbai, 2025-26).

![Dashboard](images/patient_dashboard.png)

## Why this project

Patients often miss appointments and forget medicines, and their records sit in separate systems. CareAlert+ puts appointments, prescriptions, medical history and reminders in one place for three types of users.

## Features

**Patient**
- Register and log in with email verification
- Update profile and medical details (emergency contact, blood type, allergies)
- Book appointments and view past and upcoming visits
- Set medication reminders and mark doses as taken
- View and download prescription history as PDF
- Find nearby hospitals using the browser's location

**Doctor**
- Patient directory and patient records
- Add clinical notes and prescriptions, upload medical records
- View and update appointments

**Admin**
- Manage user accounts and monitor system activity
- Post announcements

## Tech stack

| Area | Technology |
|---|---|
| Frontend | React.js, TypeScript, HTML5, CSS3 |
| Backend and database | Supabase (PostgreSQL, Authentication, Row Level Security) |
| Notifications | Twilio SMS |
| Other libraries | jsPDF (PDF export), Recharts (charts) |

## Database

Relational PostgreSQL schema in Supabase with primary and foreign keys: **users, appointments, prescriptions, medications and logs**. Role-based access control (Patient, Doctor, Admin) uses Supabase Authentication and Row Level Security.

## Testing

I wrote test cases across 7 modules (authentication, patient, doctor, reminders, admin, security, UI and performance) and fixed the bugs found, for example a missing `await` on a Supabase insert and a wrong function call in the nearby-hospitals lookup.

| Module | Result |
|---|---|
| Authentication | All test cases passed |
| Patient | All test cases passed |
| Doctor | All test cases passed |
| Security | All test cases passed |
| Reminders | Scheduled appointment and medicine reminders did not pass in final testing |
| Admin | User management and announcements passed; the statistics view did not |

## Known issues and next steps

- Automatic reminder scheduling (24-hour, 1-hour and medicine reminders) needs more work
- The admin statistics charts use sample data until enough real data is stored
- No mobile app and no offline access
- Doctor accounts are added by the admin, without automatic license verification
- Planned: Android and iOS app, video consultations, multi-language support, wearable integration

## Security note

Never commit API keys. Keep Supabase and Twilio credentials in a `.env` file (see `.env.example`), which is listed in `.gitignore`. Twilio credentials must stay on a server or Supabase Edge Function, not in frontend code.

## Run locally

1. `npm install`
2. Copy `.env.example` to `.env` and add your own Supabase and Twilio values
3. `npm run dev`

## Author

**Onkar Gawad** | B.Sc. Information Technology, University of Mumbai
[LinkedIn](https://www.linkedin.com/in/onkar-gawad-292833418/)
