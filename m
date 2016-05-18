From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: omap-sham - potential Oops on error in probe
Date: Wed, 18 May 2016 13:39:05 +0300
Message-ID: <20160518103905.GA10470@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29942 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbcERKjg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 06:39:36 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This if statement is reversed so we end up either leaking or Oopsing on
error.

Fixes: dbe246209bc1 ('crypto: omap-sham - Use dma_request_chan() for requesting DMA channel')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6eefaa2..63464e8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1986,7 +1986,7 @@ err_algs:
 					&dd->pdata->algs_info[i].algs_list[j]);
 err_pm:
 	pm_runtime_disable(dev);
-	if (dd->polling_mode)
+	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
 data_err:
 	dev_err(dev, "initialization failed.\n");
