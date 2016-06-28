From: Harsh Jain <harshjain.prof@gmail.com>
Subject: [PATCH] Remove redundant sg_init_table call.
Date: Wed, 29 Jun 2016 00:24:43 +0530
Message-ID: <1467140083-4910-1-git-send-email-harshjain.prof@gmail.com>
Cc: harshjain32@gmail.com, Harsh Jain <harshjain.prof@gmail.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34487 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbcF1TMn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 15:12:43 -0400
Received: by mail-pa0-f68.google.com with SMTP id us13so2345108pab.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jun 2016 12:12:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove redundant sg_init_table call. scatterwalk_ffwd doing the same.

Signed-off-by: Harsh Jain <harshjain.prof@gmail.com>
---
 crypto/authenc.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 55a354d..c7cc11d 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -206,7 +206,6 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	struct scatterlist *src, *dst;
 	int err;
 
-	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
 	dst = src;
 
@@ -215,7 +214,6 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 		if (err)
 			return err;
 
-		sg_init_table(areq_ctx->dst, 2);
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 	}
 
@@ -251,14 +249,11 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	if (crypto_memneq(ihash, ahreq->result, authsize))
 		return -EBADMSG;
 
-	sg_init_table(areq_ctx->src, 2);
 	src = scatterwalk_ffwd(areq_ctx->src, req->src, req->assoclen);
 	dst = src;
 
-	if (req->src != req->dst) {
-		sg_init_table(areq_ctx->dst, 2);
+	if (req->src != req->dst)
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
-	}
 
 	ablkcipher_request_set_tfm(abreq, ctx->enc);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-- 
1.7.1
