Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4AC5A4135;
	Mon, 31 Aug 2026 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184335; cv=none; b=kL8IKPAO/U+w3eD8pVqDj3Vhyp9ly1Fk+kGoZ1T9bzHtYhT+UC/N628/2UMPEtSGKOU/WSZsDBtuRQ3u2KxGnXyl+ACwnBV6a9++wHVTgtdM5LExKDLInOsyH4FACrXQDKXIeNAy5w0cRx6mFiGRy/dC7vbSCVMbr0aEx+K2vyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184335; c=relaxed/simple;
	bh=nXu4cZUKZiyhevammCH2tMRDqODXdyQGcjjk44AEiy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqgaw/TPa9lAcQ4iAOXS4JzlhluTvHkSvoDQr2DArUVrCQGVMSscA+J4ynoF/Au3MQoZiL6xX3ZJMhdT3Ghim7TuetwvAJZ2/FWfPVT9nVnB9dzZ+mpoba7jCKPQ334faKgYmXTV2/3G2AYP8izwW2SY0P4/2jnBD5gXyS/92HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsGNhhlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsGNhhlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0138C1F000E9;
	Mon, 31 Aug 2026 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184333;
	bh=tilIhcIkJOC76/K2B7WhRWr6blwCJt6RVnQlspgCzn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsGNhhlcuKL3ctem/YccE9THMU00ui4msXC0WySTUb+qg3b2+CygoCe8PqAhGXkFI
	 7m9mzthJxaNmsqGHq6eNPLi7PgATOU+J02Z2UqOkZgDy+1mpgaHVw0VXUyVC1YoSEq
	 kiAZzmy1J1n6+4V4z75ZKkcRIemjWmT/VRA4QJVSmpO3RMnXVhLLV/zDoxTxIGlfgM
	 ozxkMrGg1esQBhg19JxofyLwrrM395gWgBVAPV1aGUPebkB5DPjjH4UjmV0ULT9upE
	 cvZWMXZj6fok5zWQe2jVflWZeBYd/RocfZpnMqnMppCxq8av7ga3GTpnv1v/TZ1Rab
	 FIcNTSrwlBO7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] crypto: atmel-ecc - add support for atecc608b
Date: Mon, 31 Aug 2026 09:30:59 -0400
Message-ID: <20260831133314.4125787-631-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b668edaf8dcc8d09f6f1e71797422b44d4bd22a3 ]

Tested on hardware with an ATECC608B at 0x60. The device binds
successfully, passes the driver's sanity check, and registers the
ecdh-nist-p256 KPP algorithm.

The hardware ECDH path was also exercised using a minimal KPP test
module, covering private key generation, public key derivation, and
shared secret computation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `crypto: atmel-ecc - add support for
atecc608b`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`, detached
from `stable/linux-6.18.y`)

**Upstream commit:** `b668edaf8dcc8d09f6f1e71797422b44d4bd22a3`
**Candidate commit:** `beb0043891b43` (not yet in current HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[crypto: atmel-ecc] [add] support for atecc608b` —
subsystem is the Atmel ECC crypto driver; verb is “add” (hardware
enablement, not a bug-fix verb).

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Thorsten Blum `<thorsten.blum@linux.dev>` |
| Signed-off-by | Herbert Xu `<herbert@gondor.apana.org.au>` (crypto
maintainer) |
| Fixes: | **Absent** (expected for manual review) |
| Cc: stable | **Absent** (expected) |
| Reported-by: | **Absent** |
| Tested-by: | **Absent** (but commit body describes hardware testing) |
| Link: | **Absent** |

Notable: crypto maintainer Signed-off-by; no syzbot/sanitizer signals.

### Step 1.3: Body Analysis
**Record:**
- **Problem:** ATECC608B secure-element chips are not matched by the
  existing `atmel-ecc` driver; they will not bind/probe.
- **Symptom:** Device at I2C address 0x60 does not get a driver; ECDH
  offload unavailable.
- **Root cause:** Missing OF compatible (`atmel,atecc608b`) and I2C
  device ID (`atecc608b`) in match tables.
- **Verification:** Author tested binding, sanity check, and full ECDH
  KPP path on real hardware.

### Step 1.4: Hidden Bug Fix?
**Record:** **No.** This is explicit hardware enablement via device-ID
tables, not a disguised crash/leak/race fix. The driver logic is
unchanged; only match tables are extended.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/crypto/atmel-ecc.c` | +3 lines |

**Functions modified:** None (only static data tables
`atmel_ecc_dt_ids[]`, `atmel_ecc_id[]`).
**Scope:** Single-file, surgical device-ID addition.

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (OF table):** Before: only `atmel,atecc508a` matched. After:
  also `atmel,atecc608b`.
- **Hunk 2 (I2C ID table):** Before: only `"atecc508a"`. After: also
  `"atecc608b"`.
- **Affected path:** Device enumeration / driver probe only. No change
  to ECDH algorithm code, locking, or error handling.

### Step 2.3: Bug Mechanism
**Record:** **Category: Hardware device-ID addition (not a runtime bug
fix).** ATECC608B is protocol-compatible with the existing driver (same
sanity check, same NIST P-256 ECDH path) but was excluded from match
tables. Without these entries, the kernel never calls
`atmel_ecc_probe()` for this hardware.

### Step 2.4: Fix Quality
**Record:** Obviously correct — standard pattern mirroring the existing
`atecc508a` entry. Minimal risk; no new APIs, no logic changes.
Regression risk: **very low**.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Device-ID tables introduced in `5d324e5159d9e` (Merge tag
`usb-6.18-rc8`, Nov 2025) with only `atecc508a`. No “buggy code” — just
incomplete hardware coverage from initial driver landing.

### Step 3.2: Fixes: Tag
**Record:** **N/A** — no `Fixes:` tag present.

### Step 3.3: Related File History
**Record:** Recent `atmel-ecc.c` history in this tree:
- `9c032781c2b1f` — `crypto: atmel-ecc - Release client on allocation
  failure` (actual bug fix, already in tree)
- `5d324e5159d9e` — driver introduction via usb-6.18-rc8 merge

No prior atecc608b-related commits in HEAD. On `autosel` branch, later
cleanup commits exist (`006bbe8db4c35`, etc.) but are not prerequisites
for this 3-line ID addition.

### Step 3.4: Author Context
**Record:** Thorsten Blum submitted a 2-patch series. Herbert Xu replied
“All applied. Thanks.” Patch 2/2 (`dt-bindings: trivial-devices: add
atmel,atecc608b`) is a separate DT binding commit, not part of this
candidate.

### Step 3.5: Dependencies
**Record:** **Standalone.** No functional dependency on other commits.
Patch applies cleanly to current HEAD (`git apply --check` succeeded).
DT binding patch 2/2 is complementary for DT schema validation but not
required for the driver match tables themselves.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c beb0043891b43` found thread:
https://patch.msgid.link/20260412095642.120815-3-thorsten.blum@linux.dev

Series revisions: v1 (2026-03-30) and RESEND (2026-04-12). Committed
version matches RESEND.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd Herbert Xu, David S. Miller, Nicolas Ferre
(Microchip), Alexandre Belloni, Claudiu Beznea, linux-crypto@, linux-
arm-kernel@, linux-kernel@. Herbert Xu applied the series.

### Step 4.3: Bug Reports
**Record:** **N/A** — no bug report links. Hardware validation described
in commit message.

### Step 4.4: Related Patches
**Record:** Part of `[PATCH RESEND 1/2]` series. Patch 2/2 adds
`atmel,atecc608b` to `Documentation/devicetree/bindings/trivial-
devices.yaml` (Acked-by: Rob Herring). That binding patch is separate;
this driver patch is self-contained.

### Step 4.5: Stable List History
**Record:** **Not searched** — no stable-specific discussion found in
the retrieved thread. Absence of `Cc: stable` is expected and not a
negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** No functions modified. Match tables feed into
`atmel_ecc_driver` → `atmel_ecc_probe()` → `atmel_i2c_probe()` →
`device_sanity_check()`.

### Step 5.2: Callers
**Record:** `atmel_ecc_probe()` is invoked by the I2C core during device
enumeration when OF compatible or I2C device ID matches. Standard probe
path on embedded boards with secure elements.

### Step 5.3: Callees
**Record:** `atmel_i2c_probe()` performs I2C functionality check, clock
validation, and `device_sanity_check()` (verifies config/OTP zones are
locked). Chip-family-agnostic.

### Step 5.4: Reachability
**Record:** Triggered at boot when ATECC608B is present on I2C bus with
matching DT `compatible` or I2C board info. Common on embedded/IoT
platforms (similar boards already use `atmel,atecc508a` in this tree’s
DTS files).

### Step 5.5: Similar Patterns
**Record:** `atmel-sha204a.c` and other Atmel I2C crypto drivers use the
same pattern of multiple compatible strings in OF/I2C tables. ATECC508A
and ATECC608B share the same I2C command protocol for ECDH operations
supported by this driver.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** The **driver exists** in 6.18.43
(`CONFIG_CRYPTO_DEV_ATMEL_ECC`, `drivers/crypto/atmel-ecc.c`). The
**missing device IDs** also exist as a gap — only `atecc508a` is listed;
`atecc608b` is absent. Driver introduced in 6.18 via `5d324e5159d9e`. No
`atecc608b` references anywhere in the tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` on the diff against
current HEAD succeeded with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** `9c032781c2b1f` (allocation-failure leak fix) is already in
tree. No duplicate atecc608b support found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/crypto/` — **IMPORTANT** (hardware crypto offload
for embedded secure elements). Config-dependent
(`CONFIG_CRYPTO_DEV_ATMEL_ECC`).

### Step 7.2: Subsystem Activity
**Record:** Driver is new to 6.18 (landed Nov 2025). Low churn in this
tree since introduction (one bug-fix commit).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of boards with **ATECC608B** secure elements on I2C,
using `CONFIG_CRYPTO_DEV_ATMEL_ECC=m/y`. Currently zero support for this
chip variant in 6.18.y.

### Step 8.2: Trigger Conditions
**Record:** ATECC608B present on I2C bus at boot. Not a security
vulnerability or crash trigger — hardware simply does not bind without
the ID.

### Step 8.3: Failure Mode Severity
**Record:** **LOW** for system stability (no crash/corruption).
**MEDIUM** for functionality — secure-element ECDH offload is completely
unavailable for ATECC608B users on 6.18.y without this patch.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables tested hardware on an existing driver; 3-line
  change.
- **Risk:** Very low — no logic changes, no API changes.
- **Ratio:** Favorable for stable under the device-ID exception
  category.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Trivial I2C/OF device-ID addition to an **existing** driver (explicit
  stable exception category)
- Hardware-tested; crypto maintainer applied and Signed-off-by
- Applies cleanly to 6.18.43
- Driver already present in this tree since 6.18
- Without it, ATECC608B hardware cannot use the driver at all

**AGAINST backport:**
- Not a bug fix (crash/leak/race/security)
- Driver itself is new in 6.18 (limited exposure window)
- Companion DT binding patch (2/2) is separate — needed for full DT
  schema compliance but not for driver functionality
- No user bug reports or syzbot findings

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — hardware tested,
maintainer applied |
| 2. Fixes a real bug? | **PASS via exception** — device-ID addition
enabling hardware that cannot bind otherwise |
| 3. Important issue? | **PASS (moderate)** — hardware non-functional
without it; not crash/security |
| 4. Small and contained? | **PASS** — 3 lines, one file |
| 5. No new features/APIs? | **PASS** — only match table entries; falls
under device-ID exception |
| 6. Can apply to local tree? | **PASS** — clean apply verified |

### Step 9.3: Exception Category
**Record:** **NEW DEVICE IDs** — adding OF compatible and I2C device ID
to an existing driver. The `atmel-ecc` driver is already in 6.18.y; only
the ID for ATECC608B is new.

### Step 9.4: Decision Rationale

This commit does not fix a kernel bug, but it is a textbook stable
exception: a minimal device-ID addition to an existing driver that
enables real hardware already validated by the author and accepted by
the crypto maintainer. The driver is present in 6.18.43, the patch
applies cleanly, and ATECC608B boards cannot use the driver without it.
Risk is negligible.

---

## Verification

- **[Phase 1]** Parsed commit message from `git show beb0043891b43`:
  subject, tags, body analyzed
- **[Phase 2]** Diff analysis: 3 lines added to `atmel-ecc.c` device-ID
  tables only
- **[Phase 3]** `git blame -L 370,390`: tables from `5d324e5159d9e`
  (6.18-rc8 merge)
- **[Phase 3]** `git log -20 -- drivers/crypto/atmel-ecc.c`: driver +
  one prior bug fix in tree
- **[Phase 3]** `git merge-base --is-ancestor 5d324e5159d9e HEAD`:
  driver merge is ancestor — driver exists
- **[Phase 3]** `git apply --check` on commit diff: **applies cleanly**
- **[Phase 4]** `b4 dig -c beb0043891b43`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1 and RESEND revisions found
- **[Phase 4]** `b4 dig -w`: Herbert Xu, linux-crypto@ CC'd
- **[Phase 4]** `b4 dig -m /tmp/atecc608b.mbox`: Herbert Xu “All
  applied. Thanks.”; patch 2/2 identified as DT binding only
- **[Phase 5]** Read `atmel-i2c.c` `device_sanity_check()`: chip-family-
  agnostic sanity check
- **[Phase 5]** Read `atmel_ecc_probe()`: standard probe path, no chip-
  specific branches
- **[Phase 6]** `git describe HEAD` + `make kernelversion`: tree is
  **6.18.43**
- **[Phase 6]** `grep atecc608`: **no matches** in current tree — IDs
  absent
- **[Phase 6]** `grep atecc508`: DTS files and driver present — driver
  exists, only 508a supported
- **[Phase 7]** `Kconfig CRYPTO_DEV_ATMEL_ECC`: driver is tristate,
  depends on I2C
- **[Phase 8]** No crash/corruption path identified; functional gap for
  ATECC608B hardware

**YES****Verdict: YES** — backport to this tree (Linux 6.18.43).

This is a 3-line device-ID addition (`atmel,atecc608b` OF compatible +
I2C ID) to the existing `atmel-ecc` driver. It enables ATECC608B
hardware that otherwise won't bind; it was hardware-tested and accepted
by Herbert Xu. The patch applies cleanly to the current tree.

Note: it's patch 1/2 of a series — patch 2/2 adds the DT binding in
`trivial-devices.yaml` and would be needed separately for full Device
Tree schema compliance.

 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9da5a03880807..8988fc3d8b9fd 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -372,6 +372,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{
 		.compatible = "atmel,atecc508a",
+	}, {
+		.compatible = "atmel,atecc608b",
 	}, {
 		/* sentinel */
 	}
@@ -381,6 +383,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
+	{ "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
-- 
2.53.0

