From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 04/17] crypto: talitos - Add a helper function to clear
 j_extent field
Date: Fri, 17 Apr 2015 16:31:55 +0200 (CEST)
Message-ID: <20150417143155.4C14D1A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:42112 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934421AbbDQOb6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 10:31:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

j_extent field is specific to SEC2 so we add a helper function to clear it
so that SEC1 can redefine that function as nop

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index fca0aed..c93f79b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -61,6 +61,11 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
 	ptr->eptr = upper_32_bits(dma_addr);
 }
 
+static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
+{
+	ptr->j_extent = 0;
+}
+
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
@@ -1372,7 +1377,7 @@ int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
 	int sg_count;
 
 	ptr->len = cpu_to_be16(len);
-	ptr->j_extent = 0;
+	to_talitos_ptr_extent_clear(ptr);
 
 	sg_count = talitos_map_sg(dev, src, edesc->src_nents ? : 1, dir,
 				  edesc->src_chained);
@@ -1402,7 +1407,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 			    struct talitos_ptr *ptr, int sg_count)
 {
 	ptr->len = cpu_to_be16(len);
-	ptr->j_extent = 0;
+	to_talitos_ptr_extent_clear(ptr);
 
 	if (dir != DMA_NONE)
 		sg_count = talitos_map_sg(dev, dst, edesc->dst_nents ? : 1,
@@ -1444,7 +1449,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma);
 	desc->ptr[1].len = cpu_to_be16(ivsize);
-	desc->ptr[1].j_extent = 0;
+	to_talitos_ptr_extent_clear(&desc->ptr[1]);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-- 
2.1.0
