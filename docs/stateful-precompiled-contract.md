---
title: Stateful Precompiled Contract
description: A stateful precompiled smart contract for executing complexity task.
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

## Abstract

## Motivation

- Extending capabilities of the smart contract

## Specification

## Rationale

#### Appendix

## Security Considerations
- [SWC124:Write to Arbitrary Storage Location](https://swcregistry.io/docs/SWC-124/) Using an alternate hash function instead of keccak256 for storage slot calculations could potentially expose vulnerabilities, such as writing to arbitrary storage locations, Ensuring the integrity and collision resistance of the hash function is critical for preventing unintended overwriting or access to storage areas
