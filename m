From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/19] [CRYPTO] cryptd: Use geniv of the underlying algorithm
Date: Tue, 11 Dec 2007 12:02:55 +0800
Message-ID: <E1J1wKd-0002jd-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1909 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbXLKEC5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:02:57 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wKd-00062E-Sf
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:02:56 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] cryptd: Use geniv of the underlying algorithm

If the underlying algorithm specifies a specific geniv algorithm then
we should use it for the cryptd version as well.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |    2 ++
 1 files changed, 2 insertions(+)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1a5c45b..074298f 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -243,6 +243,8 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
 	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
 
+	inst->alg.cra_ablkcipher.geniv = alg->cra_blkcipher.geniv;
+
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_blkcipher_ctx);
 
 	inst->alg.cra_init = cryptd_blkcipher_init_tfm;
