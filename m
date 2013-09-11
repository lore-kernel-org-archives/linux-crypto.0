From: Yashpal Dutta <yashpal.dutta@freescale.com>
Subject: [PATCH v2] crypto: caam - map src buffer before access
Date: Thu, 12 Sep 2013 00:54:06 +0530
Message-ID: <1378927446-21209-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:49307
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab3IKOY7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Sep 2013 10:24:59 -0400
Received: from mail102-am1 (localhost [127.0.0.1])	by
 mail102-am1-R.bigfish.com (Postfix) with ESMTP id 57C07400F3	for
 <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2013 14:24:58 +0000 (UTC)
Received: from AM1EHSMHS014.bigfish.com (unknown [10.3.201.243])	by
 mail102-am1.bigfish.com (Postfix) with ESMTP id 6061C480047	for
 <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2013 14:24:56 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

KMap the buffers before copying trailing bytes during hmac into a session
temporary buffer. This is required if pinned buffer from user-space is send
during hmac and is safe even if hmac request is generated from within kernel.

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
---
Patch covers review comments on first version of patch.
./scripts/checkpatch.pl --strict 0001-crypto-caam-map-src-buffer-before-access.patch 
total: 0 errors, 0 warnings, 0 checks, 62 lines checked

 drivers/crypto/caam/sg_sw_sec4.h |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index e0037c8..6d21a12 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -117,6 +117,21 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 	return nents;
 }
 
+/* Map SG page in kernel virtual address space and copy */
+static inline void sg_map_copy(u8 *dest, struct scatterlist *sg,
+			       int len, int offset)
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
+			    current_sg->offset);
 		current_sg = scatterwalk_sg_next(current_sg);
 		cpy_index = next_cpy_index;
 		next_cpy_index += current_sg->length;
 	}
 	if (cpy_index < len)
-		memcpy(dest + cpy_index, (u8 *) sg_virt(current_sg),
-		       len - cpy_index);
+		sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
+			    current_sg->offset);
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
