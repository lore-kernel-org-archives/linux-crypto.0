From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 03/14] crypto: des - use crypto_[un]register_algs
Date: Wed, 11 Jul 2012 14:20:05 +0300
Message-ID: <20120711112005.6875.6929.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:33955 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2GKLUI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:08 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/des_generic.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 873818d..f6cf63f 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -943,59 +943,44 @@ static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = cpu_to_le32(L);
 }
 
-static struct crypto_alg des_alg = {
+static struct crypto_alg des_algs[2] = { {
 	.cra_name		=	"des",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct des_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_alignmask		=	3,
-	.cra_list		=	LIST_HEAD_INIT(des_alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	DES_KEY_SIZE,
 	.cia_max_keysize	=	DES_KEY_SIZE,
 	.cia_setkey		=	des_setkey,
 	.cia_encrypt		=	des_encrypt,
 	.cia_decrypt		=	des_decrypt } }
-};
-
-static struct crypto_alg des3_ede_alg = {
+}, {
 	.cra_name		=	"des3_ede",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct des3_ede_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_alignmask		=	3,
-	.cra_list		=	LIST_HEAD_INIT(des3_ede_alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	DES3_EDE_KEY_SIZE,
 	.cia_max_keysize	=	DES3_EDE_KEY_SIZE,
 	.cia_setkey		=	des3_ede_setkey,
 	.cia_encrypt		=	des3_ede_encrypt,
 	.cia_decrypt		=	des3_ede_decrypt } }
-};
+} };
 
 MODULE_ALIAS("des3_ede");
 
 static int __init des_generic_mod_init(void)
 {
-	int ret = 0;
-
-	ret = crypto_register_alg(&des_alg);
-	if (ret < 0)
-		goto out;
-
-	ret = crypto_register_alg(&des3_ede_alg);
-	if (ret < 0)
-		crypto_unregister_alg(&des_alg);
-out:
-	return ret;
+	return crypto_register_algs(des_algs, ARRAY_SIZE(des_algs));
 }
 
 static void __exit des_generic_mod_fini(void)
 {
-	crypto_unregister_alg(&des3_ede_alg);
-	crypto_unregister_alg(&des_alg);
+	crypto_unregister_algs(des_algs, ARRAY_SIZE(des_algs));
 }
 
 module_init(des_generic_mod_init);
