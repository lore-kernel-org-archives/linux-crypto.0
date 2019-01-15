Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfAONno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:44 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Hadar Gat <hadar.gat@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] crypto: ccree: remove legacy leftover
Date: Tue, 15 Jan 2019 15:43:14 +0200
Message-Id: <20190115134318.28712-5-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Hadar Gat <hadar.gat@arm.com>

Remove legacy code no longer in use.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_driver.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 5be7fd431b05..33dbf3e6d15d 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -111,13 +111,11 @@ struct cc_crypto_req {
  * @cc_base:	virt address of the CC registers
  * @irq:	device IRQ number
  * @irq_mask:	Interrupt mask shadow (1 for masked interrupts)
- * @fw_ver:	SeP loaded firmware version
  */
 struct cc_drvdata {
 	void __iomem *cc_base;
 	int irq;
 	u32 irq_mask;
-	u32 fw_ver;
 	struct completion hw_queue_avail; /* wait for HW queue availability */
 	struct platform_device *plat_dev;
 	cc_sram_addr_t mlli_sram_addr;
-- 
2.20.1
