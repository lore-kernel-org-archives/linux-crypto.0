From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/10] [CRYPTO] skcipher: Fix mask on skcipher spawns
Date: Wed, 12 Dec 2007 20:30:49 +0800
Message-ID: <E1J2Qjh-0006cx-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3709 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756576AbXLLMaw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:30:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Fix mask on skcipher spawns

The mask set on spawns should match the mask used to locate the algorithm
originally.  This patch fixes the mask used on skcipher spawns so that it
includes the proper type mask and GENIV where applicable.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    9 +++++++--
 crypto/blkcipher.c  |    7 ++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d3fc416..0bfc01f 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -250,8 +250,7 @@ static struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type,
 {
 	struct crypto_alg *alg;
 
-	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
-				    crypto_skcipher_mask(mask));
+	alg = crypto_alg_mod_lookup(name, type, mask);
 	if (IS_ERR(alg))
 		return alg;
 
@@ -273,6 +272,9 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 	struct crypto_alg *alg;
 	int err;
 
+	type = crypto_skcipher_type(type);
+	mask = crypto_skcipher_mask(mask);
+
 	alg = crypto_lookup_skcipher(name, type, mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
@@ -289,6 +291,9 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 	struct crypto_tfm *tfm;
 	int err;
 
+	type = crypto_skcipher_type(type);
+	mask = crypto_skcipher_mask(mask);
+
 	for (;;) {
 		struct crypto_alg *alg;
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 2ef5b10..10c2229 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -516,9 +516,10 @@ static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
 	struct crypto_alg *alg;
 	int err;
 
-	alg = crypto_alg_mod_lookup(name, crypto_skcipher_type(type),
-				    crypto_skcipher_mask(mask) |
-				    CRYPTO_ALG_GENIV);
+	type = crypto_skcipher_type(type);
+	mask = crypto_skcipher_mask(mask) | CRYPTO_ALG_GENIV;
+
+	alg = crypto_alg_mod_lookup(name, type, mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
