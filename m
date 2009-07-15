From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/35] crypto: authenc - Remove reference to crypto_hash
Date: Wed, 15 Jul 2009 15:16:08 +0800
Message-ID: <E1MQyim-0004zo-MD@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53631 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752630AbZGOHQK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyin-0004rF-9W
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:09 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: authenc - Remove reference to crypto_hash

Now that there are no more legacy hash implementations we can
remove the reference to crypto_hash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5793b64..2e16ce0 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -436,11 +436,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_type = &crypto_aead_type;
 
 	inst->alg.cra_aead.ivsize = enc->cra_ablkcipher.ivsize;
-	inst->alg.cra_aead.maxauthsize = auth->cra_type == &crypto_hash_type ?
-					 auth->cra_hash.digestsize :
-					 auth->cra_type ?
-					 __crypto_shash_alg(auth)->digestsize :
-					 auth->cra_digest.dia_digestsize;
+	inst->alg.cra_aead.maxauthsize = __crypto_shash_alg(auth)->digestsize;
 
 	inst->alg.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
 
