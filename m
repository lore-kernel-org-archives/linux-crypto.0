From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 07/17] crypto: talitos - Split talitos.h into 2 parts
Date: Fri,  6 Mar 2015 17:39:45 +0100 (CET)
Message-ID: <20150306163945.BE1011A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In order to be able to manage differences between SEC1 and SEC2, we split
talitos.h into two parts.
talitos2.h will contain all parts that are specific to SEC2 and different on SEC1

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.h  | 163 +-----------------------------------
 drivers/crypto/talitos2.h | 204 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+), 162 deletions(-)
 create mode 100644 drivers/crypto/talitos2.h

diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 566dc92..09c97ad 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -29,34 +29,11 @@
  */
 
 #define TALITOS_TIMEOUT 100000
-#define TALITOS_MAX_DATA_LEN 65535
 
 #define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
 #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
 #define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
 
-/* descriptor pointer entry */
-struct talitos_ptr {
-	__be16 len;     /* length */
-	u8 j_extent;    /* jump to sg link table and/or extent */
-	u8 eptr;        /* extended address */
-	__be32 ptr;     /* address */
-};
-
-static const struct talitos_ptr zero_entry = {
-	.len = 0,
-	.j_extent = 0,
-	.eptr = 0,
-	.ptr = 0
-};
-
-/* descriptor */
-struct talitos_desc {
-	__be32 hdr;                     /* header high bits */
-	__be32 hdr_lo;                  /* header low bits */
-	struct talitos_ptr ptr[7];      /* ptr/len pair array */
-};
-
 /**
  * talitos_request - descriptor submission request
  * @desc: descriptor pointer (kernel virtual)
@@ -133,38 +110,6 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
-/*
- * talitos_edesc - s/w-extended descriptor
- * @assoc_nents: number of segments in associated data scatterlist
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @assoc_chained: whether assoc is chained or not
- * @src_chained: whether src is chained or not
- * @dst_chained: whether dst is chained or not
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int assoc_nents;
-	int src_nents;
-	int dst_nents;
-	bool assoc_chained;
-	bool src_chained;
-	bool dst_chained;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	struct talitos_ptr link_tbl[0];
-};
-
 #define TALITOS_MAX_KEY_SIZE		96
 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 #define TALITOS_MAX_IV_LENGTH		16
@@ -181,77 +126,6 @@ struct talitos_ctx {
 	unsigned int authsize;
 };
 
-static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
-{
-	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	ptr->eptr = upper_32_bits(dma_addr);
-}
-
-/*
- * map virtual single (contiguous) pointer to h/w descriptor pointer
- */
-static inline void map_single_talitos_ptr(struct device *dev,
-				   struct talitos_ptr *talitos_ptr,
-				   unsigned short len, void *data,
-				   unsigned char extent,
-				   enum dma_data_direction dir)
-{
-	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
-
-	talitos_ptr->len = cpu_to_be16(len);
-	to_talitos_ptr(talitos_ptr, dma_addr);
-	talitos_ptr->j_extent = extent;
-}
-
-/*
- * unmap bus single (contiguous) h/w descriptor pointer
- */
-static inline void unmap_single_talitos_ptr(struct device *dev,
-				     struct talitos_ptr *talitos_ptr,
-				     enum dma_data_direction dir)
-{
-	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
-			 be16_to_cpu(talitos_ptr->len), dir);
-}
-
-static inline int talitos_map_sg(struct device *dev, struct scatterlist *sg,
-			  unsigned int nents, enum dma_data_direction dir,
-			  bool chained)
-{
-	if (unlikely(chained))
-		while (sg) {
-			dma_map_sg(dev, sg, 1, dir);
-			sg = sg_next(sg);
-		}
-	else
-		dma_map_sg(dev, sg, nents, dir);
-	return nents;
-}
-
-static inline void talitos_unmap_sg_chain(struct device *dev,
-					  struct scatterlist *sg,
-					  enum dma_data_direction dir)
-{
-	while (sg) {
-		dma_unmap_sg(dev, sg, 1, dir);
-		sg = sg_next(sg);
-	}
-}
-
-extern void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
-				 struct scatterlist *dst, unsigned int len,
-				 struct talitos_edesc *edesc,
-				 struct talitos_ptr *ptr_in,
-				 struct talitos_ptr *ptr_out);
-extern int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
-			  unsigned int len, struct talitos_edesc *edesc,
-			  enum dma_data_direction dir, struct talitos_ptr *ptr);
-extern void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
-			    unsigned int len, struct talitos_edesc *edesc,
-			    enum dma_data_direction dir,
-			    struct talitos_ptr *ptr, int sg_count);
-
-
 extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 			  void (*callback)(struct device *dev,
 					   struct talitos_desc *desc,
@@ -269,7 +143,6 @@ extern struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 int icv_stashing,
 						 u32 cryptoflags,
 						 bool encrypt);
-extern int talitos_alg_alloc_aead(struct crypto_alg *alg);
 extern int talitos_cra_init(struct crypto_tfm *tfm);
 
 /* .features flag */
@@ -282,21 +155,15 @@ extern int talitos_cra_init(struct crypto_tfm *tfm);
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
  */
 
-#define ISR_FORMAT(x)			(((x) << 4) | (x))
-
 /* global register offset addresses */
 #define TALITOS_MCR			0x1030  /* master control register */
 #define   TALITOS_MCR_RCA0		(1 << 15) /* remap channel 0 */
 #define   TALITOS_MCR_RCA1		(1 << 14) /* remap channel 1 */
 #define   TALITOS_MCR_RCA2		(1 << 13) /* remap channel 2 */
 #define   TALITOS_MCR_RCA3		(1 << 12) /* remap channel 3 */
-#define   TALITOS_MCR_SWR		0x1     /* s/w reset */
 #define TALITOS_MCR_LO			0x1034
 #define TALITOS_IMR			0x1008  /* interrupt mask register */
-#define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
-#define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
 #define TALITOS_IMR_LO			0x100C
-#define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
 #define   TALITOS_ISR_4CHERR		ISR_FORMAT(0xa)	/* 4 ch errors mask */
 #define   TALITOS_ISR_4CHDONE		ISR_FORMAT(0x5)	/* 4 ch done mask */
@@ -310,12 +177,9 @@ extern int talitos_cra_init(struct crypto_tfm *tfm);
 
 /* channel register address stride */
 #define TALITOS_CH_BASE_OFFSET		0x1000	/* default channel map base */
-#define TALITOS_CH_STRIDE		0x100
 
 /* channel configuration register  */
 #define TALITOS_CCCR			0x8
-#define   TALITOS_CCCR_CONT		0x2    /* channel continue */
-#define   TALITOS_CCCR_RESET		0x1    /* channel reset */
 #define TALITOS_CCCR_LO			0xc
 #define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
 #define   TALITOS_CCCR_LO_EAE		0x20   /* extended address enable */
@@ -326,18 +190,6 @@ extern int talitos_cra_init(struct crypto_tfm *tfm);
 /* CCPSR: channel pointer status register */
 #define TALITOS_CCPSR			0x10
 #define TALITOS_CCPSR_LO		0x14
-#define   TALITOS_CCPSR_LO_DOF		0x8000 /* double FF write oflow error */
-#define   TALITOS_CCPSR_LO_SOF		0x4000 /* single FF write oflow error */
-#define   TALITOS_CCPSR_LO_MDTE		0x2000 /* master data transfer error */
-#define   TALITOS_CCPSR_LO_SGDLZ	0x1000 /* s/g data len zero error */
-#define   TALITOS_CCPSR_LO_FPZ		0x0800 /* fetch ptr zero error */
-#define   TALITOS_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
-#define   TALITOS_CCPSR_LO_IEU		0x0200 /* invalid EU error */
-#define   TALITOS_CCPSR_LO_EU		0x0100 /* EU error detected */
-#define   TALITOS_CCPSR_LO_GB		0x0080 /* gather boundary error */
-#define   TALITOS_CCPSR_LO_GRL		0x0040 /* gather return/length error */
-#define   TALITOS_CCPSR_LO_SB		0x0020 /* scatter boundary error */
-#define   TALITOS_CCPSR_LO_SRL		0x0010 /* scatter return/length error */
 
 /* channel fetch fifo register */
 #define TALITOS_FF			0x48
@@ -359,16 +211,6 @@ extern int talitos_cra_init(struct crypto_tfm *tfm);
 #define TALITOS_SCATTER			0xe0
 #define TALITOS_SCATTER_LO		0xe4
 
-/* execution unit registers base */
-#define TALITOS_DEU			0x2000
-#define TALITOS_AESU			0x4000
-#define TALITOS_MDEU			0x6000
-#define TALITOS_AFEU			0x8000
-#define TALITOS_RNGU			0xa000
-#define TALITOS_PKEU			0xc000
-#define TALITOS_KEU			0xe000
-#define TALITOS_CRCU			0xf000
-
 /* execution unit interrupt status registers */
 /* DES unit */
 #define TALITOS_DEUISR			(TALITOS_DEU + 0x30)
@@ -499,7 +341,4 @@ extern int talitos_cra_init(struct crypto_tfm *tfm);
 #define DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU	cpu_to_be32(2 << 3)
 #define DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU	cpu_to_be32(4 << 3)
 
-/* link table extent field bits */
-#define DESC_PTR_LNKTBL_JUMP			0x80
-#define DESC_PTR_LNKTBL_RETURN			0x02
-#define DESC_PTR_LNKTBL_NEXT			0x01
+#include "talitos2.h"
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
new file mode 100644
index 0000000..e7a91cf
--- /dev/null
+++ b/drivers/crypto/talitos2.h
@@ -0,0 +1,204 @@
+/*
+ * Freescale SEC2 (talitos) device register and descriptor header defines
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#define TALITOS_MAX_DATA_LEN 65535
+
+/* descriptor pointer entry */
+struct talitos_ptr {
+	__be16 len;     /* length */
+	u8 j_extent;    /* jump to sg link table and/or extent */
+	u8 eptr;        /* extended address */
+	__be32 ptr;     /* address */
+};
+
+static const struct talitos_ptr zero_entry = {
+	.len = 0,
+	.j_extent = 0,
+	.eptr = 0,
+	.ptr = 0
+};
+
+/* descriptor */
+struct talitos_desc {
+	__be32 hdr;                     /* header high bits */
+	__be32 hdr_lo;                  /* header low bits */
+	struct talitos_ptr ptr[7];      /* ptr/len pair array */
+};
+
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	bool assoc_chained;
+	bool src_chained;
+	bool dst_chained;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	struct talitos_ptr link_tbl[0];
+};
+
+static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->eptr = upper_32_bits(dma_addr);
+}
+
+/*
+ * map virtual single (contiguous) pointer to h/w descriptor pointer
+ */
+static inline void map_single_talitos_ptr(struct device *dev,
+				   struct talitos_ptr *talitos_ptr,
+				   unsigned short len, void *data,
+				   unsigned char extent,
+				   enum dma_data_direction dir)
+{
+	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
+
+	talitos_ptr->len = cpu_to_be16(len);
+	to_talitos_ptr(talitos_ptr, dma_addr);
+	talitos_ptr->j_extent = extent;
+}
+
+/*
+ * unmap bus single (contiguous) h/w descriptor pointer
+ */
+static inline void unmap_single_talitos_ptr(struct device *dev,
+				     struct talitos_ptr *talitos_ptr,
+				     enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, be32_to_cpu(talitos_ptr->ptr),
+			 be16_to_cpu(talitos_ptr->len), dir);
+}
+
+static inline int talitos_map_sg(struct device *dev, struct scatterlist *sg,
+			  unsigned int nents, enum dma_data_direction dir,
+			  bool chained)
+{
+	if (unlikely(chained))
+		while (sg) {
+			dma_map_sg(dev, sg, 1, dir);
+			sg = sg_next(sg);
+		}
+	else
+		dma_map_sg(dev, sg, nents, dir);
+	return nents;
+}
+
+static inline void talitos_unmap_sg_chain(struct device *dev,
+					  struct scatterlist *sg,
+					  enum dma_data_direction dir)
+{
+	while (sg) {
+		dma_unmap_sg(dev, sg, 1, dir);
+		sg = sg_next(sg);
+	}
+}
+
+extern void unmap_sg_talitos_ptr(struct device *dev, struct scatterlist *src,
+				 struct scatterlist *dst, unsigned int len,
+				 struct talitos_edesc *edesc,
+				 struct talitos_ptr *ptr_in,
+				 struct talitos_ptr *ptr_out);
+extern int map_sg_in_talitos_ptr(struct device *dev, struct scatterlist *src,
+			  unsigned int len, struct talitos_edesc *edesc,
+			  enum dma_data_direction dir, struct talitos_ptr *ptr);
+extern void map_sg_out_talitos_ptr(struct device *dev, struct scatterlist *dst,
+			    unsigned int len, struct talitos_edesc *edesc,
+			    enum dma_data_direction dir,
+			    struct talitos_ptr *ptr, int sg_count);
+
+
+extern int talitos_alg_alloc_aead(struct crypto_alg *alg);
+
+#define ISR_FORMAT(x)			(((x) << 4) | (x))
+
+/* global register offset addresses */
+#define   TALITOS_MCR_SWR		0x1     /* s/w reset */
+
+#define   TALITOS_IMR_INIT		0x100ff /* enable channel IRQs */
+#define   TALITOS_IMR_DONE		0x00055 /* done IRQs */
+
+#define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
+
+/* channel register address stride */
+#define TALITOS_CH_STRIDE		0x100
+
+/* channel configuration register  */
+#define   TALITOS_CCCR_CONT		0x2    /* channel continue */
+#define   TALITOS_CCCR_RESET		0x1    /* channel reset */
+
+/* CCPSR: channel pointer status register */
+#define   TALITOS_CCPSR_LO_DOF		0x8000 /* double FF write oflow error */
+#define   TALITOS_CCPSR_LO_SOF		0x4000 /* single FF write oflow error */
+#define   TALITOS_CCPSR_LO_MDTE		0x2000 /* master data transfer error */
+#define   TALITOS_CCPSR_LO_SGDLZ	0x1000 /* s/g data len zero error */
+#define   TALITOS_CCPSR_LO_FPZ		0x0800 /* fetch ptr zero error */
+#define   TALITOS_CCPSR_LO_IDH		0x0400 /* illegal desc hdr error */
+#define   TALITOS_CCPSR_LO_IEU		0x0200 /* invalid EU error */
+#define   TALITOS_CCPSR_LO_EU		0x0100 /* EU error detected */
+#define   TALITOS_CCPSR_LO_GB		0x0080 /* gather boundary error */
+#define   TALITOS_CCPSR_LO_GRL		0x0040 /* gather return/length error */
+#define   TALITOS_CCPSR_LO_SB		0x0020 /* scatter boundary error */
+#define   TALITOS_CCPSR_LO_SRL		0x0010 /* scatter return/length error */
+
+/* execution unit registers base */
+#define TALITOS_DEU			0x2000
+#define TALITOS_AESU			0x4000
+#define TALITOS_MDEU			0x6000
+#define TALITOS_AFEU			0x8000
+#define TALITOS_RNGU			0xa000
+#define TALITOS_PKEU			0xc000
+#define TALITOS_KEU			0xe000
+#define TALITOS_CRCU			0xf000
+
+/* link table extent field bits */
+#define DESC_PTR_LNKTBL_JUMP			0x80
+#define DESC_PTR_LNKTBL_RETURN			0x02
+#define DESC_PTR_LNKTBL_NEXT			0x01
-- 
2.1.0
