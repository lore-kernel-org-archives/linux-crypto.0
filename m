Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F37C3A5A0
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6711216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="McKiPujK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbfHUOd0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33124 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfHUOd0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id u16so2294868wrr.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1Bgaz1dGwPYBh9D5oDVzcqGBYRtI51XEZb5wgMPv0t8=;
        b=McKiPujK4M2XLA9lKDIgmo7yIJIL7+Pj6OKhyllOWeUqpt/dCFYZFjbq9gJogIH6AV
         5B1lJ61pyyatFHuBUjOBcEgb/zzho4PtiEs1g4IFN5u30M5rG3bfHXXefHhXhfcLKHvI
         jwQq+4OFME4ON5SrKtDRWtTz/0FxR8psab2GUrkX/KHbDi8z3hNmafR6Sof9tXm83qGS
         ddoCTtc99QJWzUEiLViSQBz5fVn7Zk5lN5q3QSUltgu187RAtydKtSPThY20J20MOPMZ
         dHtkccY1N4xw1FLN0S0P6XFWWhuItfqhtdpwA/jwTjhQMtiLdLpLo05R/ubVZSaIVB4Z
         00fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1Bgaz1dGwPYBh9D5oDVzcqGBYRtI51XEZb5wgMPv0t8=;
        b=XIEKwJEZxudR3M9+LnXQf7z8GlRuC/gbFQayhdbJMOgE/21mG2K8RLeLVwDLY9cVsF
         o4w7PdUgdO/XjGjTcwYgiOp0OwRHfkfrFIPjWt6D/g1l09GBA3EBH6ZOdLNgiEfz21WO
         mBlQQCzpTEP7mfnCOk8MXH55KHS9vFbdHqxHH1lq4k3IdDLtiul3fRnDoIkSr4rjmsI2
         R8TpWg3Dn9+38VzXtLIRTPXIetOExiTw6mH+pVAkt9RBw2ese6qMxU15BjAlYVk43GMh
         YRIAziuvVLXqfvP9WFAY2RCIb2W57CeYiNWjpqURaNNywkiTs5EyGZXBSZDVbglu1QY7
         Qn7g==
X-Gm-Message-State: APjAAAX+Yb3rEVMz/A6BqCMY5SUbXru9o0gCKcEOnf12O1F3l6TdMkn4
        5c+Qy/qfjl0wS6Etb/UhDZ+mpm1lVmXspg==
X-Google-Smtp-Source: APXvYqyaUV/5JyAwtZM6RvHiMHz1hnrqFPpFpqD/IJEN2TKPxmvkdANnubV7Zd64z9psryq82NYYVg==
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr41427297wro.337.1566398003483;
        Wed, 21 Aug 2019 07:33:23 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 14/17] crypto: arm/aes-neonbs - implement ciphertext stealing for XTS
Date:   Wed, 21 Aug 2019 17:32:50 +0300
Message-Id: <20190821143253.30209-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the AES-XTS implementation based on NEON instructions so that it
can deal with inputs whose size is not a multiple of the cipher block
size. This is part of the original XTS specification, but was never
implemented before in the Linux kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-neonbs-core.S | 16 +++--
 arch/arm/crypto/aes-neonbs-glue.c | 69 +++++++++++++++++---
 2 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-core.S b/arch/arm/crypto/aes-neonbs-core.S
index bb75918e4984..cfaed4e67535 100644
--- a/arch/arm/crypto/aes-neonbs-core.S
+++ b/arch/arm/crypto/aes-neonbs-core.S
@@ -889,9 +889,9 @@ ENDPROC(aesbs_ctr_encrypt)
 
 	/*
 	 * aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		     int blocks, u8 iv[])
+	 *		     int blocks, u8 iv[], int reorder_last_tweak)
 	 * aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		     int blocks, u8 iv[])
+	 *		     int blocks, u8 iv[], int reorder_last_tweak)
 	 */
 __xts_prepare8:
 	vld1.8		{q14}, [r7]		// load iv
@@ -944,17 +944,25 @@ __xts_prepare8:
 
 	vld1.8		{q7}, [r1]!
 	next_tweak	q14, q12, q15, q13
-	veor		q7, q7, q12
+THUMB(	itt		le		)
+	W(cmple)	r8, #0
+	ble		1f
+0:	veor		q7, q7, q12
 	vst1.8		{q12}, [r4, :128]
 
-0:	vst1.8		{q14}, [r7]		// store next iv
+	vst1.8		{q14}, [r7]		// store next iv
 	bx		lr
+
+1:	vswp		q12, q14
+	b		0b
 ENDPROC(__xts_prepare8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
 	push		{r4-r8, lr}
 	mov		r5, sp			// preserve sp
 	ldrd		r6, r7, [sp, #24]	// get blocks and iv args
+	ldr		r8, [sp, #32]		// reorder final tweak?
+	rsb		r8, r8, #1
 	sub		ip, sp, #128		// make room for 8x tweak
 	bic		ip, ip, #0xf		// align sp to 16 bytes
 	mov		sp, ip
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 9000d0796d5e..e85839a8aaeb 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -12,6 +12,7 @@
 #include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
 
@@ -37,9 +38,9 @@ asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 ctr[], u8 final[]);
 
 asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 iv[]);
+				  int rounds, int blocks, u8 iv[], int);
 asmlinkage void aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 iv[]);
+				  int rounds, int blocks, u8 iv[], int);
 
 struct aesbs_ctx {
 	int	rounds;
@@ -53,6 +54,7 @@ struct aesbs_cbc_ctx {
 
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
+	struct crypto_cipher	*cts_tfm;
 	struct crypto_cipher	*tweak_tfm;
 };
 
@@ -291,6 +293,9 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	key_len /= 2;
+	err = crypto_cipher_setkey(ctx->cts_tfm, in_key, key_len);
+	if (err)
+		return err;
 	err = crypto_cipher_setkey(ctx->tweak_tfm, in_key + key_len, key_len);
 	if (err)
 		return err;
@@ -302,7 +307,13 @@ static int xts_init(struct crypto_tfm *tfm)
 {
 	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	ctx->cts_tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(ctx->cts_tfm))
+		return PTR_ERR(ctx->cts_tfm);
+
 	ctx->tweak_tfm = crypto_alloc_cipher("aes", 0, 0);
+	if (IS_ERR(ctx->tweak_tfm))
+		crypto_free_cipher(ctx->cts_tfm);
 
 	return PTR_ERR_OR_ZERO(ctx->tweak_tfm);
 }
@@ -312,17 +323,34 @@ static void xts_exit(struct crypto_tfm *tfm)
 	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_cipher(ctx->tweak_tfm);
+	crypto_free_cipher(ctx->cts_tfm);
 }
 
-static int __xts_crypt(struct skcipher_request *req,
+static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		       void (*fn)(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 iv[]))
+				  int rounds, int blocks, u8 iv[], int))
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	struct skcipher_request subreq;
+	u8 buf[2 * AES_BLOCK_SIZE];
 	struct skcipher_walk walk;
 	int err;
 
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (unlikely(tail)) {
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   req->cryptlen - tail, req->iv);
+		req = &subreq;
+	}
+
 	err = skcipher_walk_virt(&walk, req, true);
 	if (err)
 		return err;
@@ -331,30 +359,53 @@ static int __xts_crypt(struct skcipher_request *req,
 
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
+		int reorder_last_tweak = !encrypt && tail > 0;
 
-		if (walk.nbytes < walk.total)
+		if (walk.nbytes < walk.total) {
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
+			reorder_last_tweak = 0;
+		}
 
 		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->key.rk,
-		   ctx->key.rounds, blocks, walk.iv);
+		   ctx->key.rounds, blocks, walk.iv, reorder_last_tweak);
 		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
 
-	return err;
+	if (err || likely(!tail))
+		return err;
+
+	/* handle ciphertext stealing */
+	scatterwalk_map_and_copy(buf, req->dst, req->cryptlen - AES_BLOCK_SIZE,
+				 AES_BLOCK_SIZE, 0);
+	memcpy(buf + AES_BLOCK_SIZE, buf, tail);
+	scatterwalk_map_and_copy(buf, req->src, req->cryptlen, tail, 0);
+
+	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
+
+	if (encrypt)
+		crypto_cipher_encrypt_one(ctx->cts_tfm, buf, buf);
+	else
+		crypto_cipher_decrypt_one(ctx->cts_tfm, buf, buf);
+
+	crypto_xor(buf, req->iv, AES_BLOCK_SIZE);
+
+	scatterwalk_map_and_copy(buf, req->dst, req->cryptlen - AES_BLOCK_SIZE,
+				 AES_BLOCK_SIZE + tail, 1);
+	return 0;
 }
 
 static int xts_encrypt(struct skcipher_request *req)
 {
-	return __xts_crypt(req, aesbs_xts_encrypt);
+	return __xts_crypt(req, true, aesbs_xts_encrypt);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
 {
-	return __xts_crypt(req, aesbs_xts_decrypt);
+	return __xts_crypt(req, false, aesbs_xts_decrypt);
 }
 
 static struct skcipher_alg aes_algs[] = { {
-- 
2.17.1

