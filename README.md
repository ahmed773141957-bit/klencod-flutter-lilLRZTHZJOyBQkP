# HRMS Flutter Android starter

This project is a native Flutter starter based on the attached HRMS web project. The interface is Arabic/right-to-left and includes a login page, role selection for the source project's demo roles, dashboard cards, bottom navigation, employee/attendance/leave/salary sample lists, and shortcuts for other HR modules.

## Run it

1. Install Flutter (Dart 3.3+) and Android Studio/Android SDK.
2. From this directory run `flutter create . --platforms=android` to generate the standard Android runner files.
3. Run `flutter pub get`.
4. Run `flutter run` with an Android device/emulator connected, or build with `flutter build apk --release`.

## Demo access

The login screen uses the sample credentials from the source UI:

- `super_admin` / `123456`
- `admin` / `123456`
- `employee` / `123456`

These are hard-coded demonstration credentials only. Do not ship them as production authentication. The dashboard figures and list rows are illustrative local data; they are not read from the SQL database.

## Backend integration still required

The uploaded project includes a browser-side HRMS JavaScript bundle, static HTML modules, and a MySQL schema, but does not expose a documented HTTP API. This Flutter project therefore does not embed MySQL access, reuse the browser `HRMS` global, or claim to implement server-backed authentication. For production:

1. Expose the existing HRMS functionality through a secure REST/GraphQL API (or adapt its existing server code).
2. Replace the demo `login()` method and hard-coded lists in `lib/main.dart` with API services and typed models.
3. Store authentication tokens securely, enforce role permissions on the server, and use HTTPS.
4. Implement employee CRUD, attendance, leave approvals, payroll, loans, reports, and audit logs against the database/API. The current mobile navigation establishes the app shell; some secondary items are navigation placeholders.
5. Add proper loading, validation, error, offline, and localization handling before release.

The original system's schema is in `source/public/database/hr.sql`, and the original UI contains further admin and data-entry modules. This starter translates the interaction and visual direction, not the legacy browser implementation line-for-line.
