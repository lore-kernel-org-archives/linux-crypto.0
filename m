From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/10] [CRYPTO] aead: Allow algorithms with no givcrypt support
Date: Wed, 12 Dec 2007 20:30:54 +0800
Message-ID: <E1J2Qjm-0006dW-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3731 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758198AbXLLMbB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:31:01 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Allow algorithms with no givcrypt support

Some algorithms always require manual IV construction.  For instance,
the generic CCM algorithm requires the first byte of the IV to be manually
constructed.  Such algorithms are always used by other algorithms equipped
with their own IV generators and do not need IV generation by per se.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 0402b60..15335ed 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -77,7 +77,7 @@ static unsigned int crypto_aead_ctxsize(struct crypto_alg *alg, u32 type,
 	return alg->cra_ctxsize;
 }
 
-static int no_givdecrypt(struct aead_givcrypt_request *req)
+static int no_givcrypt(struct aead_givcrypt_request *req)
 {
 	return -ENOSYS;
 }
@@ -93,8 +93,8 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
-	crt->givencrypt = alg->givencrypt;
-	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
+	crt->givencrypt = alg->givencrypt ?: no_givcrypt;
+	crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->maxauthsize;
 
