From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 20/35] crypto: cryptd - Use crypto_ahash_set_reqsize
Date: Wed, 15 Jul 2009 15:16:14 +0800
Message-ID: <E1MQyis-00050X-2F@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53639 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644AbZGOHQP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyis-0004sm-Kl
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:14 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: cryptd - Use crypto_ahash_set_reqsize

This patch makes cryptd use crypto_ahash_set_reqsize to avoid
accessing crypto_ahash directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ef5720c..6e6722e 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -353,8 +353,9 @@ static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
 		return PTR_ERR(hash);
 
 	ctx->child = hash;
-	tfm->crt_ahash.reqsize = sizeof(struct cryptd_hash_request_ctx) +
-				 crypto_shash_descsize(hash);
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct cryptd_hash_request_ctx) +
+				 crypto_shash_descsize(hash));
 	return 0;
 }
 
