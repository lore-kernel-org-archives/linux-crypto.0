From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/24] crypto: seqiv - Use crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:48:03 +0800
Message-ID: <E1YrkJf-0001ED-4C@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34331 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbbEKJsH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJf-0000KT-V9
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch uses the crypto_aead_set_reqsize helper to avoid directly
touching the internals of aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b7bb9a2..5bbf2e9 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -251,7 +251,8 @@ static int seqiv_aead_init(struct crypto_tfm *tfm)
 
 	spin_lock_init(&ctx->lock);
 
-	tfm->crt_aead.reqsize = sizeof(struct aead_request);
+	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
+				sizeof(struct aead_request));
 
 	return aead_geniv_init(tfm);
 }
