From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 19/19] [CRYPTO] aead: Add top-level givencrypt/givdecrypt calls
Date: Tue, 11 Dec 2007 12:05:48 +0800
Message-ID: <E1J1wNQ-0002lh-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1976 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751944AbXLKEFz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:55 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNS-00068e-Uw
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:51 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Add top-level givencrypt/givdecrypt calls

This patch finally makes the givencrypt/givdecrypt operations available
to users by adding crypto_aead_givencrypt and crypto_aead_givdecrypt.
A suite of helpers to allocate and fill in the request is also available.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/aead.h |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 0839203..0edf949 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -15,6 +15,7 @@
 
 #include <linux/crypto.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 /**
  *	struct aead_givcrypt_request - AEAD request with IV generation
@@ -35,4 +36,70 @@ static inline struct crypto_aead *aead_givcrypt_reqtfm(
 	return crypto_aead_reqtfm(&req->areq);
 }
 
+static inline int crypto_aead_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_tfm *crt = crypto_aead_crt(aead_givcrypt_reqtfm(req));
+	return crt->givencrypt(req);
+};
+
+static inline int crypto_aead_givdecrypt(struct aead_givcrypt_request *req)
+{
+	struct aead_tfm *crt = crypto_aead_crt(aead_givcrypt_reqtfm(req));
+	return crt->givdecrypt(req);
+};
+
+static inline void aead_givcrypt_set_tfm(struct aead_givcrypt_request *req,
+					 struct crypto_aead *tfm)
+{
+	req->areq.base.tfm = crypto_aead_tfm(tfm);
+}
+
+static inline struct aead_givcrypt_request *aead_givcrypt_alloc(
+	struct crypto_aead *tfm, gfp_t gfp)
+{
+	struct aead_givcrypt_request *req;
+
+	req = kmalloc(sizeof(struct aead_givcrypt_request) +
+		      crypto_aead_reqsize(tfm), gfp);
+
+	if (likely(req))
+		aead_givcrypt_set_tfm(req, tfm);
+
+	return req;
+}
+
+static inline void aead_givcrypt_free(struct aead_givcrypt_request *req)
+{
+	kfree(req);
+}
+
+static inline void aead_givcrypt_set_callback(
+	struct aead_givcrypt_request *req, u32 flags,
+	crypto_completion_t complete, void *data)
+{
+	aead_request_set_callback(&req->areq, flags, complete, data);
+}
+
+static inline void aead_givcrypt_set_crypt(struct aead_givcrypt_request *req,
+					   struct scatterlist *src,
+					   struct scatterlist *dst,
+					   unsigned int nbytes, void *iv)
+{
+	aead_request_set_crypt(&req->areq, src, dst, nbytes, iv);
+}
+
+static inline void aead_givcrypt_set_assoc(struct aead_givcrypt_request *req,
+					   struct scatterlist *assoc,
+					   unsigned int assoclen)
+{
+	aead_request_set_assoc(&req->areq, assoc, assoclen);
+}
+
+static inline void aead_givcrypt_set_giv(struct aead_givcrypt_request *req,
+					 u8 *giv, u64 seq)
+{
+	req->giv = giv;
+	req->seq = seq;
+}
+
 #endif	/* _CRYPTO_AEAD_H */
