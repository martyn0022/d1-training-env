# D1 Claims API — Training Environment

Everything you need for Day 2 of the D1 claims API course, in one container:
IRIS, the `D1DEV` namespace, the claim tables, seed data, and one working
example endpoint.

You will add two more endpoints yourself: `POST /local/policy` and
`POST /preauth/patch`.

---

## Requirements

Docker Desktop (or any Docker with Compose v2). Nothing else — no IRIS
install, no licence key.

The first `up` pulls the IRIS image, which is several GB. Allow time for it.

---

## Start, stop, reseed

**Start** (first run builds the image and sets everything up):

```bash
docker compose up -d --build
```

**Watch the first-start setup** — it takes a minute or two, and this is where
you see the classes load and the data seed:

```bash
docker compose logs -f iris
```

Wait for `[d1-setup] complete.` Then press Ctrl-C to stop following the log.

**Stop.** Give IRIS time to shut down cleanly — a hard kill leaves the write
image journal dirty and the next start spends minutes recovering:

```bash
docker compose down -t 60
```

**Restart** (your work is preserved):

```bash
docker compose up -d
```

**Reseed the demo data** — wipes the claim tables and reloads the demo rows.
Use this whenever your own testing has left the data in a mess:

```bash
docker compose exec iris iris session IRIS -U D1DEV "##class(D1.Mock.Data.ClaimLoader).Reset()"
```

If that one-liner is awkward in your shell, open a terminal instead:

```bash
docker compose exec iris iris session IRIS -U D1DEV
```

and type `do ##class(D1.Mock.Data.ClaimLoader).Reset()` then `halt`.

**Start over completely** — throws away the namespace, your classes and all
data, and rebuilds from scratch:

```bash
docker compose down -t 60 && rm -rf data/durable/* && docker compose up -d --build
```

---

## Login

| | |
|---|---|
| Username | `_SYSTEM` |
| Password | `SYS` |
| Namespace | `D1DEV` |

There is no forced password change — you can use it immediately, in the
Management Portal, in VS Code and in Postman.

| Where | URL |
|---|---|
| Management Portal | <http://localhost:52773/csp/sys/UtilHome.csp> |
| The API | <http://localhost:52773/api/d1claims> |
| Superserver (DB-API, JDBC, ODBC) | `localhost:9091` |

### VS Code

Point the InterSystems ObjectScript extension at the **web server** port,
not the superserver:

```jsonc
{
  "intersystems.servers": {
    "d1dev": {
      "webServer": { "host": "localhost", "port": 52773 },
      "username": "_SYSTEM"
    }
  },
  "objectscript.conn": { "server": "d1dev", "ns": "D1DEV", "active": true }
}
```

---

## What is preloaded

All of it in namespace **`D1DEV`**. Interoperability is deliberately **not**
enabled — this course does not use it.

**Claim tables** (schema `D1_Mock_Data`) — 15 persistent classes:
`ClaimAdmission`, `ClaimBenefit`, `ClaimBilling`, `ClaimChiefComplaint`,
`ClaimDiagnosis`, `ClaimDischarge`, `ClaimFile`, `ClaimInsurer`,
`ClaimPatient`, `ClaimPolicy`, `ClaimPreAuth`, `ClaimVisit`,
`ClaimVisitProcedure`, `CoverageItem`, `PreAuthSubmission`.

**Seed loader:** `D1.Mock.Data.ClaimLoader` — `Reset()` wipes and reseeds.

**Shared helpers:**

| Class | What it does |
|---|---|
| `D1.REST.Base` | The abstract base every endpoint extends: body parsing, JSON output, the 400/500 envelopes, and `Log()`. |
| `D1.Mock.Util.ClaimIdentityResolver` | Turns an `identity_type` / `identity_no` pair into a hospital number and admission number. |
| `D1.Mock.Util.ClaimCompanyResolver` | The insurer tenancy check. Returns `"200"`, `"403"`, `"404"` or `"400"`. You need this for `/preauth/patch`. |

**The worked example** — study this before writing your own:

| Class | What it is |
|---|---|
| `D1.REST.Router` | The routing table. One route so far. |
| `D1.REST.Impl.LocalPreAuthInfo` | The example endpoint, split into `Handle()` and `Run()`. |
| `D1.Mock.Msg.D1GetPreAuthInfoRequest` | Its request message. |
| `D1.Mock.Msg.D1GetPreAuthInfoResponse` | Its response message. |
| `D1.Mock.Msg.PreAuthDetail` | The nested object inside that response. |

**Web application:** `/api/d1claims`, dispatch class `D1.REST.Router`,
password authentication.

**Seed data** — two claim threads:

| Admission | Patient | Insurer | Pre-auth | Case number | Status |
|---|---|---|---|---|---|
| `AN2026080001` | `HN000001` Somchai Sukjai | `AIA` | `REQ000000P1` | `PA-2026-071122` | Pre-Accepted |
| `AN2026080002` | `HN000002` Malee Wongsawat | `AIA` | `REQ000000P2` | `PA-2026-100077` | Pre-Authorize Submitted |

Both sit under policy `AIA-TH-998821`, plan `AIA Health Gold`.

---

## Verification checklist

Run this after your first `up` to confirm the environment is sound. All six
should pass before you start writing code.

### 1. Namespace `D1DEV` exists and interoperability is not enabled

Management Portal → **System Administration → Configuration → System
Configuration → Namespaces**. `D1DEV` is listed.

Then switch to `D1DEV` (top-left namespace selector). The left-hand menu must
show **System Explorer** but **no Interoperability menu**. If an
Interoperability menu appears, the namespace was created wrongly — see
Troubleshooting.

### 2. Every shipped class is compiled in `D1DEV`

Management Portal → **System Explorer → SQL**, namespace `D1DEV`:

```sql
SELECT COUNT(*) FROM %Dictionary.CompiledClass WHERE ID %STARTSWITH 'D1.'
```

Expect **25** — the 24 shipped `D1.*` classes plus `D1.Training.Setup`. To see
them by name:

```sql
SELECT ID FROM %Dictionary.CompiledClass WHERE ID %STARTSWITH 'D1.' ORDER BY ID
```

### 3. The seed data is there

```sql
SELECT AdmissionNumber, CompanyCode, PolicyNumber FROM D1_Mock_Data.ClaimPolicy ORDER BY AdmissionNumber
```

Two rows: `AN2026080001` and `AN2026080002`, both `AIA` / `AIA-TH-998821`.

```sql
SELECT ClaimId, AdmissionNumber, ClaimCaseNumber, ClaimStatus FROM D1_Mock_Data.ClaimPreAuth ORDER BY ClaimId
```

Two rows: `REQ000000P1` (`AN2026080001`, `PA-2026-071122`, `Pre-Accepted`) and
`REQ000000P2` (`AN2026080002`, `PA-2026-100077`, `Pre-Authorize Submitted`).

### 4. The web application exists

Management Portal → **System Administration → Security → Applications → Web
Applications**. Open `/api/d1claims` and confirm:

- **Namespace** `D1DEV`
- **Dispatch Class** `D1.REST.Router`
- **Allowed Authentication Methods**: Password ticked, Unauthenticated not

### 5. The example endpoint answers — whole window, no identity filter

```bash
curl -s -u _SYSTEM:SYS -H 'Content-Type: application/json' \
  -d '{"start_reqdate":"2026-07-01 00:00:00","end_reqdate":"2026-10-31 23:59:59","identity_type":"HN"}' \
  http://localhost:52773/api/d1claims/local/preauth-info
```

Expect `"response_code":"200"` and **two** `preauth` rows, `REQ000000P1` first
then `REQ000000P2` (they are ordered by `submit_date`).

### 6. The identity filter and the date range both narrow the result

```bash
curl -s -u _SYSTEM:SYS -H 'Content-Type: application/json' \
  -d '{"start_reqdate":"2026-07-01 00:00:00","end_reqdate":"2026-07-31 23:59:59","identity_type":"HN","identity_no":"HN000001"}' \
  http://localhost:52773/api/d1claims/local/preauth-info
```

Expect `"response_code":"200"` and **one** `preauth` row, `REQ000000P1`.

---

## Troubleshooting

**`[d1-setup] complete.` never appears.** Read the whole log:
`docker compose logs iris`. The setup prints `[d1-setup] FAILED:` with the
reason if it could not finish.

**Setup ran but you want it to run again.** It is guarded by a sentinel so
restarts do not wipe your work. To force a full re-run, start over completely
(command above).

**You changed a shipped class and want the original back.** Reload the shipped
source over your copy — note this overwrites *every* shipped class, including
the routes you added to `D1.REST.Router`:

```bash
docker compose exec iris iris session IRIS -U D1DEV "##class(D1.Training.Setup).ReloadShipped()"
```

**An Interoperability menu appears for `D1DEV`.** The namespace was created
with interoperability on. Start over completely; `merge.cpf` must not contain
`Interop=1`.

**On Linux, IRIS cannot write to `/dur`.** The container runs as uid 51773.
Run `sudo chown -R 51773:51773 data/durable` and start again. macOS and
Windows Docker Desktop handle this for you.

---

## Files

```
docker-compose.yml          the container, ports and volume
Dockerfile                  copies src/, setup/ and merge.cpf into the image
merge.cpf                   creates the D1DEV namespace; clears forced password change
setup/
  after-start.sh            runs once IRIS is live
  setup.script              loads Setup.cls and calls it
  Setup.cls                 loads the classes, creates the web app, seeds the data
src/D1/Mock/Data/           15 claim tables + ClaimLoader
src/D1/Mock/Msg/            the 3 message classes for the example endpoint
src/D1/Mock/Util/           the 2 resolvers
src/D1/REST/Base.cls        the base class every endpoint extends
src/D1/REST/Router.cls      the routing table
src/D1/REST/Impl/           the example endpoint
data/durable/               created at runtime: the IRIS instance and your work
```
