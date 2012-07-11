From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/14] crypto: whirlpool - use crypto_[un]register_shashes
Date: Wed, 11 Jul 2012 14:20:41 +0300
Message-ID: <20120711112041.6875.84893.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37338 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2GKLUr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:47 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all shash algs to be registered and use new crypto_[un]register_shashes
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/wp512.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/crypto/wp512.c b/crypto/wp512.c
index 71719a2..180f1d6 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1119,7 +1119,7 @@ static int wp256_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg wp512 = {
+static struct shash_alg wp_algs[3] = { {
 	.digestsize	=	WP512_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
@@ -1131,9 +1131,7 @@ static struct shash_alg wp512 = {
 		.cra_blocksize	=	WP512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg wp384 = {
+}, {
 	.digestsize	=	WP384_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
@@ -1145,9 +1143,7 @@ static struct shash_alg wp384 = {
 		.cra_blocksize	=	WP512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg wp256 = {
+}, {
 	.digestsize	=	WP256_DIGEST_SIZE,
 	.init		=	wp512_init,
 	.update		=	wp512_update,
@@ -1159,39 +1155,16 @@ static struct shash_alg wp256 = {
 		.cra_blocksize	=	WP512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+} };
 
 static int __init wp512_mod_init(void)
 {
-	int ret = 0;
-
-	ret = crypto_register_shash(&wp512);
-
-	if (ret < 0)
-		goto out;
-
-	ret = crypto_register_shash(&wp384);
-	if (ret < 0)
-	{
-		crypto_unregister_shash(&wp512);
-		goto out;
-	}
-
-	ret = crypto_register_shash(&wp256);
-	if (ret < 0)
-	{
-		crypto_unregister_shash(&wp512);
-		crypto_unregister_shash(&wp384);
-	}
-out:
-	return ret;
+	return crypto_register_shashes(wp_algs, ARRAY_SIZE(wp_algs));
 }
 
 static void __exit wp512_mod_fini(void)
 {
-	crypto_unregister_shash(&wp512);
-	crypto_unregister_shash(&wp384);
-	crypto_unregister_shash(&wp256);
+	crypto_unregister_shashes(wp_algs, ARRAY_SIZE(wp_algs));
 }
 
 MODULE_ALIAS("wp384");
