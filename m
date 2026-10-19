Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A9619B71;
	Mon, 19 Oct 2026 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418662; cv=none; b=EMl80q61umtPTFF2Nk6ZeGwWgjMnTdTPmE478HnZMZs40n8HXtY8xEMrz+YDCzJj6MC1kuoaIBocUdEB0UMQUuk7BI5zYaiVDfLW1S2q9M26P4kE1kmJ4cxBON/4fQcX8jOhSTfebB2y+foY557104NRTyC01RLAm45zKi0vv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418662; c=relaxed/simple;
	bh=0z2iNy/UGHSs+7ImtgF7sSJNQTg60k+TwDSx8ikolsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J88hNT4M9HbGiY/1tfqBiWwNWUzu4q0a8k0lhx/U4QCxZjwrvaEDD124d8Uz494cZVWwb2T5PBN/UBb3tL6PEmU+CdQDD6lHoGTXTo9YIivDOe48mFlLr0J5jf0VuYLxZMW94VRWTLgKZCx+kmbjvTA/hJM3Ry9/i6CZnJNuUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsSd3XlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsSd3XlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0D61F000C4;
	Mon, 19 Oct 2026 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418659;
	bh=5kPxBXRDhMTx10Ww1KxDFhz4iNc8EED+NixLdBgCM7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsSd3XlLsbv2rDVf2+pVRwUK91moTzV5oPKEL3hEWdwWWhqWEkZbyY/QdJvtry62P
	 5CHNSGmZrYEx5NVF4VmJWRNbiY8/9iLDp8Rj9JrSoZtnE4uonYXx7L0OfoLIpwwvmJ
	 SpAlM5SmoytSCMeivTOeNk3OGDyXBBV07JzJS4hOrWrk7trFU4RywsGDidwDf2BK0v
	 YhvpxjRHz8ijPK3U63zoSNX9nCyut1DYki1iUPQ9YSKcWHXxVRxM+vjp1LZeDqsC5H
	 GPCT2sGRRibXJzncCJ6uQPXzIy2qfmKefGmOy0PdHFtz0y1XuxxEl21Usu61juSjGg
	 C4ncoVwxY2N5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Date: Mon, 19 Oct 2026 09:51:37 -0400
Message-ID: <20261019135441.1420968-406-sashal@kernel.org>
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

[ Upstream commit 7064af16d2b418d61571dba9bb0116a547ade124 ]

Use crypto_memneq() for a constant-time comparison.

sa_aead_dma_in_callback() compares the computed authentication tag
against the received tag with memcmp(), which short-circuits on the
first differing byte. An attacker who can submit decrypt requests and
observe completion latency could recover the expected tag byte by byte.

Valid tag forgery for AEAD breaks the INT-CTXT guarantee.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy `memcmp()` of
the AEAD tag is present in `sa_aead_dma_in_callback()`, and this one-
line constant-time swap should be backported here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[crypto: sa2ul]** **[use]** use `crypto_memneq()` to compare
AEAD tag. Subsystem is the TI K3 SA2UL hardware crypto driver. The verb
is “use” with an explicit constant-time replacement; the body describes
a timing leak.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none in the commit; lore found via `b4 dig`
- **Cc: stable:** none (expected)
- **Assisted-by:** `gregkh_clanker_t1000` (tool-assisted; not a quality
  tag)
- **Signed-off-by:** David C.C.M. Gall (author); Herbert Xu (crypto
  maintainer)
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB if present —
  they are not a selection signal

Notable: crypto maintainer SOB after applying v1 unchanged. No syzbot,
no multi-user reports.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `sa_aead_dma_in_callback()` compares the computed AEAD
  authentication tag to the received tag with `memcmp()`, which returns
  on the first mismatched byte.
- **Symptom / failure mode:** An attacker who can submit decrypts and
  observe completion latency can recover the expected tag byte-by-byte
  (timing side channel).
- **Consequence:** Valid tag forgery breaks AEAD **INT-CTXT** (integrity
  of ciphertext).
- **Version info:** none in the message.
- **Root cause:** non-constant-time tag compare on the AEAD decrypt
  completion path.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a hidden fix. This is an explicit crypto-security (timing)
fix, same class as historical `crypto_memneq()` ICV/tag conversions.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/crypto/sa2ul.c` — **+2 / −1** (net +1, 3-line change)
- Functions: include block; `sa_aead_dma_in_callback()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Hunk 1 (include):** add `#include <crypto/utils.h>` so
  `crypto_memneq()` is declared. `include/crypto/utils.h` exists in this
  tree; `crypto/internal/aead.h` already pulls `crypto/algapi.h` →
  `crypto/utils.h`, so the include is explicit but not a functional
  dependency.
- **Hunk 2 (decrypt completion):** on decrypt (`!rxd->enc`), after
  copying the received tag, replace
  `err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0`
  with
  `err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0`.
- Encrypt path is unchanged (it writes the tag out).
  Error/free/`aead_request_complete()` are unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** memory-safety / crypto correctness — **timing side
  channel** on AEAD tag compare (not UAF/leak/lock).
- **Mechanism:** `memcmp()` short-circuits; `crypto_memneq()` is
  documented as comparing without leaking timing
  (`include/crypto/utils.h`). Same boolean sense: 0 = equal, nonzero =
  not equal, so `-EBADMSG` vs `0` is preserved.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: drop-in replacement used throughout the crypto
  stack and other HW AEAD drivers (`talitos`, `atmel-aes`, `nx`, `ccp`,
  etc.).
- Minimal; no API/struct/locking changes.
- Regression risk: **very low**. Slightly more work per decrypt
  (constant-time over `authsize`, typically 12–32 bytes) is negligible
  vs DMA/IRQ.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `memcmp()` introduced in **`d2c8ac187fc92`** (“crypto: sa2ul -
  Add AEAD algorithm support”, Keerthy, 2020-07-23).
- Present since **v5.9-era** driver addition; in this 6.12 tree (`git
  merge-base --is-ancestor d2c8ac187fc92 HEAD` succeeded).
- Blame on the callback still shows that 2020 origin for the compare.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The introducing commit is `d2c8ac187fc92`, and
it **is** in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `sa2ul.c` work here is unrelated (probe pool failure,
fallback names, MODULE_DESCRIPTION, setkey errors). No prerequisite
refactor of the tag compare. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Author is not the subsystem maintainer. Same-day sibling patches
on origin/master: keembay CCM/GCM `crypto_memneq()` conversions
(`353b3a85136f2`, `ff2ac77a034e0`). Herbert Xu applied this series.
Historical precedent in **this** tree: `79960943fdc11` (talitos) and
`cb8affb55c7e6` (nx) — same bug class, both **Cc: stable**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. `crypto_memneq()` lives in `lib/crypto/memneq.c`
(`CRYPTO_LIB_UTILS`, selected by `CRYPTO`). Driver already `select
CRYPTO_ALGAPI`. Patch applies standalone. `git show 7064af16d2b41 | git
apply --check` **exit 0** on this tree. Commit **not** already an
ancestor of HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 7064af16d2b418d61571dba9bb0116a547ade124` →
  https://patch.msgid.link/anX9UKJ66Aak4ICV@fudgebox
- **v1 only** (`b4 dig -a`); committed version is v1.
- Thread: author submission (2026-08-07); Herbert Xu “Patch applied.
  Thanks.” (2026-08-15). **No NAK, no review risk comments, no Cc:
  stable suggestion.**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Herbert Xu, David S. Miller, linux-crypto,
linux-kernel, gregkh@linuxfoundation.org. Subsystem maintainer applied
it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by / Link / bugzilla / syzbot. Bug is from code
review of the `memcmp()` decrypt path, not a field crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Same author, same day: keembay GCM/CCM `crypto_memneq()`
patches. This sa2ul patch is self-contained; keembay is a different
driver and is **not** a prerequisite. keembay is also not in this 6.12
tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org/stable returned an Anubis bot
challenge (HTTP 403 / JS gate). Original linux-crypto thread had no
stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `sa_aead_dma_in_callback()`; `crypto_memneq()` (callee).

**Step 5.2: TRACE CALLERS**

Record:
- Callback assigned in `sa_aead_run()` (`sa_req.callback =
  sa_aead_dma_in_callback`).
- `sa_aead_run()` called from `sa_aead_encrypt()` / `sa_aead_decrypt()`.
- Those are `.encrypt` / `.decrypt` for
  `authenc(hmac(sha1),cbc(aes))-sa2ul` and
  `authenc(hmac(sha256),cbc(aes))-sa2ul` (priority **3000**).
- Completes in DMA RX callback context, then `aead_request_complete()`.

**Step 5.3: TRACE CALLEES**

Record: `sa_sync_from_device`, `dmaengine_desc_get_metadata_ptr`,
`scatterwalk_map_and_copy`, `sa_free_sa_rx_data`,
`aead_request_complete`. After the change, decrypt also calls
`crypto_memneq()`. No new locks or allocations.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable from the kernel crypto AEAD API. Algorithms have
`CRYPTO_ALG_KERN_DRIVER_ONLY` but **not** `CRYPTO_ALG_INTERNAL`.
`KERN_DRIVER_ONLY` means “HW offload, not a CPU ISA helper”
(`include/linux/crypto.h`); AF_ALG even allows that bit in
`salg_feat`/`salg_mask`. Userspace **can** bind these algs when
`CRYPTO_USER_API_AEAD` is enabled. Kernel users (e.g. IPsec ESP with
authenc) can also select this high-priority driver.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same `memcmp`→`crypto_memneq` tag/ICV pattern already used in
`drivers/crypto/talitos.c`, `atmel-aes.c`, `nx-aes-gcm.c`, `nx-aes-
ccm.c`, `ccp-ops.c`, etc. Remaining `memcmp` of auth material in this
tree: `drivers/crypto/qce/aead.c` (different driver). sa2ul had the last
such compare in this file.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/crypto/sa2ul.c` line 1722:

`err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;`

Introduced 2020 (`d2c8ac187fc92`); still here. Tree is 6.12.111.
Upstream fix `7064af16d2b41` is **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` succeeded). Include site
and callback context match origin. `include/crypto/utils.h` exists
(moved in `c616fb0cbae8a`, long before 6.12).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No `crypto_memneq` sa2ul commit in this tree. No alternate tag-
compare fix. nx/talitos timing-leak fixes are already present; they do
not cover sa2ul.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **drivers/crypto/sa2ul.c** — TI K3 Security Accelerator.
**IMPORTANT** for those platforms (crypto offload used by
IPsec/VPN/etc.), **not CORE**. `CONFIG_CRYPTO_DEV_SA2UL` depends on
`ARCH_K3 || COMPILE_TEST`; **`CONFIG_CRYPTO_DEV_SA2UL=m` is in
`arch/arm64/configs/defconfig`**.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver (added 2020). Modest ongoing fixes in 6.12. This
is a long-standing compare bug, not a regression from recent refactor.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / platform-specific:** TI K3 SoCs
(AM62/AM64/AM65, J721e, etc.) with SA2UL AEAD offload enabled. Not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Trigger is **every hardware AEAD decrypt** that takes the non-
fallback path (`sa_aead_dma_in_callback` decrypt branch). Userspace can
hit it via AF_ALG if user-API AEAD is enabled; kernel IPsec/authenc can
hit it without userspace crypto. Timing exploitation needs many decrypts
plus latency observation — classic, not a one-shot crash. Unprivileged
trigger is possible where AF_ALG AEAD is exposed.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure mode:** timing leak of the expected authentication tag →
  theoretical **tag forgery**, breaking AEAD integrity.
- **Severity: HIGH** (crypto integrity / security). Not a panic/UAF.
  DMA/IRQ noise makes a practical oracle harder than a userspace
  `memcmp` of a hot buffer, but the kernel crypto API treats non-
  constant-time ICV checks as real bugs (talitos/nx were Cc: stable for
  the same reason). `crypto_memneq()` exists specifically for this.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** closes a known AEAD INT-CTXT hole on a defconfig-enabled
  ARM64 HW driver; matches established crypto policy.
- **Risk:** very low (one compare + include; return-value polarity
  matches).
- **Ratio:** benefit > risk for this stable tree.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real AEAD tag compare uses variable-time `memcmp()` on decrypt
  complete.
- Breaks INT-CTXT if exploited; same class previously backported
  (talitos, nx) with Cc: stable.
- Buggy code has been in this file since 2020 and is in 6.12.111.
- 3-line, obviously correct, applies cleanly; `crypto_memneq()` already
  in this tree.
- Crypto maintainer applied v1 with no objections.
- Driver is in arm64 defconfig; path is a real decrypt completion, not
  dead code.

**AGAINST:**
- No user report / CVE / syzbot.
- Practical timing through DMA+IRQ is noisy (harder oracle than a tight
  userspace loop).
- Affects TI K3 SA2UL users, not all 6.12 systems.
- No explicit Cc: stable (not a negative per the review rules).

**UNRESOLVED:**
- Whether this SHA was already discussed on stable@ (lore blocked).
- No measured exploit against sa2ul specifically.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — drop-in `crypto_memneq()`;
   maintainer applied; API used kernel-wide.
2. Fixes a real bug that affects users? **PASS** — non-constant-time
   AEAD tag verify on HW decrypt.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   security (AEAD integrity / timing). Severity HIGH, not a panic.
4. Small and contained? **PASS** — 3 lines, one file, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply; helpers present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID / quirk / DT / build / docs exception. Qualifies
as a **small security correctness fix**.

**Step 9.4: MAKE YOUR DECISION**

This is a surgical, low-risk fix for a real AEAD tag timing leak in code
that exists in 6.12.111. Stable policy has historically taken this exact
class of change. Backport to this tree.

---

### What the commit solves for stable users

On TI K3 boards using SA2UL AEAD offload, decrypt completion compared
the computed MAC to the packet tag with `memcmp()`. That can leak how
many leading tag bytes matched via completion latency and, in the
standard model, enable tag forgery (INT-CTXT failure). Replacing it with
`crypto_memneq()` makes the compare constant-time without changing
success/failure semantics.

### Stable rules / risk vs benefit

Meets all six criteria: small, obviously correct, no new API, applies
cleanly here, fixes a crypto-integrity bug. Risk is essentially the cost
of a 16–32 byte constant-time XOR loop. Benefit is aligning this long-
lived driver with the rest of the crypto stack.

### Concerns

None that block backport: no missing prereqs, no follow-up that rewrote
the callback, include header already in 6.12. Practical exploitability
is not proven in the field; that does not make the compare correct.

---

Verification:
- [Phase 1] Parsed subject/tags/body from `git show 7064af16d2b41`; no
  Fixes/Reported-by/Cc: stable; SOB Herbert Xu; Assisted-by
  gregkh_clanker_t1000
- [Phase 2] Diff: `drivers/crypto/sa2ul.c` +2/−1; include
  `crypto/utils.h`; `memcmp` → `crypto_memneq` in
  `sa_aead_dma_in_callback` decrypt branch
- [Phase 2] Confirmed `crypto_memneq` returns 0 if equal, 1 otherwise
  (`include/crypto/utils.h` lines 56–70) — same ternary as `memcmp`
- [Phase 3] `git describe HEAD` / Makefile: **6.12.111**, branch
  `pending-6.12`
- [Phase 3] `git merge-base --is-ancestor 7064af16d2b41 HEAD` → not
  ancestor; `d2c8ac187fc92` **is** ancestor
- [Phase 3] `git log origin/master -S 'memcmp(&mdptr[4]' --
  drivers/crypto/sa2ul.c` → intro `d2c8ac187fc92`, fix `7064af16d2b41`
- [Phase 3] Blame on local callback: memcmp path from 2020 AEAD add
- [Phase 3] Same-class stable precedent in this tree: `79960943fdc11`
  (talitos), `cb8affb55c7e6` (nx), both Cc: stable
- [Phase 3] `git apply --check` of `7064af16d2b41` → success
- [Phase 4] `b4 dig -c/-a/-w/-m`: lore
  https://patch.msgid.link/anX9UKJ66Aak4ICV@fudgebox ; v1 only; Herbert
  “Patch applied”; To linux-crypto + Herbert
- [Phase 4] WebFetch lore 403; stable@ search blocked by Anubis —
  UNVERIFIED for stable-list history
- [Phase 5] Callers: `sa_aead_run` ←
  `sa_aead_encrypt`/`sa_aead_decrypt`; algs
  `authenc(hmac(sha1|sha256),cbc(aes))-sa2ul`
- [Phase 5] `CRYPTO_ALG_KERN_DRIVER_ONLY` is not `CRYPTO_ALG_INTERNAL`;
  AF_ALG allows that flag (`crypto/af_alg.c`)
- [Phase 5] Other drivers already use `crypto_memneq` for AEAD tags
  under `drivers/crypto/`
- [Phase 6] Local line 1722 still `memcmp`; `include/crypto/utils.h`
  present; `CRYPTO` selects `CRYPTO_LIB_UTILS`; `lib/crypto/memneq.c`
  exports `__crypto_memneq`
- [Phase 6] `arch/arm64/configs/defconfig` has
  `CONFIG_CRYPTO_DEV_SA2UL=m`
- [Phase 7] Driver added 2020 (`7694b6ca649fe`); Kconfig
  `CRYPTO_DEV_SA2UL` depends on `ARCH_K3`
- [Phase 8] Failure mode: AEAD tag timing leak / INT-CTXT, severity
  HIGH; apply risk very low
- UNVERIFIED: stable@ mailing list discussion; real-world exploit of
  this specific DMA-callback timing channel

**YES**

 drivers/crypto/sa2ul.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 73034aeb63862..4a766e4351970 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <crypto/des.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
@@ -1688,7 +1689,7 @@ static void sa_aead_dma_in_callback(void *data)
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
 
-		err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
+		err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
 	sa_free_sa_rx_data(rxd);
-- 
2.53.0

