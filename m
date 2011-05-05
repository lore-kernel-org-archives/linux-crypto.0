From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 04/10] mv_cesa: print a warning when registration of AES algos fail
Date: Thu,  5 May 2011 15:29:00 +0200
Message-ID: <1304602146-5918-4-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:35671 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENj6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:58 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 4aac294..c018cd0 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1061,12 +1061,18 @@ static int mv_probe(struct platform_device *pdev)
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 
 	ret = crypto_register_alg(&mv_aes_alg_ecb);
-	if (ret)
+	if (ret) {
+		printk(KERN_WARNING MV_CESA
+		       "Could not register aes-ecb driver\n");
 		goto err_irq;
+	}
 
 	ret = crypto_register_alg(&mv_aes_alg_cbc);
-	if (ret)
+	if (ret) {
+		printk(KERN_WARNING MV_CESA
+		       "Could not register aes-cbc driver\n");
 		goto err_unreg_ecb;
+	}
 
 	ret = crypto_register_ahash(&mv_sha1_alg);
 	if (ret == 0)
-- 
1.7.4.1
