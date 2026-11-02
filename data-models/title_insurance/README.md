# Title Insurance

Client-neutral title-insurance semantic-model inputs and planned generated artifacts.

## Current Contents

| Path | Purpose |
|---|---|
| `semantic-brief.md` | Business narrative used to define entities, relationships, lifecycles, rules, and priority questions. |
| `business-context.json` | Modeling-agent input using the repository's supported business-context structure. |
| `ontology-requirements.yml` | Sourced concepts, relationships, invariants, classifications, and competency questions. |
| `client-knowledge/` | Synthetic Google Drive demonstration corpus and source manifest. |
| `uc-semantics/` | Unity Catalog Domain, Subdomain, Page, and asset-mapping definitions. |

## Planned Version Structure

The modeling agent will create the generated output directories. Empty placeholders are intentionally not committed.

```text
v1/
  readme.md
  mvm/
    model.json
    readme.md
    schemas/
    metrics/
    ontology/
    docs/
    diagram/
    vibes/
  ecm/
    model.json
    readme.md
    schemas/
    metrics/
    ontology/
    docs/
    diagram/
    vibes/
```

## Scope Strategy

- **MVM:** Generate and approve the minimum viable title-insurance model first.
- **ECM:** Derive expanded enterprise coverage from the approved MVM within the same version.
- **Later versions:** Create `v2/`, `v3/`, and subsequent siblings for material approved changes; do not overwrite an approved version.

## Deployment Status

- Sandbox workspace: `https://fevm-serverless-stable-dvmvgw.cloud.databricks.com`
- Databricks CLI profile: `DEFAULT`
- Catalog: `serverless_stable_dvmvgw_catalog`
- Generated schema prefix: `ti_`
- SQL warehouse: `Serverless Starter Warehouse` (`e97542bc3b72cb1b`)
- Artifact Volume: `serverless_stable_dvmvgw_catalog._metamodel.vol_root`
- Dry run `647245575063833` completed successfully on October 31, 2026.
- Final-artifact validation passes for 67 products and 392 foreign keys; see `deployment/dry-run-validation.md`.
- Physical tables, metric views, and samples should be created with the standalone model installer from the saved Volume artifacts. This avoids repeating the dry run's 301 AI calls.
- UC Semantics Pages and Genie deployment remain disabled.
