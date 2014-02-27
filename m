From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] crypto: omap-aes - Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:31:38 +0900
Message-ID: <000301cf33af$7ad7cc50$708764f0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'David Miller' <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Nishanth Menon' <nm@ti.com>, 'Joel Fernandes' <joelf@ti.com>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:45747 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaB0Lbk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Feb 2014 06:31:40 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1N008QSK0R0880@mailout4.samsung.com> for
 linux-crypto@vger.kernel.org; Thu, 27 Feb 2014 20:31:39 +0900 (KST)
Content-language: ko
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/crypto/omap-aes.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index dde41f1d..cb98fa5 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1307,9 +1307,7 @@ static int omap_aes_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops omap_aes_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(omap_aes_suspend, omap_aes_resume)
-};
+static SIMPLE_DEV_PM_OPS(omap_aes_pm_ops, omap_aes_suspend, omap_aes_resume);
 
 static struct platform_driver omap_aes_driver = {
 	.probe	= omap_aes_probe,
-- 
1.7.10.4
