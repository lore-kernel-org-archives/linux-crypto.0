Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A43444A3EE;
	Mon, 31 Aug 2026 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183733; cv=none; b=OZ9+Bw+5eCIgj1MaTkubLcaBVJRm+y+JP1LQWzwatHjZfAcnYpUQk526KMnQ+9+N9IZmhQIGV6uR9Fin395UX0uFD7RUDvKMbMkS6ulso9VplchSwflYC2XsHpU2A3U+W4yW/xWVUTY5jE8fZLeQ1o2PbH21XyzHOIyMTJBGhGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183733; c=relaxed/simple;
	bh=esiWKftdgtlhrwVwueMMa4hZKzagSmx7NPKwEK/luSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+IIwVj67InE8BAyHAGyp18YdEXDcWCsocjI6vhvs2p7Mg/Fm9vryZTOZiX9TEW/bd0u3slY+OPqVd6chRtBDzOFm+HHGtrkuetjuJjVnYGwudrFVWeHO2bcPwkV8qX2R4OkcHr8rVerAQ+14yJ1AJzsSH2nkP0uAU4Gde5tEuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llwTR3zs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llwTR3zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1AC1F000E9;
	Mon, 31 Aug 2026 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183731;
	bh=LU1tCjaazAuuI5hKZKyA4j9n1PnyCCpNtt7AusBd1p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llwTR3zsWyqyYP+9BDu2JsnlDXClT0N1miM0MtgoSkcnoe2sSlje+C5goQM7T2X9d
	 gPUTXjc4hdXVtXDaWRd/KwmxI8pupZoQdHXQvUsQVbOAcDzidwWVp0emS35a7cAYyl
	 leHJP/T1gUcMLSGWL5bceuvL9ZbXNluTlBeEO5SapGerwt3xkAdiUdT3jFKkvDGFyf
	 TcSrs9b+nMnO8t2vlRS4OVmOf/Tr5TH/CcjNNZObMeFuJ5iuvWwa2kTsY46nE1rVHf
	 wX8iDLvE1VkeCU6dPoaepsg4ZzdYFIaHZPt5mWQ/ktlB7IM1vtlnzLrSHAaiRzKE9N
	 negC8O9FLWCpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	kaloz@openwrt.org,
	clabbe@baylibre.com,
	davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] crypto: ixp4xx - fix buffer chain unwind on allocation failure
Date: Mon, 31 Aug 2026 09:24:58 -0400
Message-ID: <20260831133314.4125787-270-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 25056329384010a8672552b134f609601dc4f80e ]

chainup_buffers() builds a linked list of buffer descriptors for a
scatterlist. If dma_pool_alloc() fails while constructing the list, the
current code sets buf to NULL and later dereferences it unconditionally
at the end of the function:

  buf->next = NULL;
  buf->phys_next = 0;

This can lead to a null-pointer dereference on allocation failure.

If the failure happens after part of the descriptor chain has already
been allocated and DMA-mapped, the partially constructed chain also
needs to be released.

Fix this by terminating the partially constructed chain on allocation
failure and letting the callers unwind it via their existing cleanup
paths. Also fix ablk_perform() to preserve the hook pointers before
checking for failure, so partially built chains can be freed correctly.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[crypto: ixp4xx] [fix] fix buffer chain unwind on allocation
failure in chainup_buffers()/ablk_perform()`

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>` — author
- `Acked-by: Linus Walleij <linusw@kernel.org>` — ARM/platform
  maintainer ack
- `Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>` — crypto
  maintainer merge
- No `Fixes:` tag (expected for manual review)
- No `Reported-by:` / `Link:` / `Cc: stable@vger.kernel.org`
- Notable: maintainer ack from Linus Walleij; Herbert Xu applied v2 per
  lore

**Step 1.3 — Body analysis**

Record:
- **Bug:** `chainup_buffers()` on `dma_pool_alloc()` failure sets `buf =
  NULL`, breaks, then unconditionally does `buf->next = NULL` → NULL
  pointer dereference.
- **Secondary bug:** Partially built descriptor chains are not
  terminated/freed on failure.
- **Symptom:** Kernel oops on allocation failure; possible DMA-pool leak
  if the NULL deref were avoided without proper unwind.
- **Root cause:** Incorrect error handling in `chainup_buffers()`;
  `ablk_perform()` checks return value before saving hook pointers, so
  cleanup cannot free partial chains.
- **Version info:** None in commit message.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit bug fix (NULL deref + resource leak on
error path), not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c` (+14 / −11,
  ~25 lines)
- **Functions:** `chainup_buffers()`, `ablk_perform()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (`chainup_buffers`):** Before: on alloc failure, `buf = NULL;
  break;` then fall through to `buf->next = NULL` (crash). After:
  terminate current `buf` chain (`buf->next = NULL; buf->phys_next = 0`)
  and `return NULL` immediately.
- **Hunk 2 (`ablk_perform`):** Before: `if (!chainup_buffers(...)) goto
  cleanup` before saving `dst_hook`/`src_hook` into `req_ctx` and
  `crypt`. After: assign return to `buf`, always save hook pointers
  first, then `if (!buf) goto cleanup` — matching the pattern already
  used in `aead_perform()`.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** NULL pointer dereference + error-path resource leak
- **Mechanism:** On `dma_pool_alloc()` failure, `buf` becomes NULL but
  is dereferenced at function end. Even if that were avoided,
  `ablk_perform()` would jump to cleanup without populating
  `req_ctx->dst/src` and `crypt->dst_buf/src_buf`, so `free_buf_chain()`
  would not release partially allocated chains.

**Step 2.4 — Fix quality**

Record: Fix is minimal, obviously correct, and aligns `ablk_perform()`
with the existing correct pattern in `aead_perform()`. Low regression
risk — only affects failure paths.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `git blame` on `chainup_buffers()` lines 872–902 attributes all
lines to `5d324e5159d9e` (Nov 28, 2025 merge). This checkout’s history
is shallow around this file; exact introduction commit of the buggy
pattern could not be determined here. The driver itself dates to 2008
per file header.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag present.

**Step 3.3 — Related file history**

Record: `git log --oneline -20 --
drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c` shows only the merge commit
in this tree. Fix commit is **not** present (`git log --grep="buffer
chain"` returns nothing). Buggy code confirmed at lines 886–900 and
1028–1040.

**Step 3.4 — Author context**

Record: No prior Ruoyu Wang commits in this tree’s
`drivers/crypto/intel/ixp4xx/` history. Patch was reviewed by crypto
maintainer Herbert Xu (v2 incorporated his feedback).

**Step 3.5 — Dependencies**

Record: Standalone fix; no series dependencies. `aead_perform()` in the
same file already uses the post-fix calling convention, confirming the
API contract.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: Patch v2 submitted Apr 23, 2026 to linux-crypto. Thread:
https://lists.openwall.net/linux-kernel/2026/04/23/864. v2 changes per
Herbert Xu: keep unwind in callers, terminate partial chain, save hook
pointers in `ablk_perform()`. Herbert Xu replied “Patch applied.
Thanks.” (May 5, 2026).

**Step 4.2 — Reviewers**

Record: To: Herbert Xu, Corentin Labbe, linux-crypto. Cc: Linus Walleij,
Imre Kaloz, David S. Miller, linux-arm-kernel, linux-kernel. Appropriate
maintainers were included.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot report. Bug identified by code
review / author analysis.

**Step 4.4 — Series context**

Record: v1 used internal `free_buf_chain()` in `chainup_buffers()`; v2
(committed version) moved unwind to callers per maintainer feedback.
Committed version is the latest revision.

**Step 4.5 — Stable list discussion**

Record: No stable-list discussion found. Absence of `Cc: stable` is not
a negative signal per review guidelines.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `chainup_buffers()`, `ablk_perform()`, `free_buf_chain()`

**Step 5.2 — Callers**

Record: `chainup_buffers()` called from:
- `ablk_perform()` (lines 1028, 1038) — **buggy caller pattern**
- `aead_perform()` (lines 1140, 1160) — **already correct pattern**

`ablk_perform()` called from `ablk_encrypt()`, `ablk_decrypt()`,
`ablk_rfc3686_crypt()`.

**Step 5.3 — Callees**

Record: `dma_pool_alloc()`, `dma_map_single()`, `sg_virt()`,
`sg_next()`, `free_buf_chain()` (on error paths)

**Step 5.4 — Reachability**

Record: Reachable from userspace crypto operations (skcipher
encrypt/decrypt) on systems with `CONFIG_CRYPTO_DEV_IXP4XX` and IXP4xx
hardware (`ARCH_IXP4XX`). Trigger requires `dma_pool_alloc()` failure
(memory pressure or pool exhaustion), most likely under `GFP_ATOMIC`
when `CRYPTO_TFM_REQ_MAY_SLEEP` is unset.

**Step 5.5 — Similar patterns**

Record: `aead_perform()` already implements the correct post-fix
pattern, demonstrating this is the intended API usage and
`ablk_perform()` was simply inconsistent.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

**Step 6.1 — Buggy code present?**

Record: **YES.** Local tree is `6.18.43` (`git describe`:
`v6.18.43-1-gc7f0dac02d232`). Buggy code at:

```886:901:drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
                if (!next_buf) {
                        buf = NULL;
                        break;
                }
                // ...
        buf->next = NULL;
        buf->phys_next = 0;
        return buf;
```

and buggy `ablk_perform()` caller pattern at lines 1028–1040. Fix is
**not** yet applied.

**Step 6.2 — Backport complications**

Record: Expected **clean apply** — current source matches the patch’s
`index fcc0cf4df..5b90cf0fb` base context exactly.

**Step 6.3 — Related fixes already present?**

Record: No equivalent fix found via `git log --grep`. `aead_perform()`
already has correct hook-pointer handling but does not fix the
`chainup_buffers()` NULL deref.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drivers/crypto/intel/ixp4xx/` — crypto hardware driver for
Intel IXP4xx NPE. **Criticality: PERIPHERAL** (platform-specific
embedded hardware), but error path is in common crypto request handling.

**Step 7.2 — Activity**

Record: `drivers/crypto/` has active maintenance in this tree (recent
qat, tegra, cavium fixes). IXP4xx driver file shows limited recent churn
in this checkout.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Systems with `CONFIG_CRYPTO_DEV_IXP4XX` (depends on `ARCH_IXP4XX
|| COMPILE_TEST`, plus `IXP4XX_QMGR` and `IXP4XX_NPE`). Primarily
embedded IXP4xx/ARM routers and similar devices using hardware crypto
acceleration.

**Step 8.2 — Trigger conditions**

Record: Skcipher crypto request through `ablk_perform()` when
`dma_pool_alloc()` fails mid-chain. Uncommon but realistic under memory
pressure. Userspace can initiate crypto ops; failure is not theoretical
once pool is exhausted.

**Step 8.3 — Failure mode severity**

Record:
- **Primary:** NULL pointer dereference → kernel oops (**CRITICAL** when
  triggered)
- **Secondary:** Partial buffer-chain leak on alloc failure without
  proper hook setup (**HIGH** — DMA pool exhaustion)

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** Prevents kernel crash and fixes error-path resource leak
  in hardware crypto path
- **Risk:** Very low — ~25 lines, failure-path only, matches existing
  `aead_perform()` pattern, maintainer-reviewed
- **Ratio:** Clear benefit outweighs risk for this tree

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, verifiable NULL deref on error path
- Secondary resource-leak fix in `ablk_perform()`
- Small, surgical, single-file change
- Acked by Linus Walleij; applied by crypto maintainer Herbert Xu after
  review
- Buggy code confirmed present in local 6.18.43 tree; fix not yet
  applied
- Patch should apply cleanly
- Same-file `aead_perform()` validates the fix approach

**AGAINST backport:**
- Niche hardware (IXP4xx only) — smaller user base
- Requires `dma_pool_alloc()` failure — not everyday, but real under
  pressure
- No syzbot/user crash report (found via review)

**Unresolved:** Exact commit that introduced the buggy `buf = NULL;
break` pattern could not be determined from this tree’s shallow file
history.

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   reviewed and applied v2
2. Fixes a real bug? **PASS** — NULL deref + leak on alloc failure
3. Important issue? **PASS** — kernel oops (CRITICAL when triggered);
   memory leak (HIGH)
4. Small and contained? **PASS** — 1 file, ~25 lines, failure paths only
5. No new features/APIs? **PASS** — error-handling fix only
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

**Step 9.3 — Exception categories**

Record: None (not device ID, quirk, DT, build, or docs). Standard bug-
fix backport.

**Step 9.4 — Decision rationale**

For Linux **6.18.43**, this commit fixes a confirmed NULL pointer
dereference and an associated error-path resource leak in an existing
driver that is present and buggy in this tree. The fix is small,
maintainer-reviewed, and follows an established pattern already used in
the same file. While the hardware is niche, stable trees routinely
accept driver crash fixes of this nature.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
  and openwall lore thread
- [Phase 1] Confirmed Acked-by: Linus Walleij; Herbert Xu merge SOB
- [Phase 2] Read current `chainup_buffers()` at lines 886–901: confirmed
  `buf = NULL; break` followed by `buf->next = NULL` (NULL deref)
- [Phase 2] Read current `ablk_perform()` at lines 1028–1040: confirmed
  hook pointers saved after failure check
- [Phase 2] Read `aead_perform()` at lines 1140–1166: confirmed correct
  post-fix pattern already present
- [Phase 2] Read `free_buf_chain()` at lines 333–347: confirmed cleanup
  depends on valid hook pointers
- [Phase 3] `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`; `make
  kernelversion` → `6.18.43`
- [Phase 3] `git blame -L 872,902` → buggy lines present (attrib.
  limited by tree history)
- [Phase 3] `git log --grep="buffer chain"` → no fix commit in tree
- [Phase 4] Fetched https://lists.openwall.net/linux-
  kernel/2026/04/23/864 — v2 patch content and maintainer apply
  confirmed
- [Phase 4] UNVERIFIED: `b4 dig -c <hash>` — fix commit hash not in
  local tree
- [Phase 5] `grep chainup_buffers` — 3 call sites: 2 in `ablk_perform`,
  2 in `aead_perform`
- [Phase 6] Confirmed driver exists:
  `drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c`
- [Phase 6] Read Kconfig: `CONFIG_CRYPTO_DEV_IXP4XX` depends on
  `ARCH_IXP4XX || COMPILE_TEST`
- [Phase 6] Patch base context matches current file (lines 886–889,
  1028–1040 identical to diff)
- [Phase 8] Failure mode: NULL deref → kernel oops; partial chain leak
  without `ablk_perform()` fix

**YES**

 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 25 ++++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index fcc0cf4df637d..5b90cf0fb0e41 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -884,8 +884,9 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 		ptr = sg_virt(sg);
 		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
 		if (!next_buf) {
-			buf = NULL;
-			break;
+			buf->next = NULL;
+			buf->phys_next = 0;
+			return NULL;
 		}
 		sg_dma_address(sg) = dma_map_single(dev, ptr, len, dir);
 		buf->next = next_buf;
@@ -983,7 +984,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 	unsigned int nbytes = req->cryptlen;
 	enum dma_data_direction src_direction = DMA_BIDIRECTIONAL;
 	struct ablk_ctx *req_ctx = skcipher_request_ctx(req);
-	struct buffer_desc src_hook;
+	struct buffer_desc *buf, src_hook;
 	struct device *dev = &pdev->dev;
 	unsigned int offset;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
@@ -1025,22 +1026,24 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		/* This was never tested by Intel
 		 * for more than one dst buffer, I think. */
 		req_ctx->dst = NULL;
-		if (!chainup_buffers(dev, req->dst, nbytes, &dst_hook,
-				     flags, DMA_FROM_DEVICE))
-			goto free_buf_dest;
-		src_direction = DMA_TO_DEVICE;
+		buf = chainup_buffers(dev, req->dst, nbytes, &dst_hook,
+				      flags, DMA_FROM_DEVICE);
 		req_ctx->dst = dst_hook.next;
 		crypt->dst_buf = dst_hook.phys_next;
+		if (!buf)
+			goto free_buf_dest;
+		src_direction = DMA_TO_DEVICE;
 	} else {
 		req_ctx->dst = NULL;
 	}
 	req_ctx->src = NULL;
-	if (!chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
-			     src_direction))
-		goto free_buf_src;
-
+	buf = chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
+			      src_direction);
 	req_ctx->src = src_hook.next;
 	crypt->src_buf = src_hook.phys_next;
+	if (!buf)
+		goto free_buf_src;
+
 	crypt->ctl_flags |= CTL_FLAG_PERFORM_ABLK;
 	qmgr_put_entry(send_qid, crypt_virt2phys(crypt));
 	BUG_ON(qmgr_stat_overflow(send_qid));
-- 
2.53.0

