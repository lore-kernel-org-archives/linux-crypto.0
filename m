From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: echainiv - Stop using cryptoff
Date: Sat, 23 May 2015 15:41:54 +0800
Message-ID: <E1Yw44A-0003t1-SU@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43653 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbbEWHl6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:41:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw44B-00033S-HD
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:55 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cryptoff parameter was added to facilitate the skipping of
IVs that sit between the AD and the plain/cipher text.  However,
it was never implemented correctly as and we do not handle users
such as IPsec setting cryptoff.  It is simply ignored.

Implementing correctly is in fact more trouble than what it's
worth.

This patch removes the uses of cryptoff and simply falls back
to using the old AEAD interface as it's only needed for old AEAD
implementations.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 86e92fa..e24022e 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -167,6 +167,9 @@ static int echainiv_encrypt_compat(struct aead_request *req)
 	__be64 seq;
 	int err;
 
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
+
 	compl = req->base.complete;
 	data = req->base.data;
 
@@ -212,17 +215,18 @@ static int echainiv_encrypt(struct aead_request *req)
 	crypto_completion_t compl;
 	void *data;
 	u8 *info;
-	unsigned int ivsize;
+	unsigned int ivsize = crypto_aead_ivsize(geniv);
 	int err;
 
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
+
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = echainiv_encrypt_complete;
 	data = req;
 	info = req->iv;
 
-	ivsize = crypto_aead_ivsize(geniv);
-
 	if (req->src != req->dst) {
 		struct scatterlist src[2];
 		struct scatterlist dst[2];
@@ -270,22 +274,28 @@ static int echainiv_decrypt_compat(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct echainiv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct aead_request *subreq = aead_request_ctx(req);
+	struct echainiv_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_request *subreq = &rctx->subreq.areq;
 	crypto_completion_t compl;
 	void *data;
-	unsigned int ivsize;
+	unsigned int ivsize = crypto_aead_ivsize(geniv);
+
+	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
+		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
 
-	ivsize = crypto_aead_ivsize(geniv);
-
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, req->src, req->dst,
+	aead_request_set_crypt(subreq,
+			       scatterwalk_ffwd(rctx->src, req->src,
+						req->assoclen + ivsize),
+			       scatterwalk_ffwd(rctx->dst, req->dst,
+						req->assoclen + ivsize),
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen, ivsize);
+	aead_request_set_assoc(subreq, req->src, req->assoclen);
 
 	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
 
@@ -299,15 +309,16 @@ static int echainiv_decrypt(struct aead_request *req)
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
-	unsigned int ivsize;
+	unsigned int ivsize = crypto_aead_ivsize(geniv);
+
+	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
+		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
 
-	ivsize = crypto_aead_ivsize(geniv);
-
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->src, req->dst,
 			       req->cryptlen - ivsize, req->iv);
