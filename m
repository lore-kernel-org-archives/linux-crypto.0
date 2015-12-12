From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH] crypto: rsa-padding - don't allocate buffer on stack
Date: Sat, 12 Dec 2015 00:03:51 -0500
Message-ID: <1449896631-20472-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34704 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbbLLFEC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:04:02 -0500
Received: by qkdp187 with SMTP id p187so69260430qkd.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Dec 2015 21:04:01 -0800 (PST)
Received: from localhost.localdomain ([190.234.106.52])
        by smtp.gmail.com with ESMTPSA id b126sm15208402ywd.3.2015.12.11.21.04.00
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 11 Dec 2015 21:04:00 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid the s390 compile "warning: 'pkcs1pad_encrypt_sign_complete'
uses dynamic stack allocation" reported by kbuild test robot.  Don't
use a flat zero-filled buffer, instead zero the contents of the SGL.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 crypto/rsa-pkcs1pad.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index accc67d..50f5c97 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -110,21 +110,32 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
-	uint8_t zeros[ctx->key_size - req_ctx->child_req.dst_len];
+	size_t pad_len = ctx->key_size - req_ctx->child_req.dst_len;
+	size_t chunk_len, pad_left;
+	struct sg_mapping_iter miter;
 
 	if (!err) {
-		if (req_ctx->child_req.dst_len < ctx->key_size) {
-			memset(zeros, 0, sizeof(zeros));
-			sg_copy_from_buffer(req->dst,
-					sg_nents_for_len(req->dst,
-						sizeof(zeros)),
-					zeros, sizeof(zeros));
+		if (pad_len) {
+			sg_miter_start(&miter, req->dst,
+					sg_nents_for_len(req->dst, pad_len),
+					SG_MITER_ATOMIC | SG_MITER_TO_SG);
+
+			pad_left = pad_len;
+			while (pad_left) {
+				sg_miter_next(&miter);
+
+				chunk_len = min(miter.length, pad_left);
+				memset(miter.addr, 0, chunk_len);
+				pad_left -= chunk_len;
+			}
+
+			sg_miter_stop(&miter);
 		}
 
 		sg_pcopy_from_buffer(req->dst,
 				sg_nents_for_len(req->dst, ctx->key_size),
 				req_ctx->out_buf, req_ctx->child_req.dst_len,
-				sizeof(zeros));
+				pad_len);
 	}
 	req->dst_len = ctx->key_size;
 
-- 
2.1.4
