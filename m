Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20455445ACD;
	Mon, 31 Aug 2026 13:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183241; cv=none; b=KXFM+ZWMlYrvaPkEsUtd5t+boopb9H1eQwHr5ADOIFzGz5Ib3a47RHJyz9pYfIWhqDy9AU4wNf3DNDeAKVcJNOtNurCqz+QRbLEuBz79cAEItJ5XKhFaj+YJ5LYRoH2xKGwXmnFzdeyUoTrlixD2sWU3dt6LpOdQMJqKYvym/zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183241; c=relaxed/simple;
	bh=siC7b/RXQMD9zWiCVLMtyOflobjo0LftJv+JgUlGYYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwZw1dwNPtnpT7oOQZwV73E/q9QFoBmyp438PJ/vqGKE09cRJ30lGcdW9yDt4Wc6ak/1VI/WbRRPj3Jw/nwJZAjEVeBZw0ZI5Qio0msommhyYZrrcyNo1axXF5zCqGQJbKdzw9B08tq1ac5H0/TqhFq4KuHMeODs4DG5fW3P4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwhXxJzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwhXxJzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2521F000E9;
	Mon, 31 Aug 2026 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183238;
	bh=HFhRf0/FmP6ds4GoQQqyvgeK2pUF/4KOa974VNOLQhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwhXxJzFMotJFoJSxvhlCg3VCACmdBJ7q3ybQXQb6dUPlVDOBUXJK+dBZvfm9fVbI
	 0K4LD5NhD8qwCMc5/s42SkvGfZQ/oLOC9bhuOh7Jk8ZJQRosKjfONJgQwc7rtmQk5Z
	 hFltrlMJ+5x+GT0lr9Etg0hSQCrWZc2kKB9sqMIuEG7/dQS6WeG3QAgYafB6zY/rwj
	 paBxwCv1EjrKNUCF7mKQCqM5SKFECJQws+NnYg8sSDhs0Gk9r3AOd/x4brJhCR1q3L
	 3seYI7wVzcz5cefST+XGdlNQLR1ToERetcGfG8BIrPOtdnDuFpHBCgHKvwZ1OVqQ0c
	 Vf1+CcTisb0Rw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y
Date: Mon, 31 Aug 2026 09:20:56 -0400
Message-ID: <20260831133314.4125787-28-sashal@kernel.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit c64ba13e2033c3c6dc1a097bf35f9f1fe457c3f7 ]

Andrew reports build breakage of arm allmodconfig, reproducible with gcc
14.2.0 and 15.2.0:

  crypto/ecc.c: In function 'ecc_point_mult':
  crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

gcc aggressively inlines functions called by ecc_point_mult() (without
there being any explicit inline declarations), which pushes stack usage
close to the limit imposed by CONFIG_FRAME_WARN.  allmodconfig implies
CONFIG_KASAN_STACK=y, which increases the stack above that limit.

In the bugzilla entry linked below, gcc maintainers explain that gcc
estimates extra stack usage caused by inlining, but ASAN instrumentation
is added in post-IPA passes and thus the inlining heuristics cannot
account for it.

It could be argued that -Werror=frame-larger-than=1280 instructs the
compiler to avoid inlining beyond that limit lest the build breaks,
which would imply gcc behaves incorrectly.  But gcc maintainers reject
this notion and believe that a warning switch should never affect code
generation, even if it is promoted to an error.

One way to unbreak the build is to limit inlining via -finline-limit=100
or by explicitly declaring some functions noinline.  However while it
does keep stack usage of individual functions below the limit, *total*
stack usage increases.

A longterm solution is to refactor ecc.c for reduced stack usage.  It
currently performs ECC point multiplication with a Montgomery ladder
which uses co-Z (conjugate) addition to trade off memory for speed.
The algorithm is susceptible to timing attacks and needs to be replaced
with a constant time Montgomery ladder, which should consume less memory
and thus resolve the stack usage issue as a side effect.

In the interim, raise the limit for ecc.c, as is already done for
several other files in the source tree.

Constrain to gcc because clang 19.1.7 does not exhibit the issue.  It
makes do with a 724 bytes stack frame even though it inlines almost the
same functions as gcc.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `crypto: ecc - Unbreak the build on arm with
CONFIG_KASAN_STACK=y`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[crypto/ecc] [unbreak/fix build] [raise frame-size warning
limit for ecc.o on arm+KASAN_STACK+gcc to fix allmodconfig build
failure]`

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Link | https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949 |
| Reported-by | Andrew Morton \<akpm@linux-foundation.org\> (off-list) |
| Signed-off-by | Lukas Wunner \<lukas@wunner.de\> |
| Acked-by | Andy Shevchenko \<andriy.shevchenko@linux.intel.com\> |
| Reviewed-by | Andy Shevchenko \<andriy.shevchenko@linux.intel.com\> |
| Signed-off-by | Herbert Xu \<herbert@gondor.apana.org.au\> (crypto
maintainer) |
| Fixes: | absent (expected) |
| Cc: stable | absent (expected) |

**Notable:** Reported by Andrew Morton; crypto maintainer sign-off; gcc
bugzilla link; no syzbot.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `arm allmodconfig` fails to build with gcc 14.2.0/15.2.0 when
  `CONFIG_KASAN_STACK=y`.
- **Symptom:** `-Werror=frame-larger-than` error in `ecc_point_mult()` —
  frame 1360 bytes > 1280-byte limit.
- **Root cause:** GCC aggressively inlines into `ecc_point_mult()`;
  KASAN stack instrumentation is added post-IPA and is not accounted for
  in inlining heuristics.
- **Fix approach:** Interim workaround — raise per-object `-Wframe-
  larger-than` to 1536 for `ecc.o` under `CONFIG_ARM &&
  CONFIG_KASAN_STACK && CONFIG_CC_IS_GCC`.
- **Version info:** Triggered by newer gcc (14/15); clang 19.1.7 not
  affected.

### Step 1.4: Hidden bug fix?
**Record:** Not a hidden runtime bug fix. This is an explicit **build
fix** — a Makefile-only workaround for a compiler/KASAN interaction. No
runtime behavior change.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `crypto/Makefile` only (+5 lines)
- **Functions modified:** none (build flags only)
- **Scope:** Single-file, surgical Makefile change

### Step 2.2: Code flow per hunk
**Record:**
- **Before:** Global `CONFIG_FRAME_WARN` (1280 on 32-bit) applies to
  `ecc.o`; gcc+KASAN_STACK can push `ecc_point_mult()` past that limit →
  build error with `-Werror`.
- **After:** When `CONFIG_ARM=y`, `CONFIG_KASAN_STACK=y`, and
  `CONFIG_CC_IS_GCC=y`, add `CFLAGS_ecc.o += -Wframe-larger-than=1536`
  for that object only.
- **Path affected:** Compile-time only; no execution-path change.

### Step 2.3: Bug mechanism
**Record:** **Build fix / toolchain interaction** — not UAF, leak, race,
etc. GCC stack-frame estimate plus KASAN instrumentation exceeds the
kernel’s default 32-bit `FRAME_WARN` (1280), promoted to error under
`WERROR`/allmodconfig.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches existing pattern in the same Makefile
  (`CFLAGS_blake2b_generic.o := -Wframe-larger-than=4096`).
- **Regression risk:** Very low — only relaxes a compile-time warning
  threshold for one object under a narrow config triple; no code
  generation change intended.
- **Caveat:** Does not reduce actual stack use; silences the warning
  until a future ECC refactor.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `ecc_point_mult()` at `crypto/ecc.c:1338` — present at Linux 6.18.43
  tag (`7b923c78b50d2`).
- `CFLAGS_blake2b_generic.o` precedent at `crypto/Makefile:87` — same
  gcc frame-size workaround pattern already in this tree.
- Blame on this stable checkout points at bulk import commit
  `a112b91dd6349`; per-file history is not granular here.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `crypto/Makefile` at 6.18.43 has `obj-$(CONFIG_CRYPTO_ECC) += ecc.o`
  with **no** `CFLAGS_ecc.o` workaround — fix is **not** present.
- Commit under review **not found** in local `master` or current HEAD
  via grep/log search — likely newer mainline crypto work being
  evaluated for stable.

### Step 3.4: Author context
**Record:** Lukas Wunner is a regular kernel contributor; Herbert Xu
(crypto maintainer) merged. Andy Shevchenko acked/reviewed.

### Step 3.5: Dependencies
**Record:** Standalone — no series, no prerequisite commits, no new
APIs. Applies after `obj-$(CONFIG_CRYPTO_ECC) += ecc.o` line in
Makefile.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch discussion
**Record:** `b4 dig -c <hash>` could not run — commit hash not in this
repository. Lore and gcc bugzilla returned HTTP 403 from this
environment.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 -w. From commit message: Andy Shevchenko
(Acked-by + Reviewed-by), Herbert Xu (merge SOB).

### Step 4.3: Bug report
**Record:** Andrew Morton off-list report (high credibility for
allmodconfig breakage). gcc BZ #124949 explains gcc/KASAN stack-
estimation mismatch — URL not fetchable here.

### Step 4.4: Related patches
**Record:** Commit references long-term ECC constant-time refactor; this
patch is explicitly interim. No other patches required for this fix to
work.

### Step 4.5: Stable list
**Record:** UNVERIFIED — lore 403 blocked search.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Affected compile unit: `ecc.o` →
contains `ecc_point_mult()` and ECC helpers.

### Step 5.2: Callers
**Record:** `ecc_point_mult()` is called from `ecc_point_mult_shamir()`,
key generation, and scalar-multiply paths in `crypto/ecc.c` (lines 1593,
1661, 1708). Used when `CONFIG_CRYPTO_ECC` and dependent algorithms
(ECDH, ECDSA, ECRDSA) are enabled.

### Step 5.3: Callees
**Record:** Montgomery-ladder ECC math (`xycz_add`, `vli_mod_mult_fast`,
etc.) — large on-stack `u64` arrays (`ECC_MAX_DIGITS` = 9 → 72 bytes per
array; multiple arrays in `ecc_point_mult`).

### Step 5.4: Reachability
**Record:** Runtime path is reachable via crypto/KPP when ECC is
enabled. **The patch does not change this** — only whether the object
compiles under arm+KASAN+gcc+WERROR.

### Step 5.5: Similar patterns
**Record:** Same Makefile already has:
- `CFLAGS_blake2b_generic.o := -Wframe-larger-than=4096` (gcc BZ 105930)
- `arch/arm/boot/compressed/Makefile` per-object frame limit override
- `arch/powerpc/xmon/Makefile` clang frame override

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** `crypto/ecc.c` with `ecc_point_mult()` exists at
6.18.43. Relevant Kconfig exists:
- `CONFIG_FRAME_WARN` default **1280** for `!64BIT`
  (`lib/Kconfig.debug:448`)
- `CONFIG_KASAN_STACK` default **y** for GCC (`lib/Kconfig.kasan:167`)
- Global `-Wframe-larger-than=$(CONFIG_FRAME_WARN)` in
  `scripts/Makefile.extrawarn:25`
- `CONFIG_CRYPTO_ECC` / `ecc.o` build in `crypto/Makefile:183`

Fix is **not** yet in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — 5 lines inserted immediately
after `obj-$(CONFIG_CRYPTO_ECC) += ecc.o`. No conflicting changes at
that location in 6.18.43.

### Step 6.3: Related fixes already present?
**Record:** **NO** — `grep CFLAGS_ecc` returns nothing. Blake2b
precedent exists; ecc-specific workaround does not.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **crypto** — IMPORTANT subsystem. This patch affects
buildability, not runtime crypto behavior.

### Step 7.2: Activity
**Record:** `crypto/ecc.c` is mature, relatively stable code. Issue is
toolchain-driven (gcc 14/15 + KASAN), not a recent kernel regression in
ECC logic.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** **Config-specific builders** — developers/CI running
**32-bit ARM** (`CONFIG_ARM`) **allmodconfig** (or similar) with
**GCC**, **KASAN** (`CONFIG_KASAN_STACK=y`), and **WERROR**. Not typical
production distro arm32 kernels (KASAN usually off).

### Step 8.2: Trigger conditions
**Record:**
- `CONFIG_ARM=y` (32-bit, not arm64)
- `CONFIG_CC_IS_GCC=y`
- `CONFIG_KASAN_STACK=y` (default y for GCC)
- gcc 14.2+ with aggressive inlining
- `CONFIG_FRAME_WARN=1280` (32-bit default) + warnings-as-errors

**Likelihood:** Low for end users; **high** for kernel compile-test/CI
on arm allmodconfig. Andrew Morton’s report indicates it blocks a
standard maintainer build configuration.

### Step 8.3: Failure mode severity
**Record:** **Build failure** (compiler error). Severity for runtime
users: **NONE**. Severity for kernel development/CI: **MEDIUM** (blocks
full config testing).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Unblocks arm allmodconfig builds with modern gcc;
  restores parity with existing blake2b workaround pattern; zero runtime
  change.
- **Risk:** Very low — Makefile-only, narrow `ifeq` guard, per-object
  flag.
- **Ratio:** Favorable for stable as a **build-fix exception**,
  especially with Andrew Morton report and maintainer acks.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Explicit build fix; fits documented stable exception category
- Andrew Morton reported arm allmodconfig breakage
- Herbert Xu merged; Andy Shevchenko acked/reviewed
- Tiny (5 lines), precedented in same `crypto/Makefile`
- Buggy build conditions exist in 6.18.43; fix not yet applied
- Clean apply expected; no dependencies
- Enables kernel-wide compile testing on arm with modern gcc

**AGAINST backport:**
- No runtime bug — production kernels rarely use KASAN+allmodconfig on
  arm32
- Workaround, not a reduction of actual stack usage
- Very narrow config intersection (arm32 + gcc + KASAN_STACK)
- Commit not yet in local `master` (timing/unverified upstream merge
  status)
- External discussion (lore, gcc BZ) not accessible from this
  environment

**Unresolved:**
- Full lore review thread unavailable (403)
- gcc BZ #124949 details not fetchable (403)
- Exact upstream commit SHA not in this repo

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — Makefile pattern proven
by blake2b entry; maintainer reviewed |
| 2. Fixes real bug affecting users? | **PASS** — real build failure for
arm allmodconfig; builder/CI impact |
| 3. Important issue? | **PASS (build/CI)** — not crash/security; blocks
standard compile-test config |
| 4. Small and contained? | **PASS** — 5 lines, one file |
| 5. No new features/APIs? | **PASS** — compiler flag only |
| 6. Applies to local tree? | **PASS** — ecc.c and Kconfig preconditions
present; fix absent |

### Step 9.3: Exception category
**Record:** **BUILD FIX** — compilation failure under `CONFIG_ARM` +
`CONFIG_KASAN_STACK` + GCC + `-Werror=frame-larger-than`.

### Step 9.4: Decision rationale

For **Linux 6.18.43**, this commit should be backported. The ECC code
and all triggering Kconfig defaults exist in this tree, the fix is
absent, and the patch is a minimal Makefile workaround following an
established pattern already present in `crypto/Makefile`. While it does
not fix a runtime crash or security issue, it unblocks a standard kernel
build configuration (arm allmodconfig with modern gcc and KASAN)
reported by Andrew Morton, with crypto maintainer approval — exactly the
kind of contained build fix stable trees routinely carry.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Analyzed provided diff: +5 lines in `crypto/Makefile`
  only
- **[Phase 3]** `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- **[Phase 3]** `git log --grep` for commit subject/hash — not found in
  tree
- **[Phase 3]** `git show 7b923c78b50d2:crypto/ecc.c` — `ecc_point_mult`
  at line 1338 confirmed
- **[Phase 3]** `git show 7b923c78b50d2:crypto/Makefile` — no
  `CFLAGS_ecc.o` workaround
- **[Phase 3]** `git blame crypto/Makefile:87` — blake2b frame-larger
  precedent present
- **[Phase 4]** `b4 dig` — failed (no commit hash in repo)
- **[Phase 4]** lore.kernel.org curl — HTTP 403
- **[Phase 4]** gcc.gnu.org bugzilla #124949 — HTTP 403
- **[Phase 5]** Read `crypto/ecc.c:1338-1398` — large on-stack arrays in
  `ecc_point_mult`
- **[Phase 5]** `grep ecc_point_mult crypto/ecc.c` — callers at 1593,
  1661, 1708
- **[Phase 5]** `include/crypto/internal/ecc.h:37` — `ECC_MAX_DIGITS =
  DIV_ROUND_UP(521, 64)` (= 9)
- **[Phase 6]** `grep CFLAGS_ecc / KASAN_STACK / Wframe-larger-than`
  across tree
- **[Phase 6]** Read `lib/Kconfig.debug:441-453` — FRAME_WARN default
  1280 for !64BIT
- **[Phase 6]** Read `lib/Kconfig.kasan:163-179` — KASAN_STACK default y
  for GCC
- **[Phase 6]** Read `init/Kconfig:227-232` — WERROR defaults to
  COMPILE_TEST
- **[Phase 6]** Read `scripts/Makefile.extrawarn:24-26` — global frame-
  larger-than flag
- **[Phase 6]** Read `crypto/Makefile:183-184` — ECC object build rule,
  no workaround yet
- **UNVERIFIED:** Full mailing-list review thread and gcc BZ discussion
  text (HTTP 403)
- **UNVERIFIED:** Whether commit is already merged to mainline outside
  this checkout

**YES**

 crypto/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index e430e6e99b6a2..ef963cc03a038 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -183,6 +183,11 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
+ifeq ($(CONFIG_ARM)$(CONFIG_KASAN_STACK)$(CONFIG_CC_IS_GCC),yyy)
+CFLAGS_ecc.o += $(call cc-option,-Wframe-larger-than=1536)
+endif
+
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
-- 
2.53.0

