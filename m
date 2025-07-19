Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B0230BE5;
	Sat, 19 Jul 2025 22:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752965457; cv=none; b=Gf4nvI3om1aeVh5/LqPm/FeIv65aHgrpVQZ/+c0R4xZK8cVLdSsxkHsVwRHW15GhquKbjvOnEJzw8Low2B4EzITzovdC+V8dakncOoM+Xe7NEwG1JMyF4f8r/skXkQ8y+nmlS2tiegSTm1tcNUNpc8MBAK8wsICfJoON6XHBY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752965457; c=relaxed/simple;
	bh=X2a2KMW0q5VWGyfvxXegwbdbi47wf01rZ8qeevPKEMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2VPNPGT3X75QjkkoiUmyfxjahnmenGT1FRnfxw+e8Qy/aNud5ZIwvLvWk4X9q5iC+E9MeXhOKE+9iYPlNeJb7HM1QWtee2RwE8ycltuRdfWAEkDs0hV3DMKDtcaYpq6rGzi0jN6qXepX8u8Rkv4fUqi61Z/A/dfQNAR7g75zSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fusxll1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fusxll1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35662C4CEF6;
	Sat, 19 Jul 2025 22:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752965456;
	bh=X2a2KMW0q5VWGyfvxXegwbdbi47wf01rZ8qeevPKEMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fusxll1V7JgiH+enVl8ARhhUQzxQL2YWQZp6vF0axGeiISUq7aD+QhQAGPsVWjiVa
	 E7Bmpadu5gO3rRwbe+1w0oO9fxSNEQ4P+uBMkFyk0e/v+sf3IXMXtjZNa4EqQD28DA
	 +MnxRgCC0RWuZeNntDESHQQMGamhkcnOUWrpDogt1D6ruLWl4dardui1CqYlLvCL8Q
	 Fr48OzRmwlb22O2j72K1RaICCZXk+5m2/VISOuUvxZnyeZf2Qyor2vBpYVXWqIsUOm
	 tJm61D/uzw3+74fRTG/aN3li8OmO9seTOlbwGk+FdyAdHgwi4dxLD+SCLjrJ5Gd37O
	 Qt46H4C6jWRKA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] lib/crc: x86/crc32c: Enable VPCLMULQDQ optimization where beneficial
Date: Sat, 19 Jul 2025 15:49:38 -0700
Message-ID: <20250719224938.126512-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250719224938.126512-1-ebiggers@kernel.org>
References: <20250719224938.126512-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve crc32c() performance on lengths >= 512 bytes by using
crc32_lsb_vpclmul_avx512() instead of crc32c_x86_3way(), when the CPU
supports VPCLMULQDQ and has a "good" implementation of AVX-512.  For now
that means AMD Zen 4 and later, and Intel Sapphire Rapids and later.
Pass crc32_lsb_vpclmul_avx512() the table of constants needed to make it
use the CRC-32C polynomial.

Rationale: VPCLMULQDQ performance has improved on newer CPUs, making
crc32_lsb_vpclmul_avx512() faster than crc32c_x86_3way(), even though
crc32_lsb_vpclmul_avx512() is designed for generic 32-bit CRCs and does
not utilize x86_64's dedicated CRC-32C instructions.

Performance results for len=4096 using crc_kunit:

    CPU                        Before (MB/s)     After (MB/s)
    ======================     =============     ============
    AMD Zen 4 (Genoa)                  19868            28618
    AMD Zen 5 (Ryzen AI 9 365)         24080            46940
    AMD Zen 5 (Turin)                  29566            58468
    Intel Sapphire Rapids              22340            73794
    Intel Emerald Rapids               24696            78666

Performance results for len=512 using crc_kunit:

    CPU                        Before (MB/s)     After (MB/s)
    ======================     =============     ============
    AMD Zen 4 (Genoa)                   7251             7758
    AMD Zen 5 (Ryzen AI 9 365)         17481            19135
    AMD Zen 5 (Turin)                  21332            25424
    Intel Sapphire Rapids              18886            29312
    Intel Emerald Rapids               19675            29045

That being said, in the above benchmarks the ZMM registers are "hot", so
they don't quite tell the whole story.  While significantly improved
from older Intel CPUs, Intel still has ~2000 ns of ZMM warm-up time
where 512-bit instructions execute 4 times more slowly than they
normally do.  In contrast, AMD does better and has virtually zero ZMM
warm-up time (at most ~60 ns).  Thus, while this change is always
beneficial on AMD, strictly speaking there are cases in which it is not
beneficial on Intel, e.g. a small number of 512-byte messages with
"cold" ZMM registers.  But typically, it is beneficial even on Intel.

Note that on AMD Zen 3--5, crc32c() performance could be further
improved with implementations that interleave crc32q and VPCLMULQDQ
instructions.  Unfortunately, it appears that a different such
implementation would be optimal on *each* of these microarchitectures.
Such improvements are left for future work.  This commit just improves
the way that we choose the implementations we already have.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/x86/crc-pclmul-consts.h | 47 ++++++++++++++++++++++++++++++++-
 lib/crc/x86/crc32.h             | 38 +++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/lib/crc/x86/crc-pclmul-consts.h b/lib/crc/x86/crc-pclmul-consts.h
index fcc63c0643330..6ae94158fca28 100644
--- a/lib/crc/x86/crc-pclmul-consts.h
+++ b/lib/crc/x86/crc-pclmul-consts.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * CRC constants generated by:
  *
- *	./scripts/gen-crc-consts.py x86_pclmul crc16_msb_0x8bb7,crc32_lsb_0xedb88320,crc64_msb_0x42f0e1eba9ea3693,crc64_lsb_0x9a6c9329ac4bc9b5
+ *	./scripts/gen-crc-consts.py x86_pclmul crc16_msb_0x8bb7,crc32_lsb_0xedb88320,crc32_lsb_0x82f63b78,crc64_msb_0x42f0e1eba9ea3693,crc64_lsb_0x9a6c9329ac4bc9b5
  *
  * Do not edit manually.
  */
 
 /*
@@ -96,10 +96,55 @@ static const struct {
 		0xb4e5b025f7011641,	/* HI64_TERMS: floor(x^95 / G) */
 		0x00000001db710640,	/* LO64_TERMS: (G - x^32) * x^31 */
 	},
 };
 
+/*
+ * CRC folding constants generated for least-significant-bit-first CRC-32 using
+ * G(x) = x^32 + x^28 + x^27 + x^26 + x^25 + x^23 + x^22 + x^20 + x^19 + x^18 +
+ *        x^14 + x^13 + x^11 + x^10 + x^9 + x^8 + x^6 + x^0
+ */
+static const struct {
+	u64 fold_across_2048_bits_consts[2];
+	u64 fold_across_1024_bits_consts[2];
+	u64 fold_across_512_bits_consts[2];
+	u64 fold_across_256_bits_consts[2];
+	u64 fold_across_128_bits_consts[2];
+	u8 shuf_table[48];
+	u64 barrett_reduction_consts[2];
+} crc32_lsb_0x82f63b78_consts ____cacheline_aligned __maybe_unused = {
+	.fold_across_2048_bits_consts = {
+		0x00000000dcb17aa4,	/* HI64_TERMS: (x^2079 mod G) * x^32 */
+		0x00000000b9e02b86,	/* LO64_TERMS: (x^2015 mod G) * x^32 */
+	},
+	.fold_across_1024_bits_consts = {
+		0x000000006992cea2,	/* HI64_TERMS: (x^1055 mod G) * x^32 */
+		0x000000000d3b6092,	/* LO64_TERMS: (x^991 mod G) * x^32 */
+	},
+	.fold_across_512_bits_consts = {
+		0x00000000740eef02,	/* HI64_TERMS: (x^543 mod G) * x^32 */
+		0x000000009e4addf8,	/* LO64_TERMS: (x^479 mod G) * x^32 */
+	},
+	.fold_across_256_bits_consts = {
+		0x000000003da6d0cb,	/* HI64_TERMS: (x^287 mod G) * x^32 */
+		0x00000000ba4fc28e,	/* LO64_TERMS: (x^223 mod G) * x^32 */
+	},
+	.fold_across_128_bits_consts = {
+		0x00000000f20c0dfe,	/* HI64_TERMS: (x^159 mod G) * x^32 */
+		0x00000000493c7d27,	/* LO64_TERMS: (x^95 mod G) * x^32 */
+	},
+	.shuf_table = {
+		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+		 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
+		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	},
+	.barrett_reduction_consts = {
+		0x4869ec38dea713f1,	/* HI64_TERMS: floor(x^95 / G) */
+		0x0000000105ec76f0,	/* LO64_TERMS: (G - x^32) * x^31 */
+	},
+};
+
 /*
  * CRC folding constants generated for most-significant-bit-first CRC-64 using
  * G(x) = x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^45 +
  *        x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^27 +
  *        x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
diff --git a/lib/crc/x86/crc32.h b/lib/crc/x86/crc32.h
index ba4dacf23340c..0c2f4e5cc86df 100644
--- a/lib/crc/x86/crc32.h
+++ b/lib/crc/x86/crc32.h
@@ -9,10 +9,11 @@
 
 #include "crc-pclmul-template.h"
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pclmulqdq);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_vpclmul_avx512);
 
 DECLARE_CRC_PCLMUL_FUNCS(crc32_lsb, u32);
 
 static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
@@ -42,16 +43,50 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 	if (!static_branch_likely(&have_crc32))
 		return crc32c_base(crc, p, len);
 
 	if (IS_ENABLED(CONFIG_X86_64) && len >= CRC32C_PCLMUL_BREAKEVEN &&
 	    static_branch_likely(&have_pclmulqdq) && crypto_simd_usable()) {
+		/*
+		 * Long length, the vector registers are usable, and the CPU is
+		 * 64-bit and supports both CRC32 and PCLMULQDQ instructions.
+		 * It is worthwhile to divide the data into multiple streams,
+		 * CRC them independently, and combine them using PCLMULQDQ.
+		 * crc32c_x86_3way() does this using 3 streams, which is the
+		 * most that x86_64 CPUs have traditionally been capable of.
+		 *
+		 * However, due to improved VPCLMULQDQ performance on newer
+		 * CPUs, use crc32_lsb_vpclmul_avx512() instead of
+		 * crc32c_x86_3way() when the CPU supports VPCLMULQDQ and has a
+		 * "good" implementation of AVX-512.
+		 *
+		 * Future work: the optimal strategy on Zen 3--5 is actually to
+		 * use both crc32q and VPCLMULQDQ in parallel.  Unfortunately,
+		 * different numbers of streams and vector lengths are optimal
+		 * on each CPU microarchitecture, making taking advantage of
+		 * this challenging.  (Zen 5 even supports 7 parallel crc32q, a
+		 * major upgrade.)  For now, just choose between
+		 * crc32c_x86_3way() and crc32_lsb_vpclmul_avx512().  The latter
+		 * is needed anyway for crc32_le(), so we just reuse it here.
+		 */
 		kernel_fpu_begin();
-		crc = crc32c_x86_3way(crc, p, len);
+		if (static_branch_likely(&have_vpclmul_avx512))
+			crc = crc32_lsb_vpclmul_avx512(crc, p, len,
+				       crc32_lsb_0x82f63b78_consts.fold_across_128_bits_consts);
+		else
+			crc = crc32c_x86_3way(crc, p, len);
 		kernel_fpu_end();
 		return crc;
 	}
 
+	/*
+	 * Short length, XMM registers unusable, or the CPU is 32-bit; but the
+	 * CPU supports CRC32 instructions.  Just issue a single stream of CRC32
+	 * instructions inline.  While this doesn't use the CPU's CRC32
+	 * throughput very well, it avoids the need to combine streams.  Stream
+	 * combination would be inefficient here.
+	 */
+
 	for (num_longs = len / sizeof(unsigned long);
 	     num_longs != 0; num_longs--, p += sizeof(unsigned long))
 		asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned long *)p));
 
 	if (sizeof(unsigned long) > 4 && (len & 4)) {
@@ -79,10 +114,11 @@ static inline void crc32_mod_init_arch(void)
 		static_branch_enable(&have_pclmulqdq);
 		if (have_vpclmul()) {
 			if (have_avx512()) {
 				static_call_update(crc32_lsb_pclmul,
 						   crc32_lsb_vpclmul_avx512);
+				static_branch_enable(&have_vpclmul_avx512);
 			} else {
 				static_call_update(crc32_lsb_pclmul,
 						   crc32_lsb_vpclmul_avx2);
 			}
 		}
-- 
2.50.1

