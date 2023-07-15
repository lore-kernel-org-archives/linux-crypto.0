Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA99EB64DC
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jul 2023 05:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjGOFCa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Jul 2023 01:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGOFC3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Jul 2023 01:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245E3589
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 22:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7F38602E2
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jul 2023 05:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A47DC433C8;
        Sat, 15 Jul 2023 05:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689397347;
        bh=2jKUlk/iFBrBtBN9Ne0SL4hRkQ0yRf9CJjfjD/3gUXE=;
        h=From:To:Cc:Subject:Date:From;
        b=KNboAbX1P9JAG/zULiJHN2kz2Zab3ZOn8OpJcdzIkfR40ULLRP5DXl2ZTLt6q4LhR
         pV1rCz7phTx1rhsiZCI04wjF0Gyh1CyoEw8DpD5771/NLERYtzs6l8JFdgzqWKKdop
         pSmbWlSD3/l/EwNGOxCV9p0/Nq19/zUqn3rhe8rIA0joFer/j84OfIwcru04XY3DpY
         kDkhDMo6uaUIkiZfnSfPHyinPyGw9pd6sjhVVEPEFUFudOappoySg84nxHBGJsHb1o
         pybY/HayQtown+rdxGd5du67iFEOP2YQfYCIjhnSlP+Kb7mp4lZsodiB6ACXFxZzu5
         rheh50eVeV+/g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     "Chang S . Bae" <chang.seok.bae@intel.com>
Subject: [PATCH] crypto: x86/aesni - remove unused parameter to aes_set_key_common()
Date:   Fri, 14 Jul 2023 22:01:04 -0700
Message-ID: <20230715050104.35945-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The 'tfm' parameter to aes_set_key_common() is never used, so remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c4eea7e746e79..39d6a62ac6277 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -229,8 +229,7 @@ static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 	return (struct crypto_aes_ctx *)ALIGN(addr, align);
 }
 
-static int aes_set_key_common(struct crypto_tfm *tfm,
-			      struct crypto_aes_ctx *ctx,
+static int aes_set_key_common(struct crypto_aes_ctx *ctx,
 			      const u8 *in_key, unsigned int key_len)
 {
 	int err;
@@ -253,7 +252,8 @@ static int aes_set_key_common(struct crypto_tfm *tfm,
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
-	return aes_set_key_common(tfm, aes_ctx(crypto_tfm_ctx(tfm)), in_key, key_len);
+	return aes_set_key_common(aes_ctx(crypto_tfm_ctx(tfm)), in_key,
+				  key_len);
 }
 
 static void aesni_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -285,8 +285,7 @@ static void aesni_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			         unsigned int len)
 {
-	return aes_set_key_common(crypto_skcipher_tfm(tfm),
-				  aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
+	return aes_set_key_common(aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
 }
 
 static int ecb_encrypt(struct skcipher_request *req)
@@ -627,8 +626,7 @@ static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
 
 	memcpy(ctx->nonce, key + key_len, sizeof(ctx->nonce));
 
-	return aes_set_key_common(crypto_aead_tfm(aead),
-				  &ctx->aes_key_expanded, key, key_len) ?:
+	return aes_set_key_common(&ctx->aes_key_expanded, key, key_len) ?:
 	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
 }
 
@@ -893,14 +891,13 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keylen /= 2;
 
 	/* first half of xts-key is for crypt */
-	err = aes_set_key_common(crypto_skcipher_tfm(tfm), aes_ctx(ctx->raw_crypt_ctx),
-				 key, keylen);
+	err = aes_set_key_common(aes_ctx(ctx->raw_crypt_ctx), key, keylen);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return aes_set_key_common(crypto_skcipher_tfm(tfm), aes_ctx(ctx->raw_tweak_ctx),
-				  key + keylen, keylen);
+	return aes_set_key_common(aes_ctx(ctx->raw_tweak_ctx), key + keylen,
+				  keylen);
 }
 
 static int xts_crypt(struct skcipher_request *req, bool encrypt)
@@ -1150,8 +1147,7 @@ static int generic_gcmaes_set_key(struct crypto_aead *aead, const u8 *key,
 {
 	struct generic_gcmaes_ctx *ctx = generic_gcmaes_ctx_get(aead);
 
-	return aes_set_key_common(crypto_aead_tfm(aead),
-				  &ctx->aes_key_expanded, key, key_len) ?:
+	return aes_set_key_common(&ctx->aes_key_expanded, key, key_len) ?:
 	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
 }
 

base-commit: 635e4674e184442d300278beb6c8b609b897b6c3
-- 
2.41.0

