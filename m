Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6696AC43603
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A34611CC
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbhELVIE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236425AbhELSsV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 14:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC79761425;
        Wed, 12 May 2021 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620845100;
        bh=yMEeZkBsoAik7YRpeVN7A9qIi6cE5OsGQR+SfIXA8t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWQVzRZR9a5+rLgMtlIG7+x/AaukqYtX2ZCxGBfvFuJAwPwWNvKMLya/jNnTiO2Ft
         lurYYeSA0GXyXT683fHrmAqPB2TVOH+56rSPnPMRibzDzy/Fzy4VG04JGF1QGndI/Z
         YkHQQIaDU8EgwVeM6NLgeS5aDyM3wAlT9amwkv5d5opE3Pe9Lvn69XyeQ4UODc70SG
         r9sW5VfmE3T1tbWbjoCUruUn6dKeWaP3w+e59D9tjcSLj+yb3wTJDK4pMgn4/JeicU
         OGfqT8BJQ+4QGgZenNu7VtYN0I0lYOxezNe4OLeHEakn+iOJN5I2HO4pPopSOYC5DC
         4bvMYHcJbuhcg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 7/7] crypto: arm64/aes-ccm - remove non-SIMD fallback path
Date:   Wed, 12 May 2021 20:44:39 +0200
Message-Id: <20210512184439.8778-8-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210512184439.8778-1-ardb@kernel.org>
References: <20210512184439.8778-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AES/CCM on arm64 is implemented as a synchronous AEAD, and so it is
guaranteed by the API that it is only invoked in task or softirq
context. Since softirqs are now only handled when the SIMD is not
being used in the task context that was interrupted to service the
softirq, we no longer need a fallback path. Let's remove it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S |   1 +
 arch/arm64/crypto/aes-ce-ccm-glue.c | 183 ++++++--------------
 2 files changed, 53 insertions(+), 131 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 99a028e298ed..8adff299fcd3 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -124,6 +124,7 @@ SYM_FUNC_START(ce_aes_ccm_final)
 SYM_FUNC_END(ce_aes_ccm_final)
 
 	.macro	aes_ccm_do_crypt,enc
+	cbz	x2, 5f
 	ldr	x8, [x6, #8]			/* load lower ctr */
 	ld1	{v0.16b}, [x5]			/* load mac */
 CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f6d19b0dc893..a36df98f6fae 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -99,36 +99,8 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 			   u32 abytes, u32 *macp)
 {
-	if (crypto_simd_usable()) {
-		kernel_neon_begin();
-		ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
-				     num_rounds(key));
-		kernel_neon_end();
-	} else {
-		if (*macp > 0 && *macp < AES_BLOCK_SIZE) {
-			int added = min(abytes, AES_BLOCK_SIZE - *macp);
-
-			crypto_xor(&mac[*macp], in, added);
-
-			*macp += added;
-			in += added;
-			abytes -= added;
-		}
-
-		while (abytes >= AES_BLOCK_SIZE) {
-			aes_encrypt(key, mac, mac);
-			crypto_xor(mac, in, AES_BLOCK_SIZE);
-
-			in += AES_BLOCK_SIZE;
-			abytes -= AES_BLOCK_SIZE;
-		}
-
-		if (abytes > 0) {
-			aes_encrypt(key, mac, mac);
-			crypto_xor(mac, in, abytes);
-			*macp = abytes;
-		}
-	}
+	ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
+			     num_rounds(key));
 }
 
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
@@ -171,54 +143,6 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 	} while (len);
 }
 
-static int ccm_crypt_fallback(struct skcipher_walk *walk, u8 mac[], u8 iv0[],
-			      struct crypto_aes_ctx *ctx, bool enc)
-{
-	u8 buf[AES_BLOCK_SIZE];
-	int err = 0;
-
-	while (walk->nbytes) {
-		int blocks = walk->nbytes / AES_BLOCK_SIZE;
-		u32 tail = walk->nbytes % AES_BLOCK_SIZE;
-		u8 *dst = walk->dst.virt.addr;
-		u8 *src = walk->src.virt.addr;
-		u32 nbytes = walk->nbytes;
-
-		if (nbytes == walk->total && tail > 0) {
-			blocks++;
-			tail = 0;
-		}
-
-		do {
-			u32 bsize = AES_BLOCK_SIZE;
-
-			if (nbytes < AES_BLOCK_SIZE)
-				bsize = nbytes;
-
-			crypto_inc(walk->iv, AES_BLOCK_SIZE);
-			aes_encrypt(ctx, buf, walk->iv);
-			aes_encrypt(ctx, mac, mac);
-			if (enc)
-				crypto_xor(mac, src, bsize);
-			crypto_xor_cpy(dst, src, buf, bsize);
-			if (!enc)
-				crypto_xor(mac, dst, bsize);
-			dst += bsize;
-			src += bsize;
-			nbytes -= bsize;
-		} while (--blocks);
-
-		err = skcipher_walk_done(walk, tail);
-	}
-
-	if (!err) {
-		aes_encrypt(ctx, buf, iv0);
-		aes_encrypt(ctx, mac, mac);
-		crypto_xor(mac, buf, AES_BLOCK_SIZE);
-	}
-	return err;
-}
-
 static int ccm_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -233,41 +157,40 @@ static int ccm_encrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
-	if (crypto_simd_usable()) {
-		while (walk.nbytes) {
-			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+	kernel_neon_begin();
 
-			if (walk.nbytes == walk.total)
-				tail = 0;
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
 
-			kernel_neon_begin();
-			ce_aes_ccm_encrypt(walk.dst.virt.addr,
-					   walk.src.virt.addr,
-					   walk.nbytes - tail, ctx->key_enc,
-					   num_rounds(ctx), mac, walk.iv);
-			kernel_neon_end();
+	do {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-			err = skcipher_walk_done(&walk, tail);
-		}
-		if (!err) {
+		if (walk.nbytes == walk.total)
+			tail = 0;
+
+		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+
+		kernel_neon_end();
+
+		err = skcipher_walk_done(&walk, tail);
+		if (unlikely(err))
+			return err;
+
+		if (unlikely(walk.nbytes))
 			kernel_neon_begin();
-			ce_aes_ccm_final(mac, buf, ctx->key_enc,
-					 num_rounds(ctx));
-			kernel_neon_end();
-		}
-	} else {
-		err = ccm_crypt_fallback(&walk, mac, buf, ctx, true);
-	}
-	if (err)
-		return err;
+	} while (walk.nbytes);
 
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
@@ -291,42 +214,40 @@ static int ccm_decrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (unlikely(err))
+		return err;
 
-	if (crypto_simd_usable()) {
-		while (walk.nbytes) {
-			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+	kernel_neon_begin();
 
-			if (walk.nbytes == walk.total)
-				tail = 0;
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
 
-			kernel_neon_begin();
-			ce_aes_ccm_decrypt(walk.dst.virt.addr,
-					   walk.src.virt.addr,
-					   walk.nbytes - tail, ctx->key_enc,
-					   num_rounds(ctx), mac, walk.iv);
-			kernel_neon_end();
+	do {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-			err = skcipher_walk_done(&walk, tail);
-		}
-		if (!err) {
-			kernel_neon_begin();
-			ce_aes_ccm_final(mac, buf, ctx->key_enc,
-					 num_rounds(ctx));
-			kernel_neon_end();
-		}
-	} else {
-		err = ccm_crypt_fallback(&walk, mac, buf, ctx, false);
-	}
+		if (walk.nbytes == walk.total)
+			tail = 0;
 
-	if (err)
-		return err;
+		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+
+		kernel_neon_end();
+
+		err = skcipher_walk_done(&walk, tail);
+		if (unlikely(err))
+			return err;
+
+		if (unlikely(walk.nbytes))
+			kernel_neon_begin();
+	} while (walk.nbytes);
 
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
-- 
2.20.1

