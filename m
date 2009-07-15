From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/35] crypto: shash - Move null setkey check to registration time
Date: Wed, 15 Jul 2009 15:16:02 +0800
Message-ID: <E1MQyig-0004yw-5Q@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53621 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752605AbZGOHQE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyig-0004pN-QE
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:03 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Move null setkey check to registration time

This patch moves the run-time null setkey check to shash_prepare_alg
just like we did for finup/digest.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index f7fcc65..131e14d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -22,6 +22,12 @@
 
 static const struct crypto_type crypto_shash_type;
 
+static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+			   unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
 {
@@ -50,9 +56,6 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 
-	if (!shash->setkey)
-		return -ENOSYS;
