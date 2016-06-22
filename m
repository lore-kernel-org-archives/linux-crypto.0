From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 08/27] crypto: omap-des: Fix support for unequal lengths
Date: Wed, 22 Jun 2016 16:23:41 +0300
Message-ID: <1466601840-18486-9-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50579 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcFVNZO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:14 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <a0131933@ti.com>

For cases where total length of an input SGs is not same as
length of the input data for encryption, omap-des driver
crashes. This happens in the case when IPsec is trying to use
omap-des driver.

To avoid this, we copy all the pages from the input SG list
into a contiguous buffer and prepare a single element SG list
for this buffer with length as the total bytes to crypt, which is
similar thing that is done in case of unaligned lengths.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Tested-by: Aparna Balasubramanian <aparnab@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-des.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3eedb03..e4c87bc 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -521,29 +521,36 @@ static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
 	return 0;
 }
 
-static int omap_des_copy_needed(struct scatterlist *sg)
+static int omap_des_copy_needed(struct scatterlist *sg, int total)
 {
+	int len = 0;
+
+	if (!IS_ALIGNED(total, DES_BLOCK_SIZE))
+		return -1;
+
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, 4))
 			return -1;
 		if (!IS_ALIGNED(sg->length, DES_BLOCK_SIZE))
 			return -1;
+
+		len += sg->length;
 		sg = sg_next(sg);
 	}
+
+	if (len != total)
+		return -1;
+
 	return 0;
 }
 
 static int omap_des_copy_sgs(struct omap_des_dev *dd)
 {
 	void *buf_in, *buf_out;
-	int pages;
-
-	pages = dd->total >> PAGE_SHIFT;
-
-	if (dd->total & (PAGE_SIZE-1))
-		pages++;
+	int pages, total;
 
-	BUG_ON(!pages);
+	total = ALIGN(dd->total, DES_BLOCK_SIZE);
+	pages = get_order(total);
 
 	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
 	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
@@ -595,8 +602,8 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 	dd->in_sg = req->src;
 	dd->out_sg = req->dst;
 
-	if (omap_des_copy_needed(dd->in_sg) ||
-	    omap_des_copy_needed(dd->out_sg)) {
+	if (omap_des_copy_needed(dd->in_sg, dd->total) ||
+	    omap_des_copy_needed(dd->out_sg, dd->total)) {
 		if (omap_des_copy_sgs(dd))
 			pr_err("Failed to copy SGs for unaligned cases\n");
 		dd->sgs_copied = 1;
-- 
1.9.1
