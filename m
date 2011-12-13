From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 6/7] crypto - serpent-sse2: remove unneeded LRW/XTS #ifdefs
Date: Tue, 13 Dec 2011 12:53:17 +0200
Message-ID: <20111213105317.14934.75098.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45105 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMKxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:19 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since LRW & XTS are selected by serpent-sse2, we don't need these #ifdefs
anymore.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |   40 -----------------------------------
 1 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 2f5c304..7955a9b 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -47,14 +47,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
-#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
-#define HAS_LRW
-#endif
-
-#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
-#define HAS_XTS
-#endif
-
 struct async_serpent_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
 };
@@ -470,8 +462,6 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
-#if defined(HAS_LRW) || defined(HAS_XTS)
-
 struct crypt_priv {
 	struct serpent_ctx *ctx;
 	bool fpu_enabled;
@@ -511,10 +501,6 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
 }
 
-#endif
-
-#ifdef HAS_LRW
-
 struct serpent_lrw_ctx {
 	struct lrw_table_ctx lrw_table;
 	struct serpent_ctx serpent_ctx;
@@ -620,10 +606,6 @@ static struct crypto_alg blk_lrw_alg = {
 	},
 };
 
-#endif
-
-#ifdef HAS_XTS
-
 struct serpent_xts_ctx {
 	struct serpent_ctx tweak_ctx;
 	struct serpent_ctx crypt_ctx;
@@ -730,8 +712,6 @@ static struct crypto_alg blk_xts_alg = {
 	},
 };
 
-#endif
-
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
@@ -930,8 +910,6 @@ static struct crypto_alg ablk_ctr_alg = {
 	},
 };
 
-#ifdef HAS_LRW
-
 static int ablk_lrw_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -970,10 +948,6 @@ static struct crypto_alg ablk_lrw_alg = {
 	},
 };
 
-#endif
-
-#ifdef HAS_XTS
-
 static int ablk_xts_init(struct crypto_tfm *tfm)
 {
 	struct cryptd_ablkcipher *cryptd_tfm;
@@ -1010,8 +984,6 @@ static struct crypto_alg ablk_xts_alg = {
 	},
 };
 
-#endif
-
 static int __init serpent_sse2_init(void)
 {
 	int err;
@@ -1039,36 +1011,28 @@ static int __init serpent_sse2_init(void)
 	err = crypto_register_alg(&ablk_ctr_alg);
 	if (err)
 		goto ablk_ctr_err;
-#ifdef HAS_LRW
 	err = crypto_register_alg(&blk_lrw_alg);
 	if (err)
 		goto blk_lrw_err;
 	err = crypto_register_alg(&ablk_lrw_alg);
 	if (err)
 		goto ablk_lrw_err;
-#endif
-#ifdef HAS_XTS
 	err = crypto_register_alg(&blk_xts_alg);
 	if (err)
 		goto blk_xts_err;
 	err = crypto_register_alg(&ablk_xts_alg);
 	if (err)
 		goto ablk_xts_err;
-#endif
 	return err;
 
-#ifdef HAS_XTS
 	crypto_unregister_alg(&ablk_xts_alg);
 ablk_xts_err:
 	crypto_unregister_alg(&blk_xts_alg);
 blk_xts_err:
-#endif
-#ifdef HAS_LRW
 	crypto_unregister_alg(&ablk_lrw_alg);
 ablk_lrw_err:
 	crypto_unregister_alg(&blk_lrw_alg);
 blk_lrw_err:
-#endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 ablk_ctr_err:
 	crypto_unregister_alg(&ablk_cbc_alg);
@@ -1086,14 +1050,10 @@ blk_ecb_err:
 
 static void __exit serpent_sse2_exit(void)
 {
-#ifdef HAS_XTS
 	crypto_unregister_alg(&ablk_xts_alg);
 	crypto_unregister_alg(&blk_xts_alg);
-#endif
-#ifdef HAS_LRW
 	crypto_unregister_alg(&ablk_lrw_alg);
 	crypto_unregister_alg(&blk_lrw_alg);
-#endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 	crypto_unregister_alg(&ablk_cbc_alg);
 	crypto_unregister_alg(&ablk_ecb_alg);
