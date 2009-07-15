From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 25/35] crypto: tcrypt - Add mask parameter
Date: Wed, 15 Jul 2009 15:16:19 +0800
Message-ID: <E1MQyix-00051L-FH@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53651 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbZGOHQ1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiy-0004u7-Gs
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:21 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: tcrypt - Add mask parameter

This patch adds a mask parameter to complement the existing type
parameter.  This is useful when instantiating algorithms that
require a mask other than the default, e.g., ahash algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a890a67..5a375e8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -47,6 +47,7 @@ static unsigned int sec;
 
 static char *alg = NULL;
 static u32 type;
+static u32 mask;
 static int mode;
 static char *tvmem[TVMEMSIZE];
 
@@ -887,9 +888,10 @@ static int do_test(int m)
 	return ret;
 }
 
-static int do_alg_test(const char *alg, u32 type)
+static int do_alg_test(const char *alg, u32 type, u32 mask)
 {
-	return crypto_has_alg(alg, type, CRYPTO_ALG_TYPE_MASK) ? 0 : -ENOENT;
+	return crypto_has_alg(alg, type, mask ?: CRYPTO_ALG_TYPE_MASK) ?
+	       0 : -ENOENT;
 }
 
 static int __init tcrypt_mod_init(void)
@@ -904,7 +906,7 @@ static int __init tcrypt_mod_init(void)
 	}
 
 	if (alg)
-		err = do_alg_test(alg, type);
+		err = do_alg_test(alg, type, mask);
 	else
 		err = do_test(mode);
 
@@ -941,6 +943,7 @@ module_exit(tcrypt_mod_fini);
 
 module_param(alg, charp, 0);
 module_param(type, uint, 0);
+module_param(mask, uint, 0);
 module_param(mode, int, 0);
 module_param(sec, uint, 0);
 MODULE_PARM_DESC(sec, "Length in seconds of speed tests "
