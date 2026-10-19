Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3C95013C5;
	Mon, 19 Oct 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418564; cv=none; b=M4clttfVdel4hzROTGEaZJJ1HLiEYpuH6UFhTSKzTc31Xa56uxokuUFgA1jhyx+epHTHvznC0jHfLKpWAxqKRcPIcbA/A0jwyGOurVkvUoQAZg07Aky8inePZJCVMyzK3J3Q/Vr7qXq6xwPfMV2H7zjcnzHG0QM3/wI6JbAsPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418564; c=relaxed/simple;
	bh=4POMTHIBvXg/SOR+I7AJ8SqBO6G/q9XaINZnLi7s2r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VcqMCK+NhZsb+m+Xdugs06T+4LyFfN2iugJDA7t4B+eO+OjzFtQLQtRygniPL4rs5cPn3qdtu8Y7eRkbXA5mVcLROjFrK9NnwjPmYonGorlKoXu/UWAltdk2dz1go69rza3ALf2Q4mp06H07hr+nfCrXWHLoHfKmDS5VdWRhgk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjwnI7Tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjwnI7Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894ED1F000C6;
	Mon, 19 Oct 2026 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418562;
	bh=Bu9DY7uZLrLR+Lg00GYJm3JAD91N7dPD8oGSr501Bqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjwnI7TcgPZGLjmBUM/0e/ASPPp49tO16upUy1A7fmEOf56lKkqzu3w7O0GtDHi5C
	 aESiGmGmRrbiHWkcCSIv7K/J1D1YTPtEfuAu1uKgav+6BdUqILJZSGFVBHbSlqsqa1
	 KUnQjLSBdjKFM4hBehpIWS8pmP3i3RXHeSSfBFGvaouH7e4JPE6E622+xSHp2LjpwE
	 tzBGHtoP78IhJTZ1vVbKcHSuUMKFy6xPRf783QmHQsC9xQfGZ+aXbCxha2lCcIKWqU
	 ymKKs9uD9teIczPvXKy8CgOTWsv5if84aw8zsE+99Mf2Jg1RghR+t3T/4XCafH0CqD
	 v1sNbyUarhcUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] crypto: keembay - use crypto_memneq() to compare GCM AEAD tags
Date: Mon, 19 Oct 2026 09:50:27 -0400
Message-ID: <20261019135441.1420968-336-sashal@kernel.org>
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

[ Upstream commit 353b3a85136f2a0cf3e872acf8ad6c1dec0b7a8e ]

Use crypto_memneq() for constant-time comparison.

The GCM path in keembay-ocs-aes-core.c verifes the received
authentication tag with memcmp(), which returns early on the first
mismatched byte. This leaks valid-prefix length and allows for valid
tag forgery which violates the INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 3-line constant-time tag compare for Keem Bay GCM decrypt. The
local tree is **6.12.111** (`pending-6.12`, `p-6.12-3-gc504cf0baa3d8`).
The buggy `memcmp()` is present; the candidate is not.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[crypto: keembay] [use] [replace memcmp with crypto_memneq for
GCM AEAD tag compare]`

- Subsystem: `crypto: keembay` (Intel Keem Bay OCS AES driver)
- Action verb: **use** (the body is a security fix: constant-time
  compare)
- Intent: stop early-exit `memcmp()` from leaking valid-tag prefix
  length

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected)
- **Assisted-by:** gregkh_clanker_t1000
- **Signed-off-by:** David C.C.M. Gall `<david.ccm.gall@googlemail.com>`
  (author)
- **Signed-off-by:** Herbert Xu `<herbert@gondor.apana.org.au>` (crypto
  maintainer, applied it)

SHA: `353b3a85136f2a0cf3e872acf8ad6c1dec0b7a8e`
AuthorDate: 2026-08-07. No syzbot, no multi-reporter pattern.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** GCM decrypt checks the received auth tag with `memcmp()`,
  which returns on the first mismatch.
- **Symptom/failure mode:** timing leak of matching-prefix length; that
  leak can be used to forge a valid tag and break AEAD **INT-CTXT**
  (integrity of ciphertext).
- **Version info:** none in the message.
- **Root cause (author):** non-constant-time compare of `in_tag` vs
  `out_tag`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. It is an explicit crypto security fix (timing side
channel / AEAD integrity), even without the word “fix” in the subject.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/crypto/intel/keembay/keembay-ocs-aes-core.c` (+2 / −1)
- Functions: `#include` plus `kmb_ocs_aead_run()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Include hunk:** adds `#include <crypto/utils.h>` (declares
  `crypto_memneq()`).
- **Compare hunk (GCM decrypt only):** after `ocs_aes_gcm_op()`, if
  `rctx->instruction == OCS_DECRYPT`:
  - Before: `rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?
    -EBADMSG : 0;`
  - After: `rc = crypto_memneq(rctx->in_tag, rctx->out_tag, tag_size) ?
    -EBADMSG : 0;`
- Encrypt path, CCM path, and DMA cleanup are unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** cryptographic timing / logic correctness (not UAF, leak,
  race).
- **Mechanism:** `memcmp()` is not constant-time. `crypto_memneq()` is
  (`lib/crypto/memneq.c`, `noinline`). Both treat 0 as equal, so
  `-EBADMSG` vs `0` is unchanged; only timing changes.

CCM still uses `memcmp()` in `ocs-aes.c:ccm_compare_tag_to_yr()`; that
is a sibling patch (`ff2ac77a034e0`), not a dependency of this one.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: one-for-one substitution with the API crypto
  drivers already use for MAC/tag compares (`talitos`, `nx`, `atmel-
  aes`, `stm32-cryp`, etc. in this tree).
- Minimal; no API/data-structure change.
- Regression risk: very low. Return mapping matches. `crypto_memneq` is
  slightly slower by design (no early exit); that is the fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Introduced in `88574332451380f4b51f6ca88ab9810e714bfb9b` (“crypto:
  keembay - Add support for Keem Bay OCS AES/SM4”), 2020-12-11, Mike
  Healy.
- Original hunk: `rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?`
- Present since **v5.11** (`git merge-base --is-ancestor` vs `v5.10`
  fails, vs `v5.11` succeeds). Long-standing, not recent.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Functionally this fixes the original driver
commit `8857433245138`, which **is** an ancestor of this 6.12 HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (this tree, that file): OF alias, IRQ completion init, AEAD
unregister count, platform-remove conversion, crypto_engine_op,
prepare/unprepare removal, path move. None of those change the GCM
`memcmp`. Standalone vs the CCM sibling (patch 2/2, different file).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: David C.C.M. Gall is not the keembay maintainer. On `crypto-
next` the same author has a batch of `crypto_memneq` conversions:
keembay GCM, keembay CCM, sa2ul, octeontx, octeontx2, ccree. Crypto
maintainer Herbert Xu applied this one.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `crypto_memneq` / `crypto/utils.h` — both exist here
  (`include/crypto/utils.h`, `lib/crypto/memneq.c`).
- `crypto/internal/aead.h` already includes `crypto/algapi.h` →
  `crypto/utils.h`, so the extra include is redundant but matches
  mainline and is harmless.
- No prerequisite series beyond this one hunk. `git apply --check` of
  `353b3a85136f2` succeeded on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 353b3a85136f2`:
  https://patch.msgid.link/anYEQOzunX0Lm3N1@david.gall
- `b4 dig -a`: single revision, **v1** `[PATCH 1/2]`. No v2/v3.
- Saved thread `/tmp/keembay-gcm-memneq.mbox` (2 messages).
- Herbert Xu (2026-08-15): “All applied. Thanks.” No NAK, no review
  nits, **no Cc: stable**.
- Direct lore WebFetch returned 403; discussion taken from the b4 mbox.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Herbert Xu, David S. Miller, linux-crypto,
linux-kernel, gregkh@linuxfoundation.org. Subsystem maintainer was
included and applied the patch. No Reviewed-by tags.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by, no syzbot, no bugzilla. Issue is from code
review / known `memcmp`-vs-MAC pattern, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series is 2/2. Patch 2 is CCM `memcmp` in `ocs-aes.c`.
Independent of this GCM change. Same pattern as historical stable-bound
fixes:
- `79960943fdc11` crypto: talitos - Fix timing leak in ESP ICV
  verification (`Cc: stable`)
- `cb8affb55c7e6` crypto: nx - Fix timing leak in GCM and CCM decryption
  (`Cc: stable`)

Both are already ancestors of this 6.12 HEAD.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch returned 403. **UNVERIFIED**
whether anyone already asked for this on stable@. Original crypto thread
has no stable nomination.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

No semcode MCP tools. Used grep + file reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `kmb_ocs_aead_run()` (only runtime change).

**Step 5.2: TRACE CALLERS**

Record:
- `kmb_ocs_aes_aead_do_one_request()` → `kmb_ocs_aead_run()`
- Engine op `.do_one_request` for `gcm(aes)`, `ccm(aes)`, `gcm(sm4)`,
  `ccm(sm4)`
- Encrypt/decrypt entry: `kmb_ocs_aes_gcm_decrypt` /
  `kmb_ocs_sm4_gcm_decrypt` → `kmb_ocs_aead_common()` →
  `crypto_transfer_aead_request_to_engine()`
- CCM returns before the changed lines; only GCM decrypt hits
  `memcmp`/`crypto_memneq`.

**Step 5.3: TRACE CALLEES**

Record: After `ocs_aes_gcm_op()`, compare tags, then
`kmb_ocs_aead_dma_cleanup()`. No extra alloc/lock from this hunk.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Registered as `gcm(aes)` / `gcm(sm4)` with priority 350.
- `CRYPTO_ALG_KERN_DRIVER_ONLY` means HW accel not via a userspace ISA;
  it is **not** `CRYPTO_ALG_INTERNAL`. `af_alg.c` allows that flag, so
  AF_ALG can still select the driver.
- Also used by in-kernel AEAD (IPsec, TLS, etc.) when this HW is chosen.
- Path is reachable whenever Keem Bay OCS AES is enabled and GCM decrypt
  runs.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Remaining `memcmp` in this driver is CCM (`ocs-aes.c:1285`),
sibling commit. Other HW AEAD drivers in this tree already use
`crypto_memneq`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/crypto/intel/keembay/keembay-ocs-aes-
core.c:922` still has `memcmp(rctx->in_tag, rctx->out_tag, tag_size)`.
Introduced v5.11; present in 6.12. Candidate is **not** an ancestor of
HEAD (`git merge-base --is-ancestor 353b3a85136f2 HEAD` failed).
Kconfig: `CRYPTO_DEV_KEEMBAY_OCS_AES_SM4` depends on `ARCH_KEEMBAY ||
COMPILE_TEST`. `ARCH_KEEMBAY` exists (`arch/arm64/Kconfig.platforms`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding GCM decrypt block matches the
patch. `crypto/utils.h` exists.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No keembay `crypto_memneq` commit in this tree. GCM `memcmp`
still there.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record:
- Subsystem: `drivers/crypto/intel/keembay` (platform crypto
  accelerator)
- Criticality: **PERIPHERAL** for most 6.12 users (Keem Bay / Movidius
  SoC only), but the bug is a real AEAD integrity issue for those users.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver (2020). Recent 6.12 commits are small
correctness/build items, not a rewrite of GCM tag handling.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver/platform-specific:
`CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4` on Keem Bay, GCM(AES/SM4)
decrypt on that HW.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every successful GCM decrypt on this engine compares tags.
Trigger is ordinary decrypt, not a rare error path. Unprivileged users
can hit it via AF_ALG or via kernel users of `gcm(aes)`. Practical
exploitation needs timing measurement (local is realistic; remote is
harder). The integrity guarantee is still broken even if remote exploit
is hard.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- Failure: timing leak of valid-tag prefix → tag forgery → **INT-CTXT**
  failure (forged ciphertext accepted).
- Severity: **HIGH** (crypto/security). Not a panic/deadlock. Same class
  historically sent to stable (talitos/nx).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** restores AEAD integrity for Keem Bay GCM users on 6.12
  LTS.
- **Risk:** very low (3 lines, equivalent control flow, well-used
  helper).
- **Ratio:** benefit > risk. Niche HW lowers population, not the
  correctness of backporting a tiny security fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real AEAD security bug (non-constant-time tag compare / INT-CTXT).
- Buggy `memcmp` is in this 6.12 tree since the v5.11 driver.
- 3-line, obviously correct, applies cleanly.
- `crypto_memneq` already in tree; same pattern used by other drivers
  here.
- Crypto maintainer applied it; historical sibling timing-leak fixes
  were stable-bound.
- No new API/feature.

**AGAINST:**
- Peripheral SoC (`ARCH_KEEMBAY`), small user base.
- No user/syzbot report, no CVE, no `Cc: stable`.
- AI-assisted; no Tested-by/Reviewed-by besides maintainer apply.
- CCM `memcmp` remains until the sibling patch (this GCM fix is still
  complete on its own).

**UNRESOLVED:**
- Stable@ search 403 (whether anyone already nominated this).
- No public measurement of exploitability on this SoC (generic
  `memcmp`-MAC analysis still holds).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one helper swap; maintainer
   applied; helper is the standard MAC compare. No extra runtime test
   tags.
2. Fixes a real bug that affects users? **PASS** — GCM decrypt on this
   HW uses `memcmp` today.
3. Important issue? **PASS** — AEAD integrity / timing side channel
   (HIGH), not a crash.
4. Small and contained? **PASS** — 3 lines, one file, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
small security correctness fix.

**Step 9.4: MAKE YOUR DECISION**

The patch closes a real INT-CTXT hole with a 3-line, clean apply on this
6.12 tree. Niche hardware is not a reason to leave a known AEAD tag-
timing bug in LTS.

### What it solves for this tree
Keem Bay OCS GCM decrypt still uses early-exit `memcmp` on the auth tag.
That leaks how much of the tag matched and can be used to forge tags.
Replacing it with `crypto_memneq()` makes the compare constant-time
without changing success/failure semantics.

### Risk vs benefit
Benefit is restoring AEAD integrity for that decrypt path. Risk is
negligible: same branch structure, established helper, no locking or API
change.

---

Verification:
- [Phase 1] Parsed tags: Assisted-by gregkh_clanker_t1000; SOBs Gall +
  Herbert Xu; no Fixes/Reported-by/Cc:stable
- [Phase 1] SHA `353b3a85136f2a0cf3e872acf8ad6c1dec0b7a8e` on crypto-
  next; not ancestor of HEAD
- [Phase 2] Diff: +`crypto/utils.h`, `memcmp` → `crypto_memneq` in
  `kmb_ocs_aead_run()` GCM decrypt
- [Phase 2] Confirmed remaining CCM `memcmp` in `ocs-aes.c:1285` is
  sibling `ff2ac77a034e0`, not required here
- [Phase 2] `crypto_memneq` returns 0 equal / 1 unequal — same ternary
  as `memcmp`
- [Phase 3] `git blame`: memcmp from `8857433245138` (2020-12-11); in
  tree since v5.11
- [Phase 3] `git merge-base --is-ancestor 8857433245138 HEAD` succeeded
- [Phase 3] `git apply --check` of the candidate on this tree: success
- [Phase 3] Author’s related commits on crypto-next: keembay CCM, sa2ul,
  octeontx, ccree memneq conversions
- [Phase 4] `b4 dig -c`:
  https://patch.msgid.link/anYEQOzunX0Lm3N1@david.gall
- [Phase 4] `b4 dig -a`: v1 only, `[PATCH 1/2]`
- [Phase 4] `b4 dig -w`: Herbert Xu, davem, linux-crypto, gregkh CC’d
- [Phase 4] mbox: Herbert “All applied. Thanks.”; no NAK, no stable
  nomination
- [Phase 4] Direct lore/stable WebFetch: 403 — UNVERIFIED for stable@
  archive
- [Phase 4] Historical same-class fixes `79960943fdc11` (talitos) and
  `cb8affb55c7e6` (nx) have `Cc: stable` and are in this tree
- [Phase 5] Call chain: `kmb_ocs_aes_gcm_decrypt` →
  `kmb_ocs_aead_common` → engine → `kmb_ocs_aes_aead_do_one_request` →
  `kmb_ocs_aead_run`
- [Phase 5] Algs: `gcm(aes)`/`gcm(sm4)` priority 350; `KERN_DRIVER_ONLY`
  is not INTERNAL; AF_ALG allows that flag
- [Phase 6] `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111
- [Phase 6] Line 922 still `memcmp(...)` in this checkout
- [Phase 6] `include/crypto/utils.h` and `lib/crypto/memneq.c` present
- [Phase 7] Kconfig `depends on ARCH_KEEMBAY || COMPILE_TEST`;
  `ARCH_KEEMBAY` in arm64 Kconfig.platforms
- [Phase 8] Failure mode: AEAD tag timing leak / possible tag forgery,
  severity HIGH
- UNVERIFIED: exploit practicality on Keem Bay specifically; whether
  stable@ already discussed this commit

**YES**

 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 419f88af1031b..c4fd5e1849cdf 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -919,7 +920,7 @@ static int kmb_ocs_aead_run(struct aead_request *req)
 
 	/* For GCM decrypt, we have to compare in_tag with out_tag. */
 	if (rctx->instruction == OCS_DECRYPT) {
-		rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?
+		rc = crypto_memneq(rctx->in_tag, rctx->out_tag, tag_size) ?
 		     -EBADMSG : 0;
 		goto exit;
 	}
-- 
2.53.0

