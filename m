From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/6] crypto: serpent-sse2 - combine ablk_*_init functions
Date: Fri, 17 Feb 2012 22:48:53 +0200
Message-ID: <20120217204853.3744.10263.stgit@localhost6.localdomain6>
References: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34778 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2BQUs4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Feb 2012 15:48:56 -0500
In-Reply-To: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver name in ablk_*_init functions can be constructed runtime. Therefore
use single function ablk_init to reduce object size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |   71 ++++++-----------------------------
 1 files changed, 13 insertions(+), 58 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 5520c75..4b21be8 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -676,68 +676,23 @@ static void ablk_exit(struct crypto_tfm *tfm)
 	cryptd_free_ablkcipher(ctx->cryptd_tfm);
 }
 
-static void ablk_init_common(struct crypto_tfm *tfm,
-			     struct cryptd_ablkcipher *cryptd_tfm)
+static int ablk_init(struct crypto_tfm *tfm)
 {
 	struct async_serpent_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->cryptd_tfm = cryptd_tfm;
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
-		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
-}
-
-static int ablk_ecb_init(struct crypto_tfm *tfm)
-{
 	struct cryptd_ablkcipher *cryptd_tfm;
+	char drv_name[CRYPTO_MAX_ALG_NAME];
 
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ecb-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static int ablk_cbc_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
+	snprintf(drv_name, sizeof(drv_name), "__driver-%s",
+					crypto_tfm_alg_driver_name(tfm));
 
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-cbc-serpent-sse2", 0, 0);
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
 
-static int ablk_ctr_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-ctr-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static int ablk_lrw_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
-
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-lrw-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
-	return 0;
-}
-
-static int ablk_xts_init(struct crypto_tfm *tfm)
-{
-	struct cryptd_ablkcipher *cryptd_tfm;
+	ctx->cryptd_tfm = cryptd_tfm;
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
+		crypto_ablkcipher_reqsize(&cryptd_tfm->base);
 
-	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-xts-serpent-sse2", 0, 0);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ablk_init_common(tfm, cryptd_tfm);
 	return 0;
 }
 
@@ -858,7 +813,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(serpent_algs[5].cra_list),
-	.cra_init		= ablk_ecb_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
@@ -880,7 +835,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(serpent_algs[6].cra_list),
-	.cra_init		= ablk_cbc_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
@@ -903,7 +858,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(serpent_algs[7].cra_list),
-	.cra_init		= ablk_ctr_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
@@ -927,7 +882,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(serpent_algs[8].cra_list),
-	.cra_init		= ablk_lrw_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
@@ -952,7 +907,7 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(serpent_algs[9].cra_list),
-	.cra_init		= ablk_xts_init,
+	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
 		.ablkcipher = {
