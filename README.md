Trusted Escrow Smart Contract

A **secure escrow system** implemented in **Clarity** for the Stacks blockchain. This contract allows buyers to deposit STX into escrow, release funds to sellers upon delivery, request refunds, and enables a referee/admin to resolve disputes.

---

Features

**Secure Deposit**: Buyers can deposit STX into the escrow contract.
**Release Funds**: Buyers confirm delivery and release funds to the seller.
**Refund**: Buyers can request a refund if delivery is not confirmed.
**Dispute Resolution**: Referee/admin can resolve disputes, releasing funds to buyer or seller.
**Ownership Control**: Only the referee/admin can resolve disputes.
**Error Handling**: Standardized error codes for predictable contract behavior.

---

Error Codes

| Code                  | Description                               |
| --------------------- | ----------------------------------------- |
| `ERR-NOT-OWNER`       | Caller is not the contract owner/referee. |
| `ERR-NO-FUNDS`        | No funds deposited for withdrawal.        |
| `ERR-NOT-READY`       | Funds cannot be withdrawn yet.            |
| `ERR-TRANSFER-FAILED` | STX transfer failed.                      |

---

Contract Functions

Public Functions

| Function                          | Description                                                   |
| --------------------------------- | ------------------------------------------------------------- |
| `deposit(amount)`                 | Buyer deposits STX into escrow.                               |
| `release-funds()`                 | Buyer confirms delivery and releases funds to the seller.     |
| `refund()`                        | Buyer requests refund before funds are released.              |
| `resolve-dispute(send-to-seller)` | Referee resolves dispute, releasing funds to buyer or seller. |
| `transfer-ownership(new-owner)`   | Transfer ownership to a new referee/admin.                    |

Read-Only Functions

| Function            | Description                                 |
| ------------------- | ------------------------------------------- |
| `get-balance(user)` | Returns the escrowed balance of a user.     |
| `get-owner()`       | Returns the current contract owner/referee. |

---

Deployment

1. Install [Clarity CLI](https://docs.stacks.co/docs/clarity).
2. Compile the contract:

```bash
clarity-cli compile trusted-escrow.clar
```

3. Deploy on Stacks Testnet/Mainnet.

---

License

This project is licensed under the MIT License.

---

