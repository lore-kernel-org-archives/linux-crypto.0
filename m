From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: tcrypt - add a missing tab
Date: Wed, 29 Jun 2016 17:41:30 +0300
Message-ID: <20160629144130.GC22818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbcF2OmW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 10:42:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The "goto out;" line isn't indented far enough.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6ef7815..117f19e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -629,7 +629,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 			printk(KERN_ERR
 				"template (%u) too big for tvmem (%lu)\n",
 					speed[i].blen, TVMEMSIZE * PAGE_SIZE);
-		goto out;
+			goto out;
 		}
 
 		if (speed[i].klen)
