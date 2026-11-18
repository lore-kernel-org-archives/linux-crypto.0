Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017679;
	b=tBZgmbsHfPwHJm/kxis2Q9sxBlHo2q2UGf/OBcMyGnHo1mnwL7ZFV7mc5Z0bfSaEefos
	 lye00N9f9+xIkUTSFTO5kYVUb1U1prgyEVPZNeVPl0UtOKqAiNfB9OWyFkvUBIb1Z7iFj
	 SiyopB7t9iZdOxv28iC6RdL6+9sJpowPcn6cqVtpOaOmEt/wDTQU4WyfrZWcWcwjLdQmO
	 9L+A1RBtID5jtySV/CUo3YQXdqB4x8iIKeh0zUN7TXHyfgxG/CixN55J+58i+lGg6dcrT
	 GT/OuRDlfk96DjBQRjFu5yPSni5448ft7aboNcLtAGPnqkE8OyxL7KJzDAYA/GSInJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=U8C1CgvvgJkxuBAF5XlPlcDG9pCDTXTfhUIEI+I0GtI=;
	b=Y478RCnwIpVa8RFk+jB2g3NQ0M1bPytm3F1mBTiVW2OP020N0ErCH8e/sBGWsllFIr6z
	 O0X0lg40UrDmZRAemGw/wc78nEXgL4kj7II62yyEYYoI2WTNkIhqo1jEHroTUUHn7OpBi
	 +15C7JJ/UMaiu+Fj2I6fRrY0nV2Isq84d3iWmXzYup206KOST3dGAiymJtrisLQcX+b6r
	 QcmALGxLpyT4sIqxxWbf0noiznmuYAdNnEgbnpH/p01nn9DoTZkfpWrWUCuH5nn2LEGnC
	 otbARmOAlmx3UkKNXD35sW+l9bDEerqqOH58HEMwlnqxldWdCeNpEzCypJpEy/40+RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g370uabh;
	arc=none smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E949A606A333
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 16:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E949A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g370uabh
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4adae187d94so804139fac.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 08:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795017678; x=1795622478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U8C1CgvvgJkxuBAF5XlPlcDG9pCDTXTfhUIEI+I0GtI=;
        b=g370uabhDPxC5ljczIgZFx108Ve2rIBGsXWDAeBUoqdYv98TtS4GHX+yp9vRdhHTMe
         61u6dWYD6+xs+1DEU28L2tav2cxucTbl6lqklZh5CALfHQo4SZijmvp8sczEImHkAOdO
         5FzX3IPSwSdL1lq27m9DQAxc0ymW/kCe9LXOEidaM/7moCl29YZM4ug4V8Lj5cK1gvL0
         aWJJrDjpR4+icksnbzsrv0p0Eyyjmb3zdRUg39Ehr0bo7uF+i9/nrLXGA/3obvBId0tb
         //1mcSUEfSqzHAMPW1NTBe6D/uGufMj8NuGcumk/wvmR+8kh+Kkv9NM0fXijvjRF/VzT
         4RYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795017678; x=1795622478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U8C1CgvvgJkxuBAF5XlPlcDG9pCDTXTfhUIEI+I0GtI=;
        b=foPg2NXvJ7Q94un/usz9UsFQIxrVdm0m8XOwlAcZNHeOUJqwhjW+eJ1pnhlYF+mLDh
         eTcYII3LfOqXaUjVN+w+bORPfN5jTnupx+IxZlut1sVsJbLEXknUkIRe4/h6tg7A71pF
         /4WcBHG/p2DaQ42hmEVh20xyW1Gs8zr1NLxPxzVu+xRwYTxLnZo7d8WpovZaumDu/hqJ
         22pwQENTVYMK4gcnr9iyIatQW6fl4gYUAg7nhi12RQMMJhsVLyklqD/fTPN99ss5N6eT
         ICWOjlpXWb4GJeBrcn5nj/Y8OmayanNfv80nQzV8NLFXdsYSFk5yosyJK5/lGuK2qf39
         09GA==
X-Gm-Message-State: APuU4Z8aH8FNj3afGATEh81AF8MJOpirNyMX16GN892v2sNEAibI5bbX
	D6GTuP2OHOhKf+MeNLNZCgGyuf/BxZMnAHpH+YY3IPtlHH5d14WFId8F
X-Gm-Gg: AYBFou060b5lTVJXAcjV6iueEmoL5T6gQ1iT6p/u81xm7ogqGQni+hTXUkwTcQxlPKG
	ZijfP7ASNhhu5EE5cQcUgEcRPzFMHFZzNW2Ev6dcOITnOCa8b1X/0kuKxjffbClCk8vK2PHRmmo
	9DNAHb6shwT4iJgvCXid68xl/+32yBscbh0OW8vqE62qqB0c+d3E6eosxgtkj5qxHy0/Zb45AyO
	fFDcOD+GU/7VmH6YJgrl9pUjK58rwV+4hYUi1ml6esrj+H5c07Hupct17zuBVYbnKlhOaC5jh6V
	2QbIUzCAUsfCsUUfBSheaDejpeGKCLpUhyvq9qSuZjpS+aLjZUxDwuIz8aniFWiG4xiUbgcxsM+
	BiRa5u1NBC0YtkFbexdE48kizO4SjnXdoumILgtBHgUR3di2dPS43+pewkTF2BuO6Te6URY/TfV
	yLIs89bhgTDRHjbtv0iKtW2HWK/7rLO2DnP8VGKdINd6gJ83IqtvfXVIix+w2I/RZjrWCCGXuBO
	zu7OO4XVfjLCsRjcs7oWMSMbOat6gc0kK2qkWd1irMz+RCU9wkPMZKtyzTSaxvotKTCfB84u2gs
	+Q+n8fOxWuRQ1H9nwuUWOwk5l+shGw==
X-Received: by 2002:a05:6808:c3ea:b0:572:86c8:6b4c with SMTP id 5614622812f47-5773a0086c5mr3318610b6e.6.1795017677466;
        Wed, 18 Nov 2026 08:01:17 -0800 (PST)
Received: from gentoo ([49.204.145.8])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5777b39306asm1705822b6e.15.2026.11.18.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 08:01:17 -0800 (PST)
From: Shreesh Adiga <16567adigashreesh@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Date: Wed, 18 Nov 2026 21:31:00 +0530
Message-ID: <20261118160110.1662470-1-16567adigashreesh@gmail.com>
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
data size on Cortex-X925.

Add similar optimizations from x86 implementation like reducing
the 4x to 2x and doing a tail (len >= 32) 2x fold as well as partial
block handling to process lengths which are not multiple of 16 bytes.

The partial block stage is enabled only for AArch64 as it needs the
128-bit TBL instruction not available in AArch32.
Modified the loop dispatch on AArch64 to allow any len >= 128 rather
than just multiple of 16 bytes.

Modified the pmull intrinsics from crc64-neon.h to use inline
assembly as the intrinsic usage was causing the compiler to
generate the fold constants via mov+movk+fmov/dup which was about 10
instructions for 16-byte constant instead of expected adrp+ld1.

Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
---
 lib/crc/arm64/crc64-neon.h | 15 +++---
 lib/crc/arm64/crc64.h      | 18 ++++---
 lib/crc/crc64-neon.c       | 96 +++++++++++++++++++++++++++++++++++---
 3 files changed, 110 insertions(+), 19 deletions(-)

diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
index fcd5b1e6f812..700a3a8619f4 100644
--- a/lib/crc/arm64/crc64-neon.h
+++ b/lib/crc/arm64/crc64-neon.h
@@ -2,20 +2,21 @@
 
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
index 4753fb94a4be..03b46d0abcc4 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -10,6 +10,12 @@
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
+/* x^575 mod G, x^511 mod G */
+static const u64 fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
+					   0x62242240ace5045aULL };
+/* x^319 mod G, x^255 mod G */
+static const u64 fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
+					   0xe1e0bb9d45d7a44cULL };
 /* x^191 mod G, x^127 mod G */
 static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 					0x21e9761e252621acULL };
@@ -17,23 +23,101 @@ static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
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
+#ifdef CONFIG_ARM64
+/* vqtbl1q_u8 is not available on AArch32. */
+static inline uint64x2_t fold_partial_block(uint64x2_t fold, uint64x2_t consts,
+					    const u8 *p, size_t len)
+{
+	static const u8 crc_neon_shift_tab[32] = {
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
+	t1 = vcgezq_s8(vreinterpretq_s8_u8(t1));
+	b  = vreinterpretq_u64_u8(vbslq_u8(t1, last16, t2));
+
+	return fold_single_round(a, b, consts);
+}
+#endif
+
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 {
+	/* Assumes len >= 64. AArch32 also assumes len is multiple of 16. */
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
 
-	for (;;) {
-		v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
+	p += 64;
+	len -= 64;
+	while (len >= 64) {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
+		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
+		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
 
+		v0 = fold_single_round(v0, t0, fold_consts_4x);
+		v1 = fold_single_round(v1, t1, fold_consts_4x);
+		v2 = fold_single_round(v2, t2, fold_consts_4x);
+		v3 = fold_single_round(v3, t3, fold_consts_4x);
+		p += 64;
+		len -= 64;
+	}
+
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
 
+#ifdef CONFIG_ARM64
+	if (len)
+		v0 = fold_partial_block(v0, fold_consts, p, len);
+#endif
+
 	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
 	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
 
-- 
2.56.1

