---
title: Chain of Title
domain: insurance
subdomain: title_insurance
topic: property_and_party
owner: ${title_operations_owner}
synonyms:
  - ownership history
related_assets:
  - ${catalog}.ti_property.ownership_interest
  - ${catalog}.ti_recording.recorded_instrument
---

# Chain of Title

Chain of title is the chronological sequence of ownership interests affecting a property or parcel, as supported by recorded instruments and other approved evidence.

It is an ownership-history concept, not a title workflow record. A chain of title is not a title order, examination, requirement, commitment, policy, or claim; those records may analyze, reference, insure, or dispute the ownership history without becoming part of the chain itself.

## Business Rules

- Represent ownership as effective-dated interests, not a single current-owner field.
- Preserve grantor, grantee, estate or interest, effective date, recording date, and supporting evidence.
- Treat execution, effective, and recording dates as separate facts.
- Record gaps, overlaps, disputed interests, and examiner conclusions explicitly.
- Do not infer legal priority solely from data-ingestion order.

## Common Uses

- Reconstruct ownership as of a specified date.
- Identify gaps or conflicting interests.
- Trace a finding or claim back to its supporting instruments.
