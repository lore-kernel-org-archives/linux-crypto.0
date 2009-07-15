From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 32/35] crypto: shash - Fix alignment in unaligned operations
Date: Wed, 15 Jul 2009 15:16:27 +0800
Message-ID: <E1MQyj5-00052M-0x@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48347 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbZGOHgf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:35 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj6-0004wS-4s
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:28 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Fix alignment in unaligned operations

When we encounter an unaligned pointer we are supposed to copy
it to a temporary aligned location.  However the temporary buffer
isn't aligned properly.  This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index e543283..171c8f0 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -76,8 +76,9 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	unsigned int unaligned_len = alignmask + 1 -
 				     ((unsigned long)data & alignmask);
-	u8 buf[shash_align_buffer_size(unaligned_len, alignmask)]
+	u8 ubuf[shash_align_buffer_size(unaligned_len, alignmask)]
 		__attribute__ ((aligned));
+	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
 	if (unaligned_len > len)
@@ -111,8 +112,9 @@ static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned int ds = crypto_shash_digestsize(tfm);
-	u8 buf[shash_align_buffer_size(ds, alignmask)]
+	u8 ubuf[shash_align_buffer_size(ds, alignmask)]
 		__attribute__ ((aligned));
+	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
 	int err;
 
 	err = shash->final(desc, buf);
