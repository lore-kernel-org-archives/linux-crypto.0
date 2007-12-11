From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/19] [CRYPTO] skcipher: Add top-level givencrypt/givdecrypt calls
Date: Tue, 11 Dec 2007 12:05:43 +0800
Message-ID: <E1J1wNL-0002lF-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1970 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbXLKEFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:53 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNN-000686-RC
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:46 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Add top-level givencrypt/givdecrypt calls

This patch finally makes the givencrypt/givdecrypt operations available
to users by adding crypto_skcipher_givencrypt and crypto_skcipher_givdecrypt.
A suite of helpers to allocate and fill in the request is also available.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/skcipher.h |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index c283fab..25fd612 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -14,6 +14,8 @@
 #define _CRYPTO_SKCIPHER_H
 
 #include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
 
 /**
  *	struct skcipher_givcrypt_request - Crypto request with IV generation
@@ -34,5 +36,75 @@ static inline struct crypto_ablkcipher *skcipher_givcrypt_reqtfm(
 	return crypto_ablkcipher_reqtfm(&req->creq);
 }
 
+static inline int crypto_skcipher_givencrypt(
+	struct skcipher_givcrypt_request *req)
+{
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(skcipher_givcrypt_reqtfm(req));
+	return crt->givencrypt(req);
+};
+
+static inline int crypto_skcipher_givdecrypt(
+	struct skcipher_givcrypt_request *req)
+{
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(skcipher_givcrypt_reqtfm(req));
+	return crt->givdecrypt(req);
+};
+
+static inline void skcipher_givcrypt_set_tfm(
+	struct skcipher_givcrypt_request *req, struct crypto_ablkcipher *tfm)
+{
+	req->creq.base.tfm = crypto_ablkcipher_tfm(tfm);
+}
+
+static inline struct skcipher_givcrypt_request *skcipher_givcrypt_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(ablkcipher_request_cast(req),
+			    struct skcipher_givcrypt_request, creq);
+}
+
+static inline struct skcipher_givcrypt_request *skcipher_givcrypt_alloc(
+	struct crypto_ablkcipher *tfm, gfp_t gfp)
+{
+	struct skcipher_givcrypt_request *req;
+
+	req = kmalloc(sizeof(struct skcipher_givcrypt_request) +
+		      crypto_ablkcipher_reqsize(tfm), gfp);
+
+	if (likely(req))
+		skcipher_givcrypt_set_tfm(req, tfm);
+
+	return req;
+}
+
+static inline void skcipher_givcrypt_free(struct skcipher_givcrypt_request *req)
+{
+	kfree(req);
+}
+
+static inline void skcipher_givcrypt_set_callback(
+	struct skcipher_givcrypt_request *req, u32 flags,
+	crypto_completion_t complete, void *data)
+{
+	ablkcipher_request_set_callback(&req->creq, flags, complete, data);
+}
+
+static inline void skcipher_givcrypt_set_crypt(
+	struct skcipher_givcrypt_request *req,
+	struct scatterlist *src, struct scatterlist *dst,
+	unsigned int nbytes, void *iv)
+{
+	ablkcipher_request_set_crypt(&req->creq, src, dst, nbytes, iv);
+}
+
+static inline void skcipher_givcrypt_set_giv(
+	struct skcipher_givcrypt_request *req, u8 *giv, u64 seq)
+{
+	req->giv = giv;
+	req->seq = seq;
+}
+
 #endif	/* _CRYPTO_SKCIPHER_H */
 
