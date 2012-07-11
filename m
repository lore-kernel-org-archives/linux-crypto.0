From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 07/14] crypto: tiger - use crypto_[un]register_shashes
Date: Wed, 11 Jul 2012 14:20:25 +0300
Message-ID: <20120711112025.6875.23184.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34071 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2GKLU2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:28 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all shash algs to be registered and use new crypto_[un]register_shashes
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tgr192.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index cbca4f20..8740355 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -628,7 +628,7 @@ static int tgr128_final(struct shash_desc *desc, u8 * out)
 	return 0;
 }
 
-static struct shash_alg tgr192 = {
+static struct shash_alg tgr_algs[3] = { {
 	.digestsize	=	TGR192_DIGEST_SIZE,
 	.init		=	tgr192_init,
 	.update		=	tgr192_update,
@@ -640,9 +640,7 @@ static struct shash_alg tgr192 = {
 		.cra_blocksize	=	TGR192_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg tgr160 = {
+}, {
 	.digestsize	=	TGR160_DIGEST_SIZE,
 	.init		=	tgr192_init,
 	.update		=	tgr192_update,
@@ -654,9 +652,7 @@ static struct shash_alg tgr160 = {
 		.cra_blocksize	=	TGR192_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg tgr128 = {
+}, {
 	.digestsize	=	TGR128_DIGEST_SIZE,
 	.init		=	tgr192_init,
 	.update		=	tgr192_update,
@@ -668,38 +664,16 @@ static struct shash_alg tgr128 = {
 		.cra_blocksize	=	TGR192_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+} };
 
 static int __init tgr192_mod_init(void)
 {
-	int ret = 0;
-
-	ret = crypto_register_shash(&tgr192);
-
-	if (ret < 0) {
-		goto out;
-	}
-
-	ret = crypto_register_shash(&tgr160);
-	if (ret < 0) {
-		crypto_unregister_shash(&tgr192);
-		goto out;
-	}
-
-	ret = crypto_register_shash(&tgr128);
-	if (ret < 0) {
-		crypto_unregister_shash(&tgr192);
-		crypto_unregister_shash(&tgr160);
-	}
-      out:
-	return ret;
+	return crypto_register_shashes(tgr_algs, ARRAY_SIZE(tgr_algs));
 }
 
 static void __exit tgr192_mod_fini(void)
 {
-	crypto_unregister_shash(&tgr192);
-	crypto_unregister_shash(&tgr160);
-	crypto_unregister_shash(&tgr128);
+	crypto_unregister_shashes(tgr_algs, ARRAY_SIZE(tgr_algs));
 }
 
 MODULE_ALIAS("tgr160");
