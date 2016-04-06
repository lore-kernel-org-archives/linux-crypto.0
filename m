From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: rsa - fix dst len
Date: Wed,  6 Apr 2016 14:42:32 -0700
Message-ID: <1459978952-18238-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	stable@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The output buffer length has to be at least as big as the key_size.
It is then updated to the actual output size by the implementation.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/rsa-pkcs1pad.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 1cea67d..ead8dc0 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -387,16 +387,16 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	req_ctx->child_req.src = req->src;
 	req_ctx->child_req.src_len = req->src_len;
 	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size - 1;
+	req_ctx->child_req.dst_len = ctx->key_size ;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size - 1,
+	req_ctx->out_buf = kmalloc(ctx->key_size,
 			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 			GFP_KERNEL : GFP_ATOMIC);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
 	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size - 1, NULL);
+			    ctx->key_size, NULL);
 
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
@@ -595,16 +595,16 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	req_ctx->child_req.src = req->src;
 	req_ctx->child_req.src_len = req->src_len;
 	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size - 1;
+	req_ctx->child_req.dst_len = ctx->key_size;
 
-	req_ctx->out_buf = kmalloc(ctx->key_size - 1,
+	req_ctx->out_buf = kmalloc(ctx->key_size,
 			(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 			GFP_KERNEL : GFP_ATOMIC);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
 
 	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size - 1, NULL);
+			    ctx->key_size, NULL);
 
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
-- 
2.1.4
