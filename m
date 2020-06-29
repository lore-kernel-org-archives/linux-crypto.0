Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898ADC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65621206E9
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466522;
	bh=Su7HU4/4Njg23ZZQtRTkcf+M77/lB+jIRd2dvvCy4us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=appRUbjmXHfEXNt8UCnGIHsVhq0cnCaXS0C+Uwp5xgqw5s2Lk0IeUAgLNTxF+5PVp
	 Oe38YMUNd+tWoPCqITSjaoMG0vAPXtk7CoiuRQaawnC9oyUoydRWwdW9JtMihMMHeo
	 ouptjfdKEO09OsddVVLLh9mBMvMFnKqg1KT0uVO0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgF2VfU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbgF2Skv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:51 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E182332F;
        Mon, 29 Jun 2020 07:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416383;
        bh=Su7HU4/4Njg23ZZQtRTkcf+M77/lB+jIRd2dvvCy4us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+KrZoCO4G6IqiPX5EXjHn7vte4GO25rf9XwqVXS8OocSqW+c8WR02lf/cl57ZVMp
         K5+xg59JUNi2xHNbSx+iuNF8TsYu6P4spme3FKP0hYZTjfO8QDA1d9jUoKN8/2SeYg
         FC7hWrIGWhfw6m0SUg6AaK8pbJWMKPQZANsZ/4xg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/5] crypto: arm64/gcm - disentangle ghash and gcm setkey() routines
Date:   Mon, 29 Jun 2020 09:39:22 +0200
Message-Id: <20200629073925.127538-3-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629073925.127538-1-ardb@kernel.org>
References: <20200629073925.127538-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The remaining ghash implementation does not support aggregation, and so
there is no point in including the precomputed powers of H in the key
struct. So move that into the GCM setkey routine, and get rid of the
shared sub-routine entirely.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 47 +++++++++-----------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index be63d8b5152c..921fa69b5ded 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -184,29 +184,6 @@ static void ghash_reflect(u64 h[], const be128 *k)
 		h[1] ^= 0xc200000000000000UL;
 }
 
-static int __ghash_setkey(struct ghash_key *key,
-			  const u8 *inkey, unsigned int keylen)
-{
-	be128 h;
-
-	/* needed for the fallback */
-	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
-
-	ghash_reflect(key->h, &key->k);
-
-	h = key->k;
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h2, &h);
-
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h3, &h);
-
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h4, &h);
-
-	return 0;
-}
-
 static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *inkey, unsigned int keylen)
 {
@@ -215,7 +192,11 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
 
-	return __ghash_setkey(key, inkey, keylen);
+	/* needed for the fallback */
+	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
+
+	ghash_reflect(key->h, &key->k);
+	return 0;
 }
 
 static struct shash_alg ghash_alg = {
@@ -251,6 +232,7 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
 	u8 key[GHASH_BLOCK_SIZE];
+	be128 h;
 	int ret;
 
 	ret = aes_expandkey(&ctx->aes_key, inkey, keylen);
@@ -259,7 +241,22 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 
 	aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
 
-	return __ghash_setkey(&ctx->ghash_key, key, sizeof(be128));
+	/* needed for the fallback */
+	memcpy(&ctx->ghash_key.k, key, GHASH_BLOCK_SIZE);
+
+	ghash_reflect(ctx->ghash_key.h, &ctx->ghash_key.k);
+
+	h = ctx->ghash_key.k;
+	gf128mul_lle(&h, &ctx->ghash_key.k);
+	ghash_reflect(ctx->ghash_key.h2, &h);
+
+	gf128mul_lle(&h, &ctx->ghash_key.k);
+	ghash_reflect(ctx->ghash_key.h3, &h);
+
+	gf128mul_lle(&h, &ctx->ghash_key.k);
+	ghash_reflect(ctx->ghash_key.h4, &h);
+
+	return 0;
 }
 
 static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
-- 
2.20.1

