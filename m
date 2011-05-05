From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 02/10] mv_cesa: the descriptor pointer register needs to be set just once
Date: Thu,  5 May 2011 15:28:58 +0200
Message-ID: <1304602146-5918-2-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:44323 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1EENjq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:46 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index c443246..889c098 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -275,7 +275,6 @@ static void mv_process_current_q(int first_block)
 	memcpy(cpg->sram + SRAM_CONFIG, &op,
 			sizeof(struct sec_accel_config));
 
-	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 	/* GO */
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 
@@ -349,7 +348,6 @@ static void mv_process_hash_current(int first_block)
 
 	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));
 
-	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 	/* GO */
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
 
@@ -1063,6 +1061,7 @@ static int mv_probe(struct platform_device *pdev)
 
 	writel(SEC_INT_ACCEL0_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
 	writel(SEC_CFG_STOP_DIG_ERR, cpg->reg + SEC_ACCEL_CFG);
+	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 
 	ret = crypto_register_alg(&mv_aes_alg_ecb);
 	if (ret)
-- 
1.7.4.1
