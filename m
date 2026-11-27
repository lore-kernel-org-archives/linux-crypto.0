Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798674;
	b=jfv3+NTCGu14WpeIDqEiUHmPw8AVngHlosm+fCM65JulG6OMYeYBQWVeQqLE4ai2jKUf
	 tN4rRikg9ZcGXlCBARZMh8hkEwT+qg4q39DBSxe5pgV/FhBKuC1ZXTiuaX1k9NJiuBv6M
	 Z/Yk+Xtl0sh0G2pw+mTd6QdCF00GjYM4oJt6rVkHjDjF6FpMl2peE98By94IpN3vKMztB
	 aX5OmHFS605IRs7wQ5E/TeEvdEJKXiFM7Bkk3EHSog1DyZmeV2dSoNg0M3ub0aXCqHYpZ
	 fyJg/roYeG0dn+zsDLcm2AiyYZl59XSKSUzmV8+uHb33XW3l3xuOy47y7KZ/6PEBjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=D0lF3H3CvpgXpZNd97DaJwT9eMd2KLLk6a/xCgK/gEE=;
	b=VlnYyI9bvOPSNf6kpFvdNwC/L0vwncqdIxfKNKb+Ra8mLbNvgOQPE2OBK3XgNVCDsDg2
	 STWPSqhcp0srFiFLUf9JQwdRleX4QLhsf0hlDIGMHHKtR93QcHOIbMQeB0RdkFrUSboO2
	 c+7DuOjXAXxiSuQb1F62wOZnzmJXzf2Kv1QCtbHzaD0wjKm+LGScPAIdj3a2kQpjubb2W
	 15ZmHO5PXHcwla2M9vzy/ryTKjhZO2NhCwj0BaRtDxpb6flzKGRY5+/k8v/uSwnFXIJ5C
	 VN3mGzlCPkGO3+4F46hhspel3/lDA1XrNdzeyq187ld1kA6U1PATwLIIgbIFNelb5Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f70RYqoa;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34CB606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 16:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D34CB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f70RYqoa
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-14394530ec6so2404990c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 08:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795798673; x=1796403473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D0lF3H3CvpgXpZNd97DaJwT9eMd2KLLk6a/xCgK/gEE=;
        b=f70RYqoaAkJZTssS88gClRjychZA17GYTDoz19RuPFdkJE2wJXhpNioQpsyPN+WjEM
         2y81YnssksWGGeaLYA6ffkxi3KhcvL0qFMorYxcSUmgtbueZSOyPR9M64r/Y+KrETtIM
         lWEhR97XvSE3uJTFFBN3Ugx3ZtQ887u8UJC2tEMB4sM1b4zasoGN4Il0uRs2ML62GgRm
         a/080VgzJrN9Z/UzyTGfVKRwATRl6XzPE7TnnFW93/JWVXhEcDm06Q7ZMlPHc/7C8pcb
         haGTEBUzq/yqV/79j6L80ykcZcwkyU0RX36Cz/Rs6jCAOr08JF3zh3GvqJXerWSY7NIm
         KqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795798673; x=1796403473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D0lF3H3CvpgXpZNd97DaJwT9eMd2KLLk6a/xCgK/gEE=;
        b=kSKRGMeWFxep3Xf//AjYbQ0lj0swRnevCCE72U5PhV189wgvawiDLnVVGI0EG5a/Xo
         RkEY2T5gG5b2bmXewSr7h4Ic4oerM0xILayOKL/cqHS4P7I+H2gUn3UzwLQJY8DGkKlS
         nuMLzd3JOu4zApm0hri3WAjWPJunQvb4ON7lSvxXydHwCmQ8OR9dRfWMPHrgGivYSQ9L
         3b+dVAo/NZt6jFuoq9BfBhsgQkkWQr486NijNjxlMDw1ZbtoYhBrBVRmk4Zp6GPyG67s
         KAVfL4PkyXem81hBApO8qIatuOf2CJEMOV0htqUg/ptc8JSYyhJDHZ/XwUVYdn2ufANH
         N03g==
X-Gm-Message-State: APuU4Z/cTduXvNCUsYiJRiOwcYSct6jYXvtlefqIRy9uO2ruzjybvj3B
	/EFaK2+tLReS/xPx9b+bN617mToYvAkjcf0jKGw7CKfnzlGkVl1HBoNvQAWG2x2L
X-Gm-Gg: AZFdTZdqevwinXzG3b5mEj2OI4uQyBCqbXmW1SrkQ+ZrfXvLwPCfqyhhNksKuN6LxGt
	EYzFPu05RywPApROwkfkQd6fzuZMIWRO9Kt4TThOqjv71zhekD6omXEw9caYkLaGF+iNemhjeNV
	cchsGRjm1XNfeLjE9FUu3l/+ZFve1EnlqE6GiVPLh1YWyZtd3PCkaLYhNNx4/MNJ5CwM5hdI13+
	m4SmdUVempq2ii25V9u9uNRatqqSR33ZwJB3HRhX5kp6WqdtG14nesnE6SMwa/2ESE3htQjR4D6
	v5kJKo4d1bESEdoGthnkaMUgrkV+lOLefQhErGzZnkQSeCjVghSJ3lk/49ZaVGy4fAGdDHbKKqn
	DKAkNndhC8yiQ5x4zlyMiNCg0HyqQtjYzu2cMRiv4xe1Emh5zM2v8Gra9qiO3RUIhVuZZen5CTx
	Qa0mjR4OWErXs2IeCqb4MeJ47tOjaSsPeQ/y5A6l+0noUWzdYxpsaIPcWOsNNJS7YJNpM6XQ5l/
	Dv/LSSxsj4VDKKc3sUes221MbdKCrlanqNiA5RdnG7fpOLXWvslFU6JYFSe7Rr1HZPZ3ldmxq5i
	/zK8/f3PVR6n39LBKcB6kSglKce+MQ==
X-Received: by 2002:a05:7022:b0c8:b0:185:8c9f:de82 with SMTP id a92af1059eb24-1b5568fa1b1mr22397234c88.33.1795798672855;
        Fri, 27 Nov 2026 08:57:52 -0800 (PST)
Received: from gentoo ([49.204.145.8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm65464752c88.13.2026.11.27.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 08:57:52 -0800 (PST)
From: Shreesh Adiga <16567adigashreesh@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH v3] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
Date: Fri, 27 Nov 2026 22:27:39 +0530
Message-ID: <20261127165747.512950-1-16567adigashreesh@gmail.com>
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

Add a crc64_nvme implementation which benefits ARMv8.2 and
later processors with the SHA3 extension.

Usage of EOR3 from SHA3 extension improves performance by 20% compared
to the regular PMULL without EOR3 on Cortex-X925 measured in userspace
benchmark for 512 byte input size.

Move the existing PMULL implementation into a __always_inline function
and instantiate it twice with a boolean parameter which controls when
EOR3 is used. This is only enabled for AArch64 since the SHA3 extension
is not available in AArch32.

Use static_branch mechanism for dispatch in arm64 and enable the EOR3
variant when the CPU is determined to be not slower due to EOR3 and
PMULL sharing pipeline stage. Currently Neoverse N2 is placed on the
list to disable EOR3 based on Software Optimization Guide mentioning the
pipeline V0 being used by both PMULL and EOR3 and V used by EOR.

Tested on KUnit for correctness on both AArch32 and AArch64.

Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
---
Changes in v3:
 Avoid running EOR3 routine on Neoverse N2.
 Reuses code from PMULL implementation which was extended to support
 various optimizations like 4x unrolling and partial_block handling.
 Use inline assembly for EOR3 rather than veor3q_u64() intrinsic for GCC
 8.1 support.

Changes in v2:
 Added 2x reduction based on fold_consts_v2, use static key for PMULL
 and EOR3 instead of regular branch. 

Link to v1: https://lore.kernel.org/linux-crypto/20261114115749.1061233-1-16567adigashreesh@gmail.com/

Note:
 This patch depends on mainline 
 ff049836f05f5e46f702858a7cb949998e85a310 
 lib/crc: Don't include <linux/types.h> in NEON intrinsics code
 It also builds on top of crc-next submitted patch
 lib/crc: Add 4-way folding in NEON crc64_nvme implementation

 lib/crc/arm64/crc64-neon.h | 15 +++++++++
 lib/crc/arm64/crc64.h      | 28 ++++++++++++++--
 lib/crc/crc64-neon.c       | 66 ++++++++++++++++++++++++++++----------
 3 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
index d872f4d4e2e7..40f37ff0407c 100644
--- a/lib/crc/arm64/crc64-neon.h
+++ b/lib/crc/arm64/crc64-neon.h
@@ -32,3 +32,18 @@ static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
 {
 	return pmull64(vextq_u64(a, a, 1), b);
 }
+
+/*
+ * Use inline asm instead of veor3q_u64() intrinsic: GCC 8.1 doesn't provide
+ * that, and the target("+sha3") attribute it needs prevents some GCC versions
+ * from inlining the PMULL helpers. This follows lib/raid/xor/arm64/xor-eor3.c.
+ */
+static inline uint64x2_t eor3(uint64x2_t p, uint64x2_t q, uint64x2_t r)
+{
+	uint64x2_t res;
+
+	asm(".arch_extension sha3\n"
+	    "eor3 %0.16b, %1.16b, %2.16b, %3.16b"
+	    : "=w"(res) : "w"(p), "w"(q), "w"(r));
+	return res;
+}
diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
index 06dd08a21dd6..0cf79b9da578 100644
--- a/lib/crc/arm64/crc64.h
+++ b/lib/crc/arm64/crc64.h
@@ -4,13 +4,16 @@
  */
 
 #include <linux/cpufeature.h>
+#include <asm/cputype.h>
 #include <asm/simd.h>
 #include <linux/minmax.h>
 #include <linux/sizes.h>
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_eor3);
 
 #define crc64_be_arch crc64_be_generic
 
@@ -18,8 +21,12 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 {
 	if (static_branch_likely(&have_pmull) && len >= 128 &&
 	    likely(may_use_simd())) {
-		scoped_ksimd()
-			crc = crc64_nvme_neon(crc, p, len);
+		scoped_ksimd() {
+			if (static_branch_likely(&have_eor3))
+				crc = crc64_nvme_neon_pmull_eor3(crc, p, len);
+			else
+				crc = crc64_nvme_neon(crc, p, len);
+		}
 
 		return crc;
 	}
@@ -29,6 +36,21 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 #define crc64_mod_init_arch crc64_mod_init_arch
 static void crc64_mod_init_arch(void)
 {
-	if (cpu_have_named_feature(PMULL))
+	/*
+	 * On Neoverse N2, EOR3 can only issue on V0 pipeline, which PMULL
+	 * also uses, so the EOR3 variant has lower throughput than plain EOR
+	 * as per documentation in Arm Neoverse N2 Software Optimization Guide.
+	 */
+	static const struct midr_range eor3_slow_cpus[] = {
+		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+		{}
+	};
+
+	if (cpu_have_named_feature(PMULL)) {
 		static_branch_enable(&have_pmull);
+
+		if (cpu_have_named_feature(SHA3) &&
+		    !is_midr_in_range_list(eor3_slow_cpus))
+			static_branch_enable(&have_eor3);
+	}
 }
diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
index 18eb17d5462b..faa681bebfec 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -3,12 +3,16 @@
  * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
  */
 
+#include <stdbool.h>
 #include <stddef.h>
 #include <asm/neon-intrinsics.h>
 
 #include "crc64-neon.h"
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
+#ifdef CONFIG_ARM64
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
+#endif
 
 /* x^575 mod G, x^511 mod G */
 static const uint64_t fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
@@ -23,14 +27,27 @@ static const uint64_t fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const uint64_t bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
 					 0x34d926535897936aULL };
 
+static __always_inline uint64x2_t xor3(uint64x2_t t1,
+				       uint64x2_t t2,
+				       uint64x2_t t3,
+				       __maybe_unused bool use_eor3)
+{
+#ifdef CONFIG_ARM64
+	if (use_eor3)
+		return eor3(t1, t2, t3);
+#endif
+	return t1 ^ t2 ^ t3;
+}
+
 static __always_inline uint64x2_t fold_single_round(uint64x2_t fold,
 						    uint64x2_t temp,
-						    uint64x2_t consts)
+						    uint64x2_t consts,
+						    bool use_eor3)
 {
 	uint64x2_t temp1 = pmull64(consts, fold);
 	uint64x2_t temp2 = pmull64_high(consts, fold);
 
-	return temp ^ temp1 ^ temp2;
+	return xor3(temp, temp1, temp2, use_eor3);
 }
 
 /*
@@ -45,7 +62,8 @@ static __always_inline uint64x2_t fold_single_round(uint64x2_t fold,
 static __always_inline uint64x2_t fold_partial_block(uint64x2_t fold,
 						     uint64x2_t consts,
 						     const u8 *p,
-						     size_t len)
+						     size_t len,
+						     bool use_eor3)
 {
 	static const u8 crc_neon_shift_tab[32] = {
 		0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9, 0xf8,
@@ -68,10 +86,11 @@ static __always_inline uint64x2_t fold_partial_block(uint64x2_t fold,
 
 	return fold_single_round(vreinterpretq_u64_u8(a),
 				 vreinterpretq_u64_u8(b),
-				 consts);
+				 consts, use_eor3);
 }
 
-u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
+static __always_inline u64 crc64_nvme_neon_body(u64 crc, const u8 *p,
+						size_t len, bool use_eor3)
 {
 	/* Assumes len >= 128. */
 	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
@@ -94,39 +113,39 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
 		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
 
-		v0 = fold_single_round(v0, t0, fold_consts_4x);
-		v1 = fold_single_round(v1, t1, fold_consts_4x);
-		v2 = fold_single_round(v2, t2, fold_consts_4x);
-		v3 = fold_single_round(v3, t3, fold_consts_4x);
+		v0 = fold_single_round(v0, t0, fold_consts_4x, use_eor3);
+		v1 = fold_single_round(v1, t1, fold_consts_4x, use_eor3);
+		v2 = fold_single_round(v2, t2, fold_consts_4x, use_eor3);
+		v3 = fold_single_round(v3, t3, fold_consts_4x, use_eor3);
 		p += 64;
 		len -= 64;
 	} while (len >= 64);
 
-	v0 = fold_single_round(v0, v2, fold_consts_2x);
-	v1 = fold_single_round(v1, v3, fold_consts_2x);
+	v0 = fold_single_round(v0, v2, fold_consts_2x, use_eor3);
+	v1 = fold_single_round(v1, v3, fold_consts_2x, use_eor3);
 
 	if (len >= 32) {
 		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
 		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
 
-		v0 = fold_single_round(v0, t0, fold_consts_2x);
-		v1 = fold_single_round(v1, t1, fold_consts_2x);
+		v0 = fold_single_round(v0, t0, fold_consts_2x, use_eor3);
+		v1 = fold_single_round(v1, t1, fold_consts_2x, use_eor3);
 		p += 32;
 		len -= 32;
 	}
 
-	v0 = fold_single_round(v0, v1, fold_consts);
+	v0 = fold_single_round(v0, v1, fold_consts, use_eor3);
 
 	if (len >= 16) {
 		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
 
-		v0 = fold_single_round(v0, t0, fold_consts);
+		v0 = fold_single_round(v0, t0, fold_consts, use_eor3);
 		p += 16;
 		len -= 16;
 	}
 
 	if (len)
-		v0 = fold_partial_block(v0, fold_consts, p, len);
+		v0 = fold_partial_block(v0, fold_consts, p, len, use_eor3);
 
 	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
 	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
@@ -135,7 +154,20 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 	uint64x2_t bconsts = vld1q_u64(bconsts_val);
 	uint64x2_t final = pmull64(bconsts, v0);
 
-	v0 ^= vextq_u64(zero, final, 1) ^ pmull64_hi_lo(bconsts, final);
+	v0 = xor3(v0, vextq_u64(zero, final, 1),
+		  pmull64_hi_lo(bconsts, final), use_eor3);
 
 	return vgetq_lane_u64(v0, 1);
 }
+
+u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
+{
+	return crc64_nvme_neon_body(crc, p, len, false);
+}
+
+#ifdef CONFIG_ARM64
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len)
+{
+	return crc64_nvme_neon_body(crc, p, len, true);
+}
+#endif
-- 
2.56.1

