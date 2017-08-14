From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/3] crypto: skcipher - export crypto_skcipher_type2
Date: Mon, 14 Aug 2017 15:17:23 +0200
Message-ID: <20170814131725.9402-2-clabbe.montjoie@gmail.com>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36085 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdHNNTh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 09:19:37 -0400
In-Reply-To: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch export crypto_skcipher_type2 like others cra_type

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/skcipher.c       | 3 ++-
 include/crypto/algapi.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 4faa0fd53b0c..c6523826890f 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -893,7 +893,7 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 }
 #endif
 
-static const struct crypto_type crypto_skcipher_type2 = {
+const struct crypto_type crypto_skcipher_type2 = {
 	.extsize = crypto_skcipher_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
 	.free = crypto_skcipher_free_instance,
@@ -906,6 +906,7 @@ static const struct crypto_type crypto_skcipher_type2 = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.tfmsize = offsetof(struct crypto_skcipher, base),
 };
+EXPORT_SYMBOL_GPL(crypto_skcipher_type2);
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			  const char *name, u32 type, u32 mask)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e3cebf640c00..c6a4090ed2ed 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -130,6 +130,7 @@ struct ablkcipher_walk {
 
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
+extern const struct crypto_type crypto_skcipher_type2;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
-- 
2.13.0
