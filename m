From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/7] crypto - twofish-x86_64-3way: remove unneeded LRW/XTS
 #ifdefs
Date: Tue, 13 Dec 2011 12:53:07 +0200
Message-ID: <20111213105307.14934.66909.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45076 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1LMKxJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:09 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since LRW & XTS are selected by twofish-x86_64-3way, we don't need these
#ifdefs anymore.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 954f59e..7fee8c1 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -35,14 +35,6 @@
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 
-#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
-#define HAS_LRW
-#endif
-
-#if defined(CONFIG_CRYPTO_XTS) || defined(CONFIG_CRYPTO_XTS_MODULE)
-#define HAS_XTS
-#endif
-
 /* regular block cipher functions from twofish_x86_64 module */
 asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
 				const u8 *src);
@@ -442,8 +434,6 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
-#if defined(HAS_LRW) || defined(HAS_XTS)
-
 static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 {
 	const unsigned int bsize = TF_BLOCK_SIZE;
@@ -474,10 +464,6 @@ static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
 		twofish_dec_blk(ctx, srcdst, srcdst);
 }
 
-#endif
-
-#ifdef HAS_LRW
-
 struct twofish_lrw_ctx {
 	struct lrw_table_ctx lrw_table;
 	struct twofish_ctx twofish_ctx;
@@ -562,10 +548,6 @@ static struct crypto_alg blk_lrw_alg = {
 	},
 };
 
-#endif
-
-#ifdef HAS_XTS
-
 struct twofish_xts_ctx {
 	struct twofish_ctx tweak_ctx;
 	struct twofish_ctx crypt_ctx;
@@ -655,8 +637,6 @@ static struct crypto_alg blk_xts_alg = {
 	},
 };
 
-#endif
-
 int __init init(void)
 {
 	int err;
@@ -670,27 +650,19 @@ int __init init(void)
 	err = crypto_register_alg(&blk_ctr_alg);
 	if (err)
 		goto ctr_err;
-#ifdef HAS_LRW
 	err = crypto_register_alg(&blk_lrw_alg);
 	if (err)
 		goto blk_lrw_err;
-#endif
-#ifdef HAS_XTS
 	err = crypto_register_alg(&blk_xts_alg);
 	if (err)
 		goto blk_xts_err;
-#endif
 
 	return 0;
 
-#ifdef HAS_XTS
 	crypto_unregister_alg(&blk_xts_alg);
 blk_xts_err:
-#endif
-#ifdef HAS_LRW
 	crypto_unregister_alg(&blk_lrw_alg);
 blk_lrw_err:
-#endif
 	crypto_unregister_alg(&blk_ctr_alg);
 ctr_err:
 	crypto_unregister_alg(&blk_cbc_alg);
@@ -702,12 +674,8 @@ ecb_err:
 
 void __exit fini(void)
 {
-#ifdef HAS_XTS
 	crypto_unregister_alg(&blk_xts_alg);
-#endif
-#ifdef HAS_LRW
 	crypto_unregister_alg(&blk_lrw_alg);
-#endif
 	crypto_unregister_alg(&blk_ctr_alg);
 	crypto_unregister_alg(&blk_cbc_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
