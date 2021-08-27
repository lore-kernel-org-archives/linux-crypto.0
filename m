Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28070C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1F460FE7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbhH0HEi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhH0HEh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A6960FDA;
        Fri, 27 Aug 2021 07:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630047828;
        bh=4naiuqKa+aPSAr1V5l7Np0BN0xWzAHS9UYP0Rb8LUJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ao4lEomfsTwr1eoNuU4fPJ3BgD6xYEPuEsvBaimT6WzpTPNdOgRo5/NwEmjzad9XU
         EdecZC+rQ6W1n6kDho7n8xJj0w7q0+iWpjYQTsA8NxMMluUkBKqC8j2CTQyUTD7j7a
         H4FZhwVKSmcIcwxayJO2b5F0d+LLQ9qw2L1UMccVnQ6VvE+0z4FzYd6SEO0qcAx+aI
         g8gQy1ZtXVtf4xGvfq88ItCKxAiFEUjf5LZCtkHL88r1k8+JQCilHkFZrlZrnixJ8i
         wQPiScmvMZxyw8KZ1tPvK1jjhLrwDf9p3s8P7DVT5myuN/eQ7erxmClJxtwVUAGsan
         GlKf/xd5370HQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v7 1/7] crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
Date:   Fri, 27 Aug 2021 09:03:36 +0200
Message-Id: <20210827070342.218276-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827070342.218276-1-ardb@kernel.org>
References: <20210827070342.218276-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that kernel mode SIMD is guaranteed to be available when executing
in task or softirq context, we no longer need scalar fallbacks to use
when the NEON is unavailable. So get rid of them.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 209 +++++---------------
 1 file changed, 51 insertions(+), 158 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 720cd3a58da3..15794fe21a0b 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -362,84 +362,36 @@ static int gcm_encrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
-	if (likely(crypto_simd_usable())) {
-		do {
-			const u8 *src = walk.src.virt.addr;
-			u8 *dst = walk.dst.virt.addr;
-			int nbytes = walk.nbytes;
-
-			tag = (u8 *)&lengths;
-
-			if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE)) {
-				src = dst = memcpy(buf + sizeof(buf) - nbytes,
-						   src, nbytes);
-			} else if (nbytes < walk.total) {
-				nbytes &= ~(AES_BLOCK_SIZE - 1);
-				tag = NULL;
-			}
-
-			kernel_neon_begin();
-			pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
-					  dg, iv, ctx->aes_key.key_enc, nrounds,
-					  tag);
-			kernel_neon_end();
-
-			if (unlikely(!nbytes))
-				break;
-
-			if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
-				memcpy(walk.dst.virt.addr,
-				       buf + sizeof(buf) - nbytes, nbytes);
-
-			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-		} while (walk.nbytes);
-	} else {
-		while (walk.nbytes >= AES_BLOCK_SIZE) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
-			const u8 *src = walk.src.virt.addr;
-			u8 *dst = walk.dst.virt.addr;
-			int remaining = blocks;
-
-			do {
-				aes_encrypt(&ctx->aes_key, buf, iv);
-				crypto_xor_cpy(dst, src, buf, AES_BLOCK_SIZE);
-				crypto_inc(iv, AES_BLOCK_SIZE);
-
-				dst += AES_BLOCK_SIZE;
-				src += AES_BLOCK_SIZE;
-			} while (--remaining > 0);
-
-			ghash_do_update(blocks, dg, walk.dst.virt.addr,
-					&ctx->ghash_key, NULL);
-
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
-
-		/* handle the tail */
-		if (walk.nbytes) {
-			aes_encrypt(&ctx->aes_key, buf, iv);
+	do {
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		int nbytes = walk.nbytes;
 
-			crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr,
-				       buf, walk.nbytes);
+		tag = (u8 *)&lengths;
 
-			memcpy(buf, walk.dst.virt.addr, walk.nbytes);
-			memset(buf + walk.nbytes, 0, sizeof(buf) - walk.nbytes);
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE)) {
+			src = dst = memcpy(buf + sizeof(buf) - nbytes,
+					   src, nbytes);
+		} else if (nbytes < walk.total) {
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+			tag = NULL;
 		}
 
-		tag = (u8 *)&lengths;
-		ghash_do_update(1, dg, tag, &ctx->ghash_key,
-				walk.nbytes ? buf : NULL);
+		kernel_neon_begin();
+		pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
+				  dg, iv, ctx->aes_key.key_enc, nrounds,
+				  tag);
+		kernel_neon_end();
 
-		if (walk.nbytes)
-			err = skcipher_walk_done(&walk, 0);
+		if (unlikely(!nbytes))
+			break;
 
-		put_unaligned_be64(dg[1], tag);
-		put_unaligned_be64(dg[0], tag + 8);
-		put_unaligned_be32(1, iv + GCM_IV_SIZE);
-		aes_encrypt(&ctx->aes_key, iv, iv);
-		crypto_xor(tag, iv, AES_BLOCK_SIZE);
-	}
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - nbytes, nbytes);
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	} while (walk.nbytes);
 
 	if (err)
 		return err;
@@ -464,6 +416,7 @@ static int gcm_decrypt(struct aead_request *req)
 	u64 dg[2] = {};
 	be128 lengths;
 	u8 *tag;
+	int ret;
 	int err;
 
 	lengths.a = cpu_to_be64(req->assoclen * 8);
@@ -481,101 +434,41 @@ static int gcm_decrypt(struct aead_request *req)
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 
-	if (likely(crypto_simd_usable())) {
-		int ret;
-
-		do {
-			const u8 *src = walk.src.virt.addr;
-			u8 *dst = walk.dst.virt.addr;
-			int nbytes = walk.nbytes;
-
-			tag = (u8 *)&lengths;
-
-			if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE)) {
-				src = dst = memcpy(buf + sizeof(buf) - nbytes,
-						   src, nbytes);
-			} else if (nbytes < walk.total) {
-				nbytes &= ~(AES_BLOCK_SIZE - 1);
-				tag = NULL;
-			}
-
-			kernel_neon_begin();
-			ret = pmull_gcm_decrypt(nbytes, dst, src,
-						ctx->ghash_key.h,
-						dg, iv, ctx->aes_key.key_enc,
-						nrounds, tag, otag, authsize);
-			kernel_neon_end();
-
-			if (unlikely(!nbytes))
-				break;
-
-			if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
-				memcpy(walk.dst.virt.addr,
-				       buf + sizeof(buf) - nbytes, nbytes);
-
-			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-		} while (walk.nbytes);
-
-		if (err)
-			return err;
-		if (ret)
-			return -EBADMSG;
-	} else {
-		while (walk.nbytes >= AES_BLOCK_SIZE) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
-			const u8 *src = walk.src.virt.addr;
-			u8 *dst = walk.dst.virt.addr;
-
-			ghash_do_update(blocks, dg, walk.src.virt.addr,
-					&ctx->ghash_key, NULL);
-
-			do {
-				aes_encrypt(&ctx->aes_key, buf, iv);
-				crypto_xor_cpy(dst, src, buf, AES_BLOCK_SIZE);
-				crypto_inc(iv, AES_BLOCK_SIZE);
-
-				dst += AES_BLOCK_SIZE;
-				src += AES_BLOCK_SIZE;
-			} while (--blocks > 0);
+	do {
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		int nbytes = walk.nbytes;
 
-			err = skcipher_walk_done(&walk,
-						 walk.nbytes % AES_BLOCK_SIZE);
-		}
+		tag = (u8 *)&lengths;
 
-		/* handle the tail */
-		if (walk.nbytes) {
-			memcpy(buf, walk.src.virt.addr, walk.nbytes);
-			memset(buf + walk.nbytes, 0, sizeof(buf) - walk.nbytes);
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE)) {
+			src = dst = memcpy(buf + sizeof(buf) - nbytes,
+					   src, nbytes);
+		} else if (nbytes < walk.total) {
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+			tag = NULL;
 		}
 
-		tag = (u8 *)&lengths;
-		ghash_do_update(1, dg, tag, &ctx->ghash_key,
-				walk.nbytes ? buf : NULL);
-
-		if (walk.nbytes) {
-			aes_encrypt(&ctx->aes_key, buf, iv);
+		kernel_neon_begin();
+		ret = pmull_gcm_decrypt(nbytes, dst, src, ctx->ghash_key.h,
+					dg, iv, ctx->aes_key.key_enc,
+					nrounds, tag, otag, authsize);
+		kernel_neon_end();
 
-			crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr,
-				       buf, walk.nbytes);
+		if (unlikely(!nbytes))
+			break;
 
-			err = skcipher_walk_done(&walk, 0);
-		}
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr,
+			       buf + sizeof(buf) - nbytes, nbytes);
 
-		if (err)
-			return err;
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	} while (walk.nbytes);
 
-		put_unaligned_be64(dg[1], tag);
-		put_unaligned_be64(dg[0], tag + 8);
-		put_unaligned_be32(1, iv + GCM_IV_SIZE);
-		aes_encrypt(&ctx->aes_key, iv, iv);
-		crypto_xor(tag, iv, AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
-		if (crypto_memneq(tag, otag, authsize)) {
-			memzero_explicit(tag, AES_BLOCK_SIZE);
-			return -EBADMSG;
-		}
-	}
-	return 0;
+	return ret ? -EBADMSG : 0;
 }
 
 static struct aead_alg gcm_aes_alg = {
-- 
2.30.2

