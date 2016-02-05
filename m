From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 2/2] crypto: atmel-sha - remove calls of clk_prepare() from atomic contexts
Date: Fri, 5 Feb 2016 13:45:13 +0100
Message-ID: <6b343599db251a8f00820939e01c5e35cc359686.1454675769.git.cyrille.pitchen@atmel.com>
References: <cover.1454675769.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454675769.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

clk_prepare()/clk_unprepare() must not be called within atomic context.

This patch calls clk_prepare() once for all from atmel_sha_probe() and
clk_unprepare() from atmel_sha_remove().

Then calls of clk_prepare_enable()/clk_disable_unprepare() were replaced
by calls of clk_enable()/clk_disable().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Reported-by: Matthias Mayr <matthias.mayr@student.kit.edu>
---
 drivers/crypto/atmel-sha.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index b827c99b17c1..f8407dc7dd38 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -846,7 +846,7 @@ static void atmel_sha_finish_req(struct ahash_request *req, int err)
 	dd->flags &= ~(SHA_FLAGS_BUSY | SHA_FLAGS_FINAL | SHA_FLAGS_CPU |
 			SHA_FLAGS_DMA_READY | SHA_FLAGS_OUTPUT_READY);
 
-	clk_disable_unprepare(dd->iclk);
+	clk_disable(dd->iclk);
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
@@ -859,7 +859,7 @@ static int atmel_sha_hw_init(struct atmel_sha_dev *dd)
 {
 	int err;
 
-	err = clk_prepare_enable(dd->iclk);
+	err = clk_enable(dd->iclk);
 	if (err)
 		return err;
 
@@ -886,7 +886,7 @@ static void atmel_sha_hw_version_init(struct atmel_sha_dev *dd)
 	dev_info(dd->dev,
 			"version: 0x%x\n", dd->hw_version);
 
-	clk_disable_unprepare(dd->iclk);
+	clk_disable(dd->iclk);
 }
 
 static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
@@ -1536,6 +1536,10 @@ static int atmel_sha_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
+	err = clk_prepare(sha_dd->iclk);
+	if (err)
+		goto res_err;
+
 	atmel_sha_hw_version_init(sha_dd);
 
 	atmel_sha_get_cap(sha_dd);
@@ -1547,12 +1551,12 @@ static int atmel_sha_probe(struct platform_device *pdev)
 			if (IS_ERR(pdata)) {
 				dev_err(&pdev->dev, "platform data not available\n");
 				err = PTR_ERR(pdata);
-				goto res_err;
+				goto iclk_unprepare;
 			}
 		}
 		if (!pdata->dma_slave) {
 			err = -ENXIO;
-			goto res_err;
+			goto iclk_unprepare;
 		}
 		err = atmel_sha_dma_init(sha_dd, pdata);
 		if (err)
@@ -1583,6 +1587,8 @@ err_algs:
 	if (sha_dd->caps.has_dma)
 		atmel_sha_dma_cleanup(sha_dd);
 err_sha_dma:
+iclk_unprepare:
+	clk_unprepare(sha_dd->iclk);
 res_err:
 	tasklet_kill(&sha_dd->queue_task);
 	tasklet_kill(&sha_dd->done_task);
@@ -1611,6 +1617,8 @@ static int atmel_sha_remove(struct platform_device *pdev)
 	if (sha_dd->caps.has_dma)
 		atmel_sha_dma_cleanup(sha_dd);
 
+	clk_unprepare(sha_dd->iclk);
+
 	return 0;
 }
 
-- 
1.8.2.2
