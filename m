From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: aead - Remove unused cryptoff parameter
Date: Sat, 23 May 2015 15:41:57 +0800
Message-ID: <E1Yw44D-0003tZ-JR@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43795 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbbEWHmB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:42:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw44E-00034H-Ln
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the cryptoff parameter now that all users
set it to zero.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c         |    6 ++----
 crypto/echainiv.c     |    4 ++--
 crypto/seqiv.c        |    8 ++++----
 include/crypto/aead.h |    7 +------
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 070e4b9..7c3d725 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -106,10 +106,8 @@ static int old_crypt(struct aead_request *req,
 	if (req->old)
 		return crypt(req);
 
-	src = scatterwalk_ffwd(nreq->srcbuf, req->src,
-			       req->assoclen + req->cryptoff);
-	dst = scatterwalk_ffwd(nreq->dstbuf, req->dst,
-			       req->assoclen + req->cryptoff);
+	src = scatterwalk_ffwd(nreq->srcbuf, req->src, req->assoclen);
+	dst = scatterwalk_ffwd(nreq->dstbuf, req->dst, req->assoclen);
 
 	aead_request_set_tfm(&nreq->subreq, aead);
 	aead_request_set_callback(&nreq->subreq, aead_request_flags(req),
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index e24022e..7b62dfc 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -259,7 +259,7 @@ static int echainiv_encrypt(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->dst, req->dst,
 			       req->cryptlen - ivsize, info);
-	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	crypto_xor(info, ctx->salt, ivsize);
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
@@ -322,7 +322,7 @@ static int echainiv_decrypt(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->src, req->dst,
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
 	if (req->src != req->dst)
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 16738c5..127970a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -337,7 +337,7 @@ static int seqiv_aead_encrypt_compat(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, dst, dst,
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen, 0);
+	aead_request_set_ad(subreq, req->assoclen);
 
 	memcpy(buf, req->iv, ivsize);
 	crypto_xor(buf, ctx->salt, ivsize);
@@ -406,7 +406,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->dst, req->dst,
 			       req->cryptlen - ivsize, info);
-	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	crypto_xor(info, ctx->salt, ivsize);
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
@@ -473,7 +473,7 @@ static int seqiv_aead_decrypt_compat(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, dst, dst,
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen, 0);
+	aead_request_set_ad(subreq, req->assoclen);
 
 	err = crypto_aead_decrypt(subreq);
 	if (req->assoclen > 8)
@@ -501,7 +501,7 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->src, req->dst,
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen + ivsize, 0);
+	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
 	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
 	if (req->src != req->dst)
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index ba28c61..94141dc 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -52,7 +52,6 @@
  *	@base: Common attributes for async crypto requests
  *	@assoclen: Length in bytes of associated data for authentication
  *	@cryptlen: Length of data to be encrypted or decrypted
- *	@cryptoff: Bytes to skip after AD before plain/cipher text
  *	@iv: Initialisation vector
  *	@assoc: Associated data
  *	@src: Source data
@@ -66,7 +65,6 @@ struct aead_request {
 
 	unsigned int assoclen;
 	unsigned int cryptlen;
-	unsigned int cryptoff;
 
 	u8 *iv;
 
@@ -525,18 +523,15 @@ static inline void aead_request_set_assoc(struct aead_request *req,
  * aead_request_set_ad - set associated data information
  * @req: request handle
  * @assoclen: number of bytes in associated data
- * @cryptoff: Number of bytes to skip after AD before plain/cipher text
  *
  * Setting the AD information.  This function sets the length of
  * the associated data and the number of bytes to skip after it to
  * access the plain/cipher text.
  */
 static inline void aead_request_set_ad(struct aead_request *req,
-				       unsigned int assoclen,
-				       unsigned int cryptoff)
+				       unsigned int assoclen)
 {
 	req->assoclen = assoclen;
-	req->cryptoff = cryptoff;
 	req->old = false;
 }
 
