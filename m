From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 06/17] crypto: talitos - helper function for ptr len
Date: Fri, 17 Apr 2015 16:31:59 +0200 (CEST)
Message-ID: <20150417143159.6CECB1A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:42121 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934483AbbDQOcB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 10:32:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a helper function for reads and writes of the len
param of the talitos descriptor. This will help implement
SEC1 later.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 81e5636..bca6ded 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -61,6 +61,16 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
 	ptr->eptr = upper_32_bits(dma_addr);
 }
 
+static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned short len)
+{
+	ptr->len = cpu_to_be16(len);
+}
+
+static unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr)
+{
+	return be16_to_cpu(ptr->len);
+}
+
 static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
 {
 	ptr->j_extent = 0;
@@ -76,7 +86,7 @@ static void map_single_talitos_ptr(struct device *dev,
 {
 	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
 
-	ptr->len = cpu_to_be16(len);
+	to_talitos_ptr_len(ptr, len);
 	to_talitos_ptr(ptr, dma_addr);
 	to_talitos_ptr_extent_clear(ptr);
 }
@@ -89,7 +99,7 @@ static void unmap_single_talitos_ptr(struct device *dev,
 				     enum dma_data_direction dir)
 {
 	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
-			 be16_to_cpu(ptr->len), dir);
+			 from_talitos_ptr_len(ptr), dir);
 }
 
 static int reset_channel(struct device *dev, int ch)
@@ -1375,7 +1385,7 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 {
 	int sg_count;
 
-	ptr->len = cpu_to_be16(len);
+	to_talitos_ptr_len(ptr, len);
 	to_talitos_ptr_extent_clear(ptr);
 
 	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
@@ -1405,7 +1415,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 			    enum dma_data_direction dir,
 			    struct talitos_ptr *ptr, int sg_count)
 {
-	ptr->len = cpu_to_be16(len);
+	to_talitos_ptr_len(ptr, len);
 	to_talitos_ptr_extent_clear(ptr);
 
 	if (dir != DMA_NONE)
@@ -1447,7 +1457,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
-	desc->ptr[1].len = cpu_to_be16(ivsize);
+	to_talitos_ptr_len(&desc->ptr[1], ivsize);
 	to_talitos_ptr_extent_clear(&desc->ptr[1]);
 
 	/* cipher key */
@@ -1539,11 +1549,11 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	unmap_sg_talitos_ptr(dev, req_ctx->psrc, NULL, 0, edesc);
 
 	/* When using hashctx-in, must unmap it. */
-	if (edesc->desc.ptr[1].len)
+	if (from_talitos_ptr_len(&edesc->desc.ptr[1]))
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
 					 DMA_TO_DEVICE);
 
-	if (edesc->desc.ptr[2].len)
+	if (from_talitos_ptr_len(&edesc->desc.ptr[2]))
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
 					 DMA_TO_DEVICE);
 
-- 
2.1.0
