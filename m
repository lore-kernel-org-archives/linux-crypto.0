From: Asaf Vertz <asaf.vertz@tandemg.com>
Subject: [PATCH] crypto: ux500: fix checkpatch errors
Date: Wed, 10 Dec 2014 14:55:10 +0200
Message-ID: <20141210125510.GA1904@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, asaf.vertz@tandemg.com, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45875 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaLJMzQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Dec 2014 07:55:16 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so3532113wgg.10
        for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2014 04:55:14 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed a coding style error, code indent should use tabs where possible 

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 92105f3..b189e1d 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -479,13 +479,13 @@ static void cryp_dma_setup_channel(struct cryp_device_data *device_data,
 		.dst_addr = device_data->phybase + CRYP_DMA_TX_FIFO,
 		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
 		.dst_maxburst = 4,
-        };
+	};
 	struct dma_slave_config cryp2mem = {
 		.direction = DMA_DEV_TO_MEM,
 		.src_addr = device_data->phybase + CRYP_DMA_RX_FIFO,
 		.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
 		.src_maxburst = 4,
-        };
+	};
 
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
@@ -1772,8 +1772,8 @@ static int ux500_cryp_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(ux500_cryp_pm, ux500_cryp_suspend, ux500_cryp_resume);
 
 static const struct of_device_id ux500_cryp_match[] = {
-        { .compatible = "stericsson,ux500-cryp" },
-        { },
+	{ .compatible = "stericsson,ux500-cryp" },
+	{ },
 };
 
 static struct platform_driver cryp_driver = {
-- 
1.7.0.4
