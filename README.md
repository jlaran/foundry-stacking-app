# Foundry Staking App

[![CI](https://github.com/jlaran/foundry-stacking-app/actions/workflows/test.yml/badge.svg)](https://github.com/jlaran/foundry-stacking-app/actions/workflows/test.yml)
![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636?logo=solidity)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-Contracts-4E5EE4?logo=openzeppelin)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

A token staking protocol written in Solidity and built with [Foundry](https://getfoundry.sh/). The project pairs a custom ERC-20 staking token with an owner-managed staking contract, using battle-tested [OpenZeppelin](https://www.openzeppelin.com/contracts) primitives and a fully automated test pipeline.

> **Status:** Work in progress. The staking token is implemented and tested; the staking logic in `StakingApp` is under active development. See the [Roadmap](#roadmap).

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Contracts](#contracts)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Continuous Integration](#continuous-integration)
- [Roadmap](#roadmap)
- [Security](#security)
- [License](#license)

---

## Overview

The protocol is made of two contracts:

1. **`StakingToken`** — an ERC-20 token that users stake.
2. **`StakingApp`** — the staking contract that holds a reference to the token and is administered by an owner.

Keeping the token and the staking logic in separate contracts makes each one simpler to reason about, test and upgrade independently.

## Architecture

```
            ┌──────────────────────┐
            │     StakingToken     │
            │   (ERC-20, "STK")    │
            └──────────▲───────────┘
                       │ stakingToken (address)
            ┌──────────┴───────────┐
  owner ───▶│      StakingApp      │◀─── users (stake / withdraw)*
            │      (Ownable)       │
            └──────────────────────┘

  * planned — see Roadmap
```

## Contracts

### `StakingToken.sol`

ERC-20 token extending OpenZeppelin's `ERC20`.

| Function | Visibility | Description |
| --- | --- | --- |
| `constructor(string name_, string symbol_)` | — | Sets the token name and symbol. |
| `mint(uint256 amount_)` | `external` | Mints `amount_` tokens to `msg.sender`. |

> `mint` is intentionally permissionless so the token can be used freely in local development and on testnets. It must be access-controlled (or removed) before any production deployment.

### `StakingApp.sol`

Staking contract extending OpenZeppelin's `Ownable`.

| Member | Type | Description |
| --- | --- | --- |
| `constructor(address stakingToken_, address owner_)` | — | Stores the staking token address and assigns ownership. |
| `stakingToken` | `address public` | Address of the ERC-20 token accepted for staking. |

Inherits `owner()`, `transferOwnership()` and `renounceOwnership()` from `Ownable`.

## Project Structure

```
.
├── .github/workflows/test.yml   # CI pipeline (fmt, build, test)
├── lib/
│   ├── forge-std/               # Foundry standard library (submodule)
│   └── openzeppelin-contracts/  # OpenZeppelin Contracts (submodule)
├── src/
│   ├── StakingApp.sol           # Staking contract
│   └── StakingToken.sol         # ERC-20 staking token
├── test/
│   └── StakingTokenTest.t.sol   # Token unit tests
└── foundry.toml                 # Foundry configuration
```

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

Clone the repository **with its submodules**:

```bash
git clone --recurse-submodules https://github.com/jlaran/foundry-stacking-app.git
cd foundry-stacking-app
```

If you already cloned it without submodules:

```bash
git submodule update --init --recursive
```

### Build

```bash
forge build
```

## Testing

Run the full test suite:

```bash
forge test
```

Useful variations:

```bash
forge test -vvv          # verbose output with traces on failure
forge test --gas-report  # gas usage per function
forge coverage           # coverage report
forge snapshot           # gas snapshot
```

### Current coverage

| Test | What it verifies |
| --- | --- |
| `testStakingTokenMintsCorrectly` | Minting increases the caller's balance by exactly the minted amount. |

## Continuous Integration

Every push and pull request triggers a GitHub Actions workflow that:

1. Checks out the repository with submodules
2. Installs the Foundry toolchain
3. Verifies formatting with `forge fmt --check`
4. Builds the contracts and reports sizes with `forge build --sizes`
5. Runs the test suite with `forge test -vvv`

Run `forge fmt` locally before committing to keep the formatting check green.

## Roadmap

- [x] ERC-20 staking token
- [x] Ownable staking contract scaffold
- [x] CI pipeline (format, build, test)
- [ ] Stake / deposit tokens
- [ ] Withdraw staked tokens
- [ ] Reward distribution and claiming
- [ ] Owner-configurable staking parameters
- [ ] Events for all state-changing actions
- [ ] Unit and fuzz tests for `StakingApp`
- [ ] Deployment scripts (`script/`)

## Security

This code has **not been audited** and is intended for educational and development purposes. Do not deploy it to mainnet or use it with real funds.

## License

Released under the [MIT License](https://opensource.org/licenses/MIT), as declared in the SPDX headers of the source files.
