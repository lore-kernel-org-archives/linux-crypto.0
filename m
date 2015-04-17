From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 11/17] crypto: talitos - adaptation of talitos_submit() for
 SEC1
Date: Fri, 17 Apr 2015 16:32:09 +0200 (CEST)
Message-ID: <20150417143209.B2BF31A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

SEC1 descriptor is a bit different to SEC2+ descriptor.
talitos_submit() will have to copy hdr field into hdr1 field and
send the descriptor starting at hdr1 up to next_desc.
For SEC2, it remains unchanged and next_desc is just ignored.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 23 +++++++++++++++++++----
 drivers/crypto/talitos.h |  2 ++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 678b528..e6ea651 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -236,6 +236,7 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
@@ -249,8 +250,17 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	request->dma_desc = dma_map_single(dev, desc, sizeof(*desc),
-					   DMA_BIDIRECTIONAL);
+	if (is_sec1) {
+		desc->hdr1 = desc->hdr;
+		desc->next_desc = 0;
+		request->dma_desc = dma_map_single(dev, &desc->hdr1,
+						   TALITOS_DESC_SIZE,
+						   DMA_BIDIRECTIONAL);
+	} else {
+		request->dma_desc = dma_map_single(dev, desc,
+						   TALITOS_DESC_SIZE,
+						   DMA_BIDIRECTIONAL);
+	}
 	request->callback = callback;
 	request->context = context;
 
@@ -282,16 +292,21 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	struct talitos_request *request, saved_req;
 	unsigned long flags;
 	int tail, status;
+	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
 	tail = priv->chan[ch].tail;
 	while (priv->chan[ch].fifo[tail].desc) {
+		__be32 hdr;
+
 		request = &priv->chan[ch].fifo[tail];
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
+		hdr = is_sec1 ? request->desc->hdr1 : request->desc->hdr;
+
+		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
 		else
 			if (!error)
@@ -300,7 +315,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 				status = error;
 
 		dma_unmap_single(dev, request->dma_desc,
-				 sizeof(struct talitos_desc),
+				 TALITOS_DESC_SIZE,
 				 DMA_BIDIRECTIONAL);
 
 		/* copy entries so we can call callback outside lock */
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index b0bdb4e..f827c04 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -69,6 +69,8 @@ struct talitos_desc {
 	__be32 next_desc;		/* next descriptor (SEC1) */
 };
 
+#define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
+
 /**
  * talitos_request - descriptor submission request
  * @desc: descriptor pointer (kernel virtual)
-- 
2.1.0
