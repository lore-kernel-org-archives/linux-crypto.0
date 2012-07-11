From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 09/14] crypto: sha512 - use crypto_[un]register_shashes
Date: Wed, 11 Jul 2012 14:20:36 +0300
Message-ID: <20120711112035.6875.29251.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34118 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2GKLUi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:38 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all shash algs to be registered and use new crypto_[un]register_shashes
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/sha512_generic.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index dd30f40..71fcf36 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -242,7 +242,7 @@ static int sha384_final(struct shash_desc *desc, u8 *hash)
 	return 0;
 }
 
-static struct shash_alg sha512 = {
+static struct shash_alg sha512_algs[2] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_init,
 	.update		=	sha512_update,
@@ -254,9 +254,7 @@ static struct shash_alg sha512 = {
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
-
-static struct shash_alg sha384 = {
+}, {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_init,
 	.update		=	sha512_update,
@@ -268,24 +266,16 @@ static struct shash_alg sha384 = {
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-};
+} };
 
 static int __init sha512_generic_mod_init(void)
 {
-        int ret = 0;
-
-        if ((ret = crypto_register_shash(&sha384)) < 0)
-                goto out;
-        if ((ret = crypto_register_shash(&sha512)) < 0)
-                crypto_unregister_shash(&sha384);
-out:
-        return ret;
+	return crypto_register_shashes(sha512_algs, ARRAY_SIZE(sha512_algs));
 }
 
 static void __exit sha512_generic_mod_fini(void)
 {
-        crypto_unregister_shash(&sha384);
-        crypto_unregister_shash(&sha512);
+	crypto_unregister_shashes(sha512_algs, ARRAY_SIZE(sha512_algs));
 }
 
 module_init(sha512_generic_mod_init);
