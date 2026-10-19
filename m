Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8B5FB7F4;
	Mon, 19 Oct 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418565; cv=none; b=TX19DjZVNDeXPOQ9CpUsIxAiDosuCRvmJ6PCGRNkosvhtbnKmUtTcJ/qmWDrcu86/aDVwjzNglOKPksk6QHzTKQ3ODEQsreB+4PXi7PgQR+pQHMw1TUTdcegqXyHfw/hZDkvkBMfdgFj18ItCvjMoG06ttVJCfa1SRLuGdZzSaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418565; c=relaxed/simple;
	bh=rPijLTgEU/HPxxMVnqsn55pq5Q4ADZIvEwbVx+Jk+1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omC/Tu4dHlTrOV0J5AuDua0+Nt+uv8o4f4UsiaOMq6hwV2CWCfL3pgPc0sx7bGUWQF2KhA8xpEh3H1mUNZQ99dIwiJ/fcvTMwoHCLvH37B8Aa2V2x5bTxEtjJ1Nt7Ia6OSSU1uBvmBqRSKC1pg48DVrmY6wc0+NL5E04ekpraKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/IO6eS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/IO6eS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBD1F000C5;
	Mon, 19 Oct 2026 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418563;
	bh=ndsJzAFZinq7aVz+7uYVtCWQJVH6q6Uq9tP8Yix12pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/IO6eS/S6r+K6ttKa7/a1O1PyeDpq/xZz8y8ATx+o7q+lB4Yq4wcghzw7QAYf31d
	 6+XedcVAqqrNvUzbZ0BNltJ2+wDo8WEVsnCzgULXN+gbvCZ0ru3uXDtkXr7I2Tq9J0
	 cP5rZ+LKWyHkoaXgD6Kstc1++zQ/G3znsx73RmfYdsBVqkiPENpvIyERF2Zn314cnL
	 YnJ53OZITR/s6vZ6LfgNB7HsoVhIANQk7WElcrf7X3VMj9e/S9t//EegRFEqVAUTgy
	 sLkGxjAW7fNylcQZDVGm+sZqvbWa0x6TqkEHV9lS16bYxyaicOJ3FvxvcL7cOsOFW/
	 Xl1PdYZJquYew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] crypto: keembay - use crypto_memneq() to compare CCM AEAD tags
Date: Mon, 19 Oct 2026 09:50:28 -0400
Message-ID: <20261019135441.1420968-337-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>

[ Upstream commit ff2ac77a034e03b64e2ba34f775097427dfa5547 ]

Use crypto_memneq() for constant-time comparison.

The CCM path in ocs-aes.c verifes the received authentication tag with
memcmp(), which returns early on the first mismatched byte. This leaks
valid-prefix length and allows for valid tag forgery which violates the
INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
Record: **[crypto/keembay] [use] replace `memcmp()` with
`crypto_memneq()` when comparing CCM AEAD tags.**
Subsystem prefix `crypto: keembay`. Verb is “use”, but the body is an
explicit security fix (constant-time compare).

**Step 1.2 — Tags**
Record:
- **Assisted-by:** gregkh_clanker_t1000
- **Signed-off-by:** David C.C.M. Gall `<david.ccm.gall@googlemail.com>`
  (author)
- **Signed-off-by:** Herbert Xu `<herbert@gondor.apana.org.au>` (crypto
  maintainer; applied the patch)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected; not a negative)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link**

SHA on `origin/master` (Linus):
`ff2ac77a034e03b64e2ba34f775097427dfa5547`. Contained in `v7.3-rc1`.
Parent is the sibling GCM patch `353b3a85136f2`.

**Step 1.3 — Body**
Record:
- **Bug:** CCM decrypt in `ocs-aes.c` compares the authentication tag
  with `memcmp()`, which returns on the first mismatched byte.
- **Symptom / failure mode:** timing leak of the matching-prefix length;
  that can be used to forge a valid tag and **violates AEAD INT-CTXT**.
- **Root cause:** variable-time compare on a secret authentication tag.
- **Version info in message:** none. Bug is in the original driver
  (2020).

**Step 1.4 — Hidden bug fix?**
Record: **No disguise.** This is an explicit crypto-security fix, same
class as software `crypto/ccm.c` and other HW drivers that already use
`crypto_memneq()`.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/crypto/intel/keembay/ocs-aes.c` (**+2 / −1**)
- Functions: `ccm_compare_tag_to_yr()`; plus `#include <crypto/utils.h>`
- Scope: **single-file surgical fix**

**Step 2.2 — Code flow**
Record:
- **Before:** after CCM decrypt, hardware tag (`AES_T_MAC_*`) and `Yr`
  (`AES_MULTIPURPOSE2_*`) are compared with `memcmp()`; mismatch →
  `-EBADMSG`.
- **After:** same compare, same return values, but `crypto_memneq()`
  runs in constant time.
- Path: **normal CCM decrypt completion**, not an error/init-only path.

Verified in this tree at `ccm_compare_tag_to_yr()`:

```1285:1285:drivers/crypto/intel/keembay/ocs-aes.c
        return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
```

Called at the end of `ocs_aes_ccm_op()` on decrypt only.

`crypto_memneq()` in this tree returns 0 if equal, 1 otherwise
(`include/crypto/utils.h`), so the ternary is equivalent to `memcmp`’s
zero/non-zero sense.

**Step 2.3 — Bug mechanism**
Record: **[Memory safety / crypto side-channel]** — variable-time tag
compare. Fix is the standard constant-time helper. Not a
leak/UAF/race/NULL-deref.

**Step 2.4 — Fix quality**
Record: **Obviously correct and minimal.** Same pattern as
`crypto/ccm.c` (`crypto_memneq(authtag, odata, authsize)`) and HW
drivers (`talitos`, `nx`, `atmel-aes`, `stm32-cryp`, …).
Regression risk: **very low**. Semantics of success/fail are unchanged.
`CRYPTO` already `select CRYPTO_LIB_UTILS`, which builds
`lib/crypto/memneq.c`.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: buggy `memcmp` introduced in
**`88574332451380f4b51f6ca88ab9810e714bfb9b`** (“crypto: keembay - Add
support for Keem Bay OCS AES/SM4”, Mike Healy, 2020-11-26). Present
since **v5.11**. `git merge-base --is-ancestor 8857433245138 HEAD` →
**yes**. Unchanged until this candidate.

**Step 3.2 — Fixes: tag**
Record: **N/A** (no Fixes: tag). Introducing commit is the original
driver add, and it **is** in this tree.

**Step 3.3 — File history in this tree**
Record: recent keembay work is DMA/probe/unregister fixes, not tag
compare. No prior memneq fix here.
Series: **patch 2/2**. Sibling **1/2** (`353b3a85136f2`) changes GCM
`memcmp` in `keembay-ocs-aes-core.c` only. **Not a prerequisite** for
this CCM hunk.

**Step 3.4 — Author**
Record: David C.C.M. Gall — two keembay memneq commits on
`origin/master` (GCM + CCM). Not the subsystem maintainer. **Herbert Xu
applied both.**

**Step 3.5 — Dependencies**
Record: needs `crypto_memneq` / `include/crypto/utils.h`. Header added
in `c616fb0cbae8a` (2023); **in this 6.12 tree**.
`include/crypto/algapi.h` already includes `crypto/utils.h`. **Applies
standalone.** `git apply --check` succeeded (hunks at offset −1).

Precedent already in this tree (explicitly Cc: stable):
- `79960943fdc11` crypto: talitos — timing leak in ESP ICV
- `cb8affb55c7e6` crypto: nx — timing leak in GCM/CCM decrypt

---

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c ff2ac77a034e03b64e2ba34f775097427dfa5547` →
  https://patch.msgid.link/anYGKPaCNBgACGqK@david.gall
- Direct lore.kernel.org fetch returned **403** (Anubis). Thread also at
  https://lkml.iu.edu/hypermail/linux/kernel/2608.0/14033.html and
  https://lists.openwall.net/linux-kernel/2026/08/07/1640
- `b4 dig -a`: **v1 only** (no v2/v3). Committed diff matches v1.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Herbert Xu, David S. Miller, linux-crypto, linux-kernel, gregkh.
**Crypto maintainer was To:’d.**

**Step 4.3 — Bug report**
Record: **no user/syzbot/bugzilla report.** Issue is from code review of
`memcmp` on AEAD tags.

**Step 4.4 — Series**
Record: **[PATCH 1/2]** GCM in `keembay-ocs-aes-core.c`; **[PATCH 2/2]**
this CCM change. Independent files. Herbert (2026-08-14): **“All
applied. Thanks.”** No NAK.

**Step 4.5 — Stable list**
Record: no evidence this patch was discussed on `stable@`. WebSearch on
lore.kernel.org/stable did not find a keembay/`crypto_memneq` thread.
**Unverified beyond that** because lore.kernel.org returned 403.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `ccm_compare_tag_to_yr()` (modified). Callers/callees below from
this checkout.

**Step 5.2 — Callers**
Record:
- `ccm_compare_tag_to_yr()` ← `ocs_aes_ccm_op()` (decrypt only, line
  1398)
- `ocs_aes_ccm_op()` ← `kmb_ocs_aead_run()` when `rctx->mode ==
  OCS_MODE_CCM`
- `kmb_ocs_aead_run()` ← `kmb_ocs_aes_aead_do_one_request()` (crypto-
  engine `do_one_request`)
- Engine request queued from `kmb_ocs_aead_common()` ← CCM
  encrypt/decrypt for AES and SM4 (`ccm(aes)`, `ccm(sm4)`)

**Step 5.3 — Callees**
Record: `ioread32()` of tag/`Yr` registers, then compare. No alloc/lock
change.

**Step 5.4 — Reachability**
Record: reachable on **Keem Bay OCS CCM decrypt**
(`CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4`, `ARCH_KEEMBAY ||
COMPILE_TEST`). Algs are `CRYPTO_ALG_KERN_DRIVER_ONLY` (HW, not a CPU
ISA). Still used by in-kernel CCM consumers on that SoC (e.g. 802.11
CCMP-style CCM). Trigger is **every CCM decrypt**, not a rare error
path.

**Step 5.5 — Similar patterns**
Record: same driver still has GCM `memcmp` at `keembay-ocs-aes-
core.c:922` (sibling 1/2, not in this tree). Software CCM/GCM and many
HW drivers already use `crypto_memneq()`.

---

## Phase 6: This checkout (6.12.y)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree: **`pending-6.12` / 6.12.111**
(`p-6.12-3-gc504cf0baa3d8`).
`git merge-base --is-ancestor ff2ac77a034e0 HEAD` → **not in this
tree**.
`memcmp` still at `ocs-aes.c:1285`. Bug since v5.11.

**Step 6.2 — Backport difficulty**
Record: **clean apply** (`git apply --check`: both hunks succeed, offset
−1). `#include <crypto/utils.h>` exists here.

**Step 6.3 — Related fixes already here?**
Record: **No** keembay memneq fix. GCM sibling also absent. talitos/nx
timing-leak fixes **are** already here (same class, different drivers).

---

## Phase 7: Subsystem / maintainer

**Step 7.1**
Record: **crypto HW driver** (`drivers/crypto/intel/keembay/`).
Criticality: **PERIPHERAL** for population (Intel Movidius Keem Bay
only), but the bug is a **real AEAD security property break**.

**Step 7.2**
Record: modest activity (DMA/probe/unregister). Tag-compare code has
been **stable since 2020**.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: **platform-specific** — Keem Bay OCS AES/SM4 CCM decrypt
(`ccm(aes)` / `ccm(sm4)`).

**Step 8.2 — Trigger**
Record: every HW CCM decrypt. Timing-dependent. Unprivileged remote
trigger depends on what uses CCM on that SoC (e.g. wireless); not a
generic syscall UAF. **Security-relevant where CCM is used.**

**Step 8.3 — Failure mode**
Record: **timing leak → possible tag forgery / INT-CTXT break.**
Severity: **HIGH** (crypto integrity), not a panic. Incorrect
accept/reject is not the bug; **secret-dependent runtime** is.

**Step 8.4 — Risk vs benefit**
Record: **Benefit: HIGH for Keem Bay CCM users** (closes a well-known
AEAD side channel). **Risk: very low** (2 lines, equivalent control
flow, helper already in 6.12). Ratio favors backport.

---

## Phase 9: Synthesis

**Evidence FOR**
- Real AEAD security bug (INT-CTXT / tag-forgery via timing), not
  cleanup.
- Buggy `memcmp` is in **this** 6.12 tree since v5.11.
- 2-line, obviously correct swap to `crypto_memneq()`; same as in-tree
  `crypto/ccm.c` and Cc:stable talitos/nx fixes.
- `crypto_memneq` / `crypto/utils.h` already present; patch applies
  cleanly.
- Applied by crypto maintainer Herbert Xu; no NAK.
- Independent of series patch 1/2 (GCM file).

**Evidence AGAINST**
- Niche SoC (`ARCH_KEEMBAY`).
- No field/syzbot report.
- LLM-assisted tag in the message (does not change the correctness of
  the 2-line swap).
- Remaining GCM `memcmp` is a **separate** candidate, not a reason to
  skip CCM.

**Unresolved**
- Full lore.kernel.org thread body (403). Confirmed via b4 dig,
  lkml.iu.edu, openwall, and Herbert’s “All applied.”
- Practical exploitability over MMIO+DMA noise: **unverified**; kernel
  policy still requires constant-time tag compare.

**Stable rules**
1. Obviously correct and tested? **PASS** — semantic equivalent;
   maintainer applied; helper is the documented API.
2. Real user-facing bug? **PASS** — AEAD decrypt tag check.
3. Important (security)? **PASS** — INT-CTXT / timing side channel.
4. Small/contained? **PASS** — +2/−1, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — `git apply --check` succeeded.

**Exception category:** none required; this is a small security fix.

This should be backported to **this** 6.12 tree: the bug is present, the
fix is the standard one-line compare change plus the existing header,
and it does not need the GCM sibling.

### What it solves for stable users
On Keem Bay, CCM decrypt used `memcmp()` on the authentication tag. That
can leak how many tag bytes matched and weakens AEAD integrity.
`crypto_memneq()` makes the compare constant-time. Same class of fix
already shipped in this tree for talitos and nx.

### Risk vs benefit
Benefit is closing a crypto integrity side channel on a path that runs
on every CCM decrypt. Risk is a two-line, behavior-preserving change
using an API already built via `CRYPTO` → `CRYPTO_LIB_UTILS`.

---

## Verification
- **[Phase 1]** Parsed tags from `git show ff2ac77a034e0` on
  origin/master: Assisted-by clanker; SOB Gall + Herbert Xu; no
  Fixes/Cc:stable/Reported-by.
- **[Phase 1]** `git describe HEAD` / Makefile: **6.12.111**, branch
  `pending-6.12`.
- **[Phase 2]** Diff: +`#include <crypto/utils.h>`, `memcmp` →
  `crypto_memneq` in `ccm_compare_tag_to_yr()`. `crypto_memneq` contract
  verified in `include/crypto/utils.h`.
- **[Phase 2]** Local `ocs-aes.c:1285` still uses `memcmp`.
- **[Phase 3]** `git blame -L 1269,1286`: `8857433245138` (v5.11 driver
  add). Ancestor of HEAD: yes. Candidate SHA ancestor of HEAD: **no**.
- **[Phase 3]** `c616fb0cbae8a` (`crypto/utils.h`) is ancestor of HEAD.
- **[Phase 3]** Sibling GCM `353b3a85136f2` not in HEAD; touches a
  different file.
- **[Phase 3]** In-tree timing-leak precedent: `79960943fdc11`
  (talitos), `cb8affb55c7e6` (nx), both Cc: stable.
- **[Phase 4]** `b4 dig -c/-a/-w`: v1 only; lore msgid
  `anYGKPaCNBgACGqK@david.gall`; To/Cc Herbert, davem, linux-crypto,
  gregkh.
- **[Phase 4]** Herbert “All applied. Thanks.” on the 1/2 GCM post
  (lkml.iu.edu 2608.1/13636).
- **[Phase 4]** lore.kernel.org WebFetch: **403**. Stable-list search:
  no keembay hit found.
- **[Phase 5]** Call chain read in `keembay-ocs-aes-core.c`: CCM
  `kmb_ocs_aead_common` → engine → `kmb_ocs_aead_run` → `ocs_aes_ccm_op`
  → `ccm_compare_tag_to_yr`.
- **[Phase 5]** Remaining GCM `memcmp` at `keembay-ocs-aes-core.c:922`.
- **[Phase 6]** `git apply --check` of `ff2ac77a034e0`: hunks succeed at
  offset −1.
- **[Phase 6]** `CRYPTO` selects `CRYPTO_LIB_UTILS`;
  `lib/crypto/memneq.c` present.
- **[Phase 7]** `ARCH_KEEMBAY` = Intel Movidius Keem Bay; driver
  `depends on ARCH_KEEMBAY || COMPILE_TEST`.
- **[Phase 8]** Algs `ccm(aes)` / `ccm(sm4)` with
  `CRYPTO_ALG_KERN_DRIVER_ONLY` verified in `keembay-ocs-aes-core.c` /
  `include/linux/crypto.h`.
- **UNVERIFIED:** practical remote exploitability of this MMIO-backed
  `memcmp`; full lore HTML (403).

**YES**

 drivers/crypto/intel/keembay/ocs-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/ocs-aes.c b/drivers/crypto/intel/keembay/ocs-aes.c
index bb6f33f6b4d39..13ba7573617fe 100644
--- a/drivers/crypto/intel/keembay/ocs-aes.c
+++ b/drivers/crypto/intel/keembay/ocs-aes.c
@@ -17,6 +17,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/gcm.h>
+#include <crypto/utils.h>
 
 #include "ocs-aes.h"
 
@@ -1283,7 +1284,7 @@ static inline int ccm_compare_tag_to_yr(struct ocs_aes_dev *aes_dev,
 				 (i * sizeof(u32)));
 	}
 
-	return memcmp(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
+	return crypto_memneq(tag, yr, tag_size_bytes) ? -EBADMSG : 0;
 }
 
 /**
-- 
2.53.0

