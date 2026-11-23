Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445172;
	b=WmQmN3wJ4baBb/LQ9oqLZfZJAW+8AIwjHCJ6g8Ig01qX4M8MGzYoIMZ5pleDjNdwSUsS
	 EPhtl38Io16THAkOtlTyqpRg1v7EY/TfvX/drY3k5RiwDwW3h3wUv4AEa/tMGVfx5aEr2
	 b9Gnd17ol3mkg9PIMkEkS5Sbm9opWsS0efB+tfTaFZaPLxrRqyKKYCRonnevDukKv5BYc
	 ZMlBRm2P+Rs5igFuoR7zRx4Q89pFPHYrVC8wXFifz7IyQ9BRKY/x4EFMBq9Zd2TfyDcxg
	 nHsO/aUSWrGWlopm1LjOuisyAm+0ApD7y6fXh27gbidxiVIYylje+at1l9tq7XXYKHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=CyKIXgQRwVnOg/5HTSCC1Br3Rokfn72RQpo0wj7cTcQ=;
	b=QxMJzE1xoaxAAea4IHXnFA00bgHxG919O6fV+UptBpqGSdf2zN6CHxrvShyk5DXSame1
	 dmwSHHgSgszlwLWQCeyYaDCVOVyZy1lAguhhG2Ka8lzTVrD9zFN98OyStspH8uoeRQplK
	 L9WD2cwfdlFu5vmcsQudJM/KBipIOsmxUR7a/grB4WTlmi8fEZKZBzDy02nKvl4+R51oM
	 ShTMrcMkciwACfP2TMUX+bfyXNTskwdNGOhltEwSvpeKDcqMUjgNCdlokzpEULKCPc+LX
	 kYt6hcncyE+PquOxWOVZ3z2qxN7JgaFYkAAXgw4zhx8qdFaJHZY0AX0aId04+V1axzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oFtzshci;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9A6606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 14:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF9A6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oFtzshci
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-15dd124bbe7so2157255c88.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 06:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445171; x=1796049971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CyKIXgQRwVnOg/5HTSCC1Br3Rokfn72RQpo0wj7cTcQ=;
        b=oFtzshciZxQ5faeA/9AVOCD8oXIinEqM8oy2Iim5N5/VUEM8vc+7kguGCnIKwIBq2B
         KxT9FCMkb0rwLZUNwoc4g5B9ZQahUXmVKFLLWACo7/ESvttyHRimh/cR1ZcNHEYdHtQk
         oI3AdvWFmKK9LcT3sfHc0ZR063JZCjDwtNAofvv08PRQbw+QzwfcqaoUyZQEDdxQfA/X
         JcGWeD8xuntlXI1s1YmEZiKUKaXNstx8X+XPyYVD3a/6h8DTrrbtUpp5CXStvyBSXyI9
         7HIwtCtPGJtzu+GfF6y26wxWxlWu5EgKkTSPgTRJ45OmLelkpg4IoFk+sSfzfh6I68Ud
         zXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445171; x=1796049971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CyKIXgQRwVnOg/5HTSCC1Br3Rokfn72RQpo0wj7cTcQ=;
        b=U62KQiMY7II974/QfiY8KDhSbZ5QAQ+SrJG3nug2Eh8T6sYMt6wWGDh1qF0VGc+rN7
         ExdTDLQ1v6WOZYGedgkbTjmov+3No8hA+wq+9+Ifqq1hh/4uVzzldAwcnwPGylLfL28B
         QR1HoNqjBA3m83Wuz6hXhkcWcWyEKPOWXjILSvdFmopGZoc7afmN8gue3Kdm2FvlkPFD
         u16Xq3cO+at3R9odN+MFYq/nET7e5dFz2jehYC/Szr5NfzlhF90fLlGKq6jf75rk4tOn
         3hj8OGVOH88qJRmcB339nvvUj/Y9ZpbleJ/w0k6ZiidYm9gfcHf33gi3qF3wWbvkgV/N
         HXww==
X-Gm-Message-State: APuU4Z8MnfxyTsiay8Fcsxv62AZ8Lk3QYM5sEwNMHt/F61/kSvcrCVLJ
	krGfRqwUu2Bx/IpReySCrCSMt+0pQXp+6m7PUNWSKEbJWtuyYiQdis9G
X-Gm-Gg: AZFdTZdiSdNajmEG6oX1OrzSURjJ9MrraBGPd9+XWW5hudbRPIzaDo/wojQS+JY8dD5
	52Hv5GZa8CTo9fdqpEkO/TMLh8ZUFkif9N1f5BaisRJfrUdhrvDYH0/3r27LRKM7SnJxG49aZ1L
	USMPsOGnWgKpx1oIhmwk7O/z0UdKrzWvGuYIiRgPImIwkjgb1Dk8VD4wtzSE31WzX10Kj8TAsmV
	BStUJc6tVqBRz6YaYcSMQwqMuobGiDu4pf59YN0m6l9jeRtpbt66nbHtSXZXGfPJSgbXZ/LGNPA
	pJu4Izf+hD8ljuGz1cW5zNbsfMgyym3rRKwL2QA2I27/7f2elvVVIOqT7pKeN0KBkWEIwjD4Zdr
	7sK4nbF3y572zam+qqDkNIn1HlfELTwzCh8iu24ZzyllfPqGmI+UxKiUdDadjtANGS24SdEeH4D
	NcxTLjNMQsTZgxB2q+apxSC+s5o2bWEzxhRxN6h7VgbLJ1ZNl0lp4EWJmOsWPczHoVVlH5vPAYc
	nnIXqAj4TTPCZCno4Q06swDELzm0JXk1zErZxMp1xvHR3rwErn6oSma4v+YRSECZWtnV1gzFMb/
	DkUfK6q5FpQRtIuGwvoJgd2NyvWZIA==
X-Received: by 2002:a05:7022:7f04:b0:166:af48:a2ba with SMTP id a92af1059eb24-1b5566fdfc3mr13978613c88.0.1795445170413;
        Mon, 23 Nov 2026 06:46:10 -0800 (PST)
Received: from gentoo ([49.204.145.8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e2bd1sm27955627c88.3.2026.11.23.06.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:46:09 -0800 (PST)
From: Shreesh Adiga <16567adigashreesh@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH v2] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Date: Mon, 23 Nov 2026 20:15:50 +0530
Message-ID: <20261123144605.303362-1-16567adigashreesh@gmail.com>
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
Changes in v2:
- Squash in the follow-up requested by Eric: AArch32 partial block
  support, AArch32 chunking without rounding to 16 bytes, and comments
  explaining the inline asm and partial block handling.
- Use uint64_t for fold_consts_4x_val and fold_consts_2x_val, fixing the
  build failure reported. Also used uint8_t instead of u8 for
  consistency for the partial_block array which is loaded by vld1q_u8.
- Rebase onto v7.4-rc4

v1: https://lore.kernel.org/all/20261118160110.1662470-1-16567adigashreesh@gmail.com/

 lib/crc/arm/crc64-neon.h   |  16 ++++++
 lib/crc/arm/crc64.h        |   4 +-
 lib/crc/arm64/crc64-neon.h |  27 +++++++---
 lib/crc/arm64/crc64.h      |  18 ++++---
 lib/crc/crc64-neon.c       | 100 ++++++++++++++++++++++++++++++++++---
 5 files changed, 144 insertions(+), 21 deletions(-)

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
index 1267df1310be..313676098dee 100644
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
@@ -17,23 +23,105 @@ static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
 					 0x34d926535897936aULL };
 
+static inline uint64x2_t fold_single_round(uint64x2_t fold, uint64x2_t temp,
+					   uint64x2_t consts)
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
+static inline uint64x2_t fold_partial_block(uint64x2_t fold, uint64x2_t consts,
+					    const u8 *p, size_t len)
+{
+	static const uint8_t crc_neon_shift_tab[32] = {
+		0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8,
+		0xf7, 0xf6, 0xf5, 0xf4, 0xf3, 0xf2, 0xf1, 0xf0,
+		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	};
+
+	uint8x16_t last16, t1, t2;
+	uint64x2_t a, b;
+
+	last16 = vld1q_u8(p + len - 16);
+	t1 = vld1q_u8(crc_neon_shift_tab + len);
+	a  = vreinterpretq_u64_u8(vqtbl1q_u8(vreinterpretq_u8_u64(fold), t1));
+	t2 = vmvnq_u8(t1);
+	t2 = vqtbl1q_u8(vreinterpretq_u8_u64(fold), t2);
+	t1 = vreinterpretq_u8_s8(vshrq_n_s8(vreinterpretq_s8_u8(t1), 7));
+	b  = vreinterpretq_u64_u8(vbslq_u8(t1, t2, last16));
+
+	return fold_single_round(a, b, consts);
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

