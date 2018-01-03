From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 7/9] crypto: ghash - remove checks for key being set
Date: Wed,  3 Jan 2018 11:16:28 -0800
Message-ID: <20180103191630.79917-8-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33792 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbeACTSb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:31 -0500
Received: by mail-io0-f193.google.com with SMTP id q188so3162496iod.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:31 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Now that the crypto API prevents a keyed hash from being used without
setting the key, there's no need for GHASH to do this check itself.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ghash-generic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index 12ad3e3a84e3..1bffb3f712dd 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -56,9 +56,6 @@ static int ghash_update(struct shash_desc *desc,
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *dst = dctx->buffer;
 
-	if (!ctx->gf128)
-		return -ENOKEY;
-
 	if (dctx->bytes) {
 		int n = min(srclen, dctx->bytes);
 		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
@@ -111,9 +108,6 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *buf = dctx->buffer;
 
-	if (!ctx->gf128)
-		return -ENOKEY;
-
 	ghash_flush(ctx, dctx);
 	memcpy(dst, buf, GHASH_BLOCK_SIZE);
 
-- 
2.15.1.620.gb9897f4670-goog
