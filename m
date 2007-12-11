From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] [CRYPTO] authenc: Fix typo in ivsize
Date: Tue, 11 Dec 2007 11:50:19 +0800
Message-ID: <E1J1w8R-0002e5-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1766 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbXLKDuX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:23 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8S-0005p3-Kt
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:20 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] authenc: Fix typo in ivsize

The ivsize should be fetched from ablkcipher, not blkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index fbbc2b5..80d9d0b 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -333,7 +333,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_alignmask = auth->cra_alignmask | enc->cra_alignmask;
 	inst->alg.cra_type = &crypto_aead_type;
 
-	inst->alg.cra_aead.ivsize = enc->cra_blkcipher.ivsize;
+	inst->alg.cra_aead.ivsize = enc->cra_ablkcipher.ivsize;
 	inst->alg.cra_aead.maxauthsize = auth->cra_type == &crypto_hash_type ?
 					 auth->cra_hash.digestsize :
 					 auth->cra_digest.dia_digestsize;
