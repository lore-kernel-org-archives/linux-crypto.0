Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B547B41C;
	Mon, 31 Aug 2026 13:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183363; cv=none; b=PWLXcLVKsmO07HKdisJE6Cvn5+E0cynlla/q4aS+9XYLtGdgsOPKTYt9S5JKYt5noGcTA3p/ECijsvxTUxSwnI5dx3aLEasDjIpK9QNiYCPLqkNRKREF57jyUZ//a7kTJhTqbGkkcj09t+AaayeDy8wys0agVTHSjGGv540wFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183363; c=relaxed/simple;
	bh=GQHEgNPgE6Y3k48lTr6EsJnFbE9+hp022ZTKBtH5vdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kv/E3XTJbNGuu8EvBGyylWxv2Io7yx0dqu7N0EzmSqwSx2BcNreUL2cp93ve5UQ96TdKbgmTLHdqZYManMmfFfjbvVIuKHWsQJ9JC2wCcnm5kDQ4GZOWtG8uReNNopikNTHZOy6Ks/Z7zCeZngcye57VHUMIqN5Hw4Pg30fm3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8FDGd8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8FDGd8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0AB1F00ACA;
	Mon, 31 Aug 2026 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183360;
	bh=KJeMYH4sQgzFz1nN6KTc666XD0TglsRoDSby/9WCXwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8FDGd8Ez+u1VBO6hHk7DUY5Nm9WP84SrBdDzCvdH7L/90FblxzeJu9JmEk4d1ATk
	 zWBu5m7j1IhlqS34KrXAT8qekvY+4jCc9HM1tjFz9DKByXX5hVef9HgwUXw1BvAzGI
	 Db1wXNA1A8fcXdI+nIiZN7ITFILfGyqmsS4gVn3/u/bd2fHo+IcOSnqqAXVPhpLVwk
	 zrLm2nXwZglzNhEIeicyDn1b7yIJN9iY4hY+1mQ977uA4oqZ2kWskjQQA+U0wuAlU4
	 8lvfzS2YSRbwbPSVwqw36fsUIrwZxidb30KN6gGBZzUxCVb9RZZnrlSwY5Ar36K7ls
	 j1T4HYnuLWXrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] crypto: omap - add omap_des_unregister_algs helper
Date: Mon, 31 Aug 2026 09:22:10 -0400
Message-ID: <20260831133314.4125787-102-sashal@kernel.org>
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

[ Upstream commit 9ab1392b1163daab674484d6ddacf16f0ad4c040 ]

Add a new helper omap_des_unregister_algs() and replace two for loops in
omap_des_probe() and omap_des_remove(), which also ensure ->registered
is reset to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `crypto: omap - add omap_des_unregister_algs
helper`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)
**Upstream commit:** `9ab1392b1163daab674484d6ddacf16f0ad4c040`
**Stable-queue commit (not in HEAD):**
`18e80df6bcd291829f7f5251bafb8567a31bf25c`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[crypto: omap] [add] add omap_des_unregister_algs helper` —
introduces a helper and consolidates unregister logic.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>` (author)
- `Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>` (crypto
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`,
  `Tested-by:`, or `Reviewed-by:` tags
- Notable: maintainer sign-off only; no fuzzer or user reports

**Step 1.3 — Body**
Record:
- **Bug described:** Implicit — `->registered` must be reset to 0 when
  algorithms are unregistered
- **Symptom/failure mode:** Not stated explicitly; stale `registered`
  counter after probe error path or remove
- **Version info:** None
- **Root cause (author):** Two duplicate unregister loops did not reset
  `registered`

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Despite “add helper” wording, the behavioral fix is
`alg_info->registered = 0` after unregister. Without that, the static
`registered` counter grows across probe/remove cycles while the
unregister loops use the inflated value.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/crypto/omap-des.c` (+16 / −10 lines, ~26 lines
  touched)
- **Functions:** new `omap_des_unregister_algs()`; modified
  `omap_des_probe()` (`err_algs`), `omap_des_remove()`
- **Scope:** Single-file surgical refactor + correctness fix

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| New helper | N/A | Iterates `algs_info` groups, calls
`crypto_engine_unregister_skciphers(algs_list, registered)`, sets
`registered = 0` |
| `err_algs` | Nested loops calling
`crypto_engine_unregister_skcipher()` per entry | Calls
`omap_des_unregister_algs(dd->pdata)` |
| `omap_des_remove()` | Same nested loops, no counter reset | Calls
`omap_des_unregister_algs(dd->pdata)` |

Record: Error path and normal remove path now share identical
unregister+reset logic.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic/correctness + potential out-of-bounds access
- **Mechanism:** `omap_des_algs_info_ecb_cbc` is static; `registered` is
  mutated during probe (`registered++` per successful
  `crypto_engine_register_skcipher()`). Old `err_algs` and `remove`
  unregistered algorithms but left `registered` non-zero. On a
  subsequent probe within the same module lifetime (driver rebind
  without `rmmod`), probe registers all 4 algorithms again while
  incrementing from the stale value (e.g. 4 → 8). The next remove
  iterates `j = registered-1 … 0`, accessing `algs_list[4..7]` when the
  array has only 4 elements (`ecb(des)`, `cbc(des)`, `ecb(des3_ede)`,
  `cbc(des3_ede)`).

Unlike `omap-aes.c`, which guards re-registration with `if
(!registered)` and decrements on remove, `omap-des.c` has no such guard
— making stale `registered` directly dangerous.

**Step 2.4 — Fix quality**
Record:
- Fix is obviously correct: reset counter after unregister
- Minimal, no API changes
- `crypto_engine_unregister_skciphers()` is equivalent to the old per-
  entry loop (verified in `crypto/crypto_engine.c:654-661`)
- Regression risk: very low

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Current unregister loops in HEAD blame to `5d324e5159d9e` (v6.18
merge import). The `registered` field and buggy pattern are present in
this tree’s `omap-des.c`.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record:
- Part of a 3-patch series by Thorsten Blum (Apr 27, 2026):
  1. `omap_aes_unregister_algs` (`c207524b73f8`)
  2. **`omap_des_unregister_algs`** (`9ab1392b1163`) — this commit
  3. `Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly`
     (`2ed27b5a1174`) — unrelated OMAP scatterlist fix
- This omap-des patch is **standalone**; it does not depend on the aes
  or scatterlist patches

**Step 3.4 — Author context**
Record: Thorsten Blum submitted a series of OMAP crypto driver
correctness fixes in 2026; Herbert Xu committed them upstream May 7,
2026. Same pattern applied to `omap-aes.c`.

**Step 3.5 — Dependencies**
Record: No prerequisites. `crypto_engine_unregister_skciphers()` exists
in this tree (`crypto/crypto_engine.c`, `include/crypto/engine.h`).
Patch applies cleanly to current `omap-des.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c 18e80df6bcd291829f7f5251bafb8567a31bf25c` matched
[PATCH 2/3] at `https://lore.kernel.org/all/20260427172018.416707-5-
thorsten.blum@linux.dev/`. Lore page content could not be fetched
(Anubis bot protection). Patch content matches committed diff.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` — CC’d Herbert Xu, David S. Miller, `linux-
crypto@vger.kernel.org`, `linux-kernel@vger.kernel.org`.

**Step 4.3 — Bug reports**
Record: N/A — no `Reported-by:` or `Link:` tags; no syzbot report.

**Step 4.4 — Series context**
Record: v1 series `[PATCH 1/3]` through `[PATCH 3/3]`; omap-des patch is
self-contained within its file.

**Step 4.5 — Stable list**
Record: Could not search `lore.kernel.org/stable/` (same fetch
restriction). No stable nomination found in available sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `omap_des_unregister_algs()`, `omap_des_probe()`,
`omap_des_remove()`

**Step 5.2 — Callers**
Record:
- `omap_des_probe()` — platform driver probe (`module_platform_driver`)
- `omap_des_remove()` — platform driver remove
- `err_algs` — probe error path when `crypto_engine_register_skcipher()`
  fails

**Step 5.3 — Callees**
Record: `crypto_engine_unregister_skciphers()` →
`crypto_engine_unregister_skcipher()` → `crypto_unregister_skcipher()` →
`crypto_unregister_alg()` (WARNs if algorithm not registered:
`crypto/algapi.c:498`)

**Step 5.4 — Reachability**
Record: Triggered by driver rebind (`unbind`/`bind` sysfs) or probe
failure followed by re-probe, without module unload. Requires
`CONFIG_CRYPTO_DEV_OMAP_DES` on OMAP2+ hardware. Not syscall-reachable,
but reachable by root via driver sysfs or module lifecycle.

**Step 5.5 — Similar patterns**
Record: `omap-aes.c` in this tree still uses manual loops with
decrement-on-remove and `if (!registered)` probe guard — partial
mitigation omap-des lacks. Other drivers (`atmel-aes.c`, `sun8i-ss-
core.c`, etc.) use dedicated `*_unregister_algs()` helpers that reset
state.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

**Step 6.1 — Buggy code present?**
Record: **Yes.** HEAD `drivers/crypto/omap-des.c` lines 1045–1049
(`err_algs`) and 1076–1079 (`remove`) use old nested loops without
resetting `registered`. Commit `9ab1392b1163` is **not** an ancestor of
HEAD (`merge-base --is-ancestor` exit 1).

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** File structure matches upstream;
`crypto_engine_unregister_skciphers` API present; no conflicting changes
to this file since merge.

**Step 6.3 — Related fixes already present?**
Record: **No.** `omap_aes_unregister_algs` also absent from HEAD. No
grep match for `omap_des_unregister_algs`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `drivers/crypto/` — OMAP DES hardware crypto driver.
**Criticality: PERIPHERAL** (legacy OMAP2+ embedded platforms).

**Step 7.2 — Activity**
Record: Low churn in this tree for `omap-des.c` (single merge commit
visible); mature legacy driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users of OMAP DES hardware acceleration
(`CONFIG_CRYPTO_DEV_OMAP_DES`) who rebind the driver or re-probe after a
failed registration within the same module lifetime.

**Step 8.2 — Trigger conditions**
Record:
- Uncommon in production (typically probe-once-at-boot)
- More likely during development/testing (driver unbind/rebind)
- Requires root for sysfs driver unbind
- **Likelihood:** Low; **consequence if triggered:** High

**Step 8.3 — Failure mode severity**
Record:
- Stale `registered` counter after first remove/re-probe cycle
- Second remove: out-of-bounds reads of `algs_list[j]` for `j >= 4`
- Possible `WARN` from `crypto_unregister_alg()` for bogus entries
- **Severity: HIGH** (memory safety / undefined behavior), though
  trigger is rare

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Medium — prevents latent OOB/WARN on driver lifecycle
  edge cases
- **Risk:** Very low — 16-line helper, behavior-preserving unregister
  with added counter reset
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR backport:**
- Fixes real stale-counter bug in static driver state
- Can cause out-of-bounds array access on driver rebind (verified by
  tracing `registered` vs `ARRAY_SIZE(algs_ecb_cbc)` = 4)
- Small, contained, maintainer-reviewed
- Applies cleanly to 6.18.43; required API exists
- omap-des lacks omap-aes’s `if (!registered)` mitigation

**AGAINST backport:**
- Commit message frames as refactor, not explicit bug report
- OMAP DES is legacy embedded hardware with small user base
- Trigger (driver rebind without module unload) is uncommon
- No syzbot/user reports
- Single probe+remove per boot works correctly (counter stale but
  unused)

**Unresolved:** Full lore review thread content; no independent runtime
test evidence.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; Herbert Xu
   sign-off; no Tested-by
2. Fixes real bug affecting users? **PASS** — stale counter → OOB on
   rebind
3. Important issue? **PASS** — memory safety / WARN (HIGH severity, low
   frequency)
4. Small and contained? **PASS** — ~26 lines, one file
5. No new features/APIs? **PASS** — internal helper only
6. Can apply to local tree? **PASS** — code and APIs present; not yet in
   HEAD

**Step 9.3 — Exception category**
Record: N/A (not device ID, quirk, DT, build fix, or docs).

**Step 9.4 — Decision rationale**
This is a disguised correctness fix. The unregister loops were
functionally equivalent for a single probe/remove cycle, but the missing
`registered = 0` reset leaves static driver state corrupted across
rebind cycles, eventually causing out-of-bounds access in the remove
path. The fix is minimal, self-contained, and matches established
patterns in other crypto drivers. While the trigger is uncommon on
legacy OMAP hardware, the consequence (OOB access) meets stable backport
criteria for driver lifecycle correctness fixes.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show 9ab1392b1163`
- [Phase 2] Read `drivers/crypto/omap-des.c` lines 94–98, 796–801,
  1029–1084; counted 4 algorithms in `algs_ecb_cbc[]`
- [Phase 2] Read `crypto/crypto_engine.c:634-661` —
  `crypto_engine_unregister_skciphers` matches old loop semantics
- [Phase 2] Read `crypto/algapi.c:489-499` — `crypto_unregister_alg`
  WARN on unregistered algorithm
- [Phase 3] `git merge-base --is-ancestor 9ab1392b1163 HEAD` → exit 1
  (not in tree)
- [Phase 3] Series identified: patches 1/3 aes, 2/3 des, 3/3 scatterlist
  (independent)
- [Phase 4] `b4 dig -c 18e80df6bcd29` → lore URL found; `b4 dig -a` → v1
  series; `b4 dig -w` → maintainers CC’d
- [Phase 4] Lore/patch.msgid.link fetch blocked by Anubis — thread
  content UNVERIFIED
- [Phase 5] Compared `omap-aes.c:1184-1264` — has `if (!registered)`
  guard and decrement-on-remove; omap-des lacks both
- [Phase 6] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 6] `grep omap_des_unregister_algs` → no matches in tree (fix
  absent)
- [Phase 6] `grep crypto_engine_unregister_skciphers` → present in
  `crypto/crypto_engine.c`
- [Phase 8] Traced rebind scenario: probe(registered=4) → remove(unreg
  4, registered stays 4) → re-probe(registered→8) → remove(OOB j=7..4)

**YES**The backport analysis is complete: **YES** for Linux 6.18.43.

This commit fixes a real bug in `omap-des.c` where the static
`registered` counter is not reset after unregistering algorithms. On
driver rebind without module unload, that stale counter can grow past
the 4-entry `algs_list` array and cause out-of-bounds access on remove.
The fix is small, self-contained, and applies cleanly —
`crypto_engine_unregister_skciphers()` is already in this tree.

One background `git branch --contains` check was interrupted after
hanging on a large branch list; the important check was already done
separately: `git merge-base --is-ancestor` confirmed the fix is **not**
in current HEAD, while the buggy code is still present.

 drivers/crypto/omap-des.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 149ebd77710bf..16d5c617d5ee8 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -938,6 +938,20 @@ static int omap_des_get_pdev(struct omap_des_dev *dd,
 	return 0;
 }
 
+static void omap_des_unregister_algs(const struct omap_des_pdata *pdata)
+{
+	struct omap_des_algs_info *alg_info;
+	int i;
+
+	for (i = pdata->algs_info_size - 1; i >= 0; i--) {
+		alg_info = &pdata->algs_info[i];
+
+		crypto_engine_unregister_skciphers(alg_info->algs_list,
+						   alg_info->registered);
+		alg_info->registered = 0;
+	}
+}
+
 static int omap_des_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1043,11 +1057,7 @@ static int omap_des_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
-
+	omap_des_unregister_algs(dd->pdata);
 err_engine:
 	if (dd->engine)
 		crypto_engine_exit(dd->engine);
@@ -1067,16 +1077,12 @@ static int omap_des_probe(struct platform_device *pdev)
 static void omap_des_remove(struct platform_device *pdev)
 {
 	struct omap_des_dev *dd = platform_get_drvdata(pdev);
-	int i, j;
 
 	spin_lock_bh(&list_lock);
 	list_del(&dd->list);
 	spin_unlock_bh(&list_lock);
 
-	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
-		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
-			crypto_engine_unregister_skcipher(
-					&dd->pdata->algs_info[i].algs_list[j]);
+	omap_des_unregister_algs(dd->pdata);
 
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
-- 
2.53.0

