From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in api.c
Date: Wed, 10 Feb 2010 01:53:55 +0100
Message-ID: <1265763235-22739-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:51537 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJAy2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 19:54:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/api.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 798526d..033a714 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -10,7 +10,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -288,11 +288,11 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		return crypto_init_compress_ops(tfm);
-	
+
 	default:
 		break;
 	}
-	
+
 	BUG();
 	return -EINVAL;
 }
@@ -315,10 +315,9 @@ static void crypto_exit_ops(struct crypto_tfm *tfm)
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		crypto_exit_compress_ops(tfm);
 		break;
-	
+
 	default:
 		BUG();
-		
 	}
 }
 
@@ -593,12 +592,12 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 {
 	int ret = 0;
 	struct crypto_alg *alg = crypto_alg_mod_lookup(name, type, mask);
-	
+
 	if (!IS_ERR(alg)) {
 		crypto_mod_put(alg);
 		ret = 1;
 	}
-	
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
-- 
1.6.6.1

