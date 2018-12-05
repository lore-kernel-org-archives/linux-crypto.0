Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbeLEAu1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 19:50:27 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: adiantum - propagate CRYPTO_ALG_ASYNC flag to instance
Date: Tue,  4 Dec 2018 16:46:54 -0800
Message-Id: <20181205004654.242204-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If the stream cipher implementation is asynchronous, then the Adiantum
instance must be flagged as asynchronous as well.  Otherwise someone
asking for a synchronous algorithm can get an asynchronous algorithm.

There are no asynchronous xchacha12 or xchacha20 implementations yet
which makes this largely a theoretical issue, but it should be fixed.

Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 2dfcf12fd4529..ca27e0dc2958c 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -590,6 +590,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_drop_hash;
 
+	inst->alg.base.cra_flags = streamcipher_alg->base.cra_flags &
+				   CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask |
-- 
2.20.0.rc1.387.gf8505762e3-goog
