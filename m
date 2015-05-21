From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/16] crypto: aead - Add new interface with single SG list
Date: Thu, 21 May 2015 15:11:01 +0800
Message-ID: <E1YvKdB-0005de-57@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52819 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbbEUHLE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdB-0002xA-FJ
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:01 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The primary user of AEAD, IPsec includes the IV in the AD in
most cases, except where it is implicitly authenticated by the
underlying algorithm.

The way it is currently implemented is a hack because we pass
the data in piecemeal and the underlying algorithms try to stitch
them back up into one piece.

This is why this patch is adding a new interface that allows a
single SG list to be passed in that contains everything so the
algorithm implementors do not have to stitch.

The new interface accepts a single source SG list and a single
destination SG list.  Both must be laid out as follows:

	AD, skipped data, plain/cipher text, ICV

The ICV is not present from the source during encryption and from
the destination during decryption.

For the top-level IPsec AEAD algorithm the plain/cipher text will
contain the generated (or received) IV.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c         |   58 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/crypto/aead.h |   35 +++++++++++++++++++++++++-----
 2 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 717b2f6..c2bf3b3 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -13,6 +13,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -85,6 +86,59 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
+struct aead_old_request {
+	struct scatterlist srcbuf[2];
+	struct scatterlist dstbuf[2];
+	struct aead_request subreq;
+};
+
+unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
+{
+	return tfm->reqsize + sizeof(struct aead_old_request);
+}
+EXPORT_SYMBOL_GPL(crypto_aead_reqsize);
+
+static int old_crypt(struct aead_request *req,
+		     int (*crypt)(struct aead_request *req))
+{
+	struct aead_old_request *nreq = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct scatterlist *src, *dst;
+
+	if (req->old)
+		return crypt(req);
+
+	src = scatterwalk_ffwd(nreq->srcbuf, req->src,
+			       req->assoclen + req->cryptoff);
+	dst = scatterwalk_ffwd(nreq->dstbuf, req->dst,
+			       req->assoclen + req->cryptoff);
+
+	aead_request_set_tfm(&nreq->subreq, aead);
+	aead_request_set_callback(&nreq->subreq, aead_request_flags(req),
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(&nreq->subreq, src, dst, req->cryptlen,
+			       req->iv);
+	aead_request_set_assoc(&nreq->subreq, req->src, req->assoclen);
+
+	return crypt(&nreq->subreq);
+}
+
+static int old_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	return old_crypt(req, alg->encrypt);
+}
+
+static int old_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+
+	return old_crypt(req, alg->decrypt);
+}
+
 static int no_givcrypt(struct aead_givcrypt_request *req)
 {
 	return -ENOSYS;
@@ -98,8 +152,8 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	crt->encrypt = alg->encrypt;
-	crt->decrypt = alg->decrypt;
+	crt->encrypt = old_encrypt;
+	crt->decrypt = old_decrypt;
 	if (alg->ivsize) {
 		crt->givencrypt = alg->givencrypt ?: no_givcrypt;
 		crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index dbcad08..e2d2c3c 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -52,6 +52,7 @@
  *	@base: Common attributes for async crypto requests
  *	@assoclen: Length in bytes of associated data for authentication
  *	@cryptlen: Length of data to be encrypted or decrypted
+ *	@cryptoff: Bytes to skip after AD before plain/cipher text
  *	@iv: Initialisation vector
  *	@assoc: Associated data
  *	@src: Source data
@@ -61,8 +62,11 @@
 struct aead_request {
 	struct crypto_async_request base;
 
+	bool old;
+
 	unsigned int assoclen;
 	unsigned int cryptlen;
+	unsigned int cryptoff;
 
 	u8 *iv;
 
@@ -314,10 +318,7 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
  *
  * Return: number of bytes
  */
-static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
-{
-	return tfm->reqsize;
-}
+unsigned int crypto_aead_reqsize(struct crypto_aead *tfm);
 
 /**
  * aead_request_set_tfm() - update cipher handle reference in request
@@ -417,6 +418,9 @@ static inline void aead_request_set_callback(struct aead_request *req,
  * destination is the ciphertext. For a decryption operation, the use is
  * reversed - the source is the ciphertext and the destination is the plaintext.
  *
+ * For both src/dst the layout is associated data, skipped data,
+ * plain/cipher text, authentication tag.
+ *
  * IMPORTANT NOTE AEAD requires an authentication tag (MAC). For decryption,
  *		  the caller must concatenate the ciphertext followed by the
  *		  authentication tag and provide the entire data stream to the
@@ -449,8 +453,7 @@ static inline void aead_request_set_crypt(struct aead_request *req,
  * @assoc: associated data scatter / gather list
  * @assoclen: number of bytes to process from @assoc
  *
- * For encryption, the memory is filled with the associated data. For
- * decryption, the memory must point to the associated data.
+ * Obsolete, do not use.
  */
 static inline void aead_request_set_assoc(struct aead_request *req,
 					  struct scatterlist *assoc,
@@ -458,6 +461,26 @@ static inline void aead_request_set_assoc(struct aead_request *req,
 {
 	req->assoc = assoc;
 	req->assoclen = assoclen;
+	req->old = true;
+}
+
+/**
+ * aead_request_set_ad - set associated data information
+ * @req: request handle
+ * @assoclen: number of bytes in associated data
+ * @cryptoff: Number of bytes to skip after AD before plain/cipher text
+ *
+ * Setting the AD information.  This function sets the length of
+ * the associated data and the number of bytes to skip after it to
+ * access the plain/cipher text.
+ */
+static inline void aead_request_set_ad(struct aead_request *req,
+				       unsigned int assoclen,
+				       unsigned int cryptoff)
+{
+	req->assoclen = assoclen;
+	req->cryptoff = cryptoff;
+	req->old = false;
 }
 
 static inline struct crypto_aead *aead_givcrypt_reqtfm(
