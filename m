From: <qiang.liu@freescale.com>
Subject: [PATCH v4 6/7] fsl-dma: fix a warning of unitialized cookie
Date: Fri, 27 Jul 2012 17:16:48 +0800
Message-ID: <1343380608-12099-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:32106
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab2G0JRV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Jul 2012 05:17:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Qiang Liu <qiang.liu@freescale.com>

Fix a warning of unitialized value when compile with -Wuninitialized.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
Cc: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index e3814aa..6fc22eb 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -645,7 +645,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	dma_cookie_t cookie;
+	dma_cookie_t cookie = 0;

 	spin_lock_bh(&chan->desc_lock);

--
1.7.5.1
