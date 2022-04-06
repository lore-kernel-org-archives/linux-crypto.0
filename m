Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70956C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 17:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbiDFREV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiDFREE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 13:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A277368982
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 07:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9BFC619B0
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 14:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F5BC385A3;
        Wed,  6 Apr 2022 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255249;
        bh=/ImAOat/1mYQsuqyR8loa1M6qh+uTgujLw6w4fK7v9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3f8U0lcyZSAMoRjl805/p+Yo+HpAdCPOTOOXal/1luoVcU4bcczd2H7GDnj+aIak
         uypjV/ScwZdyVny/TH/ehp/mQOZVHvg5dPhe+yo/VL3XRkeFH26uapGZvBNoD9xoSb
         Hf9wmJ5GExGgCFjR1sRO+PdKdQ/A7sq4ONxpL6lcCPDxkIhXfA8wmbvqFJSZsbGFSe
         w1yvV84GeUelAf7S5+3GqXxs8S9ZDBL/56T/NEtZpx9T23knCwQdg/Gt8zMTHYX6WD
         bcVTiu4CPOzR4a8yn5bIo1UFUFJEvxBy0v0FhVZYSVz6EG3NDQAlLE4ykPKDyb3FV8
         Cii9KLhSm7zqg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/8] crypto: drivers - set CRYPTO_ALG_NEED_DMA_ALIGNMENT where needed
Date:   Wed,  6 Apr 2022 16:27:10 +0200
Message-Id: <20220406142715.2270256-4-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406142715.2270256-1-ardb@kernel.org>
References: <20220406142715.2270256-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=148146; h=from:subject; bh=/ImAOat/1mYQsuqyR8loa1M6qh+uTgujLw6w4fK7v9U=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBiTaM6w0NKuAtSOSz0n7+FApOZSAnfQet00ewcDkOr usSpVsGJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYk2jOgAKCRDDTyI5ktmPJC7vC/ 9IZlgvh8XeVbXgEGsIL6C5GYV+vx/aQXGwuwFSi7X/OTEcpQvMkYr6GhP0SYlavqut8hhA4u0WBYMT ChVSH57I5VOacnG3b8JyVqfgXhmkxC1p+B3dEexSi8dBzCpstZScIFeaLs4faDhd3WWzNdkGGpKInv ZAzSBlPwOV+XpFk7e8QXsK0ECvG08X8QD0PoTBFqvWDUM8KU4TAxWDlV0g2/7XyiqugN3XaeTEOg7J jZ0g4TpATcGRFV9SPm3fR8JOjSmVDzcc7GoF04pzJtzsIRcbIyJ+o7e6A6yOMBI4BbALwtdCogsNSt 4hgXu603Q7eXm3CJavv1v/2UqmTw0Fc2bNGuuFinGJVSgonDOdHXrkLadgYsOQfg53HgrBmJ18nEAa dYUvF5+kRKshJoTLSgFo2fsC7t1wTRUi0OgpF42LAVobXLWMi6SrJixg4zBoVzaxNzf37CGFBRLmtI bBIj6VvbfPhKFzIO2D2VaJI5wmXaWPmnpycyptR2pzbC0=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the CRYPTO_ALG_NEED_DMA_ALIGNMENT for all algo implementations that
might need it, i.e., the CRYPTO_ALG_ASYNC ones that can be built for
!X86. (Except CCP, which is used on arm64 but only in a cache coherent
manner)

Note that we are erring firmly on the side of caution there: most
implementations likely do not DMA into the request context buffer
directly, and so the flag might be unnecessary. However, given that
setting this flag basically preserves the status quo for these drivers,
it is a safe and reasonable default.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  | 20 +++----
 drivers/crypto/amcc/crypto4xx_core.c               |  8 +++
 drivers/crypto/amlogic/amlogic-gxl-core.c          |  2 +
 drivers/crypto/atmel-aes.c                         |  2 +-
 drivers/crypto/atmel-sha.c                         |  2 +-
 drivers/crypto/atmel-tdes.c                        |  2 +-
 drivers/crypto/axis/artpec6_crypto.c               |  8 +++
 drivers/crypto/bcm/cipher.c                        | 23 +++++++-
 drivers/crypto/caam/caamalg.c                      |  4 +-
 drivers/crypto/caam/caamalg_qi.c                   |  2 +
 drivers/crypto/caam/caamalg_qi2.c                  |  4 +-
 drivers/crypto/caam/caamhash.c                     |  3 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  6 ++
 drivers/crypto/cavium/nitrox/nitrox_aead.c         |  6 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     | 24 +++++---
 drivers/crypto/ccree/cc_aead.c                     |  3 +
 drivers/crypto/ccree/cc_cipher.c                   |  3 +
 drivers/crypto/ccree/cc_hash.c                     |  6 ++
 drivers/crypto/chelsio/chcr_algo.c                 |  5 +-
 drivers/crypto/gemini/sl3516-ce-core.c             |  1 +
 drivers/crypto/hifn_795x.c                         |  4 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  8 +++
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  2 +
 drivers/crypto/inside-secure/safexcel_cipher.c     | 47 +++++++++++++++
 drivers/crypto/inside-secure/safexcel_hash.c       | 26 +++++++++
 drivers/crypto/ixp4xx_crypto.c                     |  2 +
 drivers/crypto/keembay/keembay-ocs-aes-core.c      | 12 ++++
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      | 30 ++++++----
 drivers/crypto/marvell/cesa/cipher.c               |  6 ++
 drivers/crypto/marvell/cesa/hash.c                 |  6 ++
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   | 60 +++++++++++++++-----
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 52 ++++++++++++-----
 drivers/crypto/mxs-dcp.c                           |  8 ++-
 drivers/crypto/n2_core.c                           |  1 +
 drivers/crypto/omap-aes.c                          |  5 ++
 drivers/crypto/omap-des.c                          |  4 ++
 drivers/crypto/omap-sham.c                         | 12 ++++
 drivers/crypto/qce/aead.c                          |  1 +
 drivers/crypto/qce/sha.c                           |  3 +-
 drivers/crypto/qce/skcipher.c                      |  1 +
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |  3 +
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 18 ++++--
 drivers/crypto/s5p-sss.c                           |  6 ++
 drivers/crypto/sa2ul.c                             |  9 +++
 drivers/crypto/sahara.c                            | 14 +++--
 drivers/crypto/stm32/stm32-cryp.c                  | 27 ++++++---
 drivers/crypto/stm32/stm32-hash.c                  |  8 +++
 drivers/crypto/talitos.c                           | 40 +++++++++++++
 drivers/crypto/ux500/cryp/cryp_core.c              | 21 ++++---
 drivers/crypto/ux500/hash/hash_core.c              | 12 ++--
 drivers/crypto/xilinx/zynqmp-aes-gcm.c             |  1 +
 51 files changed, 482 insertions(+), 101 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index d8623c7e0d1d..78034031f591 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -284,7 +284,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -311,7 +311,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -337,7 +337,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -364,7 +364,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-				CRYPTO_ALG_NEED_FALLBACK,
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sun8i_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -399,7 +399,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -429,7 +429,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -459,7 +459,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -489,7 +489,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -519,7 +519,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -549,7 +549,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_alignmask = 3,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT | CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8278d98074e9..a6a35b562604 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1197,6 +1197,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "cbc-aes-ppc4xx",
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1217,6 +1218,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "cfb-aes-ppc4xx",
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1238,6 +1240,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1258,6 +1261,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "rfc3686-ctr-aes-ppc4xx",
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1278,6 +1282,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "ecb-aes-ppc4xx",
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1297,6 +1302,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "ofb-aes-ppc4xx",
 			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
@@ -1327,6 +1333,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "ccm-aes-ppc4xx",
 			.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags	= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize	= 1,
@@ -1348,6 +1355,7 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 			.cra_driver_name = "gcm-aes-ppc4xx",
 			.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
 			.cra_flags	= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize	= 1,
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6e7ae896717c..98cfa00dfd8d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -55,6 +55,7 @@ static struct meson_alg_template mc_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
@@ -81,6 +82,7 @@ static struct meson_alg_template mc_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index f72c6b3e4ad8..8585bf7d4e66 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2422,7 +2422,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 
 static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
 {
-	alg->cra_flags |= CRYPTO_ALG_ASYNC;
+	alg->cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	alg->cra_alignmask = 0xf;
 	alg->cra_priority = ATMEL_AES_PRIORITY;
 	alg->cra_module = THIS_MODULE;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d1628112dacc..44b772d82947 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1254,7 +1254,7 @@ static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 static void atmel_sha_alg_init(struct ahash_alg *alg)
 {
 	alg->halg.base.cra_priority = ATMEL_SHA_PRIORITY;
-	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	alg->halg.base.cra_ctxsize = sizeof(struct atmel_sha_ctx);
 	alg->halg.base.cra_module = THIS_MODULE;
 	alg->halg.base.cra_init = atmel_sha_cra_init;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 9fd7b8e439d2..ba55533c2936 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -903,7 +903,7 @@ static int atmel_tdes_init_tfm(struct crypto_skcipher *tfm)
 static void atmel_tdes_skcipher_alg_init(struct skcipher_alg *alg)
 {
 	alg->base.cra_priority = ATMEL_TDES_PRIORITY;
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	alg->base.cra_ctxsize = sizeof(struct atmel_tdes_ctx);
 	alg->base.cra_module = THIS_MODULE;
 
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 9ad188cffd0d..7a8e91cb5c41 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2632,6 +2632,7 @@ static struct ahash_alg hash_algos[] = {
 			.cra_driver_name = "artpec-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
@@ -2656,6 +2657,7 @@ static struct ahash_alg hash_algos[] = {
 			.cra_driver_name = "artpec-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
@@ -2681,6 +2683,7 @@ static struct ahash_alg hash_algos[] = {
 			.cra_driver_name = "artpec-hmac-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
@@ -2701,6 +2704,7 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_driver_name = "artpec6-ecb-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
@@ -2722,6 +2726,7 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_driver_name = "artpec6-ctr-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -2745,6 +2750,7 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_driver_name = "artpec6-cbc-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
@@ -2767,6 +2773,7 @@ static struct skcipher_alg crypto_algos[] = {
 			.cra_driver_name = "artpec6-xts-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct artpec6_cryptotfm_context),
@@ -2798,6 +2805,7 @@ static struct aead_alg aead_algos[] = {
 			.cra_driver_name = "artpec-gcm-aes",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 053315e260c2..c016a152179c 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -3183,6 +3183,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3208,6 +3209,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3233,6 +3235,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3258,6 +3261,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3283,6 +3287,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3308,6 +3313,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3333,6 +3339,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3358,6 +3365,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3383,6 +3391,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3408,6 +3417,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3433,6 +3443,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3458,6 +3469,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3483,6 +3495,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3508,6 +3521,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3533,6 +3547,7 @@ static struct iproc_alg_s driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_NEED_FALLBACK |
 				     CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY
 		 },
 		 .setkey = aead_authenc_setkey,
@@ -3771,6 +3786,7 @@ static struct iproc_alg_s driver_algs[] = {
 				    .cra_driver_name = "md5-iproc",
 				    .cra_blocksize = MD5_BLOCK_WORDS * 4,
 				    .cra_flags = CRYPTO_ALG_ASYNC |
+					         CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						 CRYPTO_ALG_ALLOCATES_MEMORY,
 				}
 		      },
@@ -4270,6 +4286,7 @@ static int aead_cra_init(struct crypto_aead *aead)
 			ctx->fallback_cipher =
 			    crypto_alloc_aead(alg->cra_name, 0,
 					      CRYPTO_ALG_ASYNC |
+					      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					      CRYPTO_ALG_NEED_FALLBACK);
 			if (IS_ERR(ctx->fallback_cipher)) {
 				pr_err("%s() Error: failed to allocate fallback for %s\n",
@@ -4463,6 +4480,7 @@ static int spu_register_skcipher(struct iproc_alg_s *driver_alg)
 	crypto->base.cra_alignmask = 0;
 	crypto->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 	crypto->base.cra_flags = CRYPTO_ALG_ASYNC |
+			         CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				 CRYPTO_ALG_ALLOCATES_MEMORY |
 				 CRYPTO_ALG_KERN_DRIVER_ONLY;
 
@@ -4504,6 +4522,7 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
 	hash->halg.base.cra_init = ahash_cra_init;
 	hash->halg.base.cra_exit = generic_cra_exit;
 	hash->halg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				    CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				    CRYPTO_ALG_ALLOCATES_MEMORY;
 	hash->halg.statesize = sizeof(struct spu_hash_export_s);
 
@@ -4548,7 +4567,9 @@ static int spu_register_aead(struct iproc_alg_s *driver_alg)
 	aead->base.cra_alignmask = 0;
 	aead->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
 
-	aead->base.cra_flags |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+	aead->base.cra_flags |= CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	/* setkey set in alg initialization */
 	aead->setauthsize = aead_setauthsize;
 	aead->encrypt = aead_encrypt;
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d3d8bb0a6990..3fd5be64531e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3493,7 +3493,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY);
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+				CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
 	alg->exit = caam_cra_exit;
@@ -3507,6 +3508,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 189a7438b29c..8acdfb668fb8 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2581,6 +2581,7 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init;
@@ -2595,6 +2596,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_aead_init;
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6753f0e6e55d..bf2e1e1664df 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3010,7 +3010,8 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags |= (CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
-			      CRYPTO_ALG_KERN_DRIVER_ONLY);
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+				CRYPTO_ALG_KERN_DRIVER_ONLY);
 
 	alg->init = caam_cra_init_skcipher;
 	alg->exit = caam_cra_exit;
@@ -3024,6 +3025,7 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
 	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			      CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	alg->init = caam_cra_init_aead;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 36ef738e4a18..a882a5a0d3e5 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1930,7 +1930,8 @@ caam_hash_alloc(struct caam_hash_template *template,
 	alg->cra_priority = CAAM_CRA_PRIORITY;
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			 CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 
 	t_alg->alg_type = template->alg_type;
 
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index ce3b91c612f0..4f635dd49a3e 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -342,6 +342,7 @@ static int cvm_enc_dec_init(struct crypto_skcipher *tfm)
 
 static struct skcipher_alg algs[] = { {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
@@ -360,6 +361,7 @@ static struct skcipher_alg algs[] = { {
 	.init			= cvm_enc_dec_init,
 }, {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
@@ -378,6 +380,7 @@ static struct skcipher_alg algs[] = { {
 	.init			= cvm_enc_dec_init,
 }, {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
@@ -395,6 +398,7 @@ static struct skcipher_alg algs[] = { {
 	.init			= cvm_enc_dec_init,
 }, {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
@@ -413,6 +417,7 @@ static struct skcipher_alg algs[] = { {
 	.init			= cvm_enc_dec_init,
 }, {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
@@ -431,6 +436,7 @@ static struct skcipher_alg algs[] = { {
 	.init			= cvm_enc_dec_init,
 }, {
 	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/cavium/nitrox/nitrox_aead.c
index c93c4e41d267..367933433a72 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -521,7 +521,8 @@ static struct aead_alg nitrox_aeads[] = { {
 		.cra_name = "gcm(aes)",
 		.cra_driver_name = "n5_aes_gcm",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -540,7 +541,8 @@ static struct aead_alg nitrox_aeads[] = { {
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "n5_rfc4106",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 248b4fff1c72..b540b9eeed0c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -388,7 +388,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cbc(aes)",
 		.cra_driver_name = "n5_cbc(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -407,7 +408,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "ecb(aes)",
 		.cra_driver_name = "n5_ecb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -426,7 +428,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cfb(aes)",
 		.cra_driver_name = "n5_cfb(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -445,7 +448,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "xts(aes)",
 		.cra_driver_name = "n5_xts(aes)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -464,7 +468,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "rfc3686(ctr(aes))",
 		.cra_driver_name = "n5_rfc3686(ctr(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = 1,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -483,7 +488,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cts(cbc(aes))",
 		.cra_driver_name = "n5_cts(cbc(aes))",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -502,7 +508,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "cbc(des3_ede)",
 		.cra_driver_name = "n5_cbc(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
@@ -521,7 +528,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 		.cra_name = "ecb(des3_ede)",
 		.cra_driver_name = "n5_ecb(des3_ede)",
 		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 35794c7271fb..3f870736458f 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2642,6 +2642,9 @@ int cc_aead_alloc(struct cc_drvdata *drvdata)
 				aead_algs[alg].driver_name);
 			goto fail1;
 		}
+		if (!drvdata->coherent)
+			t_alg->aead_alg.base.cra_flags |=
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 		t_alg->drvdata = drvdata;
 		rc = crypto_register_aead(&t_alg->aead_alg);
 		if (rc) {
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 309da6334a0a..12b190a81d0d 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1484,6 +1484,9 @@ int cc_cipher_alloc(struct cc_drvdata *drvdata)
 				skcipher_algs[alg].driver_name);
 			goto fail0;
 		}
+		if (!drvdata->coherent)
+			t_alg->skcipher_alg.base.cra_flags |=
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 		t_alg->drvdata = drvdata;
 
 		dev_dbg(dev, "registering %s\n",
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 683c9a430e11..529f11168967 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -2013,6 +2013,9 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 					driver_hash[alg].driver_name);
 				goto fail;
 			}
+			if (!drvdata->coherent)
+				t_alg->ahash_alg.halg.base.cra_flags |=
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 			t_alg->drvdata = drvdata;
 
 			rc = crypto_register_ahash(&t_alg->ahash_alg);
@@ -2036,6 +2039,9 @@ int cc_hash_alloc(struct cc_drvdata *drvdata)
 				driver_hash[alg].driver_name);
 			goto fail;
 		}
+		if (!drvdata->coherent)
+			t_alg->ahash_alg.halg.base.cra_flags |=
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 		t_alg->drvdata = drvdata;
 
 		rc = crypto_register_ahash(&t_alg->ahash_alg);
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6933546f87b1..c64d28f3b526 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -4441,6 +4441,7 @@ static int chcr_register_alg(void)
 			driver_algs[i].alg.skcipher.base.cra_module = THIS_MODULE;
 			driver_algs[i].alg.skcipher.base.cra_flags =
 				CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
+			        CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK;
 			driver_algs[i].alg.skcipher.base.cra_ctxsize =
@@ -4454,6 +4455,7 @@ static int chcr_register_alg(void)
 		case CRYPTO_ALG_TYPE_AEAD:
 			driver_algs[i].alg.aead.base.cra_flags =
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK |
+			        CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_ALLOCATES_MEMORY;
 			driver_algs[i].alg.aead.encrypt = chcr_aead_encrypt;
 			driver_algs[i].alg.aead.decrypt = chcr_aead_decrypt;
@@ -4475,7 +4477,8 @@ static int chcr_register_alg(void)
 			a_hash->halg.base.cra_priority = CHCR_CRA_PRIORITY;
 			a_hash->halg.base.cra_module = THIS_MODULE;
 			a_hash->halg.base.cra_flags =
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			        CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 			a_hash->halg.base.cra_alignmask = 0;
 			a_hash->halg.base.cra_exit = NULL;
 
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index b7524b649068..bbed3fe6350a 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -224,6 +224,7 @@ static struct sl3516_ce_alg_template ce_algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
+				CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 			.cra_ctxsize = sizeof(struct sl3516_ce_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7e7a8f01ea6b..b08c77d7451a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2398,7 +2398,9 @@ static int hifn_alg_alloc(struct hifn_device *dev, const struct hifn_alg_templat
 		 t->drv_name, dev->name);
 
 	alg->alg.base.cra_priority = 300;
-	alg->alg.base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC;
+	alg->alg.base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	alg->alg.base.cra_blocksize = t->bsize;
 	alg->alg.base.cra_ctxsize = sizeof(struct hifn_context);
 	alg->alg.base.cra_alignmask = 0;
diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 0a3c8f019b02..e7f03344128e 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -935,6 +935,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_aes_ecb",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -955,6 +956,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_aes_cbc",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -975,6 +977,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_aes_ctr",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -995,6 +998,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_aes_xts",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -1016,6 +1020,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_des_ecb",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -1036,6 +1041,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_des_cbc",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -1056,6 +1062,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_3des_cbc",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
@@ -1076,6 +1083,7 @@ static struct skcipher_alg sec_algs[] = {
 			.cra_driver_name = "hisi_sec_3des_ecb",
 			.cra_priority = 4001,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct sec_alg_tfm_ctx),
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index a91635c348b5..837e98048dc9 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2113,6 +2113,7 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
 		.cra_flags = CRYPTO_ALG_ASYNC |\
+	         CRYPTO_ALG_NEED_DMA_ALIGNMENT |\
 		 CRYPTO_ALG_ALLOCATES_MEMORY |\
 		 CRYPTO_ALG_NEED_FALLBACK,\
 		.cra_blocksize = blk_size,\
@@ -2366,6 +2367,7 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
 		.cra_flags = CRYPTO_ALG_ASYNC |\
+	         CRYPTO_ALG_NEED_DMA_ALIGNMENT |\
 		 CRYPTO_ALG_ALLOCATES_MEMORY |\
 		 CRYPTO_ALG_NEED_FALLBACK,\
 		.cra_blocksize = blk_size,\
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 6dc3e171f474..c047f56fa249 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1283,6 +1283,7 @@ struct safexcel_alg_template safexcel_alg_ecb_aes = {
 			.cra_driver_name = "safexcel-ecb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1321,6 +1322,7 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 			.cra_driver_name = "safexcel-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1359,6 +1361,7 @@ struct safexcel_alg_template safexcel_alg_cfb_aes = {
 			.cra_driver_name = "safexcel-cfb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1397,6 +1400,7 @@ struct safexcel_alg_template safexcel_alg_ofb_aes = {
 			.cra_driver_name = "safexcel-ofb-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1472,6 +1476,7 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
 			.cra_driver_name = "safexcel-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -1533,6 +1538,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
 			.cra_driver_name = "safexcel-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -1571,6 +1577,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
 			.cra_driver_name = "safexcel-ecb-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -1632,6 +1639,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1670,6 +1678,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 			.cra_driver_name = "safexcel-ecb-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1743,6 +1752,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1779,6 +1789,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1815,6 +1826,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1851,6 +1863,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1887,6 +1900,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = AES_BLOCK_SIZE,
@@ -1924,6 +1938,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1961,6 +1976,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -1998,6 +2014,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2035,6 +2052,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2072,6 +2090,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des3_ede",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
@@ -2109,6 +2128,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -2146,6 +2166,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -2183,6 +2204,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -2220,6 +2242,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -2257,6 +2280,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-cbc-des",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = DES_BLOCK_SIZE,
@@ -2292,6 +2316,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2327,6 +2352,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha256-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2362,6 +2388,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha224-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2397,6 +2424,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha512-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2432,6 +2460,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha384-ctr-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2546,6 +2575,7 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 			.cra_driver_name = "safexcel-xts-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = XTS_BLOCK_SIZE,
@@ -2659,6 +2689,7 @@ struct safexcel_alg_template safexcel_alg_gcm = {
 			.cra_driver_name = "safexcel-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2783,6 +2814,7 @@ struct safexcel_alg_template safexcel_alg_ccm = {
 			.cra_driver_name = "safexcel-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -2847,6 +2879,7 @@ struct safexcel_alg_template safexcel_alg_chacha20 = {
 			.cra_driver_name = "safexcel-chacha20",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3009,6 +3042,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly = {
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
@@ -3049,6 +3083,7 @@ struct safexcel_alg_template safexcel_alg_chachapoly_esp = {
 			/* +1 to put it above HW chacha + SW poly */
 			.cra_priority = SAFEXCEL_CRA_PRIORITY + 1,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
@@ -3128,6 +3163,7 @@ struct safexcel_alg_template safexcel_alg_ecb_sm4 = {
 			.cra_driver_name = "safexcel-ecb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
@@ -3166,6 +3202,7 @@ struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
 			.cra_driver_name = "safexcel-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
@@ -3204,6 +3241,7 @@ struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
 			.cra_driver_name = "safexcel-ofb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3242,6 +3280,7 @@ struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
 			.cra_driver_name = "safexcel-cfb-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3295,6 +3334,7 @@ struct safexcel_alg_template safexcel_alg_ctr_sm4 = {
 			.cra_driver_name = "safexcel-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3355,6 +3395,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SM4_BLOCK_SIZE,
@@ -3465,6 +3506,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-cbc-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
@@ -3501,6 +3543,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sha1-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3536,6 +3579,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_ctr_sm4 = {
 			.cra_driver_name = "safexcel-authenc-hmac-sm3-ctr-sm4",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3605,6 +3649,7 @@ struct safexcel_alg_template safexcel_alg_rfc4106_gcm = {
 			.cra_driver_name = "safexcel-rfc4106-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3650,6 +3695,7 @@ struct safexcel_alg_template safexcel_alg_rfc4543_gcm = {
 			.cra_driver_name = "safexcel-rfc4543-gcm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
@@ -3742,6 +3788,7 @@ struct safexcel_alg_template safexcel_alg_rfc4309_ccm = {
 			.cra_driver_name = "safexcel-rfc4309-ccm-aes",
 			.cra_priority = SAFEXCEL_CRA_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index bc60b5802256..501c265f9053 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -997,6 +997,7 @@ struct safexcel_alg_template safexcel_alg_sha1 = {
 				.cra_driver_name = "safexcel-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1249,6 +1250,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 				.cra_driver_name = "safexcel-hmac-sha1",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1306,6 +1308,7 @@ struct safexcel_alg_template safexcel_alg_sha256 = {
 				.cra_driver_name = "safexcel-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
@@ -1363,6 +1366,7 @@ struct safexcel_alg_template safexcel_alg_sha224 = {
 				.cra_driver_name = "safexcel-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
@@ -1435,6 +1439,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
 				.cra_driver_name = "safexcel-hmac-sha224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
@@ -1507,6 +1512,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
 				.cra_driver_name = "safexcel-hmac-sha256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
@@ -1564,6 +1570,7 @@ struct safexcel_alg_template safexcel_alg_sha512 = {
 				.cra_driver_name = "safexcel-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
@@ -1621,6 +1628,7 @@ struct safexcel_alg_template safexcel_alg_sha384 = {
 				.cra_driver_name = "safexcel-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
@@ -1693,6 +1701,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
 				.cra_driver_name = "safexcel-hmac-sha512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
@@ -1765,6 +1774,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 				.cra_driver_name = "safexcel-hmac-sha384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
@@ -1822,6 +1832,7 @@ struct safexcel_alg_template safexcel_alg_md5 = {
 				.cra_driver_name = "safexcel-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
@@ -1895,6 +1906,7 @@ struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 				.cra_driver_name = "safexcel-hmac-md5",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
@@ -1977,6 +1989,7 @@ struct safexcel_alg_template safexcel_alg_crc32 = {
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
 					     CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
@@ -2067,6 +2080,7 @@ struct safexcel_alg_template safexcel_alg_cbcmac = {
 				.cra_driver_name = "safexcel-cbcmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = 1,
@@ -2162,6 +2176,7 @@ struct safexcel_alg_template safexcel_alg_xcbcmac = {
 				.cra_driver_name = "safexcel-xcbc-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -2258,6 +2273,7 @@ struct safexcel_alg_template safexcel_alg_cmac = {
 				.cra_driver_name = "safexcel-cmac-aes",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = AES_BLOCK_SIZE,
@@ -2315,6 +2331,7 @@ struct safexcel_alg_template safexcel_alg_sm3 = {
 				.cra_driver_name = "safexcel-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
@@ -2387,6 +2404,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sm3 = {
 				.cra_driver_name = "safexcel-hmac-sm3",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SM3_BLOCK_SIZE,
@@ -2580,6 +2598,7 @@ struct safexcel_alg_template safexcel_alg_sha3_224 = {
 				.cra_driver_name = "safexcel-sha3-224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
@@ -2638,6 +2657,7 @@ struct safexcel_alg_template safexcel_alg_sha3_256 = {
 				.cra_driver_name = "safexcel-sha3-256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
@@ -2696,6 +2716,7 @@ struct safexcel_alg_template safexcel_alg_sha3_384 = {
 				.cra_driver_name = "safexcel-sha3-384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
@@ -2754,6 +2775,7 @@ struct safexcel_alg_template safexcel_alg_sha3_512 = {
 				.cra_driver_name = "safexcel-sha3-512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
@@ -2917,6 +2939,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha3_224 = {
 				.cra_driver_name = "safexcel-hmac-sha3-224",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
@@ -2988,6 +3011,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha3_256 = {
 				.cra_driver_name = "safexcel-hmac-sha3-256",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
@@ -3059,6 +3083,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha3_384 = {
 				.cra_driver_name = "safexcel-hmac-sha3-384",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
@@ -3129,6 +3154,7 @@ struct safexcel_alg_template safexcel_alg_hmac_sha3_512 = {
 				.cra_driver_name = "safexcel-hmac-sha3-512",
 				.cra_priority = SAFEXCEL_CRA_PRIORITY,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_KERN_DRIVER_ONLY |
 					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index d39a386b31ac..c0814a82aaf7 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1503,6 +1503,7 @@ static int ixp_crypto_probe(struct platform_device *_pdev)
 		/* block ciphers */
 		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
 				      CRYPTO_ALG_ASYNC |
+				      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				      CRYPTO_ALG_ALLOCATES_MEMORY |
 				      CRYPTO_ALG_NEED_FALLBACK;
 		if (!cra->setkey)
@@ -1538,6 +1539,7 @@ static int ixp_crypto_probe(struct platform_device *_pdev)
 		/* authenc */
 		cra->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
 				      CRYPTO_ALG_ASYNC |
+				      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				      CRYPTO_ALG_ALLOCATES_MEMORY;
 		cra->setkey = cra->setkey ?: aead_setkey;
 		cra->setauthsize = aead_setauthsize;
diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index e2a39fdaf623..faf81a156275 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1287,6 +1287,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "ecb-aes-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
@@ -1308,6 +1309,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "cbc-aes-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
@@ -1329,6 +1331,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "ctr-aes-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize = 1,
@@ -1351,6 +1354,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "cts-aes-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
@@ -1374,6 +1378,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "ecb-sm4-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
@@ -1394,6 +1399,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "cbc-sm4-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
@@ -1414,6 +1420,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "ctr-sm4-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
@@ -1435,6 +1442,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name = "cts-sm4-keembay-ocs",
 		.base.cra_priority = KMB_OCS_PRIORITY,
 		.base.cra_flags = CRYPTO_ALG_ASYNC |
+			          CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct ocs_aes_tctx),
@@ -1460,6 +1468,7 @@ static struct aead_alg algs_aead[] = {
 			.cra_driver_name = "gcm-aes-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -1482,6 +1491,7 @@ static struct aead_alg algs_aead[] = {
 			.cra_driver_name = "ccm-aes-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = 1,
@@ -1504,6 +1514,7 @@ static struct aead_alg algs_aead[] = {
 			.cra_driver_name = "gcm-sm4-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct ocs_aes_tctx),
@@ -1525,6 +1536,7 @@ static struct aead_alg algs_aead[] = {
 			.cra_driver_name = "ccm-sm4-keembay-ocs",
 			.cra_priority = KMB_OCS_PRIORITY,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = 1,
 			.cra_ctxsize = sizeof(struct ocs_aes_tctx),
diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
index 0379dbf32a4c..57be3e96de7e 100644
--- a/drivers/crypto/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -900,7 +900,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "sha224",
 			.cra_driver_name	= "sha224-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA224_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -925,7 +926,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "hmac(sha224)",
 			.cra_driver_name	= "hmac-sha224-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA224_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -951,7 +953,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "sha256-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -976,7 +979,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "hmac(sha256)",
 			.cra_driver_name	= "hmac-sha256-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1001,7 +1005,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "sm3",
 			.cra_driver_name	= "sm3-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SM3_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1026,7 +1031,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "hmac(sm3)",
 			.cra_driver_name	= "hmac-sm3-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SM3_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1051,7 +1057,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "sha384",
 			.cra_driver_name	= "sha384-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA384_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1076,7 +1083,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "hmac(sha384)",
 			.cra_driver_name	= "hmac-sha384-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA384_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1101,7 +1109,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "sha512",
 			.cra_driver_name	= "sha512-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA512_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
@@ -1126,7 +1135,8 @@ static struct ahash_alg ocs_hcu_algs[] = {
 			.cra_name		= "hmac(sha512)",
 			.cra_driver_name	= "hmac-sha512-keembay-ocs",
 			.cra_priority		= 255,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA512_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
 			.cra_alignmask		= 0,
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index b739d3b873dc..e558aa3fec0b 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -520,6 +520,7 @@ struct skcipher_alg mv_cesa_ecb_des_alg = {
 		.cra_driver_name = "mv-ecb-des",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
@@ -571,6 +572,7 @@ struct skcipher_alg mv_cesa_cbc_des_alg = {
 		.cra_driver_name = "mv-cbc-des",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des_ctx),
@@ -630,6 +632,7 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 		.cra_driver_name = "mv-ecb-des3-ede",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
@@ -684,6 +687,7 @@ struct skcipher_alg mv_cesa_cbc_des3_ede_alg = {
 		.cra_driver_name = "mv-cbc-des3-ede",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_des3_ctx),
@@ -757,6 +761,7 @@ struct skcipher_alg mv_cesa_ecb_aes_alg = {
 		.cra_driver_name = "mv-ecb-aes",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
@@ -807,6 +812,7 @@ struct skcipher_alg mv_cesa_cbc_aes_alg = {
 		.cra_driver_name = "mv-cbc-aes",
 		.cra_priority = 300,
 		.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_blocksize = AES_BLOCK_SIZE,
 		.cra_ctxsize = sizeof(struct mv_cesa_aes_ctx),
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index c72b0672fc71..b37bf6d4383f 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -949,6 +949,7 @@ struct ahash_alg mv_md5_alg = {
 			.cra_driver_name = "mv-md5",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
@@ -1020,6 +1021,7 @@ struct ahash_alg mv_sha1_alg = {
 			.cra_driver_name = "mv-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1094,6 +1096,7 @@ struct ahash_alg mv_sha256_alg = {
 			.cra_driver_name = "mv-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
@@ -1329,6 +1332,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 			.cra_driver_name = "mv-hmac-md5",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
@@ -1400,6 +1404,7 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 			.cra_driver_name = "mv-hmac-sha1",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA1_BLOCK_SIZE,
@@ -1471,6 +1476,7 @@ struct ahash_alg mv_ahmac_sha256_alg = {
 			.cra_driver_name = "mv-hmac-sha256",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_blocksize = SHA256_BLOCK_SIZE,
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 01c48ddc4eeb..8c43eeb12d08 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1302,7 +1302,9 @@ static int otx_cpt_aead_null_decrypt(struct aead_request *req)
 static struct skcipher_alg otx_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1319,7 +1321,9 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "cpt_cbc_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1336,7 +1340,9 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(aes)",
 	.base.cra_driver_name = "cpt_ecb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1353,7 +1359,9 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cfb(aes)",
 	.base.cra_driver_name = "cpt_cfb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1370,7 +1378,9 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(des3_ede)",
 	.base.cra_driver_name = "cpt_cbc_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1387,7 +1397,9 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(des3_ede)",
 	.base.cra_driver_name = "cpt_ecb_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_ALLOCATES_MEMORY,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx_cpt_des3_ctx),
 	.base.cra_alignmask = 7,
@@ -1408,7 +1420,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1427,7 +1441,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1446,7 +1462,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1465,7 +1483,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1484,7 +1504,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1503,7 +1525,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1522,7 +1546,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1541,7 +1567,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1560,7 +1588,9 @@ static struct aead_alg otx_cpt_aeads[] = { {
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "cpt_rfc4106_gcm_aes",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct otx_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index f8f8542ce3e4..18bb4a822fe9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1368,7 +1368,9 @@ static int otx2_cpt_aead_null_decrypt(struct aead_request *req)
 static struct skcipher_alg otx2_cpt_skciphers[] = { {
 	.base.cra_name = "xts(aes)",
 	.base.cra_driver_name = "cpt_xts_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1386,7 +1388,9 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(aes)",
 	.base.cra_driver_name = "cpt_cbc_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1404,7 +1408,9 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(aes)",
 	.base.cra_driver_name = "cpt_ecb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = AES_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1422,7 +1428,9 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "cbc(des3_ede)",
 	.base.cra_driver_name = "cpt_cbc_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1440,7 +1448,9 @@ static struct skcipher_alg otx2_cpt_skciphers[] = { {
 }, {
 	.base.cra_name = "ecb(des3_ede)",
 	.base.cra_driver_name = "cpt_ecb_des3_ede",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
 	.base.cra_alignmask = 7,
@@ -1462,7 +1472,9 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_NEED_FALLBACK,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1481,7 +1493,9 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_NEED_FALLBACK,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1500,7 +1514,9 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_NEED_FALLBACK,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1519,7 +1535,9 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),cbc(aes))",
 		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
 		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_NEED_FALLBACK,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1538,7 +1556,8 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1557,7 +1576,8 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1576,7 +1596,8 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1595,7 +1616,8 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
 		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
@@ -1614,7 +1636,9 @@ static struct aead_alg otx2_cpt_aeads[] = { {
 		.cra_name = "rfc4106(gcm(aes))",
 		.cra_driver_name = "cpt_rfc4106_gcm_aes",
 		.cra_blocksize = 1,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags = CRYPTO_ALG_ASYNC |
+			     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
+			     CRYPTO_ALG_NEED_FALLBACK,
 		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
 		.cra_priority = 4001,
 		.cra_alignmask = 0,
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d6f9e2fe863d..0f3f8f55c2df 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -858,6 +858,7 @@ static struct skcipher_alg dcp_aes_algs[] = {
 		.base.cra_priority	= 400,
 		.base.cra_alignmask	= 15,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct dcp_async_ctx),
@@ -876,6 +877,7 @@ static struct skcipher_alg dcp_aes_algs[] = {
 		.base.cra_priority	= 400,
 		.base.cra_alignmask	= 15,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct dcp_async_ctx),
@@ -909,7 +911,8 @@ static struct ahash_alg dcp_sha1_alg = {
 			.cra_driver_name	= "sha1-dcp",
 			.cra_priority		= 400,
 			.cra_alignmask		= 63,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA1_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
 			.cra_module		= THIS_MODULE,
@@ -936,7 +939,8 @@ static struct ahash_alg dcp_sha256_alg = {
 			.cra_driver_name	= "sha256-dcp",
 			.cra_priority		= 400,
 			.cra_alignmask		= 63,
-			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dcp_async_ctx),
 			.cra_module		= THIS_MODULE,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 3b0bf6fea491..d369b658c994 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1338,6 +1338,7 @@ static int __n2_register_one_skcipher(const struct n2_skcipher_tmpl *tmpl)
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s-n2", tmpl->drv_name);
 	alg->base.cra_priority = N2_CRA_PRIORITY;
 	alg->base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY | CRYPTO_ALG_ASYNC |
+			      CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 			      CRYPTO_ALG_ALLOCATES_MEMORY;
 	alg->base.cra_blocksize = tmpl->block_size;
 	p->enc_type = tmpl->enc_type;
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 581211a92628..e5ce2ae0413b 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -675,6 +675,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_aes_ctx),
@@ -694,6 +695,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_aes_ctx),
@@ -717,6 +719,7 @@ static struct skcipher_alg algs_ctr[] = {
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_NEED_FALLBACK,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct omap_aes_ctx),
@@ -747,6 +750,7 @@ static struct aead_alg algs_aead_gcm[] = {
 		.cra_driver_name	= "gcm-aes-omap",
 		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct omap_aes_gcm_ctx),
@@ -767,6 +771,7 @@ static struct aead_alg algs_aead_gcm[] = {
 		.cra_driver_name	= "rfc4106-gcm-aes-omap",
 		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct omap_aes_gcm_ctx),
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 538aff80869f..0f921118e6ab 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -737,6 +737,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_driver_name	= "ecb-des-omap",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_des_ctx),
@@ -754,6 +755,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_driver_name	= "cbc-des-omap",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_des_ctx),
@@ -772,6 +774,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_driver_name	= "ecb-des3-omap",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_des_ctx),
@@ -789,6 +792,7 @@ static struct skcipher_alg algs_ecb_cbc[] = {
 	.base.cra_driver_name	= "cbc-des3-omap",
 	.base.cra_priority	= 300,
 	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 				  CRYPTO_ALG_ASYNC,
 	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct omap_des_ctx),
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 4b37dc69a50c..78a866205cb6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1437,6 +1437,7 @@ static struct ahash_alg algs_sha1_md5[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1459,6 +1460,7 @@ static struct ahash_alg algs_sha1_md5[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1482,6 +1484,7 @@ static struct ahash_alg algs_sha1_md5[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
@@ -1506,6 +1509,7 @@ static struct ahash_alg algs_sha1_md5[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
@@ -1533,6 +1537,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA224_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1555,6 +1560,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1578,6 +1584,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA224_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
@@ -1602,6 +1609,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
@@ -1628,6 +1636,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1650,6 +1659,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
@@ -1673,6 +1683,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA384_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
@@ -1697,6 +1708,7 @@ static struct ahash_alg algs_sha384_sha512[] = {
 		.cra_priority		= 400,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA512_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 97a530171f07..00fabebb7383 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -788,6 +788,7 @@ static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_devi
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_NEED_FALLBACK;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 59159f5e64e5..ff3290e8c6a8 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -481,7 +481,8 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 300;
-	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_DMA_ALIGNMENT;
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 3d27cd5210ef..b626812b4325 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -463,6 +463,7 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->base.cra_ctxsize		= sizeof(struct qce_cipher_ctx);
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index ed03058497bc..dfe13babf1ec 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -330,6 +330,7 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 				  .cra_driver_name = "rk-sha1",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
@@ -360,6 +361,7 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 				  .cra_driver_name = "rk-sha256",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA256_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
@@ -390,6 +392,7 @@ struct rk_crypto_tmp rk_ahash_md5 = {
 				  .cra_driver_name = "rk-md5",
 				  .cra_priority = 300,
 				  .cra_flags = CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					       CRYPTO_ALG_NEED_FALLBACK,
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 5bbf0d2722e1..98a3a9830bb3 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -406,7 +406,8 @@ struct rk_crypto_tmp rk_ecb_aes_alg = {
 		.base.cra_name		= "ecb(aes)",
 		.base.cra_driver_name	= "ecb-aes-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x0f,
@@ -428,7 +429,8 @@ struct rk_crypto_tmp rk_cbc_aes_alg = {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "cbc-aes-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x0f,
@@ -451,7 +453,8 @@ struct rk_crypto_tmp rk_ecb_des_alg = {
 		.base.cra_name		= "ecb(des)",
 		.base.cra_driver_name	= "ecb-des-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x07,
@@ -473,7 +476,8 @@ struct rk_crypto_tmp rk_cbc_des_alg = {
 		.base.cra_name		= "cbc(des)",
 		.base.cra_driver_name	= "cbc-des-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x07,
@@ -496,7 +500,8 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 		.base.cra_name		= "ecb(des3_ede)",
 		.base.cra_driver_name	= "ecb-des3-ede-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x07,
@@ -518,7 +523,8 @@ struct rk_crypto_tmp rk_cbc_des3_ede_alg = {
 		.base.cra_name		= "cbc(des3_ede)",
 		.base.cra_driver_name	= "cbc-des3-ede-rk",
 		.base.cra_priority	= 300,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.base.cra_blocksize	= DES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct rk_cipher_ctx),
 		.base.cra_alignmask	= 0x07,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7717e9e5977b..bc7c0143adef 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1744,6 +1744,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
@@ -1769,6 +1770,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
@@ -1794,6 +1796,7 @@ static struct ahash_alg algs_sha1_md5_sha256[] = {
 		.cra_priority		= 100,
 		.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= HASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
@@ -2100,6 +2103,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name	= "ecb-aes-s5p",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
@@ -2118,6 +2122,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name	= "cbc-aes-s5p",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= AES_BLOCK_SIZE,
 		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
@@ -2137,6 +2142,7 @@ static struct skcipher_alg algs[] = {
 		.base.cra_driver_name	= "ctr-aes-s5p",
 		.base.cra_priority	= 100,
 		.base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY,
 		.base.cra_blocksize	= 1,
 		.base.cra_ctxsize	= sizeof(struct s5p_aes_ctx),
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 51b58e57153f..c4e81acaedd0 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1979,6 +1979,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
@@ -2002,6 +2003,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
@@ -2024,6 +2026,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
@@ -2047,6 +2050,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
@@ -2069,6 +2073,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 				.cra_priority	= 400,
 				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA1_BLOCK_SIZE,
@@ -2098,6 +2103,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 				.cra_priority	= 400,
 				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA256_BLOCK_SIZE,
@@ -2127,6 +2133,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 				.cra_priority	= 400,
 				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
 						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY |
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA512_BLOCK_SIZE,
@@ -2158,6 +2165,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
 					CRYPTO_ALG_KERN_DRIVER_ONLY |
 					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
 				.cra_module = THIS_MODULE,
@@ -2185,6 +2193,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
 					CRYPTO_ALG_KERN_DRIVER_ONLY |
 					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_NEED_FALLBACK,
 				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
 				.cra_module = THIS_MODULE,
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 457084b344c1..b09d39ec315a 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1182,7 +1182,9 @@ static struct skcipher_alg aes_algs[] = {
 	.base.cra_name		= "ecb(aes)",
 	.base.cra_driver_name	= "sahara-ecb-aes",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_FALLBACK |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
 	.base.cra_alignmask	= 0x0,
@@ -1199,7 +1201,9 @@ static struct skcipher_alg aes_algs[] = {
 	.base.cra_name		= "cbc(aes)",
 	.base.cra_driver_name	= "sahara-cbc-aes",
 	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_FALLBACK |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
 	.base.cra_alignmask	= 0x0,
@@ -1232,7 +1236,8 @@ static struct ahash_alg sha_v3_algs[] = {
 		.cra_driver_name	= "sahara-sha1",
 		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+					  CRYPTO_ALG_NEED_FALLBACK |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct sahara_ctx),
 		.cra_alignmask		= 0,
@@ -1258,7 +1263,8 @@ static struct ahash_alg sha_v4_algs[] = {
 		.cra_driver_name	= "sahara-sha256",
 		.cra_priority		= 300,
 		.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+					  CRYPTO_ALG_NEED_FALLBACK |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct sahara_ctx),
 		.cra_alignmask		= 0,
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 59ef541123ae..2771100f756d 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1558,7 +1558,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "ecb(aes)",
 	.base.cra_driver_name	= "stm32-ecb-aes",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1575,7 +1576,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "cbc(aes)",
 	.base.cra_driver_name	= "stm32-cbc-aes",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1593,7 +1595,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "ctr(aes)",
 	.base.cra_driver_name	= "stm32-ctr-aes",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= 1,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1611,7 +1614,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "ecb(des)",
 	.base.cra_driver_name	= "stm32-ecb-des",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1628,7 +1632,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "cbc(des)",
 	.base.cra_driver_name	= "stm32-cbc-des",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1646,7 +1651,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "ecb(des3_ede)",
 	.base.cra_driver_name	= "stm32-ecb-des3",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1663,7 +1669,8 @@ static struct skcipher_alg crypto_algs[] = {
 	.base.cra_name		= "cbc(des3_ede)",
 	.base.cra_driver_name	= "stm32-cbc-des3",
 	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 	.base.cra_blocksize	= DES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
 	.base.cra_alignmask	= 0,
@@ -1693,7 +1700,8 @@ static struct aead_alg aead_algs[] = {
 		.cra_name		= "gcm(aes)",
 		.cra_driver_name	= "stm32-gcm-aes",
 		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
 		.cra_alignmask		= 0,
@@ -1713,7 +1721,8 @@ static struct aead_alg aead_algs[] = {
 		.cra_name		= "ccm(aes)",
 		.cra_driver_name	= "stm32-ccm-aes",
 		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct stm32_cryp_ctx),
 		.cra_alignmask		= 0,
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d33006d43f76..ad3bd4c9a745 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1138,6 +1138,7 @@ static struct ahash_alg algs_md5_sha1[] = {
 				.cra_driver_name = "stm32-md5",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1164,6 +1165,7 @@ static struct ahash_alg algs_md5_sha1[] = {
 				.cra_driver_name = "stm32-hmac-md5",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1189,6 +1191,7 @@ static struct ahash_alg algs_md5_sha1[] = {
 				.cra_driver_name = "stm32-sha1",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1215,6 +1218,7 @@ static struct ahash_alg algs_md5_sha1[] = {
 				.cra_driver_name = "stm32-hmac-sha1",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1243,6 +1247,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 				.cra_driver_name = "stm32-sha224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1269,6 +1274,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 				.cra_driver_name = "stm32-hmac-sha224",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1294,6 +1300,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 				.cra_driver_name = "stm32-sha256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
@@ -1320,6 +1327,7 @@ static struct ahash_alg algs_sha224_sha256[] = {
 				.cra_driver_name = "stm32-hmac-sha256",
 				.cra_priority = 200,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					CRYPTO_ALG_KERN_DRIVER_ONLY,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct stm32_hash_ctx),
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 25c9f825b8b5..47033e27756c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2270,6 +2270,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2292,6 +2293,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2314,6 +2316,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2339,6 +2342,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2362,6 +2366,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2384,6 +2389,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2406,6 +2412,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2431,6 +2438,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2454,6 +2462,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2476,6 +2485,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2498,6 +2508,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2523,6 +2534,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2546,6 +2558,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2568,6 +2581,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2591,6 +2605,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2613,6 +2628,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2636,6 +2652,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2658,6 +2675,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-aes-talitos-hsna",
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = AES_BLOCK_SIZE,
@@ -2679,6 +2697,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2703,6 +2722,7 @@ static struct talitos_alg_template driver_algs[] = {
 						   "cbc-3des-talitos-hsna",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			},
 			.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2725,6 +2745,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "ecb-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
@@ -2739,6 +2760,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "cbc-aes-talitos",
 			.base.cra_blocksize = AES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
@@ -2755,6 +2777,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
@@ -2771,6 +2794,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "ctr-aes-talitos",
 			.base.cra_blocksize = 1,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
@@ -2787,6 +2811,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "ecb-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
@@ -2801,6 +2826,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "cbc-des-talitos",
 			.base.cra_blocksize = DES_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
@@ -2817,6 +2843,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "ecb-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
@@ -2832,6 +2859,7 @@ static struct talitos_alg_template driver_algs[] = {
 			.base.cra_driver_name = "cbc-3des-talitos",
 			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
@@ -2853,6 +2881,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2869,6 +2898,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2885,6 +2915,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2901,6 +2932,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2917,6 +2949,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2933,6 +2966,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2949,6 +2983,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-md5-talitos",
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2965,6 +3000,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-sha1-talitos",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2981,6 +3017,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-sha224-talitos",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -2997,6 +3034,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-sha256-talitos",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -3013,6 +3051,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-sha384-talitos",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
@@ -3029,6 +3068,7 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_driver_name = "hmac-sha512-talitos",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					     CRYPTO_ALG_ALLOCATES_MEMORY,
 			}
 		},
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 5a57c9afd8c8..77a8798e1144 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1072,7 +1072,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "ecb(aes)",
 			.base.cra_driver_name	= "ecb-aes-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1092,7 +1093,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "cbc(aes)",
 			.base.cra_driver_name	= "cbc-aes-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1113,7 +1115,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "ctr(aes)",
 			.base.cra_driver_name	= "ctr-aes-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= 1,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1135,7 +1138,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "ecb(des)",
 			.base.cra_driver_name	= "ecb-des-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1155,7 +1159,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "ecb(des3_ede)",
 			.base.cra_driver_name	= "ecb-des3_ede-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1175,7 +1180,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "cbc(des)",
 			.base.cra_driver_name	= "cbc-des-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
@@ -1196,7 +1202,8 @@ static struct cryp_algo_template cryp_algs[] = {
 			.base.cra_name		= "cbc(des3_ede)",
 			.base.cra_driver_name	= "cbc-des3_ede-ux500",
 			.base.cra_priority	= 300,
-			.base.cra_flags		= CRYPTO_ALG_ASYNC,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct cryp_ctx),
 			.base.cra_alignmask	= 3,
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5157c118d642..a8d8a157bed0 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1536,7 +1536,8 @@ static struct hash_algo_template hash_algs[] = {
 			.halg.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "sha1-ux500",
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct hash_ctx),
 				.cra_init = hash_cra_init,
@@ -1559,7 +1560,8 @@ static struct hash_algo_template hash_algs[] = {
 			.halg.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "sha256-ux500",
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct hash_ctx),
 				.cra_init = hash_cra_init,
@@ -1583,7 +1585,8 @@ static struct hash_algo_template hash_algs[] = {
 			.halg.base = {
 				.cra_name = "hmac(sha1)",
 				.cra_driver_name = "hmac-sha1-ux500",
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct hash_ctx),
 				.cra_init = hash_cra_init,
@@ -1607,7 +1610,8 @@ static struct hash_algo_template hash_algs[] = {
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "hmac-sha256-ux500",
-				.cra_flags = CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_DMA_ALIGNMENT,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct hash_ctx),
 				.cra_init = hash_cra_init,
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index bf1f421e05f2..40f53182f0f3 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -365,6 +365,7 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 		.cra_priority		= 200,
 		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
 					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_DMA_ALIGNMENT |
 					  CRYPTO_ALG_ALLOCATES_MEMORY |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY |
 					  CRYPTO_ALG_NEED_FALLBACK,
-- 
2.30.2

