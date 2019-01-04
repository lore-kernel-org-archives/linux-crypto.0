Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfADEU5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/16] crypto: pcbc - remove ability to wrap internal ciphers
Date: Thu,  3 Jan 2019 20:16:21 -0800
Message-Id: <20190104041625.3259-13-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Following commit 944585a64f5e ("crypto: x86/aes-ni - remove special
handling of AES in PCBC mode"), it's no longer needed for the PCBC
template to support wrapping a cipher that has the CRYPTO_ALG_INTERNAL
flag set.  Thus, remove this now-unused functionality to make PCBC
consistent with the other single block cipher templates.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/pcbc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 1b182dfedc948..4f97a9d069b62 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -219,18 +219,15 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	if (((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask) &
-	    ~CRYPTO_ALG_INTERNAL)
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER |
-				      (algt->type & CRYPTO_ALG_INTERNAL),
-				  CRYPTO_ALG_TYPE_MASK |
-				  (algt->mask & CRYPTO_ALG_INTERNAL));
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
 	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
 		goto err_free_inst;
@@ -245,7 +242,6 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
-	inst->alg.base.cra_flags = alg->cra_flags & CRYPTO_ALG_INTERNAL;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->cra_alignmask;
-- 
2.20.1
