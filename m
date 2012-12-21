From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 02/10] crypto: omap-aes - Don't reset controller for every operation
Date: Fri, 21 Dec 2012 10:04:52 -0700
Message-ID: <1356109500-11719-3-git-send-email-mgreer@animalcreek.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:49668 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2LURFK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Dec 2012 12:05:10 -0500
In-Reply-To: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

The AES controller only needs to be reset once and that will
be done by the hwmod infrastructure, if possible.  Therefore,
remove the reset code from the omap-aes driver.

CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 481da71..33cd783 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -160,19 +160,6 @@ static void omap_aes_write_n(struct omap_aes_dev *dd, u32 offset,
 		omap_aes_write(dd, offset, *value);
 }
 
-static int omap_aes_wait(struct omap_aes_dev *dd, u32 offset, u32 bit)
-{
-	unsigned long timeout = jiffies + DEFAULT_TIMEOUT;
-
-	while (!(omap_aes_read(dd, offset) & bit)) {
-		if (time_is_before_jiffies(timeout)) {
-			dev_err(dd->dev, "omap-aes timeout\n");
-			return -ETIMEDOUT;
-		}
-	}
-	return 0;
-}
-
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
 	/*
@@ -183,20 +170,6 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 	clk_enable(dd->iclk);
 
 	if (!(dd->flags & FLAGS_INIT)) {
-		/* is it necessary to reset before every operation? */
-		omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_SOFTRESET,
-					AES_REG_MASK_SOFTRESET);
-		/*
-		 * prevent OCP bus error (SRESP) in case an access to the module
-		 * is performed while the module is coming out of soft reset
-		 */
-		__asm__ __volatile__("nop");
-		__asm__ __volatile__("nop");
-
-		if (omap_aes_wait(dd, AES_REG_SYSSTATUS,
-				AES_REG_SYSSTATUS_RESETDONE))
-			return -ETIMEDOUT;
-
 		dd->flags |= FLAGS_INIT;
 		dd->err = 0;
 	}
-- 
1.7.12
