From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] crypto: hash - Add helpers to return alg and driver names
Date: Mon, 01 Feb 2016 21:36:52 +0800
Message-ID: <E1aQEey-0002pN-Mg@gondolin.me.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44054 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbcBANgz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:36:55 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1aQEey-0002Ib-SL
	for <linux-crypto@vger.kernel.org>; Tue, 02 Feb 2016 00:36:52 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds helpers to retrieve the alg name and driver name
of crypto_shash and crypto_ahash objects.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/hash.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f855efa..1969f14 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -272,6 +272,16 @@ static inline void crypto_free_ahash(struct crypto_ahash *tfm)
  */
 int crypto_has_ahash(const char *alg_name, u32 type, u32 mask);
 
+static inline const char *crypto_ahash_alg_name(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
+}
+
+static inline const char *crypto_ahash_driver_name(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
+}
+
 static inline unsigned int crypto_ahash_alignmask(
 	struct crypto_ahash *tfm)
 {
@@ -676,6 +686,16 @@ static inline void crypto_free_shash(struct crypto_shash *tfm)
 	crypto_destroy_tfm(tfm, crypto_shash_tfm(tfm));
 }
 
+static inline const char *crypto_shash_alg_name(struct crypto_shash *tfm)
+{
+	return crypto_tfm_alg_name(crypto_shash_tfm(tfm));
+}
+
+static inline const char *crypto_shash_driver_name(struct crypto_shash *tfm)
+{
+	return crypto_tfm_alg_driver_name(crypto_shash_tfm(tfm));
+}
+
 static inline unsigned int crypto_shash_alignmask(
 	struct crypto_shash *tfm)
 {
