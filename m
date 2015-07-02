From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 08/10] crypto: omap-aes: gmc: Add algo info
Date: Thu, 2 Jul 2015 10:48:38 +0530
Message-ID: <1435814320-30347-9-git-send-email-lokeshvutla@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35635 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbGBFWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 01:22:06 -0400
In-Reply-To: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now the driver supports gcm mode, add omap-aes-gcm
algo info to omap-aes driver.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index e5e9a19..11f3850 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -789,6 +789,28 @@ static struct crypto_alg algs_ctr[] = {
 		.decrypt	= omap_aes_ctr_decrypt,
 	}
 },
+{
+	.cra_name		= "gcm(aes)",
+	.cra_driver_name	= "gcm-aes-omap",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
+	.cra_alignmask		= 0xf,
+	.cra_type		= &crypto_aead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= omap_aes_gcm_cra_init,
+	.cra_exit		= omap_aes_cra_exit,
+	.cra_u.aead = {
+		.maxauthsize	= AES_BLOCK_SIZE,
+		.geniv		= "eseqiv",
+		.ivsize		= AES_BLOCK_SIZE,
+		.setkey		= omap_aes_gcm_setkey,
+		.encrypt	= omap_aes_gcm_encrypt,
+		.decrypt	= omap_aes_gcm_decrypt,
+	}
+},
 };
 
 static struct omap_aes_algs_info omap_aes_algs_info_ecb_cbc[] = {
-- 
1.7.9.5
