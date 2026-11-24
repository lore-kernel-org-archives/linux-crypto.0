Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500013;
	b=UygVK+d4NGsojlL8sfGAPT0p2Vdjlp5Gc/YftBrpNY6qVvkPUFYTvMohVVkBjVyPPXOT
	 fsxhMBgg831OArBevVtRWWVpHY9AKuZl0S8CI0BFGK8LnbuoPH7yrYDkLgdIHjk5ne0pV
	 wNaTWAB7K15b99aTVj8aO2soc9LO7Rzb057DbPEqZ1qjs27NUqTUoZ/962oDYSORQyuMe
	 n4JqL75zxFBB+Rhn9r2f521SsoAhkVtxjfAFw6/h87DPG3g/N09gVNIFOrpWO6lUh16L0
	 bZ9vUAHLqye5xEgBZkGkfVikEzJl/A2JydzSbFHBih2XCPTdd/xoq6UkvmSCMMfevvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500013;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5MgS1x4Y6uaqxSwn97B0tMnpa/cyWO9jOrj+89DUa6Y=;
	b=MNN96Lx83duLedI8T8dBl6AQLpSQOKL5Igj/F8zRnHRUxFLuxnovF0QcUi5/eOAvAqCf
	 QLAxlDRAiJLoJGgcPHQIuGMQH8uepFdTUQhGzwxlB33OTQ9ychLzgQ4hxRN6umWVgLRaO
	 Q+VabmhCJ89TtPq6bgmlXCQk/ydkl5ruX1UiOjrmQfd+FFU7T3YQvYmd82T1M9RvYJj0p
	 RlWb/cGrWZFIlvDnOstVwM3/uYoXIbF+1CBVi5Fy2QbMvlNFh6xo31RFZ4lNeZumigu9z
	 Rvv18Tz0aqjlXHcqq+XuM5myIa3qdgYFav/jgBVSA5W7F7vEHpX1GadpSMgZU5ocrQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvrzp8st;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1433606A321
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 06:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1433606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvrzp8st
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-38587f3de36so5004442eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 22:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795500012; x=1796104812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5MgS1x4Y6uaqxSwn97B0tMnpa/cyWO9jOrj+89DUa6Y=;
        b=yvrzp8stjLjA1+NsQti3XIG+7zTJ+XK0jf7WD4vfnDtcvTFiRsfDni2aEhPiQ95L5J
         ZRlMyBBAcPFYZV1+P/FpukSGH+K2acPYjyVFFS5Ohg8D/I9noqz/2poeX3ChU/yUqAi+
         TLOFjlRkkaMXzuU1bnmX4aC588col37v6zIyFAu210aVkFuZXONQkLr/1E48ENBH2Ktc
         PX6RrpjQj1W7PoqjKm24eUbNg/do2vnnbdI0MQo4qignAKhowTwiEzV8fhOYzk3WBafh
         v3+M8Pyll9YNvxpjg0BZhadB+JOblQsa9IBo+JA1CjGtEKcbbajY3Fqh0aO9SYjyE2Y0
         cv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795500012; x=1796104812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5MgS1x4Y6uaqxSwn97B0tMnpa/cyWO9jOrj+89DUa6Y=;
        b=cBVYMUrHqzZsz+FIO/p4ueqpKkT4t/DfbvmYV7sQ0w4QzGVFu5dWXCmgZCbTstHdzk
         S20opdRMHmfEQdUtRtJcFaBDnqd6i8fz16fppeuk55WSl4tFR+T7KOHM3DooWVnI4AI3
         YJbIq71vertqCjAEFU7GFXwL8My4MIduRekTAeuD3T+/+cfcdoR9X+k9h5DyhgfqWtfO
         TmPuPxoVFssNLIwf6UwHmIll/L/MiDsMZoeRYMEinYYgCPOerm8Slvz72E1d96ercEs/
         2D3lGp69UgC/d+/UWxZbOOPpergrQ7PGlu6colTa+W/DdGO6zikuZ2XImOT98gm/zo+8
         AgRA==
X-Gm-Message-State: APuU4Z8HbPRQRYeqmcc1bOIRmMz2C++oylHEt08DLCLJ6hOMTtS+MPS/
	jt7DjcGitik76cgGruUSMvtATX450eBKRqOvcJYAQKMzlFy82qxH2sP7
X-Gm-Gg: AZFdTZe2zOmyyQL42lZKoiK3vLMkLojuieeVg7ADe4LWeqUXYaPABUdxw7f2RdiCzcZ
	YBPO2EHuioe+9WsNbL2/Qs3gsTvNw9F0CnpaQS+FvOn8e/Tz0wuX01X92GKd+CTSZs17wEKm63Q
	u2w4G/C0vP8yj2RQHuGm5D1/1cOu8eEokqH06Rs1z15QdzEfHiCs87Q5I31lataefow8y+AlPzB
	K0R3jGWP/coT/nHygoebRFYpONd48AYxo1nf+K1GiLG/7ga3hdO8VPJ12OMhWsbSWCP815F9VFx
	Js+NWyriXYJx1myG1SY6/Xs2ds0EDgXdHH70Wp5aQMp6iVYZtO1whqReGHtgFzEmnP+jsQOGIHf
	XmWUrUsFyOzbrBd0W6Rlbl157tkRQzu1i+11+CRrwncYfAwElYLrn1rwRYCl5KbAEwCQCkYm4Xt
	zIgrCvMx1MiEojoc07RniZqYTZf+/cIOHoo803hG3ZvLbttTExwHIxH7JtwjWt1aMHA+q3ef5Uz
	rNRirAOfQd4jvtEiuAiTSF7YcyD4UD3VAWfLtf00eKWGt/9O3rMSeAIVLcpci4RMFAecPcNOsWI
	waVwJoVM9Ik7R5KFU+6ENmn0n3vdtg==
X-Received: by 2002:a05:693c:2181:b0:36c:b7b4:407e with SMTP id 5a478bee46e88-3856fd57eb1mr15125159eec.22.1795500011504;
        Mon, 23 Nov 2026 22:00:11 -0800 (PST)
Received: from gentoo ([49.204.145.8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5568592adsm31846305c88.15.2026.11.23.22.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 22:00:11 -0800 (PST)
From: Shreesh Adiga <16567adigashreesh@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH v3] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Date: Tue, 24 Nov 2026 11:29:51 +0530
Message-ID: <20261124060006.862167-1-16567adigashreesh@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use 4-way folding in the shared NEON crc64_nvme for AArch64
as well as AArch32. This improves performance by about 2x for 512 byte
data size on Cortex-X925, as measured with a userspace benchmark.

Add similar optimizations from x86 implementation like reducing
the 4x to 2x and doing a tail (len >= 32) 2x fold as well as partial
block handling to process lengths which are not multiple of 16 bytes.

The partial block handling uses vqtbl1q_u8(), which AArch32 does not
provide, so implement it for AArch32 using two vtbl2_u8() lookups, the
same emulation used by lib/raid/raid6/arm/recov_neon_inner.c.

crc64_nvme_neon() therefore accepts any len >= 128 on both
architectures. The AArch64 dispatch code now passes the full length, and
the AArch32 dispatch code no longer rounds chunks down to a multiple of
16 bytes: each chunk is 4 KiB, or the whole remaining length if less
than 4 KiB + 128 bytes remains, so no tail is left for the generic
implementation.

On AArch64, check for PMULL with a static key, and implement the PMULL
helpers with inline asm. With the vmull_p64() intrinsics, compilers
build the fold constants in general purpose registers with mov/movk and
transfer them with fmov/dup, up to 10 instructions per constant pair,
instead of loading them from memory.

Tested for correctness with the CRC KUnit tests under QEMU on both
AArch64 and AArch32.

Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
---
Changes in v3:
- Make the partial_block logic more readable as per suggestion by Ard.
  Mark the helper functions __always_inline inside the crc64-neon.c
  file.

Changes in v2:
- Squash in the follow-up requested by Eric: AArch32 partial block
  support, AArch32 chunking without rounding to 16 bytes, and comments
  explaining the inline asm and partial block handling.
- Use uint64_t for fold_consts_4x_val and fold_consts_2x_val, fixing the
  build failure reported.
- Rebase onto v7.4-rc4

v1: https://lore.kernel.org/all/20261118160110.1662470-1-16567adigashreesh@gmail.com/

 lib/crc/arm/crc64-neon.h   |  16 ++++++
 lib/crc/arm/crc64.h        |   4 +-
 lib/crc/arm64/crc64-neon.h |  27 +++++++---
 lib/crc/arm64/crc64.h      |  18 ++++---
 lib/crc/crc64-neon.c       | 106 ++++++++++++++++++++++++++++++++++---
 5 files changed, 150 insertions(+), 21 deletions(-)

diff --git a/lib/crc/arm/crc64-neon.h b/lib/crc/arm/crc64-neon.h
index 645f553220ff..0d0071a92071 100644
--- a/lib/crc/arm/crc64-neon.h
+++ b/lib/crc/arm/crc64-neon.h
@@ -32,3 +32,19 @@ static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
 
 	return result;
 }
+
+/*
+ * AArch32 does not provide this intrinsic natively because it does not
+ * implement the underlying instruction. AArch32 only provides a 64-bit
+ * wide vtbl.8 instruction, so use that instead.
+ */
+static inline uint8x16_t vqtbl1q_u8(uint8x16_t a, uint8x16_t b)
+{
+	union {
+		uint8x16_t	val;
+		uint8x8x2_t	pair;
+	} __a = { a };
+
+	return vcombine_u8(vtbl2_u8(__a.pair, vget_low_u8(b)),
+			   vtbl2_u8(__a.pair, vget_high_u8(b)));
+}
diff --git a/lib/crc/arm/crc64.h b/lib/crc/arm/crc64.h
index de274288af61..ce0ffe590596 100644
--- a/lib/crc/arm/crc64.h
+++ b/lib/crc/arm/crc64.h
@@ -13,10 +13,10 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
 static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 {
-	if (len >= 128 && static_branch_likely(&have_pmull) &&
+	if (static_branch_likely(&have_pmull) && len >= 128 &&
 	    likely(may_use_simd())) {
 		do {
-			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+			size_t chunk = (len < SZ_4K + 128) ? len : SZ_4K;
 
 			scoped_ksimd()
 				crc = crc64_nvme_neon(crc, p, chunk);
diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
index fcd5b1e6f812..d872f4d4e2e7 100644
--- a/lib/crc/arm64/crc64-neon.h
+++ b/lib/crc/arm64/crc64-neon.h
@@ -1,21 +1,34 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+/*
+ * The PMULL helpers below use inline asm instead of the vmull_p64() and
+ * vmull_high_p64() intrinsics. vmull_p64() takes poly64_t scalars, so the low
+ * lanes have to be extracted with vgetq_lane_u64(). For the fold constants,
+ * compilers fold that extraction into a 64-bit immediate: recent GCC and Clang
+ * build it in a GPR with mov/movk and transfer it with fmov (Clang also
+ * rebuilds the high half used by pmull2 with mov/movk and dup), instead of
+ * loading the constant pair with a single ldr. With asm operating on whole
+ * vector registers, the constants are loaded from .rodata and pmull reads
+ * the low lanes in place.
+ */
+
 static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
 {
-	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
-						vgetq_lane_u64(b, 0)));
+	uint64x2_t r;
+
+	asm("pmull %0.1q, %1.1d, %2.1d" : "=w"(r) : "w" (a), "w" (b));
+	return r;
 }
 
 static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
 {
-	poly64x2_t l = vreinterpretq_p64_u64(a);
-	poly64x2_t m = vreinterpretq_p64_u64(b);
+	uint64x2_t r;
 
-	return vreinterpretq_u64_p128(vmull_high_p64(l, m));
+	asm("pmull2 %0.1q, %1.2d, %2.2d" : "=w"(r) : "w" (a), "w" (b));
+	return r;
 }
 
 static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
 {
-	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 1),
-						vgetq_lane_u64(b, 0)));
+	return pmull64(vextq_u64(a, a, 1), b);
 }
diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
index c7a69e1f3d8f..06dd08a21dd6 100644
--- a/lib/crc/arm64/crc64.h
+++ b/lib/crc/arm64/crc64.h
@@ -10,19 +10,25 @@
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
+
 #define crc64_be_arch crc64_be_generic
 
 static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 {
-	if (len >= 128 && cpu_have_named_feature(PMULL) &&
+	if (static_branch_likely(&have_pmull) && len >= 128 &&
 	    likely(may_use_simd())) {
-		size_t chunk = len & ~15;
-
 		scoped_ksimd()
-			crc = crc64_nvme_neon(crc, p, chunk);
+			crc = crc64_nvme_neon(crc, p, len);
 
-		p += chunk;
-		len &= 15;
+		return crc;
 	}
 	return crc64_nvme_generic(crc, p, len);
 }
+
+#define crc64_mod_init_arch crc64_mod_init_arch
+static void crc64_mod_init_arch(void)
+{
+	if (cpu_have_named_feature(PMULL))
+		static_branch_enable(&have_pmull);
+}
diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
index 1267df1310be..18eb17d5462b 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -10,6 +10,12 @@
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
+/* x^575 mod G, x^511 mod G */
+static const uint64_t fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
+						0x62242240ace5045aULL };
+/* x^319 mod G, x^255 mod G */
+static const uint64_t fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
+						0xe1e0bb9d45d7a44cULL };
 /* x^191 mod G, x^127 mod G */
 static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 					     0x21e9761e252621acULL };
@@ -17,23 +23,111 @@ static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
 					 0x34d926535897936aULL };
 
+static __always_inline uint64x2_t fold_single_round(uint64x2_t fold,
+						    uint64x2_t temp,
+						    uint64x2_t consts)
+{
+	uint64x2_t temp1 = pmull64(consts, fold);
+	uint64x2_t temp2 = pmull64_high(consts, fold);
+
+	return temp ^ temp1 ^ temp2;
+}
+
+/*
+ * Fold in the final 1 <= len <= 15 bytes. With A = fold, the remaining
+ * polynomial is A*x^(8*len) + B. Rewrite it as C1*x^128 + C2, where
+ * C1 = floor(A / x^(128 - 8*len)) and C2 = (A*x^(8*len) mod x^128) + B,
+ * then fold C1 into C2. t1 selects the len highest-degree bytes of A to
+ * form C1; ~t1 selects the remaining bytes to form A*x^(8*len) mod x^128,
+ * since tbl returns 0 for any index >= 16. The sign of t1 then selects
+ * which bytes of C2 come from B.
+ */
+static __always_inline uint64x2_t fold_partial_block(uint64x2_t fold,
+						     uint64x2_t consts,
+						     const u8 *p,
+						     size_t len)
+{
+	static const u8 crc_neon_shift_tab[32] = {
+		0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8,
+		0xf7, 0xf6, 0xf5, 0xf4, 0xf3, 0xf2, 0xf1, 0xf0,
+		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	};
+
+	uint8x16_t last16, f, t1, t2, a, b;
+	int8x16_t  mask;
+
+	last16 = vld1q_u8(p + len - 16);
+	f      = vreinterpretq_u8_u64(fold);
+	t1     = vld1q_u8(crc_neon_shift_tab + len);
+	a      = vqtbl1q_u8(f,  t1);
+	t2     = vqtbl1q_u8(f, ~t1);
+	mask   = vreinterpretq_s8_u8(t1) >> 7;
+	t1     = vreinterpretq_u8_s8(mask);
+	b      = vbslq_u8(t1, t2, last16);
+
+	return fold_single_round(vreinterpretq_u64_u8(a),
+				 vreinterpretq_u64_u8(b),
+				 consts);
+}
+
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 {
+	/* Assumes len >= 128. */
 	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
+	uint64x2_t fold_consts_4x = vld1q_u64(fold_consts_4x_val);
+	uint64x2_t fold_consts_2x = vld1q_u64(fold_consts_2x_val);
 	uint64x2_t v0 = { crc, 0 };
 	uint64x2_t zero = { };
+	uint64x2_t v1, v2, v3;
+
+	v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
+	v1  = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+	v2  = vreinterpretq_u64_u8(vld1q_u8(p + 32));
+	v3  = vreinterpretq_u64_u8(vld1q_u8(p + 48));
+
+	p += 64;
+	len -= 64;
+	do {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
+		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
+		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
 
-	for (;;) {
-		v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
+		v0 = fold_single_round(v0, t0, fold_consts_4x);
+		v1 = fold_single_round(v1, t1, fold_consts_4x);
+		v2 = fold_single_round(v2, t2, fold_consts_4x);
+		v3 = fold_single_round(v3, t3, fold_consts_4x);
+		p += 64;
+		len -= 64;
+	} while (len >= 64);
 
+	v0 = fold_single_round(v0, v2, fold_consts_2x);
+	v1 = fold_single_round(v1, v3, fold_consts_2x);
+
+	if (len >= 32) {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
+		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+
+		v0 = fold_single_round(v0, t0, fold_consts_2x);
+		v1 = fold_single_round(v1, t1, fold_consts_2x);
+		p += 32;
+		len -= 32;
+	}
+
+	v0 = fold_single_round(v0, v1, fold_consts);
+
+	if (len >= 16) {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
+
+		v0 = fold_single_round(v0, t0, fold_consts);
 		p += 16;
 		len -= 16;
-		if (len < 16)
-			break;
-
-		v0 = pmull64(fold_consts, v0) ^ pmull64_high(fold_consts, v0);
 	}
 
+	if (len)
+		v0 = fold_partial_block(v0, fold_consts, p, len);
+
 	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
 	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
 

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1

