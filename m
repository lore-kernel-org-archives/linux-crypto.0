From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] crypto/cryptod: use crypto_skcipher_type() for getting skcipher type
Date: Wed, 25 Nov 2015 23:48:28 +0600
Message-ID: <1448473708-9609-1-git-send-email-kuleshovmail@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35002 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbKYRuy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Nov 2015 12:50:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The <linux/crypto.h> provides inline function - crypto_skcipher_type().
Let's use it in the cryptd_alloc_ablkcipher() instead of direct calculation.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 crypto/cryptd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index c81861b..c4af8aa 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -887,8 +887,7 @@ struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
 	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
 		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-EINVAL);
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	type = crypto_skcipher_type(type);
 	mask &= ~CRYPTO_ALG_TYPE_MASK;
 	mask |= (CRYPTO_ALG_GENIV | CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
 	tfm = crypto_alloc_base(cryptd_alg_name, type, mask);
-- 
2.5.0
