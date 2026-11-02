# Title Insurance Semantic Model Implementation Plan

## Purpose

Build a client-neutral title insurance data and semantic model that produces:

- A reusable business context and semantic brief
- A normalized Unity Catalog data model
- An RDFS/Turtle ontology
- Unity Catalog domains and subdomains
- Unity Catalog Page definitions
- Governed metric views
- Genie Agent definitions and validation questions
- Deployment-ready artifacts without selecting a workspace, profile, or catalog yet

## Guardrails

- Do not include a client or company name in committed artifacts.
- Use synthetic examples and generalized title-insurance terminology.
- Keep deployment workspace, CLI profile, catalog, schema, owners, and principals parameterized.
- Do not deploy until a sandbox location and profile are explicitly approved.
- Treat generated models as drafts until reviewed by title, escrow, underwriting, claims, governance, and analytics subject-matter experts.
- Use Google Drive as the demo knowledge source; do not assume SharePoint access.

## Proposed Artifact Layout

```text
data-models/title_insurance/
  client-knowledge/
    source-manifest.yml
    company-overview.md
    title-order-process.md
    title-examination-policy.md
    closing-escrow-procedure.md
    policy-and-claims-guide.md
    business-glossary.csv
    kpi-definitions.yml
    source-systems.csv
  business-context.json
  semantic-brief.md
  ontology-requirements.yml
  uc-semantics/
    domains.yml
    asset-mappings.yml
    pages/
      title-order.md
      chain-of-title.md
      title-commitment.md
    pages-manifest.yml
  v1/
    mvm/
      model.json
      schemas/
      metrics/
      ontology/
      docs/
      diagram/
    ecm/
      model.json
      schemas/
      metrics/
      ontology/
      docs/
      diagram/
  deployment/
    variables.example.yml
    domains/
    metric-views/
    genie/
  validation/
    coverage-report.md
    ontology-validation.md
    metric-view-tests.sql
    genie-benchmark.yml
```

The final layout may be adjusted to match the generator's established version conventions.

## Model Scope and Version Strategy

- **MVM (Minimum Viable Model):** The smallest coherent model that supports the priority title-insurance workflows, relationships, controls, metrics, and analytical questions. Generate, review, and approve this first.
- **ECM (Expanded Coverage Model):** A broader enterprise model derived from the approved MVM. It adds supporting operations, edge cases, integrations, compliance detail, agency oversight, deeper financial history, commercial transactions, and other non-core coverage.
- The first generated release uses `v1/mvm/` and `v1/ecm/`, matching the existing repository convention.
- MVM and ECM share a version because they represent two scopes of the same approved business-model generation.
- Do not overwrite an approved `v1`; material later changes create a sibling `v2/`.
- Keep semantic inputs, Google Drive knowledge manifests, ontology requirements, and UC Semantics definitions above the version folders because they can inform multiple generated versions.
- Do not create empty output directories. Let the modeling agent create `v1/mvm/` and `v1/ecm/` when real artifacts are generated.

## Step 1: Draft the Semantic Brief

### Work

Document the title-insurance business independently of current databases:

- Business segments and distribution channels
- Title order, search, examination, curative, closing, recording, policy, and claim lifecycles
- Parties and their roles
- Funds movement and escrow controls
- Industry vocabulary
- Systems of record and external data providers
- Regulatory and privacy requirements
- Priority analytical questions

### Outputs

- `data-models/title_insurance/semantic-brief.md`
- Initial glossary section within the brief
- Open-question register for subject-matter review

### Sample Output

```markdown
## Title Evidence Lifecycle

A title order concerns one or more properties and parcels. A title search collects
recorded instruments from the applicable recording jurisdictions. Examination
classifies findings as requirements, exceptions, encumbrances, or informational
items. Curative actions resolve eligible findings before closing or policy issuance.

## Required Questions

- What is median order-to-commitment time by jurisdiction?
- Which unresolved requirements are delaying scheduled closings?
- Which defect categories generate the greatest claim severity?
```

### Exit Criteria

- Every core entity, participant, lifecycle, money movement, and required question is described.
- No client-identifying or confidential information is present.

## Step 2: Define Ontology Concepts and Rules

Before defining the ontology, prepare a synthetic Google Drive knowledge pack and use it to enrich the baseline semantic brief. The demo pack represents the kinds of files a client would maintain in a governed Drive folder.

### Google Drive Knowledge Intake

1. Create a dedicated demo folder with approved synthetic documents only.
2. Record each file in `client-knowledge/source-manifest.yml` with its Drive URL placeholder, owner role, authority, and covered concepts.
3. Access selected files through an approved Google Drive MCP connector when available; otherwise export them to Markdown, CSV, YAML, PDF, or DOCX for controlled local analysis.
4. Extract candidate terms, rules, processes, KPIs, source systems, and unresolved conflicts.
5. Convert extracted knowledge into traceable requirements before changing the MVM.
6. Preserve the source ID on every resulting requirement, ontology concept, Page, and model change.

### Google Drive Source Manifest Sample

```yaml
google_drive_folder: ${google_drive_demo_folder_url}
sources:
  - id: GDRIVE-001
    file: title-order-process.md
    drive_url: ${google_drive_title_order_process_url}
    owner_role: title_operations
    authority: authoritative
    covers:
      - title_order_lifecycle
      - commitment_lifecycle

  - id: GDRIVE-002
    file: business-glossary.csv
    drive_url: ${google_drive_business_glossary_url}
    owner_role: data_governance
    authority: authoritative
    covers:
      - definitions
      - synonyms
```

### Enrichment Requirement Sample

```yaml
requirements:
  - id: ENR-001
    source_ids: [GDRIVE-001]
    statement: Preserve separate examination and curative workflow states.
    target:
      domain: title_evidence
      entities: [title_examination, curative_action]
    proposed_change: Add distinct entities and lifecycle relationships.
    review_status: pending
```

The Google Drive connector is a knowledge acquisition mechanism, not an uncontrolled model-generation input. Only reviewed, traceable requirements are promoted into model directives.

### Work

Convert the semantic brief into explicit ontology requirements:

- Concepts and definitions
- Synonyms and prohibited conflations
- Relationships and cardinalities
- Lifecycle states and events
- Temporal and historical requirements
- Data classifications
- Invariants the generated model must satisfy

### Outputs

- `data-models/title_insurance/client-knowledge/`
- `data-models/title_insurance/client-knowledge/source-manifest.yml`
- Google Drive evidence-to-requirement matrix
- `data-models/title_insurance/ontology-requirements.yml`
- Concept-to-source evidence matrix
- Initial RDFS competency questions

### Sample Output

```yaml
concepts:
  - name: title_commitment
    label: Title Commitment
    definition: A conditional offer to issue title insurance after stated requirements are satisfied.
    synonyms: [commitment, preliminary title report]
    distinct_from: [title_policy, title_search]

relationships:
  - name: results_from
    subject: title_commitment
    object: title_order
    cardinality: many_to_one
    required: true

invariants:
  - id: POL-001
    rule: Every title policy must reference an originating title order.
```

### Exit Criteria

- Important terms have authoritative definitions and synonyms.
- Ambiguous concepts such as commitment, policy, exception, and requirement remain distinct.
- Required relationships and invariants are testable.
- Every client-specific enrichment requirement traces to a Google Drive source ID.

## Step 3: Design Unity Catalog Domains and Subdomains

### Work

Map the business ontology into Unity Catalog Semantics organization:

- Reuse the existing top-level `Insurance` domain.
- Use the existing `Insurance/Title Insurance` governed tag and Title Insurance subdomain.
- Represent the seven business areas as Discover sections and Page topics because nested subdomains are unsupported.
- Assign governed-tag keys using `{domain}/{subdomain}`.
- Define descriptions, subtitles, and owner placeholders.
- Map schemas, tables, metric views, dashboards, and Genie Agents to domains.

### Outputs

- `data-models/title_insurance/uc-semantics/domains.yml`
- `data-models/title_insurance/uc-semantics/asset-mappings.yml`
- REST API or Terraform-ready generated definitions under `deployment/domains/`

### Sample Output

```yaml
domains:
  existing_parent:
    domain_id: 67536dad-1b1d-4703-82ba-a16ff4910fdd
    tag_key: Insurance
  title_insurance_subdomain:
    domain_id: fc05a63b-5d24-4e93-80cd-d492b1b7a226
    parent_domain_id: 67536dad-1b1d-4703-82ba-a16ff4910fdd
    tag_key: Insurance/Title Insurance
  discover_sections:
    - title_operations
    - property_and_party
    - underwriting_and_policy
    - settlement_and_escrow
    - recording
    - agency
    - claims
```

```yaml
asset_mappings:
  - asset: ${catalog}.title_evidence.recorded_instrument
    domain: insurance
    subdomain: title_insurance
    topic: title_operations
  - asset: ${catalog}.title_evidence.chain_of_title_metrics
    domain: insurance
    subdomain: title_insurance
    topic: property_and_party
```

### Exit Criteria

- Subdomains use only one nesting level.
- Every planned UC asset has a domain or subdomain mapping.
- Deployment-specific owners and catalog names remain variables.

## Step 4: Author Unity Catalog Page Definitions

### Work

Create authoritative business Pages for concepts Genie One should prioritize:

- Definition and scope
- Synonyms
- Business rules and examples
- Common misunderstandings
- Related UC assets
- Authoritative internal or external sources
- Domain or subdomain assignment

### Outputs

- One Markdown file per Page under `uc-semantics/pages/`
- `uc-semantics/pages-manifest.yml`
- Bulk-import instructions for Genie Code

### Sample Output

```markdown
---
title: Chain of Title
domain: insurance
subdomain: title_insurance
topic: property_and_party
owner: ${title_operations_owner}
synonyms:
  - ownership history
  - title chain
related_assets:
  - ${catalog}.title_evidence.ownership_interest
  - ${catalog}.title_evidence.recorded_instrument
sources:
  - ${source_chain_of_title_standard}
---

# Chain of Title

The chronological sequence of recorded and otherwise recognized ownership
interests affecting a property or parcel.

## Business Rules

- Preserve the effective and recording dates separately.
- Do not infer ownership solely from the latest recorded instrument.
- Record gaps, overlaps, and disputed interests explicitly.
```

```yaml
pages:
  - file: pages/chain-of-title.md
    domain: insurance
    subdomain: title_insurance
    topic: property_and_party
    status: draft
    import_method: genie_code_bulk_import
```

### Exit Criteria

- Each critical term has a Page definition or an explicit reason for exclusion.
- Related assets and sources use placeholders until deployment identifiers are known.
- Files are suitable for manual or Genie Code bulk import.

## Step 5: Create the Reusable Business Context Input

### Work

Translate the approved semantic brief and ontology requirements into the generator's business-context structure. Include explicit model directives so client requirements outrank default heuristics.

### Outputs

- `data-models/title_insurance/business-context.json`
- Model-generation instruction set
- MVM and ECM scope definitions

### Sample Output

```json
{
  "business_name": "Title Insurance",
  "industry_alignment": "Title Insurance and Settlement Services",
  "business_description": "A title insurance and settlement services business...",
  "core_business_processes": [
    "Title Order Intake",
    "Title Search and Examination",
    "Curative Processing",
    "Closing and Escrow",
    "Recording",
    "Policy Issuance",
    "Claims Administration"
  ],
  "model_vibes": [
    "Keep title commitment and title policy as separate entities.",
    "Model ownership interests and recorded instruments with effective dating.",
    "Separate escrow ledger activity from settlement statement presentation."
  ]
}
```

### Exit Criteria

- The input validates against the app or agent's expected structure.
- MVM and ECM boundaries are explicit.
- Critical ontology requirements appear as enforceable generation directives.

## Step 6: Generate the Model and Metric Views

### Work

Run the modeling agent in Dry Run mode and generate `v1/mvm/` first. Review the MVM against the semantic brief, ontology invariants, Google Drive requirements, and priority questions. After MVM approval, derive `v1/ecm/` from the same version context rather than generating an unrelated model. Author governed metric views only for measures that safely re-aggregate at query time.

### MVM Coverage

- Title order and lifecycle
- Property, parcel, legal description, party, and role
- Search, examination, evidence, finding, requirement, exception, and curative action
- Commitment and core underwriting decision
- Closing, settlement statement, escrow ledger, and recording
- Owner and lender policy, endorsement, premium, and core claim lifecycle

### ECM Expansion

- Detailed agent appointment, authority, audit, reporting, and remittance
- Deeper premium, commission, tax, fee, and financial-accounting treatment
- Advanced underwriting referrals, fraud controls, and compliance workflows
- Litigation, recovery, subrogation, and detailed claim financial development
- Commercial, construction, portfolio, and complex multi-jurisdiction transactions
- Document retention, legal hold, regulatory reporting, and operational reference data

Candidate metric themes:

- Order volume and cycle time
- Search and examination productivity
- Open requirement and curative aging
- Closing and recording timeliness
- Escrow reconciliation
- Policy issuance and premium
- Agency remittance
- Claim frequency, severity, reserve, and recovery

### Outputs

- Versioned MVM and ECM `model.json`
- UC DDL and constraints
- Metric-view SQL definitions with embedded YAML
- RDFS/Turtle ontology
- DBML diagram and model documentation

### Sample Output

```sql
CREATE OR REPLACE VIEW ${catalog}.title_order.order_performance_metrics
WITH METRICS
LANGUAGE YAML
AS $$
version: 1.1
source: ${catalog}.title_order.title_order
dimensions:
  - name: opened_date
    expr: opened_date
    display_name: Opened date
  - name: jurisdiction_state
    expr: jurisdiction_state_code
    display_name: Jurisdiction state
measures:
  - name: order_count
    expr: COUNT(*)
    display_name: Title orders
    format:
      type: number
  - name: average_commitment_cycle_days
    expr: AVG(DATEDIFF(commitment_issued_date, opened_date))
    display_name: Average commitment cycle time
    format:
      type: number
      decimal_places: 1
$$;
```

### Exit Criteria

- Deterministic model quality gates pass.
- No dangling foreign keys or prohibited ontology conflations remain.
- Every metric has a documented grain, owner, dimensions, and validation query.

## Step 7: Select the Sandbox Deployment Target

### Work

Pause for an explicit deployment decision. Record:

- Databricks workspace and CLI profile
- Development catalog and schemas
- SQL warehouse
- UC Volume for generated artifacts
- Technical and business owners
- Groups and grants
- Whether UC Semantics and Discover previews are enabled
- Whether deployment uses REST, Terraform, DABs, or a combination

### Outputs

- `data-models/title_insurance/deployment/variables.yml`, created from the example only after approval
- Approved deployment runbook
- Permission and prerequisite checklist

### Sample Output

```yaml
workspace_profile: DEFAULT
catalog: serverless_stable_dvmvgw_catalog
silver_schema_prefix: ti_
gold_schema_prefix: PENDING
warehouse_id: e97542bc3b72cb1b
artifact_volume: PENDING
technical_owner: PENDING
business_owner: PENDING
deploy_uc_domains: false
deploy_metric_views: false
create_genie_agents: false
```

### Exit Criteria

- The user explicitly approves the sandbox and profile.
- No placeholder remains for a deployment-critical value.
- Required privileges are verified before any create or update operation.

## Step 8: Validate UC Semantics and Genie Assets

### Work

After approved deployment:

- Confirm domains and subdomains exist and are published.
- Verify governed tags map assets correctly.
- Import, review, and publish Pages.
- Execute metric-view validation queries.
- Create curated Genie Agents for the approved Silver and/or Gold layers.
- Run benchmark questions and inspect generated SQL and answers.
- Record gaps, caveats, and remediation actions.

### Outputs

- `validation/coverage-report.md`
- `validation/ontology-validation.md`
- `validation/metric-view-tests.sql`
- `validation/genie-benchmark.yml`
- Final asset inventory with URLs and identifiers

### Sample Output

```yaml
benchmark:
  - id: GENIE-001
    question: What is the average commitment cycle time by county this quarter?
    expected_assets:
      - ${catalog}.title_order.order_performance_metrics
    expected_measures:
      - average_commitment_cycle_days
    required_dimensions:
      - county
    status: pending

  - id: GENIE-002
    question: Which unresolved title requirements are delaying closings?
    expected_assets:
      - ${catalog}.title_evidence.title_requirement
      - ${catalog}.settlement.closing
    status: pending
```

```markdown
## UC Semantics Coverage

| Asset type | Planned | Created | Validated | Notes |
|---|---:|---:|---:|---|
| Domains | 7 | 7 | 7 | Published |
| Subdomains | 18 | 18 | 18 | Published |
| Pages | 24 | 24 | 24 | SME review complete |
| Metric views | 12 | 12 | 12 | Validation queries passed |
| Genie Agents | 4 | 4 | 4 | Benchmark pass rate 92% |
```

### Exit Criteria

- All created assets have owners, descriptions, and source-controlled definitions.
- Metric validation queries produce expected results.
- Genie benchmark failures have documented causes and remediation.
- Pages and domain mappings are reviewed by business and governance owners.

## Review Gates

| Gate | Required Approval | Decision |
|---|---|---|
| Semantic brief | Title operations and data architecture | Pending |
| Ontology requirements | Title, escrow, underwriting, claims | Pending |
| UC domain taxonomy | Data governance | Pending |
| Page definitions | Business owners and governance | Pending |
| MVM | Data architecture and analytics | Pending |
| ECM | Domain owners | Pending |
| Sandbox deployment | Workspace owner and user | Pending |
| Production promotion | Security, governance, and operations | Out of scope |

## Current Status

- Branch: `feat/title-insurance`
- Active step: Step 1 — Draft the semantic brief
- Deployment profile: Pending
- Sandbox location: Pending
- No Databricks deployment is authorized yet
