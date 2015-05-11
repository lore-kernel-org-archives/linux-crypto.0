From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 21/24] crypto: picoxcell - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:08 +0800
Message-ID: <E1YrkJk-0001Fj-07@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33673 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbbEKJsM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJk-0000Ls-U2
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:09 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 135817f..eb2a0ca 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -790,7 +790,8 @@ static int spacc_aead_cra_init(struct crypto_tfm *tfm)
 
 	get_random_bytes(ctx->salt, sizeof(ctx->salt));
 
-	tfm->crt_aead.reqsize = sizeof(struct spacc_req);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+				sizeof(struct spacc_req));
 
 	return 0;
 }
