From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 01/14] crypto: tea - use crypto_[un]register_algs
Date: Wed, 11 Jul 2012 14:19:55 +0300
Message-ID: <20120711111955.6875.58704.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:33874 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2GKLT6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:19:58 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Combine all crypto_alg to be registered and use new crypto_[un]register_algs
functions. This simplifies init/exit code.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tea.c |   41 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/crypto/tea.c b/crypto/tea.c
index 412bc74..0a57232 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -219,84 +219,55 @@ static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	out[1] = cpu_to_le32(z);
 }
 
-static struct crypto_alg tea_alg = {
+static struct crypto_alg tea_algs[3] = { {
 	.cra_name		=	"tea",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct tea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(tea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	TEA_KEY_SIZE,
 	.cia_max_keysize	=	TEA_KEY_SIZE,
 	.cia_setkey		= 	tea_setkey,
 	.cia_encrypt		=	tea_encrypt,
 	.cia_decrypt		=	tea_decrypt } }
-};
-
-static struct crypto_alg xtea_alg = {
+}, {
 	.cra_name		=	"xtea",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(xtea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	XTEA_KEY_SIZE,
 	.cia_max_keysize	=	XTEA_KEY_SIZE,
 	.cia_setkey		= 	xtea_setkey,
 	.cia_encrypt		=	xtea_encrypt,
 	.cia_decrypt		=	xtea_decrypt } }
-};
-
-static struct crypto_alg xeta_alg = {
+}, {
 	.cra_name		=	"xeta",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
 	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(xtea_alg.cra_list),
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	XTEA_KEY_SIZE,
 	.cia_max_keysize	=	XTEA_KEY_SIZE,
 	.cia_setkey		= 	xtea_setkey,
 	.cia_encrypt		=	xeta_encrypt,
 	.cia_decrypt		=	xeta_decrypt } }
-};
+} };
 
 static int __init tea_mod_init(void)
 {
-	int ret = 0;
-	
-	ret = crypto_register_alg(&tea_alg);
-	if (ret < 0)
-		goto out;
-
-	ret = crypto_register_alg(&xtea_alg);
-	if (ret < 0) {
-		crypto_unregister_alg(&tea_alg);
-		goto out;
-	}
-
-	ret = crypto_register_alg(&xeta_alg);
-	if (ret < 0) {
-		crypto_unregister_alg(&tea_alg);
-		crypto_unregister_alg(&xtea_alg);
-		goto out;
-	}
-
-out:	
-	return ret;
+	return crypto_register_algs(tea_algs, ARRAY_SIZE(tea_algs));
 }
 
 static void __exit tea_mod_fini(void)
 {
-	crypto_unregister_alg(&tea_alg);
-	crypto_unregister_alg(&xtea_alg);
-	crypto_unregister_alg(&xeta_alg);
+	crypto_unregister_algs(tea_algs, ARRAY_SIZE(tea_algs));
 }
 
 MODULE_ALIAS("xtea");
