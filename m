From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/24] crypto: ccm - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:56 +0800
Message-ID: <E1YrkJY-0001D1-Ok@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57049 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbbEKJsA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJZ-0000II-JM
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 003bbbd..a4d1a5e 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -453,9 +453,9 @@ static int crypto_ccm_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_tfm_alg_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = align +
-				sizeof(struct crypto_ccm_req_priv_ctx) +
-				crypto_ablkcipher_reqsize(ctr);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		align + sizeof(struct crypto_ccm_req_priv_ctx) +
+		crypto_ablkcipher_reqsize(ctr));
 
 	return 0;
 
@@ -729,10 +729,10 @@ static int crypto_rfc4309_init_tfm(struct crypto_tfm *tfm)
 
 	align = crypto_aead_alignmask(aead);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
-				ALIGN(crypto_aead_reqsize(aead),
-				      crypto_tfm_ctx_alignment()) +
-				align + 16;
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+		sizeof(struct aead_request) +
+		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
+		align + 16);
 
 	return 0;
 }
