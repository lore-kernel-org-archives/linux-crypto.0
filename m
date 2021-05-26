Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C41C2B9F7
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 10:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B777C6124C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 10:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhEZKJR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 06:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233637AbhEZKJP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 06:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 094026124C;
        Wed, 26 May 2021 10:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622023664;
        bh=HsvXG+ZM+XANF/anZq9LUpKWJ+Zp18U0r3Smfr15vkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlI5ORgcOVkQ0vapVvcC/X8x4PWyvM5yjxICIeg5Uz/pNFpTKyeRGIZeDuVAcGeY3
         eU5TSFHG6N299iqcejEReB5pnZs0P8zjQpjUbK3JVm6HzoQGCyrOdCbyTTxbs78E4m
         43OjvEhp4/BxayJWljy3eNt8jYbw6/IJ+5ojjqvMMHiHm1b7MXy3D/LeWkAaNbrcDJ
         tnTKvcwmjd+PH15AAnCb72zRRmmHuY5YcCJLmJ21/IrvggJoJBMWxmD/XjOvo9cDm+
         rrwFdOTNot5Fpf9V1EDJN4xc100FB45xMznVFjqm8vReIB5amikVRVGyQZw039tjLZ
         m1JWw6pu8N4mQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v6 5/6] crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
Date:   Wed, 26 May 2021 12:07:28 +0200
Message-Id: <20210526100729.12939-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210526100729.12939-1-ardb@kernel.org>
References: <20210526100729.12939-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AES-CCM (as used in WPA2 CCMP, for instance) typically involves
authenticate-only data, and operates on a single network packet, and so
the common case is for the authenticate, en/decrypt and finalize SIMD
helpers to all be called exactly once in sequence. Since
kernel_neon_end() now involves manipulation of the preemption state as
well as the softirq mask state, let's reduce the number of times we are
forced to call it to only once if we are handling this common case.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S |  1 +
 arch/arm64/crypto/aes-ce-ccm-glue.c | 74 +++++++++++---------
 2 files changed, 43 insertions(+), 32 deletions(-)

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
index 54bd2494a000..98159f2c49ae 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -97,10 +97,8 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
 static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 			   u32 abytes, u32 *macp)
 {
-	kernel_neon_begin();
 	ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
 			     num_rounds(key));
-	kernel_neon_end();
 }
 
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
@@ -157,35 +155,41 @@ static int ccm_encrypt(struct aead_request *req)
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
 
-	while (walk.nbytes) {
+	kernel_neon_begin();
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
+
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		kernel_neon_begin();
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
-		kernel_neon_end();
 
-		err = skcipher_walk_done(&walk, tail);
-	}
-	if (!err) {
-		kernel_neon_begin();
-		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+
 		kernel_neon_end();
-	}
-	if (err)
-		return err;
+
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
@@ -209,35 +213,41 @@ static int ccm_decrypt(struct aead_request *req)
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
+
+	kernel_neon_begin();
 
-	while (walk.nbytes) {
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, mac);
+
+	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		kernel_neon_begin();
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-					   walk.nbytes - tail, ctx->key_enc,
-					   num_rounds(ctx), mac, walk.iv);
-		kernel_neon_end();
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		err = skcipher_walk_done(&walk, tail);
-	}
-	if (!err) {
-		kernel_neon_begin();
-		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 		kernel_neon_end();
-	}
-	if (err)
-		return err;
+
+		if (walk.nbytes) {
+			err = skcipher_walk_done(&walk, tail);
+			if (unlikely(err))
+				return err;
+			if (unlikely(walk.nbytes))
+				kernel_neon_begin();
+		}
+	} while (walk.nbytes);
 
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
-- 
2.20.1

