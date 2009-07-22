From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: shash - Test for the algorithms import function
	before exporting it
Date: Wed, 22 Jul 2009 14:53:02 +0200
Message-ID: <20090722125302.GM20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43964 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZGVMua (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 08:50:30 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_init_shash_ops_async() tests for setkey and not for import
before exporting the algorithms import function to ahash.
This patch fixes this.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/shash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 7713b52..d923c88 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -348,7 +348,7 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 		crt->setkey = shash_async_setkey;
 	if (alg->export)
 		crt->export = shash_async_export;
-	if (alg->setkey)
+	if (alg->import)
 		crt->import = shash_async_import;
 
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
-- 
1.5.4.2

