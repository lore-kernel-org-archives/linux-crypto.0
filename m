Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF8CC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjHKJbM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjHKJaq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:46 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FECE30DF
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTe-0020jI-Kp; Fri, 11 Aug 2023 17:30:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:38 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:38 +0800
Subject: [PATCH 29/36] crypto: keembay - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTe-0020jI-Kp@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c |  437 +++++++++-----------
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      |   71 +--
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c |  230 +++++-----
 3 files changed, 364 insertions(+), 374 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index f94f48289683..1e2fd9a754ec 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -5,24 +5,23 @@
  * Copyright (C) 2018-2020 Intel Corporation
  */
 
+#include <crypto/aes.h>
+#include <crypto/engine.h>
+#include <crypto/gcm.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/crypto.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/types.h>
-
-#include <crypto/aes.h>
-#include <crypto/engine.h>
-#include <crypto/gcm.h>
-#include <crypto/scatterwalk.h>
-
-#include <crypto/internal/aead.h>
-#include <crypto/internal/skcipher.h>
+#include <linux/string.h>
 
 #include "ocs-aes.h"
 
@@ -38,7 +37,6 @@
 
 /**
  * struct ocs_aes_tctx - OCS AES Transform context
- * @engine_ctx:		Engine context.
  * @aes_dev:		The OCS AES device.
  * @key:		AES/SM4 key.
  * @key_len:		The length (in bytes) of @key.
@@ -47,7 +45,6 @@
  * @use_fallback:	Whether or not fallback cipher should be used.
  */
 struct ocs_aes_tctx {
-	struct crypto_engine_ctx engine_ctx;
 	struct ocs_aes_dev *aes_dev;
 	u8 key[OCS_AES_KEYSIZE_256];
 	unsigned int key_len;
@@ -1148,13 +1145,6 @@ static int kmb_ocs_sm4_ccm_decrypt(struct aead_request *req)
 	return kmb_ocs_aead_common(req, OCS_SM4, OCS_DECRYPT, OCS_MODE_CCM);
 }
 
-static inline int ocs_common_init(struct ocs_aes_tctx *tctx)
-{
-	tctx->engine_ctx.op.do_one_request = kmb_ocs_aes_sk_do_one_request;
-
-	return 0;
-}
-
 static int ocs_aes_init_tfm(struct crypto_skcipher *tfm)
 {
 	const char *alg_name = crypto_tfm_alg_name(&tfm->base);
@@ -1170,16 +1160,14 @@ static int ocs_aes_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct ocs_aes_rctx));
 
-	return ocs_common_init(tctx);
+	return 0;
 }
 
 static int ocs_sm4_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct ocs_aes_tctx *tctx = crypto_skcipher_ctx(tfm);
-
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct ocs_aes_rctx));
 
-	return ocs_common_init(tctx);
+	return 0;
 }
 
 static inline void clear_key(struct ocs_aes_tctx *tctx)
@@ -1204,13 +1192,6 @@ static void ocs_exit_tfm(struct crypto_skcipher *tfm)
 	}
 }
 
-static inline int ocs_common_aead_init(struct ocs_aes_tctx *tctx)
-{
-	tctx->engine_ctx.op.do_one_request = kmb_ocs_aes_aead_do_one_request;
-
-	return 0;
-}
-
 static int ocs_aes_aead_cra_init(struct crypto_aead *tfm)
 {
 	const char *alg_name = crypto_tfm_alg_name(&tfm->base);
@@ -1229,7 +1210,7 @@ static int ocs_aes_aead_cra_init(struct crypto_aead *tfm)
 				    (sizeof(struct aead_request) +
 				     crypto_aead_reqsize(tctx->sw_cipher.aead))));
 
-	return ocs_common_aead_init(tctx);
+	return 0;
 }
 
 static int kmb_ocs_aead_ccm_setauthsize(struct crypto_aead *tfm,
@@ -1257,11 +1238,9 @@ static int kmb_ocs_aead_gcm_setauthsize(struct crypto_aead *tfm,
 
 static int ocs_sm4_aead_cra_init(struct crypto_aead *tfm)
 {
-	struct ocs_aes_tctx *tctx = crypto_aead_ctx(tfm);
-
 	crypto_aead_set_reqsize(tfm, sizeof(struct ocs_aes_rctx));
 
-	return ocs_common_aead_init(tctx);
+	return 0;
 }
 
 static void ocs_aead_cra_exit(struct crypto_aead *tfm)
@@ -1276,182 +1255,190 @@ static void ocs_aead_cra_exit(struct crypto_aead *tfm)
 	}
 }
 
-static struct skcipher_alg algs[] = {
+static struct skcipher_engine_alg algs[] = {
 #ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_ECB
 	{
-		.base.cra_name = "ecb(aes)",
-		.base.cra_driver_name = "ecb-aes-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_NEED_FALLBACK,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_AES_MIN_KEY_SIZE,
-		.max_keysize = OCS_AES_MAX_KEY_SIZE,
-		.setkey = kmb_ocs_aes_set_key,
-		.encrypt = kmb_ocs_aes_ecb_encrypt,
-		.decrypt = kmb_ocs_aes_ecb_decrypt,
-		.init = ocs_aes_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "ecb(aes)",
+		.base.base.cra_driver_name = "ecb-aes-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY |
+				       CRYPTO_ALG_NEED_FALLBACK,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_AES_MIN_KEY_SIZE,
+		.base.max_keysize = OCS_AES_MAX_KEY_SIZE,
+		.base.setkey = kmb_ocs_aes_set_key,
+		.base.encrypt = kmb_ocs_aes_ecb_encrypt,
+		.base.decrypt = kmb_ocs_aes_ecb_decrypt,
+		.base.init = ocs_aes_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 #endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_ECB */
 	{
-		.base.cra_name = "cbc(aes)",
-		.base.cra_driver_name = "cbc-aes-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_NEED_FALLBACK,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_AES_MIN_KEY_SIZE,
-		.max_keysize = OCS_AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_aes_set_key,
-		.encrypt = kmb_ocs_aes_cbc_encrypt,
-		.decrypt = kmb_ocs_aes_cbc_decrypt,
-		.init = ocs_aes_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "cbc(aes)",
+		.base.base.cra_driver_name = "cbc-aes-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY |
+				       CRYPTO_ALG_NEED_FALLBACK,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_AES_MIN_KEY_SIZE,
+		.base.max_keysize = OCS_AES_MAX_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_aes_set_key,
+		.base.encrypt = kmb_ocs_aes_cbc_encrypt,
+		.base.decrypt = kmb_ocs_aes_cbc_decrypt,
+		.base.init = ocs_aes_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 	{
-		.base.cra_name = "ctr(aes)",
-		.base.cra_driver_name = "ctr-aes-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_NEED_FALLBACK,
-		.base.cra_blocksize = 1,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_AES_MIN_KEY_SIZE,
-		.max_keysize = OCS_AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_aes_set_key,
-		.encrypt = kmb_ocs_aes_ctr_encrypt,
-		.decrypt = kmb_ocs_aes_ctr_decrypt,
-		.init = ocs_aes_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "ctr(aes)",
+		.base.base.cra_driver_name = "ctr-aes-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY |
+				       CRYPTO_ALG_NEED_FALLBACK,
+		.base.base.cra_blocksize = 1,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_AES_MIN_KEY_SIZE,
+		.base.max_keysize = OCS_AES_MAX_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_aes_set_key,
+		.base.encrypt = kmb_ocs_aes_ctr_encrypt,
+		.base.decrypt = kmb_ocs_aes_ctr_decrypt,
+		.base.init = ocs_aes_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 #ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_CTS
 	{
-		.base.cra_name = "cts(cbc(aes))",
-		.base.cra_driver_name = "cts-aes-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_NEED_FALLBACK,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_AES_MIN_KEY_SIZE,
-		.max_keysize = OCS_AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_aes_set_key,
-		.encrypt = kmb_ocs_aes_cts_encrypt,
-		.decrypt = kmb_ocs_aes_cts_decrypt,
-		.init = ocs_aes_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "cts(cbc(aes))",
+		.base.base.cra_driver_name = "cts-aes-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY |
+				       CRYPTO_ALG_NEED_FALLBACK,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_AES_MIN_KEY_SIZE,
+		.base.max_keysize = OCS_AES_MAX_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_aes_set_key,
+		.base.encrypt = kmb_ocs_aes_cts_encrypt,
+		.base.decrypt = kmb_ocs_aes_cts_decrypt,
+		.base.init = ocs_aes_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 #endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_CTS */
 #ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_ECB
 	{
-		.base.cra_name = "ecb(sm4)",
-		.base.cra_driver_name = "ecb-sm4-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_SM4_KEY_SIZE,
-		.max_keysize = OCS_SM4_KEY_SIZE,
-		.setkey = kmb_ocs_sm4_set_key,
-		.encrypt = kmb_ocs_sm4_ecb_encrypt,
-		.decrypt = kmb_ocs_sm4_ecb_decrypt,
-		.init = ocs_sm4_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "ecb(sm4)",
+		.base.base.cra_driver_name = "ecb-sm4-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_SM4_KEY_SIZE,
+		.base.max_keysize = OCS_SM4_KEY_SIZE,
+		.base.setkey = kmb_ocs_sm4_set_key,
+		.base.encrypt = kmb_ocs_sm4_ecb_encrypt,
+		.base.decrypt = kmb_ocs_sm4_ecb_decrypt,
+		.base.init = ocs_sm4_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 #endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_ECB */
 	{
-		.base.cra_name = "cbc(sm4)",
-		.base.cra_driver_name = "cbc-sm4-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_SM4_KEY_SIZE,
-		.max_keysize = OCS_SM4_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_sm4_set_key,
-		.encrypt = kmb_ocs_sm4_cbc_encrypt,
-		.decrypt = kmb_ocs_sm4_cbc_decrypt,
-		.init = ocs_sm4_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "cbc(sm4)",
+		.base.base.cra_driver_name = "cbc-sm4-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_SM4_KEY_SIZE,
+		.base.max_keysize = OCS_SM4_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_sm4_set_key,
+		.base.encrypt = kmb_ocs_sm4_cbc_encrypt,
+		.base.decrypt = kmb_ocs_sm4_cbc_decrypt,
+		.base.init = ocs_sm4_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 	{
-		.base.cra_name = "ctr(sm4)",
-		.base.cra_driver_name = "ctr-sm4-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.base.cra_blocksize = 1,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_SM4_KEY_SIZE,
-		.max_keysize = OCS_SM4_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_sm4_set_key,
-		.encrypt = kmb_ocs_sm4_ctr_encrypt,
-		.decrypt = kmb_ocs_sm4_ctr_decrypt,
-		.init = ocs_sm4_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "ctr(sm4)",
+		.base.base.cra_driver_name = "ctr-sm4-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.base.base.cra_blocksize = 1,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_SM4_KEY_SIZE,
+		.base.max_keysize = OCS_SM4_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_sm4_set_key,
+		.base.encrypt = kmb_ocs_sm4_ctr_encrypt,
+		.base.decrypt = kmb_ocs_sm4_ctr_decrypt,
+		.base.init = ocs_sm4_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	},
 #ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_CTS
 	{
-		.base.cra_name = "cts(cbc(sm4))",
-		.base.cra_driver_name = "cts-sm4-keembay-ocs",
-		.base.cra_priority = KMB_OCS_PRIORITY,
-		.base.cra_flags = CRYPTO_ALG_ASYNC |
-				  CRYPTO_ALG_KERN_DRIVER_ONLY,
-		.base.cra_blocksize = AES_BLOCK_SIZE,
-		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
-		.base.cra_module = THIS_MODULE,
-		.base.cra_alignmask = 0,
-
-		.min_keysize = OCS_SM4_KEY_SIZE,
-		.max_keysize = OCS_SM4_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.setkey = kmb_ocs_sm4_set_key,
-		.encrypt = kmb_ocs_sm4_cts_encrypt,
-		.decrypt = kmb_ocs_sm4_cts_decrypt,
-		.init = ocs_sm4_init_tfm,
-		.exit = ocs_exit_tfm,
+		.base.base.cra_name = "cts(cbc(sm4))",
+		.base.base.cra_driver_name = "cts-sm4-keembay-ocs",
+		.base.base.cra_priority = KMB_OCS_PRIORITY,
+		.base.base.cra_flags = CRYPTO_ALG_ASYNC |
+				       CRYPTO_ALG_KERN_DRIVER_ONLY,
+		.base.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
+		.base.base.cra_module = THIS_MODULE,
+		.base.base.cra_alignmask = 0,
+
+		.base.min_keysize = OCS_SM4_KEY_SIZE,
+		.base.max_keysize = OCS_SM4_KEY_SIZE,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.setkey = kmb_ocs_sm4_set_key,
+		.base.encrypt = kmb_ocs_sm4_cts_encrypt,
+		.base.decrypt = kmb_ocs_sm4_cts_decrypt,
+		.base.init = ocs_sm4_init_tfm,
+		.base.exit = ocs_exit_tfm,
+		.op.do_one_request = kmb_ocs_aes_sk_do_one_request,
 	}
 #endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_AES_SM4_CTS */
 };
 
-static struct aead_alg algs_aead[] = {
+static struct aead_engine_alg algs_aead[] = {
 	{
-		.base = {
+		.base.base = {
 			.cra_name = "gcm(aes)",
 			.cra_driver_name = "gcm-aes-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
@@ -1463,17 +1450,18 @@ static struct aead_alg algs_aead[] = {
 			.cra_alignmask = 0,
 			.cra_module = THIS_MODULE,
 		},
-		.init = ocs_aes_aead_cra_init,
-		.exit = ocs_aead_cra_exit,
-		.ivsize = GCM_AES_IV_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setauthsize = kmb_ocs_aead_gcm_setauthsize,
-		.setkey = kmb_ocs_aes_aead_set_key,
-		.encrypt = kmb_ocs_aes_gcm_encrypt,
-		.decrypt = kmb_ocs_aes_gcm_decrypt,
+		.base.init = ocs_aes_aead_cra_init,
+		.base.exit = ocs_aead_cra_exit,
+		.base.ivsize = GCM_AES_IV_SIZE,
+		.base.maxauthsize = AES_BLOCK_SIZE,
+		.base.setauthsize = kmb_ocs_aead_gcm_setauthsize,
+		.base.setkey = kmb_ocs_aes_aead_set_key,
+		.base.encrypt = kmb_ocs_aes_gcm_encrypt,
+		.base.decrypt = kmb_ocs_aes_gcm_decrypt,
+		.op.do_one_request = kmb_ocs_aes_aead_do_one_request,
 	},
 	{
-		.base = {
+		.base.base = {
 			.cra_name = "ccm(aes)",
 			.cra_driver_name = "ccm-aes-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
@@ -1485,17 +1473,18 @@ static struct aead_alg algs_aead[] = {
 			.cra_alignmask = 0,
 			.cra_module = THIS_MODULE,
 		},
-		.init = ocs_aes_aead_cra_init,
-		.exit = ocs_aead_cra_exit,
-		.ivsize = AES_BLOCK_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setauthsize = kmb_ocs_aead_ccm_setauthsize,
-		.setkey = kmb_ocs_aes_aead_set_key,
-		.encrypt = kmb_ocs_aes_ccm_encrypt,
-		.decrypt = kmb_ocs_aes_ccm_decrypt,
+		.base.init = ocs_aes_aead_cra_init,
+		.base.exit = ocs_aead_cra_exit,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.maxauthsize = AES_BLOCK_SIZE,
+		.base.setauthsize = kmb_ocs_aead_ccm_setauthsize,
+		.base.setkey = kmb_ocs_aes_aead_set_key,
+		.base.encrypt = kmb_ocs_aes_ccm_encrypt,
+		.base.decrypt = kmb_ocs_aes_ccm_decrypt,
+		.op.do_one_request = kmb_ocs_aes_aead_do_one_request,
 	},
 	{
-		.base = {
+		.base.base = {
 			.cra_name = "gcm(sm4)",
 			.cra_driver_name = "gcm-sm4-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
@@ -1506,17 +1495,18 @@ static struct aead_alg algs_aead[] = {
 			.cra_alignmask = 0,
 			.cra_module = THIS_MODULE,
 		},
-		.init = ocs_sm4_aead_cra_init,
-		.exit = ocs_aead_cra_exit,
-		.ivsize = GCM_AES_IV_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setauthsize = kmb_ocs_aead_gcm_setauthsize,
-		.setkey = kmb_ocs_sm4_aead_set_key,
-		.encrypt = kmb_ocs_sm4_gcm_encrypt,
-		.decrypt = kmb_ocs_sm4_gcm_decrypt,
+		.base.init = ocs_sm4_aead_cra_init,
+		.base.exit = ocs_aead_cra_exit,
+		.base.ivsize = GCM_AES_IV_SIZE,
+		.base.maxauthsize = AES_BLOCK_SIZE,
+		.base.setauthsize = kmb_ocs_aead_gcm_setauthsize,
+		.base.setkey = kmb_ocs_sm4_aead_set_key,
+		.base.encrypt = kmb_ocs_sm4_gcm_encrypt,
+		.base.decrypt = kmb_ocs_sm4_gcm_decrypt,
+		.op.do_one_request = kmb_ocs_aes_aead_do_one_request,
 	},
 	{
-		.base = {
+		.base.base = {
 			.cra_name = "ccm(sm4)",
 			.cra_driver_name = "ccm-sm4-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
@@ -1527,21 +1517,22 @@ static struct aead_alg algs_aead[] = {
 			.cra_alignmask = 0,
 			.cra_module = THIS_MODULE,
 		},
-		.init = ocs_sm4_aead_cra_init,
-		.exit = ocs_aead_cra_exit,
-		.ivsize = AES_BLOCK_SIZE,
-		.maxauthsize = AES_BLOCK_SIZE,
-		.setauthsize = kmb_ocs_aead_ccm_setauthsize,
-		.setkey = kmb_ocs_sm4_aead_set_key,
-		.encrypt = kmb_ocs_sm4_ccm_encrypt,
-		.decrypt = kmb_ocs_sm4_ccm_decrypt,
+		.base.init = ocs_sm4_aead_cra_init,
+		.base.exit = ocs_aead_cra_exit,
+		.base.ivsize = AES_BLOCK_SIZE,
+		.base.maxauthsize = AES_BLOCK_SIZE,
+		.base.setauthsize = kmb_ocs_aead_ccm_setauthsize,
+		.base.setkey = kmb_ocs_sm4_aead_set_key,
+		.base.encrypt = kmb_ocs_sm4_ccm_encrypt,
+		.base.decrypt = kmb_ocs_sm4_ccm_decrypt,
+		.op.do_one_request = kmb_ocs_aes_aead_do_one_request,
 	}
 };
 
 static void unregister_aes_algs(struct ocs_aes_dev *aes_dev)
 {
-	crypto_unregister_aeads(algs_aead, ARRAY_SIZE(algs_aead));
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs_aead));
+	crypto_engine_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 static int register_aes_algs(struct ocs_aes_dev *aes_dev)
@@ -1552,13 +1543,13 @@ static int register_aes_algs(struct ocs_aes_dev *aes_dev)
 	 * If any algorithm fails to register, all preceding algorithms that
 	 * were successfully registered will be automatically unregistered.
 	 */
-	ret = crypto_register_aeads(algs_aead, ARRAY_SIZE(algs_aead));
+	ret = crypto_engine_register_aeads(algs_aead, ARRAY_SIZE(algs_aead));
 	if (ret)
 		return ret;
 
-	ret = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+	ret = crypto_engine_register_skciphers(algs, ARRAY_SIZE(algs));
 	if (ret)
-		crypto_unregister_aeads(algs_aead, ARRAY_SIZE(algs));
+		crypto_engine_unregister_aeads(algs_aead, ARRAY_SIZE(algs));
 
 	return ret;
 }
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index e91e570b7ae0..fb95deed9057 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -7,30 +7,27 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <crypto/ecc_curve.h>
+#include <crypto/ecdh.h>
+#include <crypto/engine.h>
+#include <crypto/internal/ecc.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/kpp.h>
+#include <crypto/rng.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/crypto.h>
-#include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-
-#include <crypto/ecc_curve.h>
-#include <crypto/ecdh.h>
-#include <crypto/engine.h>
-#include <crypto/kpp.h>
-#include <crypto/rng.h>
-
-#include <crypto/internal/ecc.h>
-#include <crypto/internal/kpp.h>
+#include <linux/string.h>
 
 #define DRV_NAME			"keembay-ocs-ecc"
 
@@ -95,13 +92,11 @@ struct ocs_ecc_dev {
 
 /**
  * struct ocs_ecc_ctx - Transformation context.
- * @engine_ctx:	 Crypto engine ctx.
  * @ecc_dev:	 The ECC driver associated with this context.
  * @curve:	 The elliptic curve used by this transformation.
  * @private_key: The private key.
  */
 struct ocs_ecc_ctx {
-	struct crypto_engine_ctx engine_ctx;
 	struct ocs_ecc_dev *ecc_dev;
 	const struct ecc_curve *curve;
 	u64 private_key[KMB_ECC_VLI_MAX_DIGITS];
@@ -794,8 +789,6 @@ static int kmb_ecc_tctx_init(struct ocs_ecc_ctx *tctx, unsigned int curve_id)
 	if (!tctx->curve)
 		return -EOPNOTSUPP;
 
-	tctx->engine_ctx.op.do_one_request = kmb_ocs_ecc_do_one_request;
-
 	return 0;
 }
 
@@ -828,36 +821,38 @@ static unsigned int kmb_ocs_ecdh_max_size(struct crypto_kpp *tfm)
 	return digits_to_bytes(tctx->curve->g.ndigits) * 2;
 }
 
-static struct kpp_alg ocs_ecdh_p256 = {
-	.set_secret = kmb_ocs_ecdh_set_secret,
-	.generate_public_key = kmb_ocs_ecdh_generate_public_key,
-	.compute_shared_secret = kmb_ocs_ecdh_compute_shared_secret,
-	.init = kmb_ocs_ecdh_nist_p256_init_tfm,
-	.exit = kmb_ocs_ecdh_exit_tfm,
-	.max_size = kmb_ocs_ecdh_max_size,
-	.base = {
+static struct kpp_engine_alg ocs_ecdh_p256 = {
+	.base.set_secret = kmb_ocs_ecdh_set_secret,
+	.base.generate_public_key = kmb_ocs_ecdh_generate_public_key,
+	.base.compute_shared_secret = kmb_ocs_ecdh_compute_shared_secret,
+	.base.init = kmb_ocs_ecdh_nist_p256_init_tfm,
+	.base.exit = kmb_ocs_ecdh_exit_tfm,
+	.base.max_size = kmb_ocs_ecdh_max_size,
+	.base.base = {
 		.cra_name = "ecdh-nist-p256",
 		.cra_driver_name = "ecdh-nist-p256-keembay-ocs",
 		.cra_priority = KMB_OCS_ECC_PRIORITY,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ocs_ecc_ctx),
 	},
+	.op.do_one_request = kmb_ocs_ecc_do_one_request,
 };
 
-static struct kpp_alg ocs_ecdh_p384 = {
-	.set_secret = kmb_ocs_ecdh_set_secret,
-	.generate_public_key = kmb_ocs_ecdh_generate_public_key,
-	.compute_shared_secret = kmb_ocs_ecdh_compute_shared_secret,
-	.init = kmb_ocs_ecdh_nist_p384_init_tfm,
-	.exit = kmb_ocs_ecdh_exit_tfm,
-	.max_size = kmb_ocs_ecdh_max_size,
-	.base = {
+static struct kpp_engine_alg ocs_ecdh_p384 = {
+	.base.set_secret = kmb_ocs_ecdh_set_secret,
+	.base.generate_public_key = kmb_ocs_ecdh_generate_public_key,
+	.base.compute_shared_secret = kmb_ocs_ecdh_compute_shared_secret,
+	.base.init = kmb_ocs_ecdh_nist_p384_init_tfm,
+	.base.exit = kmb_ocs_ecdh_exit_tfm,
+	.base.max_size = kmb_ocs_ecdh_max_size,
+	.base.base = {
 		.cra_name = "ecdh-nist-p384",
 		.cra_driver_name = "ecdh-nist-p384-keembay-ocs",
 		.cra_priority = KMB_OCS_ECC_PRIORITY,
 		.cra_module = THIS_MODULE,
 		.cra_ctxsize = sizeof(struct ocs_ecc_ctx),
 	},
+	.op.do_one_request = kmb_ocs_ecc_do_one_request,
 };
 
 static irqreturn_t ocs_ecc_irq_handler(int irq, void *dev_id)
@@ -939,14 +934,14 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 	}
 
 	/* Register the KPP algo. */
-	rc = crypto_register_kpp(&ocs_ecdh_p256);
+	rc = crypto_engine_register_kpp(&ocs_ecdh_p256);
 	if (rc) {
 		dev_err(dev,
 			"Could not register OCS algorithms with Crypto API\n");
 		goto cleanup;
 	}
 
-	rc = crypto_register_kpp(&ocs_ecdh_p384);
+	rc = crypto_engine_register_kpp(&ocs_ecdh_p384);
 	if (rc) {
 		dev_err(dev,
 			"Could not register OCS algorithms with Crypto API\n");
@@ -956,7 +951,7 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 	return 0;
 
 ocs_ecdh_p384_error:
-	crypto_unregister_kpp(&ocs_ecdh_p256);
+	crypto_engine_unregister_kpp(&ocs_ecdh_p256);
 
 cleanup:
 	crypto_engine_exit(ecc_dev->engine);
@@ -975,8 +970,8 @@ static int kmb_ocs_ecc_remove(struct platform_device *pdev)
 
 	ecc_dev = platform_get_drvdata(pdev);
 
-	crypto_unregister_kpp(&ocs_ecdh_p384);
-	crypto_unregister_kpp(&ocs_ecdh_p256);
+	crypto_engine_unregister_kpp(&ocs_ecdh_p384);
+	crypto_engine_unregister_kpp(&ocs_ecdh_p256);
 
 	spin_lock(&ocs_ecc.lock);
 	list_del(&ecc_dev->list);
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index 51a6de6294cb..57a20281ead8 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -5,19 +5,20 @@
  * Copyright (C) 2018-2020 Intel Corporation
  */
 
+#include <crypto/engine.h>
+#include <crypto/hmac.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha2.h>
+#include <crypto/sm3.h>
 #include <linux/completion.h>
-#include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
-
-#include <crypto/engine.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/sha2.h>
-#include <crypto/sm3.h>
-#include <crypto/hmac.h>
-#include <crypto/internal/hash.h>
+#include <linux/string.h>
 
 #include "ocs-hcu.h"
 
@@ -34,7 +35,6 @@
 
 /**
  * struct ocs_hcu_ctx: OCS HCU Transform context.
- * @engine_ctx:	 Crypto Engine context.
  * @hcu_dev:	 The OCS HCU device used by the transformation.
  * @key:	 The key (used only for HMAC transformations).
  * @key_len:	 The length of the key.
@@ -42,7 +42,6 @@
  * @is_hmac_tfm: Whether or not this is a HMAC transformation.
  */
 struct ocs_hcu_ctx {
-	struct crypto_engine_ctx engine_ctx;
 	struct ocs_hcu_dev *hcu_dev;
 	u8 key[SHA512_BLOCK_SIZE];
 	size_t key_len;
@@ -824,11 +823,6 @@ static void __cra_init(struct crypto_tfm *tfm, struct ocs_hcu_ctx *ctx)
 {
 	crypto_ahash_set_reqsize_dma(__crypto_ahash_cast(tfm),
 				     sizeof(struct ocs_hcu_rctx));
-
-	/* Init context to 0. */
-	memzero_explicit(ctx, sizeof(*ctx));
-	/* Set engine ops. */
-	ctx->engine_ctx.op.do_one_request = kmb_ocs_hcu_do_one_request;
 }
 
 static int kmb_ocs_hcu_sha_cra_init(struct crypto_tfm *tfm)
@@ -883,17 +877,17 @@ static void kmb_ocs_hcu_hmac_cra_exit(struct crypto_tfm *tfm)
 	memzero_explicit(ctx->key, sizeof(ctx->key));
 }
 
-static struct ahash_alg ocs_hcu_algs[] = {
+static struct ahash_engine_alg ocs_hcu_algs[] = {
 #ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.halg = {
 		.digestsize	= SHA224_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -907,18 +901,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_module		= THIS_MODULE,
 			.cra_init		= kmb_ocs_hcu_sha_cra_init,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.setkey		= kmb_ocs_hcu_setkey,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.setkey		= kmb_ocs_hcu_setkey,
+	.base.halg = {
 		.digestsize	= SHA224_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -933,18 +928,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
 			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 #endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.halg = {
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -958,18 +954,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_module		= THIS_MODULE,
 			.cra_init		= kmb_ocs_hcu_sha_cra_init,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.setkey		= kmb_ocs_hcu_setkey,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.setkey		= kmb_ocs_hcu_setkey,
+	.base.halg = {
 		.digestsize	= SHA256_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -984,17 +981,18 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
 			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.halg = {
 		.digestsize	= SM3_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1008,18 +1006,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_module		= THIS_MODULE,
 			.cra_init		= kmb_ocs_hcu_sm3_cra_init,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.setkey		= kmb_ocs_hcu_setkey,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.setkey		= kmb_ocs_hcu_setkey,
+	.base.halg = {
 		.digestsize	= SM3_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1034,17 +1033,18 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_init		= kmb_ocs_hcu_hmac_sm3_cra_init,
 			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.halg = {
 		.digestsize	= SHA384_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1058,18 +1058,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_module		= THIS_MODULE,
 			.cra_init		= kmb_ocs_hcu_sha_cra_init,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.setkey		= kmb_ocs_hcu_setkey,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.setkey		= kmb_ocs_hcu_setkey,
+	.base.halg = {
 		.digestsize	= SHA384_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1084,17 +1085,18 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
 			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.halg = {
 		.digestsize	= SHA512_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1108,18 +1110,19 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_module		= THIS_MODULE,
 			.cra_init		= kmb_ocs_hcu_sha_cra_init,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 {
-	.init		= kmb_ocs_hcu_init,
-	.update		= kmb_ocs_hcu_update,
-	.final		= kmb_ocs_hcu_final,
-	.finup		= kmb_ocs_hcu_finup,
-	.digest		= kmb_ocs_hcu_digest,
-	.export		= kmb_ocs_hcu_export,
-	.import		= kmb_ocs_hcu_import,
-	.setkey		= kmb_ocs_hcu_setkey,
-	.halg = {
+	.base.init		= kmb_ocs_hcu_init,
+	.base.update		= kmb_ocs_hcu_update,
+	.base.final		= kmb_ocs_hcu_final,
+	.base.finup		= kmb_ocs_hcu_finup,
+	.base.digest		= kmb_ocs_hcu_digest,
+	.base.export		= kmb_ocs_hcu_export,
+	.base.import		= kmb_ocs_hcu_import,
+	.base.setkey		= kmb_ocs_hcu_setkey,
+	.base.halg = {
 		.digestsize	= SHA512_DIGEST_SIZE,
 		.statesize	= sizeof(struct ocs_hcu_rctx),
 		.base	= {
@@ -1134,7 +1137,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
 			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
 		}
-	}
+	},
+	.op.do_one_request = kmb_ocs_hcu_do_one_request,
 },
 };
 
@@ -1155,7 +1159,7 @@ static int kmb_ocs_hcu_remove(struct platform_device *pdev)
 	if (!hcu_dev)
 		return -ENODEV;
 
-	crypto_unregister_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
+	crypto_engine_unregister_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
 
 	rc = crypto_engine_exit(hcu_dev->engine);
 
@@ -1223,7 +1227,7 @@ static int kmb_ocs_hcu_probe(struct platform_device *pdev)
 
 	/* Security infrastructure guarantees OCS clock is enabled. */
 
-	rc = crypto_register_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
+	rc = crypto_engine_register_ahashes(ocs_hcu_algs, ARRAY_SIZE(ocs_hcu_algs));
 	if (rc) {
 		dev_err(dev, "Could not register algorithms.\n");
 		goto cleanup;
