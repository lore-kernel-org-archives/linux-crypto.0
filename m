From: <qiang.liu@freescale.com>
Subject: [PATCH v6 7/8] fsl-dma: fix a warning of unitialized cookie
Date: Mon, 6 Aug 2012 18:14:58 +0800
Message-ID: <1344248098-9360-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, <arnd@arndb.de>,
	<gregkh@linuxfoundation.org>, Qiang Liu <qiang.liu@freescale.com>,
	Li Yang <leoli@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@gmail.com>, <vinod.koul@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.180.189] ([216.32.180.189]:28575 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab2HFKlg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2012 06:41:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Qiang Liu <qiang.liu@freescale.com>

Fix a warning of unitialized value when compile with -Wuninitialized.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
Reported-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 3f809df..6275bdf 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -405,7 +405,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	dma_cookie_t cookie;
+	dma_cookie_t cookie = 0;

 	spin_lock_bh(&chan->desc_lock);

--
1.7.5.1
