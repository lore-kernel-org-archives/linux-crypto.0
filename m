From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: rsa-pkcs1pad: indent a couple statements
Date: Tue, 8 Mar 2016 15:07:36 +0300
Message-ID: <20160308120736.GC28684@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32264 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbcCHMH6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Mar 2016 07:07:58 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These if statements aren't indented far enough and it makes static
checkers complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Hopefully GCC6 will start complaining about these as well?

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 1cea67d..1eb5cbe 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -705,7 +705,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
 			     rsa_alg->base.cra_driver_name) >=
 					CRYPTO_MAX_ALG_NAME)
-		goto out_drop_alg;
+			goto out_drop_alg;
 	} else {
 		if (snprintf(inst->alg.base.cra_name,
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
@@ -715,7 +715,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
 			     rsa_alg->base.cra_driver_name, hash_name) >=
 					CRYPTO_MAX_ALG_NAME)
-		goto out_free_hash;
+			goto out_free_hash;
 	}
 
 	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
