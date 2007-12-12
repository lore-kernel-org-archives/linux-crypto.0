From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/10] [CRYPTO] skcipher: Return EINVAL on zero IV when making givcipher
Date: Wed, 12 Dec 2007 20:30:53 +0800
Message-ID: <E1J2Qjl-0006dP-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3725 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757572AbXLLMa6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:30:58 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Return EINVAL on zero IV when making givcipher

Returning EAGAIN on a zero IV when making givcipher will lead to an
infinite loop since the upper layer will simply retry the operation.

During normal operation IV sizes shouldn't change given the same
algorithm so it's safe to return EINVAL.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/blkcipher.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 10c2229..6f84481 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -604,7 +604,7 @@ struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
 		balg.geniv = alg->cra_ablkcipher.geniv;
 	}
 
-	err = -EAGAIN;
+	err = -EINVAL;
 	if (!balg.ivsize)
 		goto err_drop_alg;
 
@@ -616,6 +616,7 @@ struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
 	if (algt->mask & CRYPTO_ALG_GENIV) {
 		if (!balg.geniv)
 			balg.geniv = crypto_default_geniv(alg);
+		err = -EAGAIN;
 		if (strcmp(tmpl->name, balg.geniv))
 			goto err_drop_alg;
 
