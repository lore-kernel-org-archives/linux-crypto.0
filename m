From: <Yashpal.Dutta@freescale.com>
Subject: [PATCH] drivers/crypto:caam:Map src buffer before access in CAAM driver
Date: Wed, 11 Sep 2013 11:32:26 +0530
Message-ID: <1378879346-24500-1-git-send-email-Yashpal.Dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:39880
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab3IKGOn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Sep 2013 02:14:43 -0400
Received: from mail191-co1 (localhost [127.0.0.1])	by
 mail191-co1-R.bigfish.com (Postfix) with ESMTP id 1C4C9B400BB	for
 <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2013 06:14:43 +0000 (UTC)
Received: from CO1EHSMHS024.bigfish.com (unknown [10.243.78.236])	by
 mail191-co1.bigfish.com (Postfix) with ESMTP id C175F180041	for
 <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2013 06:14:41 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yashpal Dutta <yashpal.dutta@freescale.com>

KMap the buffers before copying trailing bytes during hmac in CAAM driver into a
session temporary buffer. This is required if pinned buffer from user-space
is send to CAAM driver during hmac and is safe even if hmac request is generated
from within kernel.

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
 drivers/crypto/caam/sg_sw_sec4.h |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index e0037c8..9575985 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -117,6 +117,21 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 	return nents;
 }
 
+/* Map SG page in kernel virtual address space and copy */
+static inline void sg_map_copy(u8 *dest, struct scatterlist *sg,
+					int len, int offset)
+{
+	u8 *mapped_addr;
+
+	/*
+	 * Page here can be user-space pinned using get_user_pages
+	 * Same must be kmapped before use and kunmapped subsequently
+	 */
+	mapped_addr = kmap_atomic(sg_page(sg));
+	memcpy(dest, mapped_addr + offset, len);
+	kunmap_atomic(mapped_addr);
+}
+
 /* Copy from len bytes of sg to dest, starting from beginning */
 static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
 {
@@ -124,15 +139,15 @@ static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
 	int cpy_index = 0, next_cpy_index = current_sg->length;
 
 	while (next_cpy_index < len) {
-		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
-		       current_sg->length);
+		sg_map_copy(dest + cpy_index, current_sg, current_sg->length,
+				current_sg->offset);
 		current_sg = scatterwalk_sg_next(current_sg);
 		cpy_index = next_cpy_index;
 		next_cpy_index += current_sg->length;
 	}
 	if (cpy_index < len)
-		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
-		       len - cpy_index);
+		sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
+				current_sg->offset);
 }
 
 /* Copy sg data, from to_skip to end, to dest */
@@ -140,7 +155,7 @@ static inline void sg_copy_part(u8 *dest, struct scatterlist *sg,
 				      int to_skip, unsigned int end)
 {
 	struct scatterlist *current_sg = sg;
-	int sg_index, cpy_index;
+	int sg_index, cpy_index, offset;
 
 	sg_index = current_sg->length;
 	while (sg_index <= to_skip) {
@@ -148,9 +163,10 @@ static inline void sg_copy_part(u8 *dest, struct scatterlist *sg,
 		sg_index += current_sg->length;
 	}
 	cpy_index = sg_index - to_skip;
-	memcpy(dest, (u8 *) sg_virt(current_sg) +
-	       current_sg->length - cpy_index, cpy_index);
-	current_sg = scatterwalk_sg_next(current_sg);
-	if (end - sg_index)
+	offset = current_sg->offset + current_sg->length - cpy_index;
+	sg_map_copy(dest, current_sg, cpy_index, offset);
+	if (end - sg_index) {
+		current_sg = scatterwalk_sg_next(current_sg);
 		sg_copy(dest + cpy_index, current_sg, end - sg_index);
+	}
 }
-- 
1.7.10.4
