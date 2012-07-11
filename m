From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 12/14] crypto: arch/x86 - cleanup - remove unneeded
 crypto_alg.cra_list initializations
Date: Wed, 11 Jul 2012 14:20:51 +0300
Message-ID: <20120711112051.6875.39344.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34240 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab2GKLUz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:20:55 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initialization of cra_list is currently mixed, most ciphers initialize this
field and most shashes do not. Initialization however is not needed at all
since cra_list is initialized/overwritten in __crypto_register_alg() with
list_add(). Therefore perform cleanup to remove all unneeded initializations
of this field in 'arch/x86/crypto/'.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aes_glue.c                 |    1 -
 arch/x86/crypto/aesni-intel_glue.c         |    5 +----
 arch/x86/crypto/blowfish_glue.c            |    4 ----
 arch/x86/crypto/camellia_glue.c            |    6 ------
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    2 --
 arch/x86/crypto/salsa20_glue.c             |    1 -
 arch/x86/crypto/serpent_avx_glue.c         |   10 ----------
 arch/x86/crypto/serpent_sse2_glue.c        |   10 ----------
 arch/x86/crypto/twofish_avx_glue.c         |   10 ----------
 arch/x86/crypto/twofish_glue.c             |    1 -
 arch/x86/crypto/twofish_glue_3way.c        |    5 -----
 11 files changed, 1 insertion(+), 54 deletions(-)

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index 59b37de..aafe8ce 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -40,7 +40,6 @@ static struct crypto_alg aes_alg = {
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(aes_alg.cra_list),
 	.cra_u	= {
 		.cipher	= {
 			.cia_min_keysize	= AES_MIN_KEY_SIZE,
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 34fdcff..648347a 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1118,7 +1118,7 @@ MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
 
 static int __init aesni_init(void)
 {
-	int err, i;
+	int err;
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
@@ -1127,9 +1127,6 @@ static int __init aesni_init(void)
 	if (err)
 		return err;
 
-	for (i = 0; i < ARRAY_SIZE(aesni_algs); i++)
-		INIT_LIST_HEAD(&aesni_algs[i].cra_list);
-
 	return crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 }
 
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 7967474..50ec333 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -367,7 +367,6 @@ static struct crypto_alg bf_algs[4] = { {
 	.cra_ctxsize		= sizeof(struct bf_ctx),
 	.cra_alignmask		= 0,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(bf_algs[0].cra_list),
 	.cra_u = {
 		.cipher = {
 			.cia_min_keysize	= BF_MIN_KEY_SIZE,
@@ -387,7 +386,6 @@ static struct crypto_alg bf_algs[4] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(bf_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= BF_MIN_KEY_SIZE,
@@ -407,7 +405,6 @@ static struct crypto_alg bf_algs[4] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(bf_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= BF_MIN_KEY_SIZE,
@@ -428,7 +425,6 @@ static struct crypto_alg bf_algs[4] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(bf_algs[3].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= BF_MIN_KEY_SIZE,
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index eeb2b3b..7a74d7b 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1601,7 +1601,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_ctxsize		= sizeof(struct camellia_ctx),
 	.cra_alignmask		= 0,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[0].cra_list),
 	.cra_u			= {
 		.cipher = {
 			.cia_min_keysize = CAMELLIA_MIN_KEY_SIZE,
@@ -1621,7 +1620,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
@@ -1641,7 +1639,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
@@ -1662,7 +1659,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[3].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
@@ -1683,7 +1679,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[4].cra_list),
 	.cra_exit		= lrw_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
@@ -1707,7 +1702,6 @@ static struct crypto_alg camellia_algs[6] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(camellia_algs[5].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE * 2,
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index b4bf0a6..6759dd1 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -150,7 +150,6 @@ static struct shash_alg ghash_alg = {
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct ghash_ctx),
 		.cra_module		= THIS_MODULE,
-		.cra_list		= LIST_HEAD_INIT(ghash_alg.base.cra_list),
 	},
 };
 
@@ -288,7 +287,6 @@ static struct ahash_alg ghash_async_alg = {
 			.cra_blocksize		= GHASH_BLOCK_SIZE,
 			.cra_type		= &crypto_ahash_type,
 			.cra_module		= THIS_MODULE,
-			.cra_list		= LIST_HEAD_INIT(ghash_async_alg.halg.base.cra_list),
 			.cra_init		= ghash_async_init_tfm,
 			.cra_exit		= ghash_async_exit_tfm,
 		},
diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
index bccb76d..a3a3c02 100644
--- a/arch/x86/crypto/salsa20_glue.c
+++ b/arch/x86/crypto/salsa20_glue.c
@@ -97,7 +97,6 @@ static struct crypto_alg alg = {
 	.cra_ctxsize        =   sizeof(struct salsa20_ctx),
 	.cra_alignmask      =	3,
 	.cra_module         =   THIS_MODULE,
-	.cra_list           =   LIST_HEAD_INIT(alg.cra_list),
 	.cra_u              =   {
 		.blkcipher = {
 			.setkey         =   setkey,
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index b36bdac..3f543a0 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -390,7 +390,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[0].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -410,7 +409,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -430,7 +428,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -451,7 +448,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[3].cra_list),
 	.cra_exit		= lrw_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
@@ -475,7 +471,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[4].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
@@ -496,7 +491,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[5].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -518,7 +512,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[6].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -541,7 +534,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[7].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -565,7 +557,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[8].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -590,7 +581,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[9].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index d679c86..9107a99 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -393,7 +393,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[0].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -413,7 +412,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -433,7 +431,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE,
@@ -454,7 +451,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[3].cra_list),
 	.cra_exit		= lrw_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
@@ -478,7 +474,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[4].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= SERPENT_MIN_KEY_SIZE * 2,
@@ -499,7 +494,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[5].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -521,7 +515,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[6].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -544,7 +537,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[7].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -568,7 +560,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[8].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -593,7 +584,6 @@ static struct crypto_alg serpent_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(serpent_algs[9].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 782b67d..e7708b5 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -378,7 +378,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[0].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -398,7 +397,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -418,7 +416,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -439,7 +436,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[3].cra_list),
 	.cra_exit		= lrw_twofish_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
@@ -463,7 +459,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[4].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE * 2,
@@ -484,7 +479,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[5].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -506,7 +500,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[6].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -529,7 +522,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[7].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -553,7 +545,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[8].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
@@ -578,7 +569,6 @@ static struct crypto_alg twofish_algs[10] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(twofish_algs[9].cra_list),
 	.cra_init		= ablk_init,
 	.cra_exit		= ablk_exit,
 	.cra_u = {
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 359ae08..0a52023 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -70,7 +70,6 @@ static struct crypto_alg alg = {
 	.cra_ctxsize		=	sizeof(struct twofish_ctx),
 	.cra_alignmask		=	0,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	TF_MIN_KEY_SIZE,
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 15f9347..aa3eb35 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -342,7 +342,6 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(tf_algs[0].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -362,7 +361,6 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(tf_algs[1].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -383,7 +381,6 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(tf_algs[2].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE,
@@ -404,7 +401,6 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(tf_algs[3].cra_list),
 	.cra_exit		= lrw_twofish_exit_tfm,
 	.cra_u = {
 		.blkcipher = {
@@ -426,7 +422,6 @@ static struct crypto_alg tf_algs[5] = { {
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(tf_algs[4].cra_list),
 	.cra_u = {
 		.blkcipher = {
 			.min_keysize	= TF_MIN_KEY_SIZE * 2,
