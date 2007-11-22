From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/11] [CRYPTO] cryptd: Use geniv of the underlying algorithm
Date: Thu, 22 Nov 2007 16:48:40 +0800
Message-ID: <E1Iv7jk-000204-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4668 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751353AbXKVIst (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:49 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7jl-0008Bu-N7
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:42 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] cryptd: Use geniv of the underlying algorithm

If the underlying algorithm specifies a specific geniv algorithm then
we should use it for the cryptd version as well.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |    3 +++
 1 files changed, 3 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1a5c45b..f03e912 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -243,6 +243,9 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
 	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
 
+	memcpy(inst->alg.cra_ablkcipher.geniv, alg->cra_blkcipher.geniv,
+	       CRYPTO_MAX_ALG_NAME);
+
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_blkcipher_ctx);
 
 	inst->alg.cra_init = cryptd_blkcipher_init_tfm;
