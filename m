From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] [CRYPTO] api: Use structs for cipher/compression
Date: Wed, 24 Jan 2007 21:29:21 +1100
Message-ID: <E1H9fNZ-0005nI-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2908 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbXAXK3Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:24 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNa-0005x9-Dl
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:22 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNZ-0005nI-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:21 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Use structs for cipher/compression

Now that all cipher/compression users have switched over to the new
allocation scheme, we can get rid of the compatility defines and use
proper structs for them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -311,13 +311,18 @@ struct crypto_tfm {
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-#define crypto_cipher crypto_tfm
-#define crypto_comp crypto_tfm
-
 struct crypto_blkcipher {
 	struct crypto_tfm base;
 };
 
+struct crypto_cipher {
+	struct crypto_tfm base;
+};
+
+struct crypto_comp {
+	struct crypto_tfm base;
+};
+
 struct crypto_hash {
 	struct crypto_tfm base;
 };
@@ -576,7 +581,7 @@ static inline struct crypto_cipher *cryp
 
 static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
 {
-	return tfm;
+	return &tfm->base;
 }
 
 static inline void crypto_free_cipher(struct crypto_cipher *tfm)
@@ -776,7 +781,7 @@ static inline struct crypto_comp *crypto
 
 static inline struct crypto_tfm *crypto_comp_tfm(struct crypto_comp *tfm)
 {
-	return tfm;
+	return &tfm->base;
 }
 
 static inline void crypto_free_comp(struct crypto_comp *tfm)
@@ -807,14 +812,16 @@ static inline int crypto_comp_compress(s
                                        const u8 *src, unsigned int slen,
                                        u8 *dst, unsigned int *dlen)
 {
-	return crypto_comp_crt(tfm)->cot_compress(tfm, src, slen, dst, dlen);
+	return crypto_comp_crt(tfm)->cot_compress(crypto_comp_tfm(tfm),
+						  src, slen, dst, dlen);
 }
 
 static inline int crypto_comp_decompress(struct crypto_comp *tfm,
                                          const u8 *src, unsigned int slen,
                                          u8 *dst, unsigned int *dlen)
 {
-	return crypto_comp_crt(tfm)->cot_decompress(tfm, src, slen, dst, dlen);
+	return crypto_comp_crt(tfm)->cot_decompress(crypto_comp_tfm(tfm),
+						    src, slen, dst, dlen);
 }
 
 #endif	/* _LINUX_CRYPTO_H */
