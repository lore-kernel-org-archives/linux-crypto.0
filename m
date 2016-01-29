From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH] crypto: atmel-aes - remove calls of clk_prepare() from atomic contexts
Date: Fri, 29 Jan 2016 17:53:33 +0100
Message-ID: <f8f0ac52fcfbbef5cbddb2a189128b253df7d678.1454086302.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<matthias.mayr@student.kit.edu>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:32807 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbcA2QxD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 11:53:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

clk_prepare()/clk_unprepare() must not be called within atomic context.

This patch calls clk_prepare() once for all from atmel_aes_probe() and
clk_unprepare() from atmel_aes_remove().

Then calls of clk_prepare_enable()/clk_disable_unprepare() were replaced
by calls of clk_enable()/clk_disable().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Reported-by: Matthias Mayr <matthias.mayr@student.kit.edu>
---
 drivers/crypto/atmel-aes.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6dd3317ca365..3eb3f1279fb7 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -400,7 +400,7 @@ static int atmel_aes_hw_init(struct atmel_aes_dev *dd)
 {
 	int err;
 
-	err = clk_prepare_enable(dd->iclk);
+	err = clk_enable(dd->iclk);
 	if (err)
 		return err;
 
@@ -430,7 +430,7 @@ static int atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
 
 	dev_info(dd->dev, "version: 0x%x\n", dd->hw_version);
 
-	clk_disable_unprepare(dd->iclk);
+	clk_disable(dd->iclk);
 	return 0;
 }
 
@@ -448,7 +448,7 @@ static inline bool atmel_aes_is_encrypt(const struct atmel_aes_dev *dd)
 
 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
-	clk_disable_unprepare(dd->iclk);
+	clk_disable(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
 
 	if (dd->is_async)
@@ -2091,10 +2091,14 @@ static int atmel_aes_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
-	err = atmel_aes_hw_version_init(aes_dd);
+	err = clk_prepare(aes_dd->iclk);
 	if (err)
 		goto res_err;
 
+	err = atmel_aes_hw_version_init(aes_dd);
+	if (err)
+		goto iclk_unprepare;
+
 	atmel_aes_get_cap(aes_dd);
 
 	err = atmel_aes_buff_init(aes_dd);
@@ -2127,6 +2131,8 @@ err_algs:
 err_aes_dma:
 	atmel_aes_buff_cleanup(aes_dd);
 err_aes_buff:
+iclk_unprepare:
+	clk_unprepare(aes_dd->iclk);
 res_err:
 	tasklet_kill(&aes_dd->done_task);
 	tasklet_kill(&aes_dd->queue_task);
@@ -2155,6 +2161,8 @@ static int atmel_aes_remove(struct platform_device *pdev)
 	atmel_aes_dma_cleanup(aes_dd);
 	atmel_aes_buff_cleanup(aes_dd);
 
+	clk_unprepare(aes_dd->iclk);
+
 	return 0;
 }
 
-- 
1.8.2.2
