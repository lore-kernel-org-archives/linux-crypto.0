From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] crypto: omap-des - Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:32:35 +0900
Message-ID: <000501cf33af$9c4a4480$d4decd80$%han@samsung.com>
References: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Joel Fernandes' <joelf@ti.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB0Lch (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 06:32:37 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1N00K32K2B9PE0@mailout2.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 27 Feb 2014 20:32:35 +0900 (KST)
In-reply-to: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/omap-des.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 006d914..758919e 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1196,9 +1196,7 @@ static int omap_des_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops omap_des_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(omap_des_suspend, omap_des_resume)
-};
+static SIMPLE_DEV_PM_OPS(omap_des_pm_ops, omap_des_suspend, omap_des_resume);
 
 static struct platform_driver omap_des_driver = {
 	.probe	= omap_des_probe,
-- 
1.7.10.4
