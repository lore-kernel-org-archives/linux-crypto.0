Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F094566C4E;
	Mon, 31 Aug 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184084; cv=none; b=uVCH5TJMUrhNPknBoek56ToLt5rhBaF5hnrtJrKXWVhLmfQw5QJQFxrCxNDlVFL51oipO7minfutb3ZDuXCmKNzEE0JGlQpOelIFF9p6UxziBM9SgmH90h1S73XUCFLlKKIRTnvnuRFTGsocvmLq4kLCWmLmxYq5Vwh+KZEPQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184084; c=relaxed/simple;
	bh=kVDwmKRyY7K+PV+CWmAPPeA6HKS068Y55C+8X3+eovI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/oktysbU7cZ8KEy8JjxYb9rYNsGXJjyNHObqnVhbB+U6qzhJAL6/n/i6H3O7raK0B9/qpyY9zAN1q3gDcnA8pRrbdRhPIqxlAu4ypUOvV+bRlCFibyR9tffEJ/ICkomMPYRf6iJklV/jpn3Wdt5irFFtUwxoGkfEqrYyOOPwqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MX1puEAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX1puEAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741471F00ACF;
	Mon, 31 Aug 2026 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184080;
	bh=/77pn6z30uvsynT2JfwXrNtm08jv46VHuqPUGer+tik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MX1puEAUAPcO5ns4rOTYtaZBH3dMCUaKRP8byzMc/+xqGPKxjRnKOQmX/nZFhwnPD
	 K1AV3lsk+MMXoJToZOLBzyAPRpuxGW/mRROtTV+yeXCwo46CSFutJlE5jxmKorSFlc
	 be988ilj7FLHwD5gylsQqKcmumSWJSUgsvT2ABK0r2QBhLoTdyirBpkNLAFZ1yYIfs
	 NrLO6zDkrXrJ3xnbOv4sDNmGfz0geLd8x0SS/WebfqksC3kV7hJHvC8dTXPaL2e5sI
	 8bhFkxZRUoe4afuh7fQsYYn3ov4S0gJwyGBIpTjM3SKEoFRYNYXGRK8CpnU7qElsGz
	 bvOGUNnAXSc+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] crypto: amcc - convert irq_of_parse_and_map to platform_get_irq
Date: Mon, 31 Aug 2026 09:28:27 -0400
Message-ID: <20260831133314.4125787-479-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 1cecde1005399eb4e4069c036dcfcbe3c240b6e0 ]

Replace the deprecated irq_of_parse_and_map() call with the modern
platform_get_irq() in the probe function. This also improves error
handling: platform_get_irq() returns a negative errno on failure,
whereas irq_of_parse_and_map() returned 0.

Change the irq field in struct crypto4xx_core_device from u32 to int
to match the return type of platform_get_irq().

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `crypto: amcc - convert irq_of_parse_and_map
to platform_get_irq`

**Local tree:** `stable/linux-6.18.y` at `v6.18.44-1-g2736c32da98b9`
(kernel version **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[crypto: amcc]` `[convert]` — Replace deprecated
`irq_of_parse_and_map()` with `platform_get_irq()` in the AMCC PPC4xx
crypto driver probe path.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — absent (expected for candidate review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable@vger.kernel.org** — absent (expected)
- **Signed-off-by:** Rosen Penev `<rosenp@gmail.com>`, Herbert Xu
  `<herbert@gondor.apana.org.au>`
- **Assisted-by:** opencode:big-pickle
- **Notable patterns:** No fuzzer report, no user bug report, no
  explicit stable nomination. Herbert Xu (crypto maintainer) signed off.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug described:** `irq_of_parse_and_map()` returns `0` on failure,
  which is ambiguous and not a proper errno. `platform_get_irq()`
  returns a negative errno on failure.
- **Symptom/failure mode:** IRQ lookup failure is not detected before
  `devm_request_irq()`; `-EPROBE_DEFER` from the OF IRQ path is
  swallowed (converted to `0` by `irq_of_parse_and_map()`).
- **Version information:** None stated.
- **Root cause:** Deprecated IRQ API with incorrect failure signaling;
  missing explicit error check before IRQ registration.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** **Yes — hidden bug fix disguised as API modernization.**
Beyond deprecation cleanup, it fixes:
1. Missing probe error handling for IRQ lookup failure.
2. Failure to propagate `-EPROBE_DEFER` (verified: `of_irq_get()`
   returns `-EPROBE_DEFER` when `irq_find_host()` fails;
   `irq_of_parse_and_map()` maps `of_irq_parse_one()` errors to `0`).
3. Aligns with the same class of fix already backported to this tree for
   another PPC 460-class driver (`sata_dwc_460ex`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- `drivers/crypto/amcc/crypto4xx_core.c`: +4 lines (error check added)
- `drivers/crypto/amcc/crypto4xx_core.h`: 1 line (`u32 irq` → `int irq`)
- **Functions modified:** `crypto4xx_probe()`
- **Scope:** Single-subsystem, surgical, 2 files, 6 insertions / 2
  deletions

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (probe):** Before: assign IRQ via `irq_of_parse_and_map()`,
  proceed directly to `devm_request_irq()`. After: obtain IRQ via
  `platform_get_irq()`, bail out with proper errno (including
  `-EPROBE_DEFER`) if `< 0`, then request IRQ.
- **Hunk 2 (header):** Before: `irq` stored as `u32`. After: `int` to
  correctly hold negative errno values during assignment and positive
  IRQ numbers on success.
- **Path affected:** Platform driver probe, IRQ setup — initialization
  path on `CONFIG_CRYPTO_DEV_PPC4XX` hardware.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** Logic/correctness fix + initialization/probe-
  deferral fix
- **Mechanism:** `irq_of_parse_and_map()` returns `0` on
  `of_irq_parse_one()` failure (see `drivers/of/irq.c:44-45`),
  conflating failure with a potentially valid IRQ number and never
  returning `-EPROBE_DEFER`. The old code then called
  `devm_request_irq()` with `0`, which returns `-EINVAL` via
  `irq_to_desc(0)` returning NULL — causing permanent probe failure
  instead of deferred reprobe. `platform_get_irq()` → `of_irq_get()`
  correctly returns negative errnos including `-EPROBE_DEFER`.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix is minimal, idiomatic, and matches kernel-wide pattern (documented
  in `platform_get_irq()` kerneldoc).
- `core_dev->irq` is only referenced at assignment and
  `devm_request_irq()` call — `u32`→`int` change is safe.
- **Regression risk:** Very low. Same author applied an analogous change
  to `net: ibm: emac` already present in this stable tree.
- **Minor concern:** On `-EPROBE_DEFER`, `err_iomap` path runs
  `tasklet_kill()` and manual pool teardown before returning —
  acceptable since probe will retry from scratch.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `irq_of_parse_and_map()` line introduced in `b0a191cebea13c`
  (Christian Lamparter, 2017-12-22).
- `devm_request_irq()` conversion in `0a53948477ca1d` (Rosen Penev,
  2024-10-10).
- Buggy IRQ pattern has been present since 2017; devm conversion in 2024
  did not fix the error-handling gap.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — not applicable.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Related stable precedent: `678d874e6ae11` (`ata: sata_dwc_460ex: use
  platform_get_irq()`) — same author (Rosen Penev), same PPC 4xx
  platform family, same API migration, explicitly backported to
  `stable/linux-6.18.y` with rationale citing missing
  `irq_dispose_mapping()` and better error reporting.
- Related author commit: `a598f66d91693` (`net: ibm: emac: use
  platform_get_irq`) — same author, backported to this tree.
- `bdd3f7fa77257` (2012): moved `err_iomap` label to cover
  post-`irq_of_parse_and_map` cleanup — shows IRQ setup has long been in
  this code region.
- **Standalone:** Single-patch fix, not part of a series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Rosen Penev is an active contributor to this driver
(`0a53948477ca1d` devm probe refactor, `7337b18f1ec75` resource
cleanup). Same author has had similar IRQ API migrations accepted into
this stable tree.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Commit `1cecde1005399` applies cleanly to
current `6.18.44` tree (`git apply --check` succeeded). Standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c 1cecde1005399`:
  https://patch.msgid.link/20260602014645.522137-1-rosenp@gmail.com
- **Series revisions:** v1 only (`b4 dig -a`)
- **Lore content:** Could not fetch full thread (Anubis bot protection
  on lore.kernel.org). No reviewer stable nominations verifiable from
  fetched content.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w` recipients: Rosen Penev, `linux-
crypto@vger.kernel.org`, Herbert Xu, David S. Miller, `linux-
kernel@vger.kernel.org`. Herbert Xu (crypto maintainer) committed it. No
explicit Reviewed-by in commit.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No bug report, syzbot link, or user-reported crash. Bug
identified by code inspection / API deprecation work.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone patch. Related stable backport `678d874e6ae11`
(sata_dwc_460ex, PPC 460ex) provides direct precedent in this same
stable tree.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched on lore stable list (fetch blocked). However,
`678d874e6ae11` and `a598f66d91693` in `git log stable/linux-6.18.y`
confirm stable maintainers accept this class of fix for PPC platform
drivers.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `crypto4xx_probe()` — only function modified.

### Step 5.2: TRACE CALLERS
**Record:** `crypto4xx_probe()` is the `.probe` callback of the
`platform_driver` for `CONFIG_CRYPTO_DEV_PPC4XX`. Called during kernel
boot / module load when a matching OF platform device is registered on
PowerPC 4xx SoCs. Not a hot path; runs once per device at
initialization.

### Step 5.3: TRACE CALLEES
**Record:** Key callees in affected region: `platform_get_irq()` →
`of_irq_get()`, `devm_request_irq()`, `tasklet_init()`,
`devm_platform_ioremap_resource()`, pool build functions. IRQ path
involves OF parsing and interrupt domain mapping.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Device tree match → `platform_device` registration →
`crypto4xx_probe()` → IRQ setup → `devm_request_irq()`. Reachable on
every boot for systems with `CRYPTO_DEV_PPC4XX=y/m` and matching
hardware (e.g., AMCC PPC4xx crypto accelerator on embedded PowerPC
boards).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same `irq_of_parse_and_map` → `platform_get_irq` migration
pattern backported in this tree for `sata_dwc_460ex` and `ibm emac`. No
`irq_dispose_mapping()` anywhere in `drivers/crypto/amcc/` (verified via
grep) — same cleanup gap cited in the sata stable backport.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** At `drivers/crypto/amcc/crypto4xx_core.c:1298`:
```c
core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
```
No error check before `devm_request_irq()`. `struct
crypto4xx_core_device::irq` is still `u32` in `crypto4xx_core.h:109`.
Bug present since 2017.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git format-patch -1 1cecde1005399
| git apply --check` succeeded with no conflicts. File structure matches
upstream commit base.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Fix `1cecde1005399` is **not** in this tree. `git log
stable/linux-6.18.y..1cecde1005399 -- drivers/crypto/amcc/` shows only
this commit as relevant. No duplicate fix present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/crypto/amcc/` — crypto hardware accelerator driver.
**Criticality: PERIPHERAL** (platform-specific; `depends on PPC &&
4xx`). Affects crypto offload and optionally HW RNG on embedded PowerPC
4xx systems.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Moderately active — recent stable commits include ahash
removal, gcc12 warning fix, devm conversion (2024). Driver is mature but
still maintained.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Platform-specific / config-specific** — users of
`CONFIG_CRYPTO_DEV_PPC4XX` on PowerPC 4xx SoCs (embedded systems, some
legacy networking appliances). Small population, but real hardware.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- IRQ not yet available in device tree / interrupt parent not probed yet
  → `-EPROBE_DEFER` mishandled.
- Malformed or missing interrupt spec → `0` returned, probe fails at
  `request_irq()` with `-EINVAL` instead of clean early error.
- **Likelihood:** Boot-order race is realistic on deferred-probe
  systems; missing IRQ spec is a DT configuration error.
- **Unprivileged trigger:** No — requires specific hardware and kernel
  config.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Without fix:** Driver probe fails permanently (returns `-EINVAL`
  instead of `-EPROBE_DEFER`), or proceeds with invalid IRQ `0`. Crypto
  hardware acceleration unavailable; possible mis-registered interrupt
  in edge cases.
- **Severity: MEDIUM** — functional failure (hardware crypto offload
  broken), not a system-wide crash, data corruption, or security
  vulnerability. Important for affected embedded deployments.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** MEDIUM for PPC 4xx users — restores correct probe
  deferral and proper IRQ error handling; aligns with already-accepted
  stable precedent.
- **Risk:** VERY LOW — 6-line change, applies cleanly, no API changes,
  no behavior change on success path.
- **Ratio:** Favorable for backport, especially given identical fix
  already in this tree for `sata_dwc_460ex`.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real probe bug: `-EPROBE_DEFER` not propagated through
  `irq_of_parse_and_map()`
- Missing explicit IRQ error check before `devm_request_irq()`
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.44
- Direct stable precedent: `678d874e6ae11` (same author, same PPC 4xx
  family, same fix class) already in this tree
- Same author's `a598f66d91693` (emac) also in this tree
- Herbert Xu signed off
- Buggy code confirmed present in local tree since 2017

**AGAINST backporting:**
- No user bug report or syzbot finding
- Affects niche embedded hardware only
- Failure mode is driver probe failure, not kernel crash/oops/corruption
- Primarily described as API modernization

**UNRESOLVED:**
- Full lore review thread inaccessible (bot protection)
- No explicit stable nomination in mailing list (unverifiable)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — idiomatic
   `platform_get_irq()` pattern; no Tested-by on this specific commit,
   but analogous change tested in related work.
2. Fixes a real bug? **PASS** — EPROBE_DEFER mishandling and missing IRQ
   error check verified in source.
3. Important issue? **PASS (borderline)** — permanent probe failure on
   affected hardware; not crash/corruption but functionally important
   for PPC 4xx crypto users.
4. Small and contained? **PASS** — 6 lines across 2 files.
5. No new features or APIs? **PASS** — uses existing
   `platform_get_irq()` API.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** Not a device ID, quirk, DT, build, or documentation fix.
Qualifies as a probe correctness fix.

### Step 9.4: DECISION RATIONALE

This commit fixes a genuine probe-path bug on hardware that exists in
the 6.18.y tree (`CONFIG_CRYPTO_DEV_PPC4XX`, `PPC && 4xx`). The failure
to propagate `-EPROBE_DEFER` can cause the crypto accelerator driver to
fail permanently at boot when the interrupt parent has not yet probed —
a real functional regression on affected embedded systems. The fix is
minimal, low-risk, and follows the exact pattern already accepted for
stable backport in this same tree (`ata: sata_dwc_460ex: use
platform_get_irq()` by the same author on the same platform family).
While the user population is small, stable trees explicitly serve
embedded/LTS deployments where this hardware lives.

---

## Verification

- **[Phase 1]** Parsed commit `1cecde1005399`: subject, tags, body
  analyzed; no Reported-by/syzbot/Fixes tags.
- **[Phase 2]** Diff analyzed: 2 files, `crypto4xx_probe()` only; error-
  check and type change verified.
- **[Phase 2]** Read `drivers/of/irq.c:39-50`: `irq_of_parse_and_map()`
  returns `0` on `of_irq_parse_one()` failure.
- **[Phase 2]** Read `drivers/of/irq.c:458-478`: `of_irq_get()` returns
  `-EPROBE_DEFER` when `irq_find_host()` fails.
- **[Phase 2]** Read `kernel/irq/manage.c:2106-2108`: `request_irq()`
  returns `-EINVAL` when `irq_to_desc(irq)` is NULL.
- **[Phase 3]** `git blame`: `irq_of_parse_and_map` from 2017
  (`b0a191cebea13c`).
- **[Phase 3]** `git log stable/linux-6.18.y`: found precedent commits
  `678d874e6ae11`, `a598f66d91693`.
- **[Phase 3]** `git show 678d874e6ae11`: sata_dwc_460ex stable backport
  with same rationale.
- **[Phase 3]** `git show a598f66d91693`: emac stable backport by same
  author.
- **[Phase 3]** `git apply --check`: patch applies cleanly to current
  tree.
- **[Phase 4]** `b4 dig -c 1cecde1005399`: found lore URL; v1 only;
  recipients include Herbert Xu.
- **[Phase 4]** WebFetch lore URL: blocked by Anubis — full thread
  unverified.
- **[Phase 5]** `grep core_dev->irq drivers/crypto/amcc/`: only used in
  probe assignment and `devm_request_irq()`.
- **[Phase 5]** Read `drivers/base/platform.c:260-270`:
  `platform_get_irq()` behavior confirmed.
- **[Phase 6]** `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`.
- **[Phase 6]** Read current `crypto4xx_core.c:1297-1304`: buggy code
  confirmed present.
- **[Phase 6]** `git log stable/linux-6.18.y..1cecde1005399 --
  drivers/crypto/amcc/`: fix not yet present.
- **[Phase 7]** Read `drivers/crypto/Kconfig:294-306`:
  `CRYPTO_DEV_PPC4XX` depends on `PPC && 4xx`.
- **[Phase 8]** Assessed failure mode: permanent probe failure / missing
  crypto offload, severity MEDIUM.

**YES****Verdict: YES** — backport to this tree (`linux-6.18.y` /
6.18.44).

The commit fixes real probe-path bugs in the AMCC PPC4xx crypto driver:
`irq_of_parse_and_map()` returns `0` on failure (and swallows
`-EPROBE_DEFER`), so IRQ setup can fail permanently instead of
deferring. The fix is small (6 lines), applies cleanly, and matches the
same pattern already backported here for `sata_dwc_460ex` by the same
author.

**Scope:** Only affects `CONFIG_CRYPTO_DEV_PPC4XX` on PowerPC 4xx
embedded hardware — niche, but a genuine functional bug for those
systems.

 drivers/crypto/amcc/crypto4xx_core.c | 6 +++++-
 drivers/crypto/amcc/crypto4xx_core.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index be55eb6a03164..d82b00cdc4e08 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1295,7 +1295,11 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	}
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
-	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
+	core_dev->irq = platform_get_irq(ofdev, 0);
+	if (core_dev->irq < 0) {
+		rc = core_dev->irq;
+		goto err_iomap;
+	}
 	rc = devm_request_irq(&ofdev->dev, core_dev->irq,
 			      is_revb ? crypto4xx_ce_interrupt_handler_revb :
 					crypto4xx_ce_interrupt_handler,
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 3a028aec3f0c1..66a95733c86dd 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -106,7 +106,7 @@ struct crypto4xx_core_device {
 	struct crypto4xx_device *dev;
 	struct hwrng *trng;
 	u32 int_status;
-	u32 irq;
+	int irq;
 	struct tasklet_struct tasklet;
 	spinlock_t lock;
 };
-- 
2.53.0

