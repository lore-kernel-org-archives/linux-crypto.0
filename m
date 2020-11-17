Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09D8C64E90
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B1F24199
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cet0n5Jf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbgKQNu3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732319AbgKQNch (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:37 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B5ED2463D;
        Tue, 17 Nov 2020 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619958;
        bh=Iyf4Rgv1+x9PtEcqoWVcwfYPM8emMHSynQZDAw8Vlh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cet0n5JfTryI2r5wS0lajmlBaXW1o1RRiB4pZeSqFUJRK0Wwka+h0yt1RlMiiiUbm
         VXdHZ6gmvmY4vFt072CdGV3xX1YatYMgxHBI6/vxVm/7DPdVepaOZ8fjkdrp92Tnmb
         wZ7aKg3DlscXPu8H+jZ5tdfyq2Ctp+NBCqcyRzzk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 1/4] crypto: aegis128 - wipe plaintext and tag if decryption fails
Date:   Tue, 17 Nov 2020 14:32:11 +0100
Message-Id: <20201117133214.29114-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117133214.29114-1-ardb@kernel.org>
References: <20201117133214.29114-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AEGIS spec mentions explicitly that the security guarantees hold
only if the resulting plaintext and tag of a failed decryption are
withheld. So ensure that we abide by this.

While at it, drop the unused struct aead_request *req parameter from
crypto_aegis128_process_crypt().

Reviewed-by: Ondrej Mosnacek <omosnacek@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-core.c | 32 ++++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 44fb4956f0dd..3a71235892f5 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -154,6 +154,12 @@ static void crypto_aegis128_ad(struct aegis_state *state,
 	}
 }
 
+static void crypto_aegis128_wipe_chunk(struct aegis_state *state, u8 *dst,
+				       const u8 *src, unsigned int size)
+{
+	memzero_explicit(dst, size);
+}
+
 static void crypto_aegis128_encrypt_chunk(struct aegis_state *state, u8 *dst,
 					  const u8 *src, unsigned int size)
 {
@@ -324,7 +330,6 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 static __always_inline
 int crypto_aegis128_process_crypt(struct aegis_state *state,
-				  struct aead_request *req,
 				  struct skcipher_walk *walk,
 				  void (*crypt)(struct aegis_state *state,
 					        u8 *dst, const u8 *src,
@@ -403,14 +408,14 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	if (aegis128_do_simd()) {
 		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
 		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, req, &walk,
+		crypto_aegis128_process_crypt(&state, &walk,
 					      crypto_aegis128_encrypt_chunk_simd);
 		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
 					   cryptlen);
 	} else {
 		crypto_aegis128_init(&state, &ctx->key, req->iv);
 		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, req, &walk,
+		crypto_aegis128_process_crypt(&state, &walk,
 					      crypto_aegis128_encrypt_chunk);
 		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 	}
@@ -438,19 +443,34 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	if (aegis128_do_simd()) {
 		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
 		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, req, &walk,
+		crypto_aegis128_process_crypt(&state, &walk,
 					      crypto_aegis128_decrypt_chunk_simd);
 		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
 					   cryptlen);
 	} else {
 		crypto_aegis128_init(&state, &ctx->key, req->iv);
 		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, req, &walk,
+		crypto_aegis128_process_crypt(&state, &walk,
 					      crypto_aegis128_decrypt_chunk);
 		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 	}
 
-	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
+	if (unlikely(crypto_memneq(tag.bytes, zeros, authsize))) {
+		/*
+		 * From Chapter 4. 'Security Analysis' of the AEGIS spec [0]
+		 *
+		 * "3. If verification fails, the decrypted plaintext and the
+		 *     wrong authentication tag should not be given as output."
+		 *
+		 * [0] https://competitions.cr.yp.to/round3/aegisv11.pdf
+		 */
+		skcipher_walk_aead_decrypt(&walk, req, false);
+		crypto_aegis128_process_crypt(NULL, &walk,
+					      crypto_aegis128_wipe_chunk);
+		memzero_explicit(&tag, sizeof(tag));
+		return -EBADMSG;
+	}
+	return 0;
 }
 
 static struct aead_alg crypto_aegis128_alg = {
-- 
2.17.1

