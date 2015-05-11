From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/24] crypto: cryptd - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:58 +0800
Message-ID: <E1YrkJa-0001DL-97@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46465 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbbEKJsC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJa-0000Ip-R3
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index b0602ba..e1584fb 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -729,7 +729,8 @@ static int cryptd_aead_init_tfm(struct crypto_tfm *tfm)
 
 	crypto_aead_set_flags(cipher, CRYPTO_TFM_REQ_MAY_SLEEP);
 	ctx->child = cipher;
-	tfm->crt_aead.reqsize = sizeof(struct cryptd_aead_request_ctx);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+				sizeof(struct cryptd_aead_request_ctx));
 	return 0;
 }
 
