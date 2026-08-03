# Lab 2.5 – IaC as Compliance Evidence (AWS)

## Overview

Traditional compliance evidence often relies on screenshots, PDFs, and manually collected artifacts. While useful, these forms of evidence can be difficult to verify, reproduce, and protect from tampering.

This lab demonstrates how Infrastructure as Code (IaC) can produce stronger audit evidence by automatically capturing Terraform deployment artifacts and storing them in an immutable AWS S3 Object Lock vault.

The result is an automated evidence pipeline that provides integrity, attribution, and reproducibility for infrastructure deployments.

---

# Objectives

* Build an immutable AWS S3 evidence vault
* Configure Object Lock, versioning, encryption, and public access controls
* Automatically collect Terraform deployment artifacts
* Generate SHA-256 integrity hashes
* Create an evidence manifest
* Upload versioned evidence packages into immutable storage
* Verify retention policies
* Demonstrate evidence immutability by attempting (and failing) to delete protected objects

---

# Architecture

```text
Terraform Deployment
        │
        ▼
Terraform Plan
Terraform State
Git Commit
Terraform Version
        │
        ▼
capture-evidence.sh
        │
        ├── Generate SHA-256 hashes
        ├── Build evidence manifest
        ├── Bundle artifacts
        ▼
AWS S3 Object Lock Vault
        │
        ▼
VersionId Returned
        │
        ▼
Immutable Audit Evidence
```

---

# Technologies Used

* Terraform
* AWS S3
* S3 Object Lock
* S3 Versioning
* AWS CLI
* Bash
* SHA-256
* Git

---

# Security Controls Implemented

## Immutable Evidence Storage

Evidence is stored in an S3 bucket with Object Lock enabled, preventing modification or deletion during the configured retention period.

---

## Versioning

Every uploaded evidence bundle receives a unique VersionId, allowing retrieval of the exact deployment artifact captured during a specific execution.

---

## Encryption

Server-side encryption (AES-256) protects evidence stored within the bucket.

---

## Public Access Protection

The bucket blocks:

* Public ACLs
* Public bucket policies
* Public access inheritance

ensuring evidence remains private.

---

## Integrity Verification

Every evidence artifact is hashed using SHA-256 and recorded in a manifest, allowing integrity verification of every collected file.

---

# Evidence Captured

The automation collects:

* Terraform execution plan
* Terraform state
* Latest Git commit metadata
* Terraform version
* SHA-256 hashes
* Evidence manifest
* Compressed evidence bundle

---

# Validation Performed

The implementation was validated by:

* Successfully deploying the evidence vault with Terraform
* Uploading an evidence bundle into the vault
* Retrieving the object's retention policy
* Verifying Object Lock configuration
* Attempting to delete the evidence object

Expected result:

```text
AccessDenied because object protected by object lock.
```

This confirms that the evidence cannot be removed during the retention period.

---

# Real-World Use Case

Organizations pursuing frameworks such as:

* SOC 2
* ISO 27001
* NIST 800-53
* FedRAMP

must demonstrate that infrastructure changes are authorized, reproducible, and supported by trustworthy evidence.

Rather than relying on manually collected screenshots, this approach creates a repeatable evidence pipeline that automatically captures deployment artifacts, protects them from tampering, and preserves a verifiable chain of custody.

---

# Key Lessons Learned

This lab shifted my perspective from simply deploying infrastructure to designing systems that automatically generate trustworthy compliance evidence.

Key takeaways include:

* Infrastructure can serve as audit evidence when paired with version control and immutable storage.
* Cryptographic hashing provides integrity verification for deployment artifacts.
* S3 Object Lock protects evidence from accidental or malicious deletion.
* Versioned evidence enables auditors and investigators to retrieve the exact artifacts associated with a deployment.

---

# Skills Demonstrated

* Terraform
* Infrastructure as Code
* AWS S3
* AWS Object Lock
* Cloud Security
* Compliance Automation
* Evidence Collection
* Infrastructure Governance
* Security Engineering
* Bash Automation
* Git
* Cryptographic Hashing
* Audit Readiness

---


