From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/28] crypto: ahash - Add padding in crypto_ahash_extsize
Date: Wed, 29 Jun 2016 18:03:47 +0800
Message-ID: <E1bICLT-0006rD-5N@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52006 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbcF2KDu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:03:50 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLT-0005F3-B0
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:47 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function crypto_ahash_extsize did not include padding when
computing the tfm context size.  This patch fixes this by using
the generic crypto_alg_extsize helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3887a98..2ce8bcb 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -461,10 +461,10 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 {
-	if (alg->cra_type == &crypto_ahash_type)
-		return alg->cra_ctxsize;
+	if (alg->cra_type != &crypto_ahash_type)
+		return sizeof(struct crypto_shash *);
 
-	return sizeof(struct crypto_shash *);
+	return crypto_alg_extsize(alg);
 }
 
 #ifdef CONFIG_NET
