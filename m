Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C71425CC3;
	Mon, 20 Apr 2026 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691670; cv=none; b=UOwKS20Z5B5ZidwKgTkSALftG/fp4Vgi/POox79pIOVMPsIJAvBl6V8fw+/NNWd+polhStOl6KaVJWwh6TPb7zzHZoOlhcLl3oiyBkMvhRcMy80ye9CkB4YUw+V47NhhxZ8+P+S87US+bVi5lT4pnTKdVB3NlXcut1DeYsNCNhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691670; c=relaxed/simple;
	bh=1AEE6QbOyxG6mEOMUW+BeWMvXfezYfD5yIVBLksLyvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hD7aDTvl/3Wd1NBtq16MnGLW9i8xM0wnREDkSV3bl7Wsvt1X+mDoRKXGv+6WzKIm5IxE14wVJ1Eu7FvScgEcc+FG9SBx0BRJpA9l+N4npGFksrVogX6xq+AanqH1J585lMSMJr3FnevKqiGxWZIZqyyjAFB6EQJDGjvT3q2+8KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yo8oOnb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yo8oOnb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C5FC2BCB6;
	Mon, 20 Apr 2026 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691670;
	bh=1AEE6QbOyxG6mEOMUW+BeWMvXfezYfD5yIVBLksLyvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yo8oOnb57CNwzyJrnkrCGw4461j8cHLqoPmdh009PSE7PiSeDjXX6y3t5uun6b6+M
	 YT6g+XHdsnrI8AMnEjdVKaqgz1HCA8gr82l7ThXRtgko/umHQOLM8C0m7i7NRv8rmp
	 T1pn1Em4ot0ZR293t60QUu2KXlIo+2DESFhCNSmh3NXsMvVvDsGVku+dud5EyJ9pgT
	 l7gWEUZ+vrlcGlq0uPHc1hfEG9CsWxAREETp8O3e5+SKYFIOaQ09LtLg3kik4+uBEf
	 H2o8WvUgujdRqk0aYeVeIHioNG9v8D4oj5VOgWD3zoTciwEg0G+hGfTzoPlGrwmEHP
	 tjD1MJ9/5qEjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] crypto: tcrypt - clamp num_mb to avoid divide-by-zero
Date: Mon, 20 Apr 2026 09:19:18 -0400
Message-ID: <20260420132314.1023554-164-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

[ Upstream commit 32e76e3757e89f370bf2ac8dba8aeb133071834e ]

Passing num_mb=0 to the multibuffer speed tests leaves test_mb_aead_cycles()
and test_mb_acipher_cycles() dividing by (8 * num_mb). With sec=0 (the
default), the module prints "1 operation in ..." and hits a divide-by-zero
fault.

Force num_mb to at least 1 during module init and warn the caller so the
warm-up loop and the final report stay well-defined.

To reproduce:
sudo modprobe tcrypt mode=600 num_mb=0

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `crypto: tcrypt`
- **Action verb**: "clamp" (defensive input validation)
- **Summary**: Clamps `num_mb` module parameter to minimum 1 to avoid
  divide-by-zero

### Step 1.2: Tags
- **Signed-off-by**: Saeed Mirzamohammadi (author), Herbert Xu (crypto
  subsystem maintainer)
- No Fixes: tag (expected for this review pipeline)
- No Reported-by, Tested-by, Reviewed-by, or Cc: stable tags
- Herbert Xu's SOB confirms the crypto maintainer accepted this patch

### Step 1.3: Commit Body
- **Bug**: Passing `num_mb=0` causes `test_mb_aead_cycles()` and
  `test_mb_acipher_cycles()` to divide by `(8 * num_mb)` = 0
- **Symptom**: kernel divide-by-zero fault (oops)
- **Reproduction**: `sudo modprobe tcrypt mode=600 num_mb=0`
- **Root cause**: No validation that `num_mb` (a `uint` module
  parameter) must be >= 1

### Step 1.4: Hidden Bug Fix Detection
This is an explicit bug fix. The commit message clearly describes the
divide-by-zero.

Record: Not a hidden fix; it's an explicit divide-by-zero fix.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: `crypto/tcrypt.c` (+5 lines)
- **Functions modified**: `tcrypt_mod_init()` only
- **Scope**: Single-file, single-function, surgical fix

### Step 2.2: Code Flow
- **Before**: `tcrypt_mod_init()` passed `num_mb` directly to
  `do_test()` without validation
- **After**: Checks if `num_mb == 0`, warns, and sets it to 1 before
  calling `do_test()`
- Path affected: module initialization (normal path, not error path)

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** - missing input validation leading
to divide-by-zero.

The division expressions are at:
- Line 236: `(cycles + 4) / (8 * num_mb)` in `test_mb_aead_cycles()`
- Line 1053: `(cycles + 4) / (8 * num_mb)` in `test_mb_acipher_cycles()`

When `num_mb=0`, `8 * 0 = 0`, causing a kernel divide-by-zero
fault/oops.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes - trivial clamping of an input parameter
- **Minimal**: Yes - 4 effective lines added
- **Regression risk**: Essentially zero - the only change is that
  `num_mb=0` becomes `num_mb=1` instead of crashing
- **Red flags**: None

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The division expressions were introduced by commit `4e234eed58518a`
(Kees Cook, "crypto: tcrypt - Remove VLA usage", 2018-04-26). This
commit landed in v4.18-rc1.

Record: Buggy code introduced in v4.18, present in ALL active stable
trees (5.4, 5.10, 5.15, 6.1, 6.6, 6.12).

### Step 3.2: Fixes Tag
No Fixes: tag present. If there were one, it would logically point to
`4e234eed58518a`.

### Step 3.3: File History
Recent tcrypt changes are mostly adding/removing test algorithms, not
related to this bug. No prerequisites identified.

### Step 3.4: Author
Saeed Mirzamohammadi has 3 commits in the tree - one HID quirk, one
fbdev divide fix, one netfilter fix. Not a regular crypto contributor,
but the patch was accepted by Herbert Xu (crypto maintainer).

### Step 3.5: Dependencies
No dependencies. The fix is self-contained and the code context
(`tcrypt_mod_init`) is stable across all kernel versions since v4.18.

## PHASE 4: MAILING LIST RESEARCH

Lore.kernel.org was unavailable due to anti-bot protection. Web searches
did not find the specific patch thread.

Record: Could not verify mailing list discussion. However, the patch was
accepted by Herbert Xu, the crypto subsystem maintainer, which is strong
evidence of review.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `tcrypt_mod_init()` - the module's init function.

### Step 5.2: Callers
`tcrypt_mod_init()` is called once during `modprobe tcrypt`. It's the
module's `late_initcall` entry point.

### Step 5.3-5.4: Call Chain
The divide-by-zero path: `tcrypt_mod_init()` -> `do_test()` ->
`test_mb_aead_speed()` / `test_mb_skcipher_speed()` ->
`test_mb_aead_cycles()` / `test_mb_acipher_cycles()` -> division by `(8
* num_mb)`.

Trigger: `modprobe tcrypt mode=600 num_mb=0` (requires root).

### Step 5.5: Similar Patterns
Both `test_mb_aead_cycles()` (line 236) and `test_mb_acipher_cycles()`
(line 1053) have the identical `(8 * num_mb)` division. The fix at
module init covers both.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy division was introduced in v4.18 (commit `4e234eed58518a`). It
exists in ALL active stable trees: 5.4.y, 5.10.y, 5.15.y, 6.1.y, 6.6.y,
6.12.y.

### Step 6.2: Backport Complications
`tcrypt_mod_init()` is straightforward and has been stable for years.
The patch should apply cleanly to all stable trees. The recent
`kzalloc_objs` refactoring (v7.0-specific) is only in the
`test_mb_*_cycles` functions, not in `tcrypt_mod_init()`.

### Step 6.3: Related Fixes
No existing fix for this specific divide-by-zero issue was found in any
stable tree.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: crypto (specifically the tcrypt benchmark module)
- **Criticality**: PERIPHERAL - tcrypt is a benchmarking/test module,
  not used in production crypto operations. However, it's a standard
  kernel module that can be loaded by root.

### Step 7.2: Activity
The crypto subsystem and tcrypt specifically are moderately active with
ongoing changes.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Anyone who loads the tcrypt module with `num_mb=0`. This is primarily
kernel developers and system administrators running crypto benchmarks.

### Step 8.2: Trigger Conditions
- Requires root (modprobe)
- Requires deliberately passing `num_mb=0` - however, `num_mb` is a
  `uint` parameter with no documented minimum, so passing 0 is a
  "reasonable" (if mistaken) value
- Deterministic - always triggers with `num_mb=0`

### Step 8.3: Failure Mode
- **Divide-by-zero kernel fault/oops**: This is a kernel crash. On some
  configurations (panic_on_oops=1), this brings down the entire system.
- **Severity**: HIGH (kernel oops, but requires root and specific module
  parameter)

### Step 8.4: Risk-Benefit
- **Benefit**: Prevents a kernel oops in a standard kernel module. Low-
  medium benefit (affects test module users only, but the crash is
  real).
- **Risk**: VERY LOW - 4 lines of trivial input validation in module
  init. Zero regression potential.
- **Ratio**: Favorable - low-to-medium benefit with essentially zero
  risk.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence

**FOR backporting:**
- Fixes a real divide-by-zero that causes a kernel oops
- Reproducible with a simple command (`modprobe tcrypt mode=600
  num_mb=0`)
- Fix is 4 lines, obviously correct, and zero regression risk
- Bug has existed since v4.18, present in all active stable trees
- Accepted by the crypto subsystem maintainer (Herbert Xu)
- No dependencies - standalone fix

**AGAINST backporting:**
- tcrypt is a benchmark module, not production code
- Requires root to trigger
- Requires a non-default parameter value (default is 8)
- Low real-world impact

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES - trivial clamping, author
   provided reproduction steps
2. **Fixes a real bug?** YES - divide-by-zero causing kernel oops
3. **Important issue?** MODERATE - kernel oops, but in a test module
   with root-only trigger
4. **Small and contained?** YES - 4 lines in one function
5. **No new features?** YES - input validation only
6. **Can apply to stable?** YES - clean apply expected

### Step 9.3: Exception Categories
Not applicable (not a device ID, quirk, DT, or build fix).

### Step 9.4: Decision

This is a small, obviously correct fix for a real divide-by-zero that
causes a kernel oops. While the impact is limited to users of the tcrypt
benchmark module who pass `num_mb=0`, the fix is trivial, risk-free, and
the bug exists in all active stable trees since v4.18. The kernel should
not oops on any valid `uint` module parameter value, and the fix follows
the principle of defensive input validation.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author and Herbert Xu
  (crypto maintainer)
- [Phase 2] Diff analysis: 4 lines added in `tcrypt_mod_init()`,
  clamping `num_mb` to min 1
- [Phase 2] Confirmed divide-by-zero at lines 236 and 1053: `(cycles +
  4) / (8 * num_mb)`
- [Phase 3] git blame: Division expression introduced in commit
  `4e234eed58518a` (Kees Cook, v4.18-rc1)
- [Phase 3] git describe --contains: Bug present since v4.18, in all
  stable trees
- [Phase 3] git log: No related fixes or prerequisites found
- [Phase 3] Author has 3 commits in tree; patch accepted by crypto
  maintainer Herbert Xu
- [Phase 4] UNVERIFIED: Lore discussion not accessible (anti-bot
  protection blocked access)
- [Phase 5] Traced call chain: `tcrypt_mod_init` -> `do_test` ->
  `test_mb_*_speed` -> `test_mb_*_cycles` -> division by `(8 * num_mb)`
- [Phase 6] Code exists in all active stable trees (v5.4+) - verified
  buggy commit in v4.18
- [Phase 6] Backport expected to apply cleanly - `tcrypt_mod_init()` is
  stable
- [Phase 8] Failure mode: kernel divide-by-zero oops, severity HIGH but
  limited user base

**YES**

 crypto/tcrypt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aded375461374..61c8cf55c4f1e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2808,6 +2808,11 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
+	if (!num_mb) {
+		pr_warn("num_mb must be at least 1; forcing to 1\n");
+		num_mb = 1;
+	}
+
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-- 
2.53.0

