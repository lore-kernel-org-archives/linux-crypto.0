From: Aditya Shevade <aditya.shevade@gmail.com>
Subject: [PATCH 2/2] crypto: blkcipher: Fixed some whitespace style issues
Date: Thu,  7 Apr 2011 00:10:04 -0700
Message-ID: <1302160204-21715-1-git-send-email-aditya.shevade@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Aditya Shevade <aditya.shevade@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61772 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1DGHKL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Apr 2011 03:10:11 -0400
Received: by iwn34 with SMTP id 34so2178041iwn.19
        for <linux-crypto@vger.kernel.org>; Thu, 07 Apr 2011 00:10:10 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed whitespace issues.

Signed-off-by: Aditya Shevade <aditya.shevade@gmail.com>
---
 crypto/blkcipher.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 7a72192..f4a32f9 100644
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
@@ -521,7 +521,7 @@ static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
 	int err;
 
 	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask)| CRYPTO_ALG_GENIV;
+	mask = crypto_skcipher_mask(mask) | CRYPTO_ALG_GENIV;
 
 	alg = crypto_alg_mod_lookup(name, type, mask);
 	if (IS_ERR(alg))
-- 
1.7.4.3
