---
title: Property and Parcel
domain: insurance
subdomain: title_insurance
topic: property_and_party
owner: ${data_governance_owner}
synonyms:
  - real property
  - tax parcel
related_assets:
  - ${catalog}.ti_property.property
  - ${catalog}.ti_property.parcel
  - ${catalog}.ti_property.legal_description
---

# Property and Parcel

A property is the real-estate subject of an order, closing, instrument, policy, or claim. A parcel is a jurisdictionally identified tract or unit associated with a property. They are related but not interchangeable.

## Business Rules

- One property can contain multiple parcels.
- A parcel can participate in multiple transactions over time.
- Street address, parcel identifier, and legal description are distinct identifiers.
- Preserve source identifiers and resolution history across title plants, assessors, and order systems.
- Do not treat an address match alone as proof that two property records are identical.
