From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 33/35] crypto: ahash - Use GFP_KERNEL in unaligned setkey
Date: Wed, 15 Jul 2009 15:16:28 +0800
Message-ID: <E1MQyj6-00052V-3f@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48340 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752855AbZGOHg1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj6-0004wr-Qc
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:28 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: ahash - Use GFP_KERNEL in unaligned setkey

We currently use GFP_ATOMIC in the unaligned setkey function
to allocate the temporary aligned buffer.  Since setkey must
be called in a sleepable context, we can use GFP_KERNEL instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 1576f95..a196055 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -145,7 +145,7 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 	unsigned long absize;
 
 	absize = keylen + alignmask;
-	buffer = kmalloc(absize, GFP_ATOMIC);
+	buffer = kmalloc(absize, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
