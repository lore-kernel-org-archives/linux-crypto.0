From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 08/14] crypto: sha256 - use crypto_[un]register_shashes
Date: Wed, 11 Jul 2012 14:20:30 +0300
Message-ID: <20120711112030.6875.63103.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40792 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2GKLUf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:35 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all shash algs to be registered and use new crypto_[un]register_shashes
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/sha256_generic.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index c48459e..c3ed4ec 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -336,7 +336,7 @@ static int sha256_import(struct shash_desc *desc, const void *in)
 	return 0;
 }
 
-static struct shash_alg sha256 = {
+static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_init,
 	.update		=	sha256_update,
@@ -352,9 +352,7 @@ static struct shash_alg sha256 = {
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg sha224 = {
+}, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
 	.init		=	sha224_init,
 	.update		=	sha256_update,
@@ -367,29 +365,16 @@ static struct shash_alg sha224 = {
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+} };
 
 static int __init sha256_generic_mod_init(void)
 {
-	int ret = 0;
-
-	ret = crypto_register_shash(&sha224);
-
-	if (ret < 0)
-		return ret;
-
-	ret = crypto_register_shash(&sha256);
-
-	if (ret < 0)
-		crypto_unregister_shash(&sha224);
-
-	return ret;
+	return crypto_register_shashes(sha256_algs, ARRAY_SIZE(sha256_algs));
 }
 
 static void __exit sha256_generic_mod_fini(void)
 {
-	crypto_unregister_shash(&sha224);
-	crypto_unregister_shash(&sha256);
+	crypto_unregister_shashes(sha256_algs, ARRAY_SIZE(sha256_algs));
 }
 
 module_init(sha256_generic_mod_init);
