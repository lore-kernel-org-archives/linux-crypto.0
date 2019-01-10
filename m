Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfAJUSW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:22 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 01/11] crypto: gcm - use correct endianness type in gcm_hash_len()
Date: Thu, 10 Jan 2019 12:17:52 -0800
Message-Id: <20190110201802.82442-2-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In gcm_hash_len(), use be128 rather than u128.  This fixes the following
sparse warnings:

    crypto/gcm.c:252:19: warning: incorrect type in assignment (different base types)
    crypto/gcm.c:252:19:    expected unsigned long long [usertype] a
    crypto/gcm.c:252:19:    got restricted __be64 [usertype]
    crypto/gcm.c:253:19: warning: incorrect type in assignment (different base types)
    crypto/gcm.c:253:19:    expected unsigned long long [usertype] b
    crypto/gcm.c:253:19:    got restricted __be64 [usertype]

No actual change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index e438492db2ca2..bbce31f6199ba 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -247,7 +247,7 @@ static int gcm_hash_len(struct aead_request *req, u32 flags)
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ahash_request *ahreq = &pctx->u.ahreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	u128 lengths;
+	be128 lengths;
 
 	lengths.a = cpu_to_be64(req->assoclen * 8);
 	lengths.b = cpu_to_be64(gctx->cryptlen * 8);
-- 
2.20.1.97.g81188d93c3-goog
