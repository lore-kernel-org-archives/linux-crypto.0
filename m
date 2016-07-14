From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: rsa-pkcs1pad - Fix akcipher request allocation
Date: Thu, 14 Jul 2016 11:25:05 +0100
Message-ID: <1468491905-2597-1-git-send-email-salvatore.benedetto@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	andrew.zaborowski@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbcGNKZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 06:25:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Embedding the akcipher_request in pkcs1pad_request don't take
into account the context space required by the akcipher object.
This result in memory corruption (and kernel panic) as the
akcipher object will overwrite anything after akcipher_request
structure.

Fix it by dinamically allocating the structure with akcipher_request_alloc.

Software akcipher implementation is working only because it is
synchronous and it does not use a request context.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 crypto/rsa-pkcs1pad.c | 75 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 24 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 880d3db..d663ab6 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -101,7 +101,7 @@ struct pkcs1pad_inst_ctx {
 };
 
 struct pkcs1pad_request {
-	struct akcipher_request child_req;
+	struct akcipher_request *child_req;
 
 	struct scatterlist in_sg[2], out_sg[1];
 	uint8_t *in_buf, *out_buf;
@@ -192,7 +192,7 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	if (err)
 		goto out;
 
-	len = req_ctx->child_req.dst_len;
+	len = req_ctx->child_req->dst_len;
 	pad_len = ctx->key_size - len;
 
 	/* Four billion to one */
@@ -215,6 +215,7 @@ out:
 	req->dst_len = ctx->key_size;
 
 	kfree(req_ctx->in_buf);
+	akcipher_request_free(req_ctx->child_req);
 
 	return err;
 }
@@ -277,15 +278,21 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			ctx->key_size, NULL);
 
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+	req_ctx->child_req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
+	if (!req_ctx->child_req) {
+		kfree(req_ctx->out_buf);
+		kfree(req_ctx->in_buf);
+		return -ENOMEM;
+	}
+	akcipher_request_set_tfm(req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
 
 	/* Reuse output buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
+	akcipher_request_set_crypt(req_ctx->child_req, req_ctx->in_sg,
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
-	err = crypto_akcipher_encrypt(&req_ctx->child_req);
+	err = crypto_akcipher_encrypt(req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
 			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
@@ -308,7 +315,7 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 	if (err)
 		goto done;
 
-	if (req_ctx->child_req.dst_len != ctx->key_size - 1) {
+	if (req_ctx->child_req->dst_len != ctx->key_size - 1) {
 		err = -EINVAL;
 		goto done;
 	}
@@ -317,18 +324,18 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 		err = -EINVAL;
 		goto done;
 	}
-	for (pos = 1; pos < req_ctx->child_req.dst_len; pos++)
+	for (pos = 1; pos < req_ctx->child_req->dst_len; pos++)
 		if (req_ctx->out_buf[pos] == 0x00)
 			break;
-	if (pos < 9 || pos == req_ctx->child_req.dst_len) {
+	if (pos < 9 || pos == req_ctx->child_req->dst_len) {
 		err = -EINVAL;
 		goto done;
 	}
 	pos++;
 
-	if (req->dst_len < req_ctx->child_req.dst_len - pos)
+	if (req->dst_len < req_ctx->child_req->dst_len - pos)
 		err = -EOVERFLOW;
-	req->dst_len = req_ctx->child_req.dst_len - pos;
+	req->dst_len = req_ctx->child_req->dst_len - pos;
 
 	if (!err)
 		sg_copy_from_buffer(req->dst,
@@ -337,6 +344,7 @@ static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
 
 done:
 	kzfree(req_ctx->out_buf);
+	akcipher_request_free(req_ctx->child_req);
 
 	return err;
 }
@@ -373,16 +381,22 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
 
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+	req_ctx->child_req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
+	if (!req_ctx->child_req) {
+		kfree(req_ctx->out_buf);
+		return -ENOMEM;
+	}
+
+	akcipher_request_set_tfm(req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(req_ctx->child_req, req->base.flags,
 			pkcs1pad_decrypt_complete_cb, req);
 
 	/* Reuse input buffer, output to a new buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
+	akcipher_request_set_crypt(req_ctx->child_req, req->src,
 				   req_ctx->out_sg, req->src_len,
 				   ctx->key_size);
 
-	err = crypto_akcipher_decrypt(&req_ctx->child_req);
+	err = crypto_akcipher_decrypt(req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
 			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
@@ -420,6 +434,12 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	if (!req_ctx->in_buf)
 		return -ENOMEM;
 
+	req_ctx->child_req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
+	if (!req_ctx->child_req) {
+		kfree(req_ctx->in_buf);
+		return -ENOMEM;
+	}
+
 	ps_end = ctx->key_size - digest_size - req->src_len - 2;
 	req_ctx->in_buf[0] = 0x01;
 	memset(req_ctx->in_buf + 1, 0xff, ps_end - 1);
@@ -431,15 +451,15 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+	akcipher_request_set_tfm(req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
 
 	/* Reuse output buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
+	akcipher_request_set_crypt(req_ctx->child_req, req_ctx->in_sg,
 				   req->dst, ctx->key_size - 1, req->dst_len);
 
-	err = crypto_akcipher_sign(&req_ctx->child_req);
+	err = crypto_akcipher_sign(req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
 			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
@@ -464,7 +484,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		goto done;
 
 	err = -EINVAL;
-	dst_len = req_ctx->child_req.dst_len;
+	dst_len = req_ctx->child_req->dst_len;
 	if (dst_len < ctx->key_size - 1)
 		goto done;
 
@@ -507,6 +527,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 				out_buf + pos, req->dst_len);
 done:
 	kzfree(req_ctx->out_buf);
+	akcipher_request_free(req_ctx->child_req);
 
 	return err;
 }
@@ -551,16 +572,22 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
 			    ctx->key_size, NULL);
 
-	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
-	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
+	req_ctx->child_req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
+	if (!req_ctx->child_req) {
+		kfree(req_ctx->out_buf);
+		return -ENOMEM;
+	}
+
+	akcipher_request_set_tfm(req_ctx->child_req, ctx->child);
+	akcipher_request_set_callback(req_ctx->child_req, req->base.flags,
 			pkcs1pad_verify_complete_cb, req);
 
 	/* Reuse input buffer, output to a new buffer */
-	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
+	akcipher_request_set_crypt(req_ctx->child_req, req->src,
 				   req_ctx->out_sg, req->src_len,
 				   ctx->key_size);
 
-	err = crypto_akcipher_verify(&req_ctx->child_req);
+	err = crypto_akcipher_verify(req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
 			 !(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
-- 
2.7.4
