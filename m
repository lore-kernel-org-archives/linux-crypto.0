From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/10] [CRYPTO] ctr: Set seqiv on rfc3686 only
Date: Wed, 12 Dec 2007 20:30:51 +0800
Message-ID: <E1J2Qjj-0006dB-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3717 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757980AbXLLMa4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:30:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] ctr: Set seqiv on rfc3686 only

Only RFC 3686 requires the seqiv generator.  The generic CTR is better off
using the standard chainiv method.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ctr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index a51f973..2d7425f 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -210,8 +210,6 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
 
-	inst->alg.cra_blkcipher.geniv = "seqiv";
-
 	inst->alg.cra_ctxsize = sizeof(struct crypto_ctr_ctx);
 
 	inst->alg.cra_init = crypto_ctr_init_tfm;
@@ -363,6 +361,8 @@ static struct crypto_instance *crypto_rfc3686_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_blkcipher.max_keysize
 					      + CTR_RFC3686_NONCE_SIZE;
 
+	inst->alg.cra_blkcipher.geniv = "seqiv";
+
 	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc3686_ctx);
 
 	inst->alg.cra_init = crypto_rfc3686_init_tfm;
