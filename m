From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 10/n]: Move command descriptor setup to seperate function
Date: Wed, 07 May 2008 14:50:29 +0200
Message-ID: <4821A595.807@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050908080409040808000601"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYEGMvO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:51:14 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050908080409040808000601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Note: the DMA setup fixes mentioned in the changelog still
need a bit of work, so I'm not sure if I'll manage to send
them today. This one is fine for review or applying anyway.



--------------050908080409040808000601
Content-Type: text/x-diff;
 name="10.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.diff"

commit 163c74fc4f18d086bbb7f114d55bc7dac939d6b7
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 13:11:59 2008 +0200

    [HIFN]: Move command descriptor setup to seperate function
    
    Move command descriptor setup to seperate function as preparation
    for the following DMA setup fixes.
    
    Note 1: also fix a harmless typo while moving it: sa_idx is initialized
    	to dma->resi instead of dma->cmdi.
    
    Note 2: errors from command descriptor setup are not propagated back,
    	anymore, they can't be handled anyway and all conditions leading
    	to errors should be checked earlier.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7d19b15..d1660b5 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1168,109 +1168,15 @@ static int hifn_setup_crypto_command(struct hifn_device *dev,
 	return cmd_len;
 }
 
-static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
-		unsigned int offset, unsigned int size)
-{
-	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
-	int idx;
-	dma_addr_t addr;
-
-	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_TODEVICE);
-
-	idx = dma->srci;
-
-	dma->srcr[idx].p = __cpu_to_le32(addr);
-	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
-
-	if (++idx == HIFN_D_SRC_RSIZE) {
-		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |
-				HIFN_D_JUMP |
-				HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
-		idx = 0;
-	}
-
-	dma->srci = idx;
-	dma->srcu++;
-
-	if (!(dev->flags & HIFN_FLAG_SRC_BUSY)) {
-		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_S_CTRL_ENA);
-		dev->flags |= HIFN_FLAG_SRC_BUSY;
-	}
-
-	return size;
-}
-
-static void hifn_setup_res_desc(struct hifn_device *dev)
-{
-	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
-
-	dma->resr[dma->resi].l = __cpu_to_le32(HIFN_USED_RESULT |
-			HIFN_D_VALID | HIFN_D_LAST);
-	/*
-	 * dma->resr[dma->resi].l = __cpu_to_le32(HIFN_MAX_RESULT | HIFN_D_VALID |
-	 *					HIFN_D_LAST | HIFN_D_NOINVALID);
-	 */
-
-	if (++dma->resi == HIFN_D_RES_RSIZE) {
-		dma->resr[HIFN_D_RES_RSIZE].l = __cpu_to_le32(HIFN_D_VALID |
-				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
-		dma->resi = 0;
-	}
-
-	dma->resu++;
-
-	if (!(dev->flags & HIFN_FLAG_RES_BUSY)) {
-		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_R_CTRL_ENA);
-		dev->flags |= HIFN_FLAG_RES_BUSY;
-	}
-}
-
-static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
-		unsigned offset, unsigned size)
-{
-	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
-	int idx;
-	dma_addr_t addr;
-
-	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_FROMDEVICE);
-
-	idx = dma->dsti;
-	dma->dstr[idx].p = __cpu_to_le32(addr);
-	dma->dstr[idx].l = __cpu_to_le32(size |	HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
-
-	if (++idx == HIFN_D_DST_RSIZE) {
-		dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID |
-				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
-				HIFN_D_LAST | HIFN_D_NOINVALID);
-		idx = 0;
-	}
-	dma->dsti = idx;
-	dma->dstu++;
-
-	if (!(dev->flags & HIFN_FLAG_DST_BUSY)) {
-		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_D_CTRL_ENA);
-		dev->flags |= HIFN_FLAG_DST_BUSY;
-	}
-}
-
-static int hifn_setup_dma(struct hifn_device *dev, struct page *spage, unsigned int soff,
-		struct page *dpage, unsigned int doff, unsigned int nbytes, void *priv,
-		struct hifn_context *ctx)
+static int hifn_setup_cmd_desc(struct hifn_device *dev,
+		struct hifn_context *ctx, void *priv, unsigned int nbytes)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int cmd_len, sa_idx;
 	u8 *buf, *buf_pos;
 	u16 mask;
 
-	dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, nbytes: %u, priv: %p, ctx: %p.\n",
-			dev->name, spage, soff, dpage, doff, nbytes, priv, ctx);
-
-	sa_idx = dma->resi;
-
-	hifn_setup_src_desc(dev, spage, soff, nbytes);
-
+	sa_idx = dma->cmdi;
 	buf_pos = buf = dma->command_bufs[dma->cmdi];
 
 	mask = 0;
@@ -1372,16 +1278,113 @@ static int hifn_setup_dma(struct hifn_device *dev, struct page *spage, unsigned
 		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_C_CTRL_ENA);
 		dev->flags |= HIFN_FLAG_CMD_BUSY;
 	}
-
-	hifn_setup_dst_desc(dev, dpage, doff, nbytes);
-	hifn_setup_res_desc(dev);
-
 	return 0;
 
 err_out:
 	return -EINVAL;
 }
 
+static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
+		unsigned int offset, unsigned int size)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int idx;
+	dma_addr_t addr;
+
+	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_TODEVICE);
+
+	idx = dma->srci;
+
+	dma->srcr[idx].p = __cpu_to_le32(addr);
+	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
+			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
+
+	if (++idx == HIFN_D_SRC_RSIZE) {
+		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |
+				HIFN_D_JUMP |
+				HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+		idx = 0;
+	}
+
+	dma->srci = idx;
+	dma->srcu++;
+
+	if (!(dev->flags & HIFN_FLAG_SRC_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_S_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_SRC_BUSY;
+	}
+
+	return size;
+}
+
+static void hifn_setup_res_desc(struct hifn_device *dev)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+
+	dma->resr[dma->resi].l = __cpu_to_le32(HIFN_USED_RESULT |
+			HIFN_D_VALID | HIFN_D_LAST);
+	/*
+	 * dma->resr[dma->resi].l = __cpu_to_le32(HIFN_MAX_RESULT | HIFN_D_VALID |
+	 *					HIFN_D_LAST | HIFN_D_NOINVALID);
+	 */
+
+	if (++dma->resi == HIFN_D_RES_RSIZE) {
+		dma->resr[HIFN_D_RES_RSIZE].l = __cpu_to_le32(HIFN_D_VALID |
+				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
+		dma->resi = 0;
+	}
+
+	dma->resu++;
+
+	if (!(dev->flags & HIFN_FLAG_RES_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_R_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_RES_BUSY;
+	}
+}
+
+static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
+		unsigned offset, unsigned size)
+{
+	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
+	int idx;
+	dma_addr_t addr;
+
+	addr = pci_map_page(dev->pdev, page, offset, size, PCI_DMA_FROMDEVICE);
+
+	idx = dma->dsti;
+	dma->dstr[idx].p = __cpu_to_le32(addr);
+	dma->dstr[idx].l = __cpu_to_le32(size |	HIFN_D_VALID |
+			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
+
+	if (++idx == HIFN_D_DST_RSIZE) {
+		dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID |
+				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
+				HIFN_D_LAST | HIFN_D_NOINVALID);
+		idx = 0;
+	}
+	dma->dsti = idx;
+	dma->dstu++;
+
+	if (!(dev->flags & HIFN_FLAG_DST_BUSY)) {
+		hifn_write_1(dev, HIFN_1_DMA_CSR, HIFN_DMACSR_D_CTRL_ENA);
+		dev->flags |= HIFN_FLAG_DST_BUSY;
+	}
+}
+
+static int hifn_setup_dma(struct hifn_device *dev, struct page *spage, unsigned int soff,
+		struct page *dpage, unsigned int doff, unsigned int nbytes, void *priv,
+		struct hifn_context *ctx)
+{
+	dprintk("%s: spage: %p, soffset: %u, dpage: %p, doffset: %u, nbytes: %u, priv: %p, ctx: %p.\n",
+			dev->name, spage, soff, dpage, doff, nbytes, priv, ctx);
+
+	hifn_setup_src_desc(dev, spage, soff, nbytes);
+	hifn_setup_cmd_desc(dev, ctx, priv, nbytes);
+	hifn_setup_dst_desc(dev, dpage, doff, nbytes);
+	hifn_setup_res_desc(dev);
+	return 0;
+}
+
 static int ablkcipher_walk_init(struct ablkcipher_walk *w,
 		int num, gfp_t gfp_flags)
 {

--------------050908080409040808000601--
