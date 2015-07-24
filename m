From: Ahmed Mohamed Abd EL Mawgood <ahmedsoliman0x666@gmail.com>
Subject: [PATCH] code cleanups for crypto/blkcipher.c
Date: Fri, 24 Jul 2015 16:04:32 +0200
Message-ID: <1437746672.19489.2.camel@My-Computer>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34699 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbGXOEh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 10:04:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


fixing all errors and most warning of checkpatch.pl for
crypto/blkcipher.c

Signed-off-by: Ahmed Mohamed <ahmedsoliman0x666@gmail.com>
---
 crypto/blkcipher.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 11b9814..4530ff9 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -1,6 +1,6 @@
 /*
  * Block chaining cipher operations.
- * 
+ *
  * Generic encrypt/decrypt wrapper for ciphers, handles operations across
  * multiple page boundaries by using temporary blocks.  In user context,
  * the kernel is given a chance to schedule us once per page.
@@ -9,7 +9,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -68,6 +68,7 @@ static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 static inline u8 *blkcipher_get_spot(u8 *start, unsigned int len)
 {
 	u8 *end_page = (u8 *)(((unsigned long)(start + len - 1)) & PAGE_MASK);
+
 	return max(start, end_page);
 }
 
@@ -334,6 +335,7 @@ static int blkcipher_walk_first(struct blkcipher_desc *desc,
 	walk->iv = desc->info;
 	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
 		int err = blkcipher_copy_iv(walk);
+
 		if (err)
 			return err;
 	}
@@ -541,7 +543,7 @@ static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
-	seq_printf(m, "type         : blkcipher\n");
+	seq_puts(m, "type         : blkcipher");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "min keysize  : %u\n", alg->cra_blkcipher.min_keysize);
 	seq_printf(m, "max keysize  : %u\n", alg->cra_blkcipher.max_keysize);
@@ -567,7 +569,7 @@ static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
 	int err;
 
 	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask)| CRYPTO_ALG_GENIV;
+	mask = crypto_skcipher_mask(mask) | CRYPTO_ALG_GENIV;
 
 	alg = crypto_alg_mod_lookup(name, type, mask);
 	if (IS_ERR(alg))
-- 
1.9.1
