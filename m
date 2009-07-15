From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/35] crypto: shash - Move finup/digest null checks to registration time
Date: Wed, 15 Jul 2009 15:15:54 +0800
Message-ID: <E1MQyiY-0004xv-Iw@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53610 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752546AbZGOHPz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:15:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiY-0004o2-Rd
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Move finup/digest null checks to registration time

This patch moves the run-time null finup/digest checks to the
shash_prepare_alg function which is run at registration time.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 14a3b70..f7fcc65 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -142,8 +142,7 @@ int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 
-	if (((unsigned long)data | (unsigned long)out) & alignmask ||
-	    !shash->finup)
+	if (((unsigned long)data | (unsigned long)out) & alignmask)
 		return shash_finup_unaligned(desc, data, len, out);
 
 	return shash->finup(desc, data, len, out);
@@ -164,8 +163,7 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 
-	if (((unsigned long)data | (unsigned long)out) & alignmask ||
-	    !shash->digest)
+	if (((unsigned long)data | (unsigned long)out) & alignmask)
 		return shash_digest_unaligned(desc, data, len, out);
 
 	return shash->digest(desc, data, len, out);
@@ -488,6 +486,10 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
 
+	if (!alg->finup)
+		alg->finup = shash_finup_unaligned;
+	if (!alg->digest)
+		alg->digest = shash_digest_unaligned;
 	if (!alg->import)
 		alg->import = shash_no_import;
 	if (!alg->export)
