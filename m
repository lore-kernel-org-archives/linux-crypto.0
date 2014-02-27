From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] crypto: omap-sham - Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:33:32 +0900
Message-ID: <000601cf33af$beaebdd0$3c0c3970$%han@samsung.com>
References: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Lokesh Vutla' <lokeshvutla@ti.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50400 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaB0Lde (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 06:33:34 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1N00KRCK3XXT30@mailout3.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 27 Feb 2014 20:33:33 +0900 (KST)
In-reply-to: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/omap-sham.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a727a6a..4e2067d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2022,9 +2022,7 @@ static int omap_sham_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops omap_sham_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(omap_sham_suspend, omap_sham_resume)
-};
+static SIMPLE_DEV_PM_OPS(omap_sham_pm_ops, omap_sham_suspend, omap_sham_resume);
 
 static struct platform_driver omap_sham_driver = {
 	.probe	= omap_sham_probe,
-- 
1.7.10.4
