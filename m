From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] [CRYPTO] authenc: Use or instead of max on alignment masks
Date: Sun, 02 Dec 2007 18:53:07 +1100
Message-ID: <E1IyjdT-0001Wr-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2733 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbXLBHxL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Dec 2007 02:53:11 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IyjdU-00089K-VW
	for <linux-crypto@vger.kernel.org>; Sun, 02 Dec 2007 18:53:09 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Use or instead of max on alignment masks

Since alignment masks are always one less than a power of two, we can
use binary or to find their maximum.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -333,7 +333,7 @@ static struct crypto_instance *crypto_au
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_priority = enc->cra_priority * 10 + auth->cra_priority;
 	inst->alg.cra_blocksize = enc->cra_blocksize;
-	inst->alg.cra_alignmask = max(auth->cra_alignmask, enc->cra_alignmask);
+	inst->alg.cra_alignmask = auth->cra_alignmask | enc->cra_alignmask;
 	inst->alg.cra_type = &crypto_aead_type;
 
 	inst->alg.cra_aead.ivsize = enc->cra_blkcipher.ivsize;
