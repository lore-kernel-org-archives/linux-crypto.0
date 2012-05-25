From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 3/4] mv_cesa: initialise the interrupt status field to zero
Date: Fri, 25 May 2012 15:54:48 +0200
Message-ID: <1337954089-12702-3-git-send-email-phil.sutter@viprinet.com>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:45589 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab2EYOCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 10:02:18 -0400
In-Reply-To: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 4a1f872..d4763fb 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1073,6 +1073,7 @@ static int mv_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_thread;
 
+	writel(0, cpg->reg + SEC_ACCEL_INT_STATUS);
 	writel(SEC_INT_ACCEL0_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
 	writel(SEC_CFG_STOP_DIG_ERR, cpg->reg + SEC_ACCEL_CFG);
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
-- 
1.7.3.4
