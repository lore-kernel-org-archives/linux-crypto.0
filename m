From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: hash - Add crypto_has_ahash helper
Date: Sat, 23 Jan 2016 13:52:40 +0800
Message-ID: <20160123055240.GA24268@gondor.apana.org.au>
References: <20160123055101.GA24235@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51450 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcAWFwn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Jan 2016 00:52:43 -0500
Content-Disposition: inline
In-Reply-To: <20160123055101.GA24235@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_has_ahash which should replace
crypto_has_hash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index d19b523..8b08a59 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -542,6 +542,12 @@ struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
 
+int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_type_has_alg(alg_name, &crypto_ahash_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_has_ahash);
+
 static int ahash_prepare_alg(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 6361892..5700e6a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -259,6 +260,18 @@ static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 	crypto_destroy_tfm(tfm, crypto_ahash_tfm(tfm));
 }
 
+/**
+ * crypto_has_ahash() - Search for the availability of an ahash.
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      ahash
+ * @type: specifies the type of the ahash 
+ * @mask: specifies the mask for the ahash 
+ *
+ * Return: true when the ahash is known to the kernel crypto API; false
+ *	   otherwise
+ */
+int crypto_has_ahash(const char *alg_name, u32 type, u32 mask);
+
 static inline unsigned int crypto_ahash_alignmask(
 	struct crypto_ahash *tfm)
 {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
