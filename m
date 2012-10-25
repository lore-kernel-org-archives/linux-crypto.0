From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] crypto: tegra-aes - fix error-valued pointer dereference
Date: Thu, 25 Oct 2012 22:55:04 +0800
Message-ID: <CAPgLHd8CSEYpdGHfmwOjbH4EPszYjB01mvGMczmbMmJss_L2XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	grant.likely@secretlab.ca, rob.herring@calxeda.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37028 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab2JYOzF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Oct 2012 10:55:05 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so763130qcr.19
        for <linux-crypto@vger.kernel.org>; Thu, 25 Oct 2012 07:55:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

clk_put(dd->aes_clk) will dereference an error-valued pointer since the
dd->aes_clk is a ERR_PTR() value. The correct check is call clk_put()
if !IS_ERR(dd->aes_clk).

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/tegra-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 37185e6..bb4195a 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -1031,7 +1031,7 @@ out:
 	if (dd->buf_out)
 		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
 			dd->buf_out, dd->dma_buf_out);
-	if (IS_ERR(dd->aes_clk))
+	if (!IS_ERR(dd->aes_clk))
 		clk_put(dd->aes_clk);
 	if (aes_wq)
 		destroy_workqueue(aes_wq);
