From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 4/4] crypto: talitos - static code checker fixes
Date: Mon, 11 May 2015 20:04:56 +0300
Message-ID: <1431363896-2745-1-git-send-email-horia.geanta@freescale.com>
References: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:55808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751039AbbEKRUt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 13:20:49 -0400
In-Reply-To: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-change req_ctx->nbuf from u64 to unsigned int to silence checker
warnings; this is safe since nbuf value is <= HASH_MAX_BLOCK_SIZE
-remove unused value read from TALITOS_CCPSR; there is no requirement
to read upper 32b before reading lower 32b of a 64b register;
SEC RM mentions: "reads can always be done by byte, word, or dword"
-remove unused return value of sg_to_link_tbl()
-change "len" parameter of map_single_talitos_ptr() and
to_talitos_ptr_len() to unsigned int; later, cpu_to_be16 will __force
downcast the value to unsigned short without any checker warning

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7367f6cba2ed..cb183b0b8578 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -63,7 +63,7 @@ static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
 		ptr->eptr = upper_32_bits(dma_addr);
 }
 
-static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned short len,
+static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned int len,
 			       bool is_sec1)
 {
 	if (is_sec1) {
@@ -94,7 +94,7 @@ static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr, bool is_sec1)
  */
 static void map_single_talitos_ptr(struct device *dev,
 				   struct talitos_ptr *ptr,
-				   unsigned short len, void *data,
+				   unsigned int len, void *data,
 				   enum dma_data_direction dir)
 {
 	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
@@ -543,7 +543,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 	int ch, error, reset_dev = 0;
-	u32 v, v_lo;
+	u32 v_lo;
 	bool is_sec1 = has_ftr_sec1(priv);
 	int reset_ch = is_sec1 ? 1 : 0; /* only SEC2 supports continuation */
 
@@ -560,7 +560,6 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 
 		error = -EINVAL;
 
-		v = in_be32(priv->chan[ch].reg + TALITOS_CCPSR);
 		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
 
 		if (v_lo & TALITOS_CCPSR_LO_DOF) {
@@ -815,7 +814,7 @@ struct talitos_ahash_req_ctx {
 	unsigned int first;
 	unsigned int last;
 	unsigned int to_hash_later;
-	u64 nbuf;
+	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
 };
@@ -1639,8 +1638,7 @@ void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
 					    (edesc->src_nents + 1) *
 					     sizeof(struct talitos_ptr), 0);
 			ptr->j_extent |= DESC_PTR_LNKTBL_JUMP;
-			sg_count = sg_to_link_tbl(dst, sg_count, len,
-						  link_tbl_ptr);
+			sg_to_link_tbl(dst, sg_count, len, link_tbl_ptr);
 			dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 						   edesc->dma_len,
 						   DMA_BIDIRECTIONAL);
-- 
1.8.3.1
