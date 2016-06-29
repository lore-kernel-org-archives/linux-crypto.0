From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/7] crypto: rsa-pkcs1pad - Always use GFP_KERNEL
Date: Wed, 29 Jun 2016 17:58:31 +0800
Message-ID: <E1bICGN-0006oH-Ux@gondolin.me.apana.org.au>
References: <20160629095655.GA26056@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52911 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcF2J6v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 05:58:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We don't currently support using akcipher in atomic contexts,
so GFP_KERNEL should always be used.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index d9baefb..db19284 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -260,8 +260,7 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	req_ctx->child_req.dst_len = ctx->key_size;
 
 	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+				  GFP_KERNEL);
 	if (!req_ctx->in_buf)
 		return -ENOMEM;
 
@@ -274,9 +273,7 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf) {
 		kfree(req_ctx->in_buf);
 		return -ENOMEM;
@@ -379,9 +376,7 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	req_ctx->child_req.dst = req_ctx->out_sg;
 	req_ctx->child_req.dst_len = ctx->key_size ;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
@@ -438,8 +433,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	req_ctx->child_req.dst_len = ctx->key_size;
 
 	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+				  GFP_KERNEL);
 	if (!req_ctx->in_buf)
 		return -ENOMEM;
 
@@ -454,9 +448,7 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf) {
 		kfree(req_ctx->in_buf);
 		return -ENOMEM;
@@ -577,9 +569,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	req_ctx->child_req.dst = req_ctx->out_sg;
 	req_ctx->child_req.dst_len = ctx->key_size;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size,
-			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-			GFP_KERNEL : GFP_ATOMIC);
+	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
