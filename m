From: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
Subject: [PATCH v2] crypto: drbg: use memzero_explicit() for clearing
 sensitive data
Date: Wed, 26 Nov 2014 13:40:57 -0500
Message-ID: <20141126184057.GA8235@nick-ThinkPad-T430s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58395 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZSlA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Nov 2014 13:41:00 -0500
Received: by mail-qa0-f42.google.com with SMTP id j7so2347195qaq.29
        for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2014 10:40:59 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Compiler dead store optimization can sometimes remove final calls
to memset() used to clear sensitive data at the end of a function.
Replace trailing memset() calls with memzero_explicit() to
preclude unwanted removal.

Signed-off-by: Nickolaus Woodruff <nickolauswoodruff@gmail.com>
---
Changes in v2:
    - Move the linux/string.h inclusion to drbg.c

 crypto/drbg.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 54cfd48..5d89023 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -98,6 +98,7 @@
  */
 
 #include <crypto/drbg.h>
+#include <linux/string.h>
 
 /***************************************************************
  * Backend cipher definitions available to DRBG
@@ -522,9 +523,9 @@ static int drbg_ctr_df(struct drbg_state *drbg,
 	ret = 0;
 
 out:
-	memset(iv, 0, drbg_blocklen(drbg));
-	memset(temp, 0, drbg_statelen(drbg));
-	memset(pad, 0, drbg_blocklen(drbg));
+	memzero_explicit(iv, drbg_blocklen(drbg));
+	memzero_explicit(temp, drbg_statelen(drbg));
+	memzero_explicit(pad, drbg_blocklen(drbg));
 	return ret;
 }
 
@@ -599,9 +600,9 @@ static int drbg_ctr_update(struct drbg_state *drbg, struct list_head *seed,
 	ret = 0;
 
 out:
-	memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
+	memzero_explicit(temp, drbg_statelen(drbg) + drbg_blocklen(drbg));
 	if (2 != reseed)
-		memset(df_data, 0, drbg_statelen(drbg));
+		memzero_explicit(df_data, drbg_statelen(drbg));
 	return ret;
 }
 
@@ -660,7 +661,7 @@ static int drbg_ctr_generate(struct drbg_state *drbg,
 		len = ret;
 
 out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
+	memzero_explicit(drbg->scratchpad, drbg_blocklen(drbg));
 	return len;
 }
 
@@ -848,7 +849,7 @@ static int drbg_hash_df(struct drbg_state *drbg,
 	}
 
 out:
-	memset(tmp, 0, drbg_blocklen(drbg));
+	memzero_explicit(tmp, drbg_blocklen(drbg));
 	return ret;
 }
 
@@ -892,7 +893,7 @@ static int drbg_hash_update(struct drbg_state *drbg, struct list_head *seed,
 	ret = drbg_hash_df(drbg, drbg->C, drbg_statelen(drbg), &datalist2);
 
 out:
-	memset(drbg->scratchpad, 0, drbg_statelen(drbg));
+	memzero_explicit(drbg->scratchpad, drbg_statelen(drbg));
 	return ret;
 }
 
@@ -927,7 +928,7 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
 		     drbg->scratchpad, drbg_blocklen(drbg));
 
 out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
+	memzero_explicit(drbg->scratchpad, drbg_blocklen(drbg));
 	return ret;
 }
 
@@ -975,7 +976,7 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
 	}
 
 out:
-	memset(drbg->scratchpad, 0,
+	memzero_explicit(drbg->scratchpad,
 	       (drbg_statelen(drbg) + drbg_blocklen(drbg)));
 	return len;
 }
@@ -1024,7 +1025,7 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 	drbg_add_buf(drbg->V, drbg_statelen(drbg), u.req, 8);
 
 out:
-	memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
+	memzero_explicit(drbg->scratchpad, drbg_blocklen(drbg));
 	return len;
 }
 
-- 
1.9.1
