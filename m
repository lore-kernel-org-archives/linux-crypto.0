Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6949915AC2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEUZLuMD"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-336b8da86eeso3309427f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976414; x=1705581214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7NqHvpVwYIckzJz3vTZ8qk1DnUwBae1Z/b9b550F34=;
        b=qEUZLuMDZStxy4VsKWA/DIn7XpnVNYaY+mvirx1Bh/sMJTccW5af/OcY2ZEcqY3fQS
         wY303th/G8o9aN849gqtfBvg7b6Gv/I1NSUCQx3WMBXevf/bglCrowvr2mkma5kYor2r
         CBdYsAbt5GTrZJuQYaLWldqLHJZG9X6rZooQtWmsCg2as0h5suh+EADxG3im+ajjU2l9
         V2Z4FND46FG79LoTgypO3uWSUTAkDMLco1CWjBJIzPYW5oIyOqhtyGz3yb5GeQoOWqQr
         M2KJyMTR8cyVEWDY1BOI8RB2rrF9k4GdDkZd6G1IslhNjfAXlrAP3e9TOg4SOmhUzJYm
         HKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976414; x=1705581214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7NqHvpVwYIckzJz3vTZ8qk1DnUwBae1Z/b9b550F34=;
        b=R7xwmKon34mKd/NxLuQklgKVGFoMZojV2CuScgyiHhq32HZSudI/nUAM0KfzEcH7pQ
         8b3gkdAT9rsEkaVRID+VORtSzm0HOkHZ+9pNiZST+YsT5/GsJhXsifMgeVmiiKN5X+ZK
         ehu/3W2G5iIzRvvQ49nN9DaxyMHv5dTT8ouIyNVtxjR1vsHZfm0+HzmjiUYlD99BSbo7
         rUhraJelfQCunob2Wpp5lNrPPUNOwCSruDbMTABrNS7N4E+vcDdYj8/0jP+Wp6kok989
         b9cppHmdRBoz++xUFHsTGReNzalK9Gw0ryuVx+HcqVYPgiNGQTRA2lumHf9GbG4Z/qiQ
         vNfA==
X-Gm-Message-State: AOJu0YxwyDPXxrjGIFHrT6Sdrj5105aCkmgmbcrxVACgVEgXqKyRIWoe
	XdVuH6brD/kVtE49kJIHiBbyePtcP8VQ71E2fGOiaoYak5E7FQ8sr2SuQ8+SefhvuqD5HoxMaYA
	No5Vs5zMkgsvGc3t+3db8uNMAZRhRN6oRZ823wWFh+FNG+k1Xqpp52r/7j3jGZn8c2nn3W8M=
X-Google-Smtp-Source: AGHT+IG1OE+vDmEsbe2sQorhqr94K4Y2eP/iuYTMTFAHNPq0MDGTHEk7shg3n4Q2qAwc65fyp0Se8LIf
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6000:1c1c:b0:337:77fc:e84f with SMTP id
 ba28-20020a0560001c1c00b0033777fce84fmr11442wrb.9.1704976414596; Thu, 11 Jan
 2024 04:33:34 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:08 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=6993; i=ardb@kernel.org;
 h=from:subject; bh=yle/H4ZDasJ7xiFxa7Y8LY3dYulmTCAxQvljqoR89sw=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A+Yg09Ware4npj29VlzwjHOloJ6s4mSprKfhm1ye+
 wRsXx7aUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbyX4uR4Tiv54f8aImk8HaO
 Ez1z0w5rH7FxZHkTEWsSaKQwceleX0aGBpPrNim+Nsl9jTEfJDSLapsq0zIO/+dtYjt2is2hlJ8 BAA==
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-15-ardb+git@google.com>
Subject: [PATCH 5/8] crypto: arm64/aes-ccm - Reuse existing MAC update for AAD input
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
2.43.0.275.g3460e3d667-goog

