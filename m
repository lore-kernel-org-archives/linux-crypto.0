From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: talitos - fix locating offending descriptor in error path
Date: Wed, 13 Nov 2013 12:20:37 +0200
Message-ID: <1384338037-25287-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Lei Xu <Lei.Xu@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.185] ([213.199.154.185]:19573 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab3KMK3a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Nov 2013 05:29:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 3e721aeb3df3816e283ab18e327cd4652972e213
("crypto: talitos - handle descriptor not found in error path")
tried to address the fact that CDPR (Current Descriptor Pointer Register)
is unreliable.

As it turns out, there are still issues in the function detecting the
offending descriptor:
-only 32 bits of the descriptor address are read, however the address is
36-bit - since reset_channel() initializes channels with EAE (extended
address) bit set
-reading CDPR can return zero in cur_desc; when searching the channel
fifo for this address, cur_desc == dma_desc (= 0) case might happen,
leading to an oops when trying to return desc->hdr (desc is zero)
-read channel's .tail only once; the tail is a moving target; use a
local variable for the end of search condition

Signed-off-by: Lei Xu <Lei.Xu@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Tested-by: Kalyani Chowdhury <Kalyani.Chowdhury@freescale.com>
---
 drivers/crypto/talitos.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f6f7c68..04c5de3b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -336,20 +336,29 @@ DEF_TALITOS_DONE(ch1_3, TALITOS_ISR_CH_1_3_DONE)
 static u32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	int tail = priv->chan[ch].tail;
+	int tail, iter;
 	dma_addr_t cur_desc;
 
-	cur_desc = in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
+	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
+	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
 
-	while (priv->chan[ch].fifo[tail].dma_desc != cur_desc) {
-		tail = (tail + 1) & (priv->fifo_len - 1);
-		if (tail == priv->chan[ch].tail) {
+	if (!cur_desc) {
+		dev_err(dev, "CDPR is NULL, giving up search for offending descriptor\n");
+		return 0;
+	}
+
+	tail = priv->chan[ch].tail;
+
+	iter = tail;
+	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc) {
+		iter = (iter + 1) & (priv->fifo_len - 1);
+		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
 			return 0;
 		}
 	}
 
-	return priv->chan[ch].fifo[tail].desc->hdr;
+	return priv->chan[ch].fifo[iter].desc->hdr;
 }
 
 /*
-- 
1.7.7.6
