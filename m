Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E4AC3526C
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD4C23382
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgLPLtG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 06:49:06 -0500
Received: from mga05.intel.com ([192.55.52.43]:25431 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgLPLtG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 06:49:06 -0500
IronPort-SDR: 8l3q8mRDV4vlHEduCe9CZja/DYEsbytgFt+phRZw59IQGsUCXASe3jIwZaT8NzuYJbEq1yGEZ8
 sqmEkBJSIkRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="259775336"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="259775336"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:20 -0800
IronPort-SDR: 1HCkqxajkwDsjo8q12L7M1GdBZUxTflXvOxRGW4qNuq37//PGE5ZDYhrv4zxvQeo0OfouES+A7
 dGZ6pP09CWYg==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="368985185"
Received: from johnlyon-mobl.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.90.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:17 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v4 4/5] crypto: keembay-ocs-hcu - Add optional support for sha224
Date:   Wed, 16 Dec 2020 11:46:38 +0000
Message-Id: <20201216114639.3451399-5-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
References: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>

Add optional support of sha224 and hmac(sha224).

Co-developed-by: Declan Murphy <declan.murphy@intel.com>
Signed-off-by: Declan Murphy <declan.murphy@intel.com>
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
---
 drivers/crypto/keembay/Kconfig                | 12 ++++
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 63 +++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/crypto/keembay/Kconfig b/drivers/crypto/keembay/Kconfig
index a4e7a1626cef..2b2f514f116b 100644
--- a/drivers/crypto/keembay/Kconfig
+++ b/drivers/crypto/keembay/Kconfig
@@ -54,3 +54,15 @@ config CRYPTO_DEV_KEEMBAY_OCS_HCU
 	  as a module, the module will be called keembay-ocs-hcu.
 
 	  If unsure, say N.
+
+config CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	bool "Enable sha224 and hmac(sha224) support in Intel Keem Bay OCS HCU"
+	depends on CRYPTO_DEV_KEEMBAY_OCS_HCU
+	help
+	  Enables support for sha224 and hmac(sha224) algorithms in the Intel
+	  Keem Bay OCS HCU driver. Intel recommends not to use these
+	  algorithms.
+
+	  Provides OCS HCU hardware acceleration of sha224 and hmac(224).
+
+	  If unsure, say N.
diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
index 37c4b4a689a8..d547af047131 100644
--- a/drivers/crypto/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -575,6 +575,12 @@ static int kmb_ocs_hcu_init(struct ahash_request *req)
 	rctx->dig_sz = crypto_ahash_digestsize(tfm);
 
 	switch (rctx->dig_sz) {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	case SHA224_DIGEST_SIZE:
+		rctx->blk_sz = SHA224_BLOCK_SIZE;
+		rctx->algo = OCS_HCU_ALGO_SHA224;
+		break;
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
 	case SHA256_DIGEST_SIZE:
 		rctx->blk_sz = SHA256_BLOCK_SIZE;
 		/*
@@ -765,6 +771,11 @@ static int kmb_ocs_hcu_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 
 	switch (digestsize) {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+	case SHA224_DIGEST_SIZE:
+		alg_name = "sha224-keembay-ocs";
+		break;
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
 	case SHA256_DIGEST_SIZE:
 		alg_name = ctx->is_sm3_tfm ? "sm3-keembay-ocs" :
 					     "sha256-keembay-ocs";
@@ -873,6 +884,58 @@ static void kmb_ocs_hcu_hmac_cra_exit(struct crypto_tfm *tfm)
 }
 
 static struct ahash_alg ocs_hcu_algs[] = {
+#ifdef CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.halg = {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "sha224",
+			.cra_driver_name	= "sha224-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA224_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_sha_cra_init,
+		}
+	}
+},
+{
+	.init		= kmb_ocs_hcu_init,
+	.update		= kmb_ocs_hcu_update,
+	.final		= kmb_ocs_hcu_final,
+	.finup		= kmb_ocs_hcu_finup,
+	.digest		= kmb_ocs_hcu_digest,
+	.export		= kmb_ocs_hcu_export,
+	.import		= kmb_ocs_hcu_import,
+	.setkey		= kmb_ocs_hcu_setkey,
+	.halg = {
+		.digestsize	= SHA224_DIGEST_SIZE,
+		.statesize	= sizeof(struct ocs_hcu_rctx),
+		.base	= {
+			.cra_name		= "hmac(sha224)",
+			.cra_driver_name	= "hmac-sha224-keembay-ocs",
+			.cra_priority		= 255,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA224_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct ocs_hcu_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= kmb_ocs_hcu_hmac_cra_init,
+			.cra_exit		= kmb_ocs_hcu_hmac_cra_exit,
+		}
+	}
+},
+#endif /* CONFIG_CRYPTO_DEV_KEEMBAY_OCS_HCU_HMAC_SHA224 */
 {
 	.init		= kmb_ocs_hcu_init,
 	.update		= kmb_ocs_hcu_update,
-- 
2.26.2

