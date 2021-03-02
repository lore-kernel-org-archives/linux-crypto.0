Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A975C433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3610864E09
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhCCB3n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378881AbhCBJFa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:05:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D603B64F18;
        Tue,  2 Mar 2021 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675746;
        bh=H2GOdv4kmqAztPHmgAn7EHakKeKpHN0h1sdR1E++ryA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDD7lnrrZEZVKscBmqk/bDnF3dDLwdVQLGGdZpy3Ac30VRXL/a/B4rguHwxQC7xPI
         elIohA72MIHnFm7i9kC0uPb7RZfycMR8c3GxJqw3BjgUN0BvXNcqzPPWeu87RmDwa3
         QhOT1heZVzkTGVsWXtpt9+I28OUSfEelw7SdXmfandimFpLGgbkR/QUmKprHfRYpN5
         y+Wrgntiy6fTOTrUKTBC8qXRADhLxGQkAzsMJhyKWGYb2/7N5UOhPiwQssH/X9KHck
         px84SVIAdsO657J4jZZ8+gHNgnYgFBRiKejz1gZZ4mDN4l8vcGkXLWQeOMhEJM79RO
         5ue/E3WufU43g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 7/9] crypto: arm64/aes-ccm - remove non-SIMD fallback path
Date:   Tue,  2 Mar 2021 10:01:16 +0100
Message-Id: <20210302090118.30666-8-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
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
 arch/arm64/crypto/aes-ce-ccm-glue.c | 151 ++++----------------
 1 file changed, 30 insertions(+), 121 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f6d19b0dc893..e6a7243825a2 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -99,36 +99,10 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
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
@@ -171,54 +145,6 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
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
@@ -241,30 +167,22 @@ static int ccm_encrypt(struct aead_request *req)
 
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
+		if (walk.nbytes == walk.total)
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
+
+		err = skcipher_walk_done(&walk, tail);
 	}
 	if (err)
 		return err;
@@ -299,32 +217,23 @@ static int ccm_decrypt(struct aead_request *req)
 
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
-					   walk.nbytes - tail, ctx->key_enc,
-					   num_rounds(ctx), mac, walk.iv);
-			kernel_neon_end();
+		kernel_neon_begin();
+		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				   walk.nbytes - tail, ctx->key_enc,
+				   num_rounds(ctx), mac, walk.iv);
 
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
+			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		kernel_neon_end();
 
+		err = skcipher_walk_done(&walk, tail);
+	}
 	if (err)
 		return err;
 
-- 
2.30.1

