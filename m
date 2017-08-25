From: Christian Lamparter <chunkeey@googlemail.com>
Subject: [RFC PATCH 09/12] crypto: crypto4xx: refactor crypto4xx_copy_pkt_to_dst()
Date: Fri, 25 Aug 2017 15:47:22 +0200
Message-ID: <26b1303367e13a4c0d61cdfbae90dbf588bcc9b5.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36996 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932473AbdHYNri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 09:47:38 -0400
Received: by mail-wr0-f196.google.com with SMTP id p14so1519184wrg.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Aug 2017 06:47:37 -0700 (PDT)
In-Reply-To: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com>
In-Reply-To: <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com>
References: <71020bd2e3f4100c3c0668a13fdad9d22c8884a7.1503668705.git.chunkeey@googlemail.com> <85532949069735593f777489c6efcb6d1b08cdec.1503668705.git.chunkeey@googlemail.com> <7f51944084eef13bebe5f052557533bf6ade4ebc.1503668705.git.chunkeey@googlemail.com> <44b9527904d134982932cb807a3fa6f36093acbf.1503668705.git.chunkeey@googlemail.com> <c623cda688571bc483f0c9a9fb4c17cda0514cdd.1503668705.git.chunkeey@googlemail.com> <575e998ebe72ea59e785263e11b2a44fb1c6d910.1503668705.git.chunkeey@googlemail.com> <0521bf298c4b6aeba2d1e1e89aac9929ebffd0d4.1503668705.git.chunkeey@googlemail.com> <668f5f89e62ccb2e410c5a63f35c64efe9bd0686.1503668705.git.chunkeey@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch refactors the crypto4xx_copy_pkt_to_dst() to use
scatterwalk_map_and_copy() to copy the processed data between
the crypto engine's scatter ring buffer and the destination
specified by the ablkcipher_request.

This also makes the crypto4xx_fill_one_page() function redundant.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 126 +++++++++--------------------------
 1 file changed, 30 insertions(+), 96 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 3c086cf7b052..f3f151820373 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -38,6 +38,7 @@
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
 #include <crypto/sha.h>
+#include <crypto/scatterwalk.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_core.h"
 #include "crypto4xx_sa.h"
@@ -481,111 +482,44 @@ static inline struct ce_sd *crypto4xx_get_sdp(struct crypto4xx_device *dev,
 	return  (struct ce_sd *)(dev->sdr + sizeof(struct ce_sd) * idx);
 }
 
-static u32 crypto4xx_fill_one_page(struct crypto4xx_device *dev,
-				   dma_addr_t *addr, u32 *length,
-				   u32 *idx, u32 *offset, u32 *nbytes)
-{
-	u32 len;
-
-	if (*length > dev->scatter_buffer_size) {
-		memcpy(phys_to_virt(*addr),
-			dev->scatter_buffer_va +
-			*idx * dev->scatter_buffer_size + *offset,
-			dev->scatter_buffer_size);
-		*offset = 0;
-		*length -= dev->scatter_buffer_size;
-		*nbytes -= dev->scatter_buffer_size;
-		if (*idx == PPC4XX_LAST_SD)
-			*idx = 0;
-		else
-			(*idx)++;
-		*addr = *addr +  dev->scatter_buffer_size;
-		return 1;
-	} else if (*length < dev->scatter_buffer_size) {
-		memcpy(phys_to_virt(*addr),
-			dev->scatter_buffer_va +
-			*idx * dev->scatter_buffer_size + *offset, *length);
-		if ((*offset + *length) == dev->scatter_buffer_size) {
-			if (*idx == PPC4XX_LAST_SD)
-				*idx = 0;
-			else
-				(*idx)++;
-			*nbytes -= *length;
-			*offset = 0;
-		} else {
-			*nbytes -= *length;
-			*offset += *length;
-		}
-
-		return 0;
-	} else {
-		len = (*nbytes <= dev->scatter_buffer_size) ?
-				(*nbytes) : dev->scatter_buffer_size;
-		memcpy(phys_to_virt(*addr),
-			dev->scatter_buffer_va +
-			*idx * dev->scatter_buffer_size + *offset,
-			len);
-		*offset = 0;
-		*nbytes -= len;
-
-		if (*idx == PPC4XX_LAST_SD)
-			*idx = 0;
-		else
-			(*idx)++;
-
-		return 0;
-    }
-}
-
 static void crypto4xx_copy_pkt_to_dst(struct crypto4xx_device *dev,
 				      struct ce_pd *pd,
 				      struct pd_uinfo *pd_uinfo,
 				      u32 nbytes,
 				      struct scatterlist *dst)
 {
-	dma_addr_t addr;
-	u32 this_sd;
-	u32 offset;
-	u32 len;
-	u32 i;
-	u32 sg_len;
-	struct scatterlist *sg;
+	unsigned int first_sd = pd_uinfo->first_sd;
+	unsigned int last_sd;
+	unsigned int overflow = 0;
+	unsigned int to_copy;
+	unsigned int dst_start = 0;
+
+	/*
+	 * Because the scatter buffers are all neatly organized in one
+	 * big continuous ringbuffer; scatterwalk_map_and_copy() can
+	 * be instructed to copy a range of buffers in one go.
+	 */
 
-	this_sd = pd_uinfo->first_sd;
-	offset = 0;
-	i = 0;
+	last_sd = (first_sd + pd_uinfo->num_sd);
+	if (last_sd > PPC4XX_LAST_SD) {
+		last_sd = PPC4XX_LAST_SD;
+		overflow = last_sd % PPC4XX_NUM_SD;
+	}
 
 	while (nbytes) {
-		sg = &dst[i];
-		sg_len = sg->length;
-		addr = dma_map_page(dev->core_dev->device, sg_page(sg),
-				sg->offset, sg->length, DMA_TO_DEVICE);
-
-		if (offset == 0) {
-			len = (nbytes <= sg->length) ? nbytes : sg->length;
-			while (crypto4xx_fill_one_page(dev, &addr, &len,
-				&this_sd, &offset, &nbytes))
-				;
-			if (!nbytes)
-				return;
-			i++;
-		} else {
-			len = (nbytes <= (dev->scatter_buffer_size - offset)) ?
-				nbytes : (dev->scatter_buffer_size - offset);
-			len = (sg->length < len) ? sg->length : len;
-			while (crypto4xx_fill_one_page(dev, &addr, &len,
-					       &this_sd, &offset, &nbytes))
-				;
-			if (!nbytes)
-				return;
-			sg_len -= len;
-			if (sg_len) {
-				addr += len;
-				while (crypto4xx_fill_one_page(dev, &addr,
-					&sg_len, &this_sd, &offset, &nbytes))
-					;
-			}
-			i++;
+		void *buf = dev->scatter_buffer_va +
+			first_sd * PPC4XX_SD_BUFFER_SIZE;
+
+		to_copy = min(nbytes, PPC4XX_SD_BUFFER_SIZE *
+				      (1 + last_sd - first_sd));
+		scatterwalk_map_and_copy(buf, dst, dst_start, to_copy, 1);
+		nbytes -= to_copy;
+
+		if (overflow) {
+			first_sd = 0;
+			last_sd = overflow;
+			dst_start += to_copy;
+			overflow = 0;
 		}
 	}
 }
-- 
2.14.1
