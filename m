Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DD81714CF
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823265; cv=none; b=e6ZXRokb78nw3gtwIc+/tFpuCCAP2TyL1kCA3x/U/gkgvxcVXOuammKW4A4ekG/ziRXQj8vh+TlPMXHe3CnC+F95DePcHa0OfKgOs9IWNFTTWPdsC77LBX2xvtkft0sfjkUmkAU4XCIMng7xHzwmwolMSq6Dm9EPZv0p3KPAuZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823265; c=relaxed/simple;
	bh=oemtjBrK+K0nL8nCtNSFHCcJf4f5MzD8rkgdossOoQU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tHEI3rIQEvPAQkVMOlaQW8gJy7+4FX0R++BCp8RJ2VQgD39LphkjzJ4HApoFT1FdC97LTbAKvW6q2/P2lv/s6fXuIXPaE3I3KwH1fhGqueaPH0XxvKaiIKGeHmp9qmmYvuZWM8Z1xdUi+/ZTohgQYh0OB9mFk1sE7QFIaHOAT5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wr5B7ezk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wr5B7ezk"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-431518ae047so36742015e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823262; x=1731428062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5C9UQXxiURmILMPEwiZdl1ShbeIW9MqWROHwJW9ezc=;
        b=wr5B7ezkERqTDJpFRkcG0QhR5KE3vxxiP/qRayaFJqECvGCl/DppMEAuL2bHAUZrq9
         75o6RmLMRNRSPMSOcpl8YQS4I6FAajgnV7QqR+fHhrartOo/rUQiwv7mJ9SZEwVqZaWn
         +apVl6074YExFghG7ZIu/knL1DrkUHlTz/pYW8dMXzLCm7AkiDJQJUJk7uVRRTKHE+5H
         Zd0OGKZzO6dhQGtGiXfvndOXbgvnZM9A+/pSTQptEh9cCncJZgNA+cCp9+hDzB/r7Bxm
         6kLHhDbpd5evotOUMYi0wLlWs+TszKWppewCNnRCts8xbeMa0whD1LylSq45MAWSwgWN
         WDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823262; x=1731428062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5C9UQXxiURmILMPEwiZdl1ShbeIW9MqWROHwJW9ezc=;
        b=kVxBZ2MOCflaHjrLJ2qIHJSQ5hDNzx6ZJ8/72Wl4YeYtNDvIoVS0jQHyyFlLtq+DxC
         g6C8cYvuGoGIE0VMmx20lkTwth7wAbKfj/eBSSccPBEgnOhWuOYki4tD0Y2+VsaMJXyE
         E14eIE3kIBLuEHKLMypjeNYLVtAd580rjGiZO+uTdl+kd3V4KrikNjgHq/XLyG9uwpYw
         1icTiIvNE42pd725K90leX8MoXzSuM31ULe+39HMduNSoSCEaSRxReR38OUX/JaVO9yi
         VWyzRgnhsXokrqa4yQ9A5M2x8ED3cLn/LXVCwjSPpaQM+2g0ZSkFBn7Tvx8LTQhAGpec
         DS+w==
X-Gm-Message-State: AOJu0YwWSkDvvW6kGMzLF+Tvf75/1r26lLY1LI4xp3sNzd/74n+eIIc1
	Pew/ryAcExnVxYXbxUd4dovu17IZtEv3ONfMdWmdnd3JmFv3lUkWLQy/MuxjMjd2JZELY4U8H4c
	QuuzrqctmUaLG66xxO5DTIyg1FQackP922sY3mqifAS99tiiIDvwbuQ3nohZGPTUgZoaIvx7g13
	AE1RgoOMJLNkSneq4D7vplXWd2fRUPzg==
X-Google-Smtp-Source: AGHT+IGoUtJ5+KmRmnOKl2AZ6ZxwHw9MzdvYo9g4ve3paCn9ggnLv8R8NjYp1xRcfQPf/t8joGA1v+aG
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:6c56:b0:431:44c4:c932 with SMTP id
 5b1f17b1804b1-432830b14dfmr1188005e9.4.1730823261778; Tue, 05 Nov 2024
 08:14:21 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:06 +0100
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160859.1459261-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=8242; i=ardb@kernel.org;
 h=from:subject; bh=wTU9qg6b3+f755RWEvZYGTwnH7lJNldlFtFrxF4nGyQ=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWeXwTm/eq6/+PLzxffMV+f6dLy5VnE4v+j/H7dKjp
 iUrGMSndZSyMIhxMMiKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJdFcw/M+SVzEreeqg4rXr
 kLXYssdCTfEb1EvidTZcF5F2f5xwQJ3hf/yc9+ums846tMnkwgr9muMJDs29N/NuXpF/YV7dMVN VjQcA
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-14-ardb+git@google.com>
Subject: [PATCH v2 6/6] crypto: arm/crct10dif - Implement plain NEON variant
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The CRC-T10DIF algorithm produces a 16-bit CRC, and this is reflected in
the folding coefficients, which are also only 16 bits wide.

This means that the polynomial multiplications involving these
coefficients can be performed using 8-bit long polynomial multiplication
(8x8 -> 16) in only a few steps, and this is an instruction that is part
of the base NEON ISA, which is all most real ARMv7 cores implement. (The
64-bit PMULL instruction is part of the crypto extensions, which are
only implemented by 64-bit cores)

The final reduction is a bit more involved, but we can delegate that to
the generic CRC-T10DIF implementation after folding the entire input
into a 16 byte vector.

This results in a speedup of around 6.6x on Cortex-A72 running in 32-bit
mode. On Cortex-A8 (BeagleBone White), the results are substantially
better than that, but not sufficiently reproducible (with tcrypt) to
quote a number here.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 98 +++++++++++++++++++-
 arch/arm/crypto/crct10dif-ce-glue.c | 45 ++++++++-
 2 files changed, 134 insertions(+), 9 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 6b72167574b2..2bbf2df9c1e2 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -112,6 +112,82 @@
 	FOLD_CONST_L	.req	q10l
 	FOLD_CONST_H	.req	q10h
 
+	/*
+	 * Pairwise long polynomial multiplication of two 16-bit values
+	 *
+	 *   { w0, w1 }, { y0, y1 }
+	 *
+	 * by two 64-bit values
+	 *
+	 *   { x0, x1, x2, x3, x4, x5, x6, x7 }, { z0, z1, z2, z3, z4, z5, z6, z7 }
+	 *
+	 * where each vector element is a byte, ordered from least to most
+	 * significant. The resulting 80-bit vectors are XOR'ed together.
+	 *
+	 * This can be implemented using 8x8 long polynomial multiplication, by
+	 * reorganizing the input so that each pairwise 8x8 multiplication
+	 * produces one of the terms from the decomposition below, and
+	 * combining the results of each rank and shifting them into place.
+	 *
+	 * Rank
+	 *  0            w0*x0 ^              |        y0*z0 ^
+	 *  1       (w0*x1 ^ w1*x0) <<  8 ^   |   (y0*z1 ^ y1*z0) <<  8 ^
+	 *  2       (w0*x2 ^ w1*x1) << 16 ^   |   (y0*z2 ^ y1*z1) << 16 ^
+	 *  3       (w0*x3 ^ w1*x2) << 24 ^   |   (y0*z3 ^ y1*z2) << 24 ^
+	 *  4       (w0*x4 ^ w1*x3) << 32 ^   |   (y0*z4 ^ y1*z3) << 32 ^
+	 *  5       (w0*x5 ^ w1*x4) << 40 ^   |   (y0*z5 ^ y1*z4) << 40 ^
+	 *  6       (w0*x6 ^ w1*x5) << 48 ^   |   (y0*z6 ^ y1*z5) << 48 ^
+	 *  7       (w0*x7 ^ w1*x6) << 56 ^   |   (y0*z7 ^ y1*z6) << 56 ^
+	 *  8            w1*x7      << 64     |        y1*z7      << 64
+	 *
+	 * The inputs can be reorganized into
+	 *
+	 *   { w0, w0, w0, w0, y0, y0, y0, y0 }, { w1, w1, w1, w1, y1, y1, y1, y1 }
+	 *   { x0, x2, x4, x6, z0, z2, z4, z6 }, { x1, x3, x5, x7, z1, z3, z5, z7 }
+	 *
+	 * and after performing 8x8->16 bit long polynomial multiplication of
+	 * each of the halves of the first vector with those of the second one,
+	 * we obtain the following four vectors of 16-bit elements:
+	 *
+	 *   a := { w0*x0, w0*x2, w0*x4, w0*x6 }, { y0*z0, y0*z2, y0*z4, y0*z6 }
+	 *   b := { w0*x1, w0*x3, w0*x5, w0*x7 }, { y0*z1, y0*z3, y0*z5, y0*z7 }
+	 *   c := { w1*x0, w1*x2, w1*x4, w1*x6 }, { y1*z0, y1*z2, y1*z4, y1*z6 }
+	 *   d := { w1*x1, w1*x3, w1*x5, w1*x7 }, { y1*z1, y1*z3, y1*z5, y1*z7 }
+	 *
+	 * Results b and c can be XORed together, as the vector elements have
+	 * matching ranks. Then, the final XOR can be pulled forward, and
+	 * applied between the halves of each of the remaining three vectors,
+	 * which are then shifted into place, and XORed together to produce the
+	 * final 80-bit result.
+	 */
+        .macro		pmull16x64_p8, v16, v64
+	vext.8		q11, \v64, \v64, #1
+	vld1.64		{q12}, [r4, :128]
+	vuzp.8		q11, \v64
+	vtbl.8		d24, {\v16\()_L-\v16\()_H}, d24
+	vtbl.8		d25, {\v16\()_L-\v16\()_H}, d25
+	bl		__pmull16x64_p8
+	veor		\v64, q12, q14
+        .endm
+
+__pmull16x64_p8:
+	vmull.p8	q13, d23, d24
+	vmull.p8	q14, d23, d25
+	vmull.p8	q15, d22, d24
+	vmull.p8	q12, d22, d25
+
+	veor		q14, q14, q15
+	veor		d24, d24, d25
+	veor		d26, d26, d27
+	veor		d28, d28, d29
+	vmov.i32	d25, #0
+	vmov.i32	d29, #0
+	vext.8		q12, q12, q12, #14
+	vext.8		q14, q14, q14, #15
+	veor		d24, d24, d26
+	bx		lr
+ENDPROC(__pmull16x64_p8)
+
         .macro		pmull16x64_p64, v16, v64
 	vmull.p64	q11, \v64\()l, \v16\()_L
 	vmull.p64	\v64, \v64\()h, \v16\()_H
@@ -249,9 +325,9 @@ CPU_LE(	vrev64.8	q0, q0	)
 	vswp		q0l, q0h
 
 	// q1 = high order part of second chunk: q7 left-shifted by 'len' bytes.
-	mov_l		r3, .Lbyteshift_table + 16
-	sub		r3, r3, len
-	vld1.8		{q2}, [r3]
+	mov_l		r1, .Lbyteshift_table + 16
+	sub		r1, r1, len
+	vld1.8		{q2}, [r1]
 	vtbl.8		q1l, {q7l-q7h}, q2l
 	vtbl.8		q1h, {q7l-q7h}, q2h
 
@@ -341,9 +417,20 @@ ENTRY(crc_t10dif_pmull64)
 
 	vmov.u16	r0, q0l[0]
 	bx		lr
-
 ENDPROC(crc_t10dif_pmull64)
 
+ENTRY(crc_t10dif_pmull8)
+	push		{r4, lr}
+	mov_l		r4, .L16x64perm
+
+	crct10dif	p8
+
+CPU_LE(	vrev64.8	q7, q7	)
+	vswp		q7l, q7h
+	vst1.64		{q7}, [r3, :128]
+	pop		{r4, pc}
+ENDPROC(crc_t10dif_pmull8)
+
 	.section	".rodata", "a"
 	.align		4
 
@@ -376,3 +463,6 @@ ENDPROC(crc_t10dif_pmull64)
 	.byte		0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f
 	.byte		 0x0,  0x1,  0x2,  0x3,  0x4,  0x5,  0x6,  0x7
 	.byte		 0x8,  0x9,  0xa,  0xb,  0xc,  0xd,  0xe , 0x0
+
+.L16x64perm:
+	.quad		0x808080800000000, 0x909090901010101
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index 60aa79c2fcdb..a8b74523729e 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -20,6 +20,8 @@
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
 asmlinkage u16 crc_t10dif_pmull64(u16 init_crc, const u8 *buf, size_t len);
+asmlinkage void crc_t10dif_pmull8(u16 init_crc, const u8 *buf, size_t len,
+				  u8 out[16]);
 
 static int crct10dif_init(struct shash_desc *desc)
 {
@@ -45,6 +47,27 @@ static int crct10dif_update_ce(struct shash_desc *desc, const u8 *data,
 	return 0;
 }
 
+static int crct10dif_update_neon(struct shash_desc *desc, const u8 *data,
+			         unsigned int length)
+{
+	u16 *crcp = shash_desc_ctx(desc);
+	u8 buf[16] __aligned(16);
+	u16 crc = *crcp;
+
+	if (length > CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
+		kernel_neon_begin();
+		crc_t10dif_pmull8(crc, data, length, buf);
+		kernel_neon_end();
+
+		crc = 0;
+		data = buf;
+		length = sizeof(buf);
+	}
+
+	*crcp = crc_t10dif_generic(crc, data, length);
+	return 0;
+}
+
 static int crct10dif_final(struct shash_desc *desc, u8 *out)
 {
 	u16 *crc = shash_desc_ctx(desc);
@@ -53,7 +76,19 @@ static int crct10dif_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg crc_t10dif_alg = {
+static struct shash_alg algs[] = {{
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= crct10dif_init,
+	.update			= crct10dif_update_neon,
+	.final			= crct10dif_final,
+	.descsize		= CRC_T10DIF_DIGEST_SIZE,
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-arm-neon",
+	.base.cra_priority	= 150,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
 	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
 	.init			= crct10dif_init,
 	.update			= crct10dif_update_ce,
@@ -65,19 +100,19 @@ static struct shash_alg crc_t10dif_alg = {
 	.base.cra_priority	= 200,
 	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
-};
+}};
 
 static int __init crc_t10dif_mod_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_PMULL))
+	if (!(elf_hwcap & HWCAP_NEON))
 		return -ENODEV;
 
-	return crypto_register_shash(&crc_t10dif_alg);
+	return crypto_register_shashes(algs, 1 + !!(elf_hwcap2 & HWCAP2_PMULL));
 }
 
 static void __exit crc_t10dif_mod_exit(void)
 {
-	crypto_unregister_shash(&crc_t10dif_alg);
+	crypto_unregister_shashes(algs, 1 + !!(elf_hwcap2 & HWCAP2_PMULL));
 }
 
 module_init(crc_t10dif_mod_init);
-- 
2.47.0.199.ga7371fff76-goog

