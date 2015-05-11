From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 20/24] crypto: ixp4xx - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:06 +0800
Message-ID: <E1YrkJi-0001FD-DB@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38078 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbEKJsL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:11 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJj-0000LV-H1
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:07 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index a8875b4..46cd696 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -575,7 +575,8 @@ static int init_tfm_ablk(struct crypto_tfm *tfm)
 
 static int init_tfm_aead(struct crypto_tfm *tfm)
 {
-	tfm->crt_aead.reqsize = sizeof(struct aead_ctx);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+				sizeof(struct aead_ctx));
 	return init_tfm(tfm);
 }
 
