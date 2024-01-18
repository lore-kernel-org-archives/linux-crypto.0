Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97662C844
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597672; cv=none; b=IjrL/t7/6SYmeMkNeWCRma0+TgshkmoqJNjBqosNvMY/FHeJ2H/a3obf5gYO/xPNHzyFRdTJEZyzmjQ9BiIohjY6IQObQfouI6gOpm7kU59WBtYMuboCFojX6+85l3hEGHMZTiNnsPkJ/16d75/IEHWrol89U9fOFTDBc+IB9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597672; c=relaxed/simple;
	bh=DbEGZ3L5DngoSsRWHP3kKzWqHfzgs5uTriIQ1V4Vy+E=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=u+IAxOF+R/uYSTwwJo1eMpVAYwq0Uo638BcyUFAUw5NXGgbWJQt0xZ/xWZdbgTjAZDTsvMitI0TDKxboGfqVzZHp+e8WKiNgmlYVndGy4v0FiWPsoXDqtznAMduLELUpRruyYgraj0+Vqzm6zV67X0YX9WkfptawTxHKlnkAkYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2eybz9E4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2eybz9E4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e530b7596so80299475e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597669; x=1706202469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=07TFk+I2O9cltRfB22alYzY612bOP1dW+/1EMp4yy9s=;
        b=2eybz9E4f5DXh/2Xwhzuq+k4ZTI22kKSKBn2TbPrzQ81KGrPrqQhrsANfGb35FxgME
         f8eZj7wOLL6Yzok2oFLcQpfr/DpTj0Z7D5rrKCKmpIjSgx4mayrReRifmWnvuNSi5jai
         nz+6CkBskKDuNnsuPBaQdJNXMMcB6lV/tvBUlf3h43NC7E9+3e17U2h45rEny45GdvXB
         rTHjiCTPjBKLP54/L8DVFVvgHQEdr3CnAsS+knx8Eib8DUZBJ5TToIefkrhr4rpJbIUj
         vizOOfQSCx/ZxQHpWhVVmYcPd49tlR9Q/GYJXSMywsVFOFBXavadwHUHpzWt31Nb5LCG
         RbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597669; x=1706202469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07TFk+I2O9cltRfB22alYzY612bOP1dW+/1EMp4yy9s=;
        b=mvMxzLP//5OpQEWBusbPpuBb7bQUJxEhjrySXHR34STSN9zFIW5YN1yYdAJ9SUmdZ1
         hLmCGz46z5fy/ysHsJE+E4io7M+giBHI06cmN6ucac07zqROrJ2QMEG5vnJOMazev8lK
         J7G1gYtMucWzb4Se2inUicYwIviUJMKSnghRxK71fawHHXud38YCR2vkX4K4P7kzk6/+
         rH5tSs9u9wR93dCwcU+Px867G/JgrjYlukGZnvCtivPaw3zSvT5MIe54tdu6fY8cAxf8
         Mc3TpVhFZ9Vy4IJ3XY20N5LdiqXd5Kxv5EyoKbTNFF62YSQK7aoBIwZT1RbLz45OTf3O
         bJXA==
X-Gm-Message-State: AOJu0YxrUarOGoKQL9cB2+Klcm7pYRqIYP240SuVIILtKtBAML9E/2+x
	Er84vq7spatriw+VpV3jrcbIoNQfuhnq0dgGfZLhPNOhVAGn5bjC3M0hXFjrDA/5EeofN4rTGYQ
	hFQ2+Ba7TYcuhtd8VFML7sCn1/PK5kwJlr8AFjqlGWpctjhw+oH4RvJ/WzB/OITbkgkr+hwIRqY
	Apn9dpu/yztyuP4W4LtitlLwhuQLisFg==
X-Google-Smtp-Source: AGHT+IGmSWEZubw3z/x0/RUxqBPx5wFHd+4QML+GB4geAAMGi/c4S7CGXNu0hjFXpXlCVZKpZ0sSJQB3
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:600e:b0:40e:4d51:99a7 with SMTP id
 az14-20020a05600c600e00b0040e4d5199a7mr18870wmb.4.1705597669071; Thu, 18 Jan
 2024 09:07:49 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:34 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6993; i=ardb@kernel.org;
 h=from:subject; bh=B/bVfYR9u8frO8VtpHOGbHCAOq8to2rRaUDnMzpLDpg=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1Cz1HbMs74uelTJ3rNQ2CuK5zVtx9NejD/kn9cru/
 lX27TLtKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNxOcTwT114qrF/8tvA3+vP
 9F7u/XDyR9Sbmtxjb+4senxt86crl+sZ/ilbv034tVr6pUVSvshFS3bDrffK+dZFfBFv3+3yOS8 njRMA
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-15-ardb+git@google.com>
Subject: [PATCH v2 5/8] crypto: arm64/aes-ccm - Reuse existing MAC update for
 AAD input
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

CCM combines the counter (CTR) encryption mode with a MAC based on the
same block cipher. This MAC construction is a bit clunky: it invokes the
block cipher in a way that cannot be parallelized, resulting in poor CPU
pipeline efficiency.

The arm64 CCM code mitigates this by interleaving the encryption and MAC
at the AES round level, resulting in a substantial speedup. But this
approach does not apply to the additional authenticated data (AAD) which
is not encrypted.

This means the special asm routine dealing with the AAD is not any
better than the MAC update routine used by the arm64 AES block
encryption driver, so let's reuse that, and drop the special AES-CCM
version.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/Kconfig           |  1 +
 arch/arm64/crypto/aes-ce-ccm-core.S | 71 --------------------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 49 +++++++++++---
 arch/arm64/crypto/aes-glue.c        |  1 +
 4 files changed, 43 insertions(+), 79 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index eb7b423ba463..e7d9bd8e4709 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -268,6 +268,7 @@ config CRYPTO_AES_ARM64_CE_CCM
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_ARM64_CE
+	select CRYPTO_AES_ARM64_CE_BLK
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	help
diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index b21a9b759ab2..0132872bd780 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -14,77 +14,6 @@
 	.text
 	.arch	armv8-a+crypto
 
-	/*
-	 * u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
-	 *			    u32 macp, u8 const rk[], u32 rounds);
-	 */
-SYM_FUNC_START(ce_aes_ccm_auth_data)
-	ld1	{v0.16b}, [x0]			/* load mac */
-	cbz	w3, 1f
-	sub	w3, w3, #16
-	eor	v1.16b, v1.16b, v1.16b
-0:	ldrb	w7, [x1], #1			/* get 1 byte of input */
-	subs	w2, w2, #1
-	add	w3, w3, #1
-	ins	v1.b[0], w7
-	ext	v1.16b, v1.16b, v1.16b, #1	/* rotate in the input bytes */
-	beq	8f				/* out of input? */
-	cbnz	w3, 0b
-	eor	v0.16b, v0.16b, v1.16b
-1:	ld1	{v3.4s}, [x4]			/* load first round key */
-	prfm	pldl1strm, [x1]
-	cmp	w5, #12				/* which key size? */
-	add	x6, x4, #16
-	sub	w7, w5, #2			/* modified # of rounds */
-	bmi	2f
-	bne	5f
-	mov	v5.16b, v3.16b
-	b	4f
-2:	mov	v4.16b, v3.16b
-	ld1	{v5.4s}, [x6], #16		/* load 2nd round key */
-3:	aese	v0.16b, v4.16b
-	aesmc	v0.16b, v0.16b
-4:	ld1	{v3.4s}, [x6], #16		/* load next round key */
-	aese	v0.16b, v5.16b
-	aesmc	v0.16b, v0.16b
-5:	ld1	{v4.4s}, [x6], #16		/* load next round key */
-	subs	w7, w7, #3
-	aese	v0.16b, v3.16b
-	aesmc	v0.16b, v0.16b
-	ld1	{v5.4s}, [x6], #16		/* load next round key */
-	bpl	3b
-	aese	v0.16b, v4.16b
-	subs	w2, w2, #16			/* last data? */
-	eor	v0.16b, v0.16b, v5.16b		/* final round */
-	bmi	6f
-	ld1	{v1.16b}, [x1], #16		/* load next input block */
-	eor	v0.16b, v0.16b, v1.16b		/* xor with mac */
-	bne	1b
-6:	st1	{v0.16b}, [x0]			/* store mac */
-	beq	10f
-	adds	w2, w2, #16
-	beq	10f
-	mov	w3, w2
-7:	ldrb	w7, [x1], #1
-	umov	w6, v0.b[0]
-	eor	w6, w6, w7
-	strb	w6, [x0], #1
-	subs	w2, w2, #1
-	beq	10f
-	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
-	b	7b
-8:	cbz	w3, 91f
-	mov	w7, w3
-	add	w3, w3, #16
-9:	ext	v1.16b, v1.16b, v1.16b, #1
-	adds	w7, w7, #1
-	bne	9b
-91:	eor	v0.16b, v0.16b, v1.16b
-	st1	{v0.16b}, [x0]
-10:	mov	w0, w3
-	ret
-SYM_FUNC_END(ce_aes_ccm_auth_data)
-
 	/*
 	 * void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u8 const rk[],
 	 * 			 u32 rounds);
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index 4710e59075f5..ed3d79e05112 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -18,6 +18,8 @@
 
 #include "aes-ce-setkey.h"
 
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
+
 static int num_rounds(struct crypto_aes_ctx *ctx)
 {
 	/*
@@ -30,8 +32,9 @@ static int num_rounds(struct crypto_aes_ctx *ctx)
 	return 6 + ctx->key_length / 4;
 }
 
-asmlinkage u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
-				    u32 macp, u32 const rk[], u32 rounds);
+asmlinkage u32 ce_aes_mac_update(u8 const in[], u32 const rk[], int rounds,
+				 int blocks, u8 dg[], int enc_before,
+				 int enc_after);
 
 asmlinkage void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
 				   u32 const rk[], u32 rounds, u8 mac[],
@@ -97,6 +100,41 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 	return 0;
 }
 
+static u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
+				u32 macp, u32 const rk[], u32 rounds)
+{
+	int enc_after = (macp + abytes) % AES_BLOCK_SIZE;
+
+	do {
+		u32 blocks = abytes / AES_BLOCK_SIZE;
+
+		if (macp == AES_BLOCK_SIZE || (!macp && blocks > 0)) {
+			u32 rem = ce_aes_mac_update(in, rk, rounds, blocks, mac,
+						    macp, enc_after);
+			u32 adv = (blocks - rem) * AES_BLOCK_SIZE;
+
+			macp = enc_after ? 0 : AES_BLOCK_SIZE;
+			in += adv;
+			abytes -= adv;
+
+			if (unlikely(rem)) {
+				kernel_neon_end();
+				kernel_neon_begin();
+				macp = 0;
+			}
+		} else {
+			u32 l = min(AES_BLOCK_SIZE - macp, abytes);
+
+			crypto_xor(&mac[macp], in, l);
+			in += l;
+			macp += l;
+			abytes -= l;
+		}
+	} while (abytes > 0);
+
+	return macp;
+}
+
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -104,7 +142,7 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 	struct __packed { __be16 l; __be32 h; u16 len; } ltag;
 	struct scatter_walk walk;
 	u32 len = req->assoclen;
-	u32 macp = 0;
+	u32 macp = AES_BLOCK_SIZE;
 
 	/* prepend the AAD with a length tag */
 	if (len < 0xff00) {
@@ -128,16 +166,11 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
-		n = min_t(u32, n, SZ_4K); /* yield NEON at least every 4k */
 		p = scatterwalk_map(&walk);
 
 		macp = ce_aes_ccm_auth_data(mac, p, n, macp, ctx->key_enc,
 					    num_rounds(ctx));
 
-		if (len / SZ_4K > (len - n) / SZ_4K) {
-			kernel_neon_end();
-			kernel_neon_begin();
-		}
 		len -= n;
 
 		scatterwalk_unmap(p);
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 162787c7aa86..a147e847a5a1 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -1048,6 +1048,7 @@ static int __init aes_init(void)
 
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 module_cpu_feature_match(AES, aes_init);
+EXPORT_SYMBOL_NS(ce_aes_mac_update, CRYPTO_INTERNAL);
 #else
 module_init(aes_init);
 EXPORT_SYMBOL(neon_aes_ecb_encrypt);
-- 
2.43.0.381.gb435a96ce8-goog

