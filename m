From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] crypto: shash - Require all algorithms to support export/import
Date: Wed, 22 Jul 2009 14:40:09 +0800
Message-ID: <E1MTVUn-0007kI-Qt@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51386 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbZGVGkK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUo-0005zB-4U
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:10 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Require all algorithms to support export/import

This patch provides a default export/import function for all
shash algorithms.  It simply copies the descriptor context as
is done by sha1_generic.

This in essence means that all existing shash algorithms now
support export/import.  This is something that will be depended
upon in implementations such as hmac.  Therefore all new shash
and ahash implementations must support export/import.

For those that cannot obtain a partial result, padlock-sha's
fallback model should be used so that a partial result is always
available.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 7713b52..98b7f46 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -183,14 +183,16 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
-static int shash_no_export(struct shash_desc *desc, void *out)
+static int shash_default_export(struct shash_desc *desc, void *out)
 {
-	return -ENOSYS;
+	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm));
+	return 0;
 }
 
-static int shash_no_import(struct shash_desc *desc, const void *in)
+static int shash_default_import(struct shash_desc *desc, const void *in)
 {
-	return -ENOSYS;
+	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(desc->tfm));
+	return 0;
 }
 
 static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
@@ -563,10 +565,11 @@ static int shash_prepare_alg(struct shash_alg *alg)
 		alg->finup = shash_finup_unaligned;
 	if (!alg->digest)
 		alg->digest = shash_digest_unaligned;
-	if (!alg->import)
-		alg->import = shash_no_import;
-	if (!alg->export)
-		alg->export = shash_no_export;
+	if (!alg->export) {
+		alg->export = shash_default_export;
+		alg->import = shash_default_import;
+		alg->statesize = alg->descsize;
+	}
 	if (!alg->setkey)
 		alg->setkey = shash_no_setkey;
 
