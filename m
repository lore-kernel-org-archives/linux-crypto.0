Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15975C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD5F60FDA
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbhH0HEp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhH0HEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2369160FD9;
        Fri, 27 Aug 2021 07:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630047835;
        bh=cDhV/NWPbyrsBr2BIwai5Ghc3qm8ztabL00TNktB3Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq3mjIssMMYw9io+norPiK5RE0Tv+i5aXHU8UyZDuCcRAEOhuXoFvZ0hOoSyEQ3iG
         KlL1/8yUUXYyVNO+YJTdGyVizFMO7H7tYmX+9bvT9vd6se2/jm7dCAeoa0Byj8VZek
         2BdpAs+gfqtp0BveTuvne/v2uls4ZnBrDoAaxjyERqvkpHHBF+ZR/fhVORLMlApx7Q
         KRuHFeIvNd86eUHmRNM94sccL6XJIUoD1bfXr/f8NofAtj8OsDXUiEcBnAyl/qcunx
         TrP3tTqqIrWX6CetylfZVXWA9mRJTq08SyPlECwG1l0Hi20G52saCS2KuYmjItWmGa
         WLHhUPyC6BXtw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v7 5/7] crypto: arm64/aes-ccm - remove non-SIMD fallback path
Date:   Fri, 27 Aug 2021 09:03:40 +0200
Message-Id: <20210827070342.218276-6-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827070342.218276-1-ardb@kernel.org>
References: <20210827070342.218276-1-ardb@kernel.org>
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 153 ++++----------------
 1 file changed, 32 insertions(+), 121 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index fe9c837ac4b9..c1f221a181a5 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -6,12 +6,10 @@
  */
 
 #include <asm/neon.h>
-#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
@@ -99,36 +97,10 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
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
+	kernel_neon_begin();
+	ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
+			     num_rounds(key));
+	kernel_neon_end();
 }
 
 static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
@@ -172,54 +144,6 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
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
@@ -242,30 +166,24 @@ static int ccm_encrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
-	if (crypto_simd_usable()) {
-		while (walk.nbytes) {
-			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+	while (walk.nbytes) {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-			if (walk.nbytes == walk.total)
-				tail = 0;
+		if (walk.nbytes == walk.total)
+			tail = 0;
 
-			kernel_neon_begin();
-			ce_aes_ccm_encrypt(walk.dst.virt.addr,
-					   walk.src.virt.addr,
-					   walk.nbytes - tail, ctx->key_enc,
-					   num_rounds(ctx), mac, walk.iv);
-			kernel_neon_end();
+		kernel_neon_begin();
+		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
+		kernel_neon_end();
 
-			err = skcipher_walk_done(&walk, tail);
-		}
-		if (!err) {
-			kernel_neon_begin();
-			ce_aes_ccm_final(mac, buf, ctx->key_enc,
-					 num_rounds(ctx));
-			kernel_neon_end();
-		}
-	} else {
-		err = ccm_crypt_fallback(&walk, mac, buf, ctx, true);
+		err = skcipher_walk_done(&walk, tail);
+	}
+	if (!err) {
+		kernel_neon_begin();
+		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 	}
 	if (err)
 		return err;
@@ -300,32 +218,25 @@ static int ccm_decrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
-	if (crypto_simd_usable()) {
-		while (walk.nbytes) {
-			u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+	while (walk.nbytes) {
+		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-			if (walk.nbytes == walk.total)
-				tail = 0;
+		if (walk.nbytes == walk.total)
+			tail = 0;
 
-			kernel_neon_begin();
-			ce_aes_ccm_decrypt(walk.dst.virt.addr,
-					   walk.src.virt.addr,
+		kernel_neon_begin();
+		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 					   walk.nbytes - tail, ctx->key_enc,
 					   num_rounds(ctx), mac, walk.iv);
-			kernel_neon_end();
+		kernel_neon_end();
 
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
+		err = skcipher_walk_done(&walk, tail);
+	}
+	if (!err) {
+		kernel_neon_begin();
+		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 	}
-
 	if (err)
 		return err;
 
-- 
2.30.2

