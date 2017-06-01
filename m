From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 07/20] staging: ccree: refactor HW command FIFO access
Date: Thu,  1 Jun 2017 14:02:57 +0300
Message-ID: <1496314993-30229-8-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The programming of the HW command FIFO in ccree was done via
a set of macros which suffer a few problems:
- Use of macros rather than inline leaves out parameter type
  checking and risks multiple macro parameter evaluation side
  effects.
- Implemented via hand rolled versions of bitfield operations.

This patch refactors the HW command queue access into a set
of inline functions using generic kernel bitfield access
infrastructure, thus resolving the above issues and opening
the way later on to drop the hand rolled bitfield macros
once additional users are dropped in later patches in the
series.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_bitops.h        |   8 +-
 drivers/staging/ccree/cc_hw_queue_defs.h | 660 ++++++++++++----------
 drivers/staging/ccree/ssi_aead.c         | 901 +++++++++++++++----------------
 drivers/staging/ccree/ssi_cipher.c       | 224 ++++----
 drivers/staging/ccree/ssi_driver.h       |   4 +-
 drivers/staging/ccree/ssi_fips_ll.c      | 704 ++++++++++++------------
 drivers/staging/ccree/ssi_hash.c         | 832 ++++++++++++++--------------
 drivers/staging/ccree/ssi_ivgen.c        |  77 ++-
 drivers/staging/ccree/ssi_request_mgr.c  |  23 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |   8 +-
 10 files changed, 1753 insertions(+), 1688 deletions(-)

diff --git a/drivers/staging/ccree/cc_bitops.h b/drivers/staging/ccree/cc_bitops.h
index ee5238a..cbdc1ab 100644
--- a/drivers/staging/ccree/cc_bitops.h
+++ b/drivers/staging/ccree/cc_bitops.h
@@ -21,8 +21,12 @@
 #ifndef _CC_BITOPS_H_
 #define _CC_BITOPS_H_
 
-#define BITMASK(mask_size) (((mask_size) < 32) ?	\
-	((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+
+#define BITMASK(mask_size) (((mask_size) < 32) ?       \
+       ((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
+
 #define BITMASK_AT(mask_size, mask_offset) (BITMASK(mask_size) << (mask_offset))
 
 #define BITFIELD_GET(word, bit_offset, bit_size) \
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index 7138176..c3f9d6a 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -26,21 +26,65 @@
 *				DEFINITIONS
 ******************************************************************************/
 
-/* Dma AXI Secure bit */
-#define	AXI_SECURE	0
-#define AXI_NOT_SECURE	1
-
 #define HW_DESC_SIZE_WORDS		6
 #define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
 
 #define _HW_DESC_MONITOR_KICK 0x7FFFC00
 
+#define CC_REG_NAME(word, name) DX_DSCRPTR_QUEUE_WORD ## word ## _ ## name
+
+#define CC_REG_LOW(word, name)  \
+	(DX_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SHIFT)
+
+#define CC_REG_HIGH(word, name) \
+	(CC_REG_LOW(word, name) + \
+	 DX_DSCRPTR_QUEUE_WORD ## word ## _ ## name ## _BIT_SIZE - 1)
+
+#define CC_GENMASK(word, name) \
+	GENMASK(CC_REG_HIGH(word, name), CC_REG_LOW(word, name))
+
+#define WORD0_VALUE		CC_GENMASK(0, VALUE)
+#define WORD1_DIN_CONST_VALUE	CC_GENMASK(1, DIN_CONST_VALUE)
+#define WORD1_DIN_DMA_MODE	CC_GENMASK(1, DIN_DMA_MODE)
+#define WORD1_DIN_SIZE		CC_GENMASK(1, DIN_SIZE)
+#define WORD1_NOT_LAST		CC_GENMASK(1, NOT_LAST)
+#define WORD1_NS_BIT		CC_GENMASK(1, NS_BIT)
+#define WORD2_VALUE		CC_GENMASK(2, VALUE)
+#define WORD3_DOUT_DMA_MODE	CC_GENMASK(3, DOUT_DMA_MODE)
+#define WORD3_DOUT_LAST_IND	CC_GENMASK(3, DOUT_LAST_IND)
+#define WORD3_DOUT_SIZE		CC_GENMASK(3, DOUT_SIZE)
+#define WORD3_HASH_XOR_BIT	CC_GENMASK(3, HASH_XOR_BIT)
+#define WORD3_NS_BIT		CC_GENMASK(3, NS_BIT)
+#define WORD3_QUEUE_LAST_IND	CC_GENMASK(3, QUEUE_LAST_IND)
+#define WORD4_ACK_NEEDED	CC_GENMASK(4, ACK_NEEDED)
+#define WORD4_AES_SEL_N_HASH	CC_GENMASK(4, AES_SEL_N_HASH)
+#define WORD4_BYTES_SWAP	CC_GENMASK(4, BYTES_SWAP)
+#define WORD4_CIPHER_CONF0	CC_GENMASK(4, CIPHER_CONF0)
+#define WORD4_CIPHER_CONF1	CC_GENMASK(4, CIPHER_CONF1)
+#define WORD4_CIPHER_CONF2	CC_GENMASK(4, CIPHER_CONF2)
+#define WORD4_CIPHER_DO		CC_GENMASK(4, CIPHER_DO)
+#define WORD4_CIPHER_MODE	CC_GENMASK(4, CIPHER_MODE)
+#define WORD4_CMAC_SIZE0	CC_GENMASK(4, CMAC_SIZE0)
+#define WORD4_DATA_FLOW_MODE	CC_GENMASK(4, DATA_FLOW_MODE)
+#define WORD4_KEY_SIZE		CC_GENMASK(4, KEY_SIZE)
+#define WORD4_SETUP_OPERATION	CC_GENMASK(4, SETUP_OPERATION)
+#define WORD5_DIN_ADDR_HIGH	CC_GENMASK(5, DIN_ADDR_HIGH)
+#define WORD5_DOUT_ADDR_HIGH	CC_GENMASK(5, DOUT_ADDR_HIGH)
+
 /******************************************************************************
 *				TYPE DEFINITIONS
 ******************************************************************************/
 
 struct cc_hw_desc {
-	u32 word[HW_DESC_SIZE_WORDS];
+	union {
+		u32 word[HW_DESC_SIZE_WORDS];
+		u16 hword[HW_DESC_SIZE_WORDS * 2];
+	};
+};
+
+enum cc_axi_sec {
+	AXI_SECURE = 0,
+	AXI_NOT_SECURE = 1
 };
 
 enum cc_desc_direction {
@@ -164,369 +208,403 @@ enum cc_hw_des_key_size {
 /* Descriptor packing macros */
 /*****************************/
 
-#define GET_HW_Q_DESC_WORD_IDX(descWordIdx) (CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD ## descWordIdx))
-
-#define HW_DESC_INIT(pDesc)  memset(pDesc, 0, sizeof(struct cc_hw_desc))
+/*
+ * Init a HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void hw_desc_init(struct cc_hw_desc *pdesc)
+{
+	memset(pdesc, 0, sizeof(struct cc_hw_desc));
+}
 
-/*!
- * This macro indicates the end of current HW descriptors flow and release the HW engines.
+/*
+ * Indicates the end of current HW descriptors flow and release the HW engines.
  *
- * \param pDesc pointer HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
  */
-#define HW_DESC_SET_QUEUE_LAST_IND(pDesc)								\
-	do {												\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, QUEUE_LAST_IND, (pDesc)->word[3], 1);	\
-	} while (0)
+static inline void set_queue_last_ind(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[3] |= FIELD_PREP(WORD3_QUEUE_LAST_IND, 1);
+}
 
-/*!
- * This macro signs the end of HW descriptors flow by asking for completion ack, and release the HW engines
+/*
+ * Signs the end of HW descriptors flow by asking for completion ack,
+ * and release the HW engines
  *
- * \param pDesc pointer HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
  */
-#define HW_DESC_SET_ACK_LAST(pDesc)									\
-	do {												\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, QUEUE_LAST_IND, (pDesc)->word[3], 1);	\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, ACK_NEEDED, (pDesc)->word[4], 1);	\
-	} while (0)
+static inline void set_ack_last(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[3] |= FIELD_PREP(WORD3_QUEUE_LAST_IND, 1);
+	pdesc->word[4] |= FIELD_PREP(WORD4_ACK_NEEDED, 1);
+}
 
 #define MSB64(_addr) (sizeof(_addr) == 4 ? 0 : ((_addr) >> 32) & U16_MAX)
 
-/*!
- * This macro sets the DIN field of a HW descriptors
+/*
+ * Set the DIN field of a HW descriptors
  *
- * \param pDesc pointer HW descriptor struct
- * \param dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
- * \param dinAdr DIN address
- * \param dinSize Data size in bytes
- * \param axiNs AXI secure bit
- */
-#define HW_DESC_SET_DIN_TYPE(pDesc, dmaMode, dinAdr, dinSize, axiNs)								\
-	do {															\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (dinAdr) & U32_MAX);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DIN_ADDR_HIGH, (pDesc)->word[5], MSB64(dinAdr));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], (dmaMode));			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));				\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, NS_BIT, (pDesc)->word[1], (axiNs));				\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @dma_mode: dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * @addr: dinAdr DIN address
+ * @size: Data size in bytes
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_din_type(struct cc_hw_desc *pdesc,
+				enum cc_dma_mode dma_mode, dma_addr_t addr,
+				u32 size, enum cc_axi_sec axi_sec)
+{
+	pdesc->word[0] = (u32)addr;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	pdesc->word[5] |= FIELD_PREP(WORD5_DIN_ADDR_HIGH, ((u16)(addr >> 32)));
+#endif
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_DMA_MODE, dma_mode) |
+				FIELD_PREP(WORD1_DIN_SIZE, size) |
+				FIELD_PREP(WORD1_NS_BIT, axi_sec);
+}
 
-/*!
- * This macro sets the DIN field of a HW descriptors to NO DMA mode. Used for NOP descriptor, register patches and
- * other special modes
+/*
+ * Set the DIN field of a HW descriptors to NO DMA mode.
+ * Used for NOP descriptor, register patches and other special modes.
  *
- * \param pDesc pointer HW descriptor struct
- * \param dinAdr DIN address
- * \param dinSize Data size in bytes
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DIN address
+ * @size: Data size in bytes
  */
-#define HW_DESC_SET_DIN_NO_DMA(pDesc, dinAdr, dinSize)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (u32)(dinAdr));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
-	} while (0)
+static inline void set_din_no_dma(struct cc_hw_desc *pdesc, u32 addr, u32 size)
+{
+	pdesc->word[0] = addr;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size);
+}
 
-/*!
- * This macro sets the DIN field of a HW descriptors to SRAM mode.
+/*
+ * Set the DIN field of a HW descriptors to SRAM mode.
  * Note: No need to check SRAM alignment since host requests do not use SRAM and
  * adaptor will enforce alignment check.
  *
- * \param pDesc pointer HW descriptor struct
- * \param dinAdr DIN address
- * \param dinSize Data size in bytes
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DIN address
+ * @size Data size in bytes
  */
-#define HW_DESC_SET_DIN_SRAM(pDesc, dinAdr, dinSize)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (u32)(dinAdr));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], DMA_SRAM);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
-	} while (0)
+static inline void set_din_sram(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				u32 size)
+{
+	pdesc->word[0] = (u32)addr;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_SIZE, size) |
+				FIELD_PREP(WORD1_DIN_DMA_MODE, DMA_SRAM);
+}
 
-/*! This macro sets the DIN field of a HW descriptors to CONST mode
+/*
+ * Set the DIN field of a HW descriptors to CONST mode
  *
- * \param pDesc pointer HW descriptor struct
- * \param val DIN const value
- * \param dinSize Data size in bytes
+ * @pdesc: pointer HW descriptor struct
+ * @val: DIN const value
+ * @size: Data size in bytes
  */
-#define HW_DESC_SET_DIN_CONST(pDesc, val, dinSize)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0, VALUE, (pDesc)->word[0], (u32)(val));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_CONST_VALUE, (pDesc)->word[1], 1);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_DMA_MODE, (pDesc)->word[1], DMA_SRAM);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, DIN_SIZE, (pDesc)->word[1], (dinSize));			\
-	} while (0)
+static inline void set_din_const(struct cc_hw_desc *pdesc, u32 val, u32 size)
+{
+	pdesc->word[0] = val;
+	pdesc->word[1] |= FIELD_PREP(WORD1_DIN_CONST_VALUE, 1) |
+			FIELD_PREP(WORD1_DIN_DMA_MODE, DMA_SRAM) |
+			FIELD_PREP(WORD1_DIN_SIZE, size);
+}
 
-/*!
- * This macro sets the DIN not last input data indicator
+/*
+ * Set the DIN not last input data indicator
  *
- * \param pDesc pointer HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
  */
-#define HW_DESC_SET_DIN_NOT_LAST_INDICATION(pDesc)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD1, NOT_LAST, (pDesc)->word[1], 1);				\
-	} while (0)
+static inline void set_din_not_last_indication(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[1] |= FIELD_PREP(WORD1_NOT_LAST, 1);
+}
 
-/*!
- * This macro sets the DOUT field of a HW descriptors
+/*
+ * Set the DOUT field of a HW descriptors
  *
- * \param pDesc pointer HW descriptor struct
- * \param dmaMode The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
- * \param doutAdr DOUT address
- * \param doutSize Data size in bytes
- * \param axiNs AXI secure bit
+ * @pdesc: pointer HW descriptor struct
+ * @dma_mode: The DMA mode: NO_DMA, SRAM, DLLI, MLLI, CONSTANT
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @axi_sec: AXI secure bit
  */
-#define HW_DESC_SET_DOUT_TYPE(pDesc, dmaMode, doutAdr, doutSize, axiNs)							\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr) & U32_MAX);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr));	\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], (dmaMode));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));			\
-	} while (0)
+static inline void set_dout_type(struct cc_hw_desc *pdesc,
+				 enum cc_dma_mode dma_mode, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec)
+{
+	pdesc->word[2] = (u32)addr;
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	pdesc->word[5] |= FIELD_PREP(WORD5_DOUT_ADDR_HIGH, ((u16)(addr >> 32)));
+#endif
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_DMA_MODE, dma_mode) |
+				FIELD_PREP(WORD3_DOUT_SIZE, size) |
+				FIELD_PREP(WORD3_NS_BIT, axi_sec);
+}
 
-/*!
- * This macro sets the DOUT field of a HW descriptors to DLLI type
+/*
+ * Set the DOUT field of a HW descriptors to DLLI type
  * The LAST INDICATION is provided by the user
  *
- * \param pDesc pointer HW descriptor struct
- * \param doutAdr DOUT address
- * \param doutSize Data size in bytes
- * \param lastInd The last indication bit
- * \param axiNs AXI secure bit
- */
-#define HW_DESC_SET_DOUT_DLLI(pDesc, doutAdr, doutSize, axiNs, lastInd)								\
-	do {															\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr) & U32_MAX);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr));	\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_DLLI);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], lastInd);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));				\
-	} while (0)
+ * @pdesc pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @last_ind: The last indication bit
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_dout_dlli(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec,
+				 u32 last_ind)
+{
+	set_dout_type(pdesc, DMA_DLLI, addr, size, axi_sec);
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_LAST_IND, last_ind);
+}
 
-/*!
- * This macro sets the DOUT field of a HW descriptors to DLLI type
+/*
+ * Set the DOUT field of a HW descriptors to DLLI type
  * The LAST INDICATION is provided by the user
  *
- * \param pDesc pointer HW descriptor struct
- * \param doutAdr DOUT address
- * \param doutSize Data size in bytes
- * \param lastInd The last indication bit
- * \param axiNs AXI secure bit
- */
-#define HW_DESC_SET_DOUT_MLLI(pDesc, doutAdr, doutSize, axiNs, lastInd)								\
-	do {															\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (doutAdr) & U32_MAX);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD5, DOUT_ADDR_HIGH, (pDesc)->word[5], MSB64(doutAdr));	\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_MLLI);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], lastInd);			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, NS_BIT, (pDesc)->word[3], (axiNs));				\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @last_ind: The last indication bit
+ * @axi_sec: AXI secure bit
+ */
+static inline void set_dout_mlli(struct cc_hw_desc *pdesc, dma_addr_t addr,
+				 u32 size, enum cc_axi_sec axi_sec,
+				 bool last_ind)
+{
+	set_dout_type(pdesc, DMA_MLLI, addr, size, axi_sec);
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_LAST_IND, last_ind);
+}
 
-/*!
- * This macro sets the DOUT field of a HW descriptors to NO DMA mode. Used for NOP descriptor, register patches and
- * other special modes
+/*
+ * Set the DOUT field of a HW descriptors to NO DMA mode.
+ * Used for NOP descriptor, register patches and other special modes.
  *
- * \param pDesc pointer HW descriptor struct
- * \param doutAdr DOUT address
- * \param doutSize Data size in bytes
- * \param registerWriteEnable Enables a write operation to a register
- */
-#define HW_DESC_SET_DOUT_NO_DMA(pDesc, doutAdr, doutSize, registerWriteEnable)							\
-	do {															\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(doutAdr));			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));			\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_LAST_IND, (pDesc)->word[3], (registerWriteEnable));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
+ * @write_enable: Enables a write operation to a register
+ */
+static inline void set_dout_no_dma(struct cc_hw_desc *pdesc, u32 addr,
+				   u32 size, bool write_enable)
+{
+	pdesc->word[2] = addr;
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_SIZE, size) |
+			FIELD_PREP(WORD3_DOUT_LAST_IND, write_enable);
+}
 
-/*!
- * This macro sets the word for the XOR operation.
+/*
+ * Set the word for the XOR operation.
  *
- * \param pDesc pointer HW descriptor struct
- * \param xorVal xor data value
+ * @pdesc: pointer HW descriptor struct
+ * @val: xor data value
  */
-#define HW_DESC_SET_XOR_VAL(pDesc, xorVal)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(xorVal));		\
-	} while (0)
+static inline void set_xor_val(struct cc_hw_desc *pdesc, u32 val)
+{
+	pdesc->word[2] = val;
+}
 
-/*!
- * This macro sets the XOR indicator bit in the descriptor
+/*
+ * Sets the XOR indicator bit in the descriptor
  *
- * \param pDesc pointer HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
  */
-#define HW_DESC_SET_XOR_ACTIVE(pDesc)											\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, HASH_XOR_BIT, (pDesc)->word[3], 1);			\
-	} while (0)
+static inline void set_xor_active(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[3] |= FIELD_PREP(WORD3_HASH_XOR_BIT, 1);
+}
 
-/*!
- * This macro selects the AES engine instead of HASH engine when setting up combined mode with AES XCBC MAC
+/*
+ * Select the AES engine instead of HASH engine when setting up combined mode
+ * with AES XCBC MAC
  *
- * \param pDesc pointer HW descriptor struct
+ * @pdesc: pointer HW descriptor struct
  */
-#define HW_DESC_SET_AES_NOT_HASH_MODE(pDesc)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, AES_SEL_N_HASH, (pDesc)->word[4], 1);			\
-	} while (0)
+static inline void set_aes_not_hash_mode(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_AES_SEL_N_HASH, 1);
+}
 
-/*!
- * This macro sets the DOUT field of a HW descriptors to SRAM mode
+/*
+ * Set the DOUT field of a HW descriptors to SRAM mode
  * Note: No need to check SRAM alignment since host requests do not use SRAM and
  * adaptor will enforce alignment check.
  *
- * \param pDesc pointer HW descriptor struct
- * \param doutAdr DOUT address
- * \param doutSize Data size in bytes
+ * @pdesc: pointer HW descriptor struct
+ * @addr: DOUT address
+ * @size: Data size in bytes
  */
-#define HW_DESC_SET_DOUT_SRAM(pDesc, doutAdr, doutSize)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(doutAdr));		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_DMA_MODE, (pDesc)->word[3], DMA_SRAM);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD3, DOUT_SIZE, (pDesc)->word[3], (doutSize));		\
-	} while (0)
+static inline void set_dout_sram(struct cc_hw_desc *pdesc, u32 addr, u32 size)
+{
+	pdesc->word[2] = addr;
+	pdesc->word[3] |= FIELD_PREP(WORD3_DOUT_DMA_MODE, DMA_SRAM) |
+			FIELD_PREP(WORD3_DOUT_SIZE, size);
+}
 
-/*!
- * This macro sets the data unit size for XEX mode in data_out_addr[15:0]
+/*
+ * Sets the data unit size for XEX mode in data_out_addr[15:0]
  *
- * \param pDesc pointer HW descriptor struct
- * \param dataUnitSize data unit size for XEX mode
+ * @pdesc: pDesc pointer HW descriptor struct
+ * @size: data unit size for XEX mode
  */
-#define HW_DESC_SET_XEX_DATA_UNIT_SIZE(pDesc, dataUnitSize)								\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(dataUnitSize));	\
-	} while (0)
+static inline void set_xex_data_unit_size(struct cc_hw_desc *pdesc, u32 size)
+{
+	pdesc->word[2] = size;
+}
 
-/*!
- * This macro sets the number of rounds for Multi2 in data_out_addr[15:0]
+/*
+ * Set the number of rounds for Multi2 in data_out_addr[15:0]
  *
- * \param pDesc pointer HW descriptor struct
- * \param numRounds number of rounds for Multi2
-*/
-#define HW_DESC_SET_MULTI2_NUM_ROUNDS(pDesc, numRounds)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(numRounds));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @num: number of rounds for Multi2
+ */
+static inline void set_multi2_num_rounds(struct cc_hw_desc *pdesc, u32 num)
+{
+	pdesc->word[2] = num;
+}
 
-/*!
- * This macro sets the flow mode.
+/*
+ * Set the flow mode.
  *
- * \param pDesc pointer HW descriptor struct
- * \param flowMode Any one of the modes defined in [CC7x-DESC]
-*/
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_flow_mode(struct cc_hw_desc *pdesc,
+				 enum cc_flow_mode mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_DATA_FLOW_MODE, mode);
+}
 
-#define HW_DESC_SET_FLOW_MODE(pDesc, flowMode)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, DATA_FLOW_MODE, (pDesc)->word[4], (flowMode));		\
-	} while (0)
+/*
+ * Set the cipher mode.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @mode:  Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_mode(struct cc_hw_desc *pdesc,
+				   enum drv_cipher_mode mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_MODE, mode);
+}
 
-/*!
- * This macro sets the cipher mode.
+/*
+ * Set the cipher configuration fields.
  *
- * \param pDesc pointer HW descriptor struct
- * \param cipherMode Any one of the modes defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_CIPHER_MODE(pDesc, cipherMode)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_MODE, (pDesc)->word[4], (cipherMode));		\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_config0(struct cc_hw_desc *pdesc,
+				      enum drv_crypto_direction mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF0, mode);
+}
 
-/*!
- * This macro sets the cipher configuration fields.
+/*
+ * Set the cipher configuration fields.
  *
- * \param pDesc pointer HW descriptor struct
- * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_CIPHER_CONFIG0(pDesc, cipherConfig)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF0, (pDesc)->word[4], (cipherConfig));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_cipher_config1(struct cc_hw_desc *pdesc,
+				      enum HashConfig1Padding config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_CONF1, config);
+}
 
-/*!
- * This macro sets the cipher configuration fields.
+/*
+ * Set HW key configuration fields.
  *
- * \param pDesc pointer HW descriptor struct
- * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_CIPHER_CONFIG1(pDesc, cipherConfig)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF1, (pDesc)->word[4], (cipherConfig));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @hw_key: The HW key slot asdefined in enum cc_hw_crypto_key
+ */
+static inline void set_hw_crypto_key(struct cc_hw_desc *pdesc,
+				     enum cc_hw_crypto_key hw_key)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_DO,
+				     (hw_key & HW_KEY_MASK_CIPHER_DO)) |
+			FIELD_PREP(WORD4_CIPHER_CONF2,
+				   (hw_key >> HW_KEY_SHIFT_CIPHER_CFG2));
+}
 
-/*!
- * This macro sets HW key configuration fields.
+/*
+ * Set byte order of all setup-finalize descriptors.
  *
- * \param pDesc pointer HW descriptor struct
- * \param hwKey The hw key number as in enun HwCryptoKey
-*/
-#define HW_DESC_SET_HW_CRYPTO_KEY(pDesc, hwKey)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (hwKey) & HW_KEY_MASK_CIPHER_DO);		\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF2, (pDesc)->word[4], (hwKey >> HW_KEY_SHIFT_CIPHER_CFG2));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the modes defined in [CC7x-DESC]
+ */
+static inline void set_bytes_swap(struct cc_hw_desc *pdesc, bool config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_BYTES_SWAP, config);
+}
 
-/*!
- * This macro changes the bytes order of all setup-finalize descriptosets.
+/*
+ * Set CMAC_SIZE0 mode.
  *
- * \param pDesc pointer HW descriptor struct
- * \param swapConfig Any one of the modes defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_BYTES_SWAP(pDesc, swapConfig)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, BYTES_SWAP, (pDesc)->word[4], (swapConfig));		\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ */
+static inline void set_cmac_size0_mode(struct cc_hw_desc *pdesc)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CMAC_SIZE0, 1);
+}
 
-/*!
- * This macro sets the CMAC_SIZE0 mode.
+/*
+ * Set key size descriptor field.
  *
- * \param pDesc pointer HW descriptor struct
-*/
-#define HW_DESC_SET_CMAC_SIZE0_MODE(pDesc)										\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CMAC_SIZE0, (pDesc)->word[4], 0x1);			\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size(struct cc_hw_desc *pdesc, u32 size)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_KEY_SIZE, size);
+}
 
-/*!
- * This macro sets the key size for AES engine.
+/*
+ * Set AES key size.
  *
- * \param pDesc pointer HW descriptor struct
- * \param keySize key size in bytes (NOT size code)
-*/
-#define HW_DESC_SET_KEY_SIZE_AES(pDesc, keySize)									\
-	do {													        \
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 2);	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size_aes(struct cc_hw_desc *pdesc, u32 size)
+{
+	set_key_size(pdesc, ((size >> 3) - 2));
+}
 
-/*!
- * This macro sets the key size for DES engine.
+/*
+ * Set DES key size.
  *
- * \param pDesc pointer HW descriptor struct
- * \param keySize key size in bytes (NOT size code)
-*/
-#define HW_DESC_SET_KEY_SIZE_DES(pDesc, keySize)									\
-	do {													        \
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 1);	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @size: key size in bytes (NOT size code)
+ */
+static inline void set_key_size_des(struct cc_hw_desc *pdesc, u32 size)
+{
+	set_key_size(pdesc, ((size >> 3) - 1));
+}
 
-/*!
- * This macro sets the descriptor's setup mode
+/*
+ * Set the descriptor setup mode
  *
- * \param pDesc pointer HW descriptor struct
- * \param setupMode Any one of the setup modes defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_SETUP_MODE(pDesc, setupMode)									\
-	do {														\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, SETUP_OPERATION, (pDesc)->word[4], (setupMode));	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @mode: Any one of the setup modes defined in [CC7x-DESC]
+ */
+static inline void set_setup_mode(struct cc_hw_desc *pdesc,
+				  enum cc_setup_op mode)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_SETUP_OPERATION, mode);
+}
 
-/*!
- * This macro sets the descriptor's cipher do
+/*
+ * Set the descriptor cipher DO
  *
- * \param pDesc pointer HW descriptor struct
- * \param cipherDo Any one of the cipher do defined in [CC7x-DESC]
-*/
-#define HW_DESC_SET_CIPHER_DO(pDesc, cipherDo)											\
-	do {															\
-		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (cipherDo) & HW_KEY_MASK_CIPHER_DO);	\
-	} while (0)
+ * @pdesc: pointer HW descriptor struct
+ * @config: Any one of the cipher do defined in [CC7x-DESC]
+ */
+static inline void set_cipher_do(struct cc_hw_desc *pdesc,
+				 enum HashCipherDoPadding config)
+{
+	pdesc->word[4] |= FIELD_PREP(WORD4_CIPHER_DO,
+				(config & HW_KEY_MASK_CIPHER_DO));
+}
 
 /*!
  * This macro sets the DIN field of a HW descriptors to star/stop monitor descriptor.
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 26afa87..1bb78d10 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -277,32 +277,35 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req, void __iomem *c
 static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 {
 	/* Load the AES key */
-	HW_DESC_INIT(&desc[0]);
+	hw_desc_init(&desc[0]);
 	/* We are using for the source/user key the same buffer as for the output keys,
 	   because after this key loading it is not needed anymore */
-	HW_DESC_SET_DIN_TYPE(&desc[0], DMA_DLLI, ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen, NS_BIT);
-	HW_DESC_SET_CIPHER_MODE(&desc[0], DRV_CIPHER_ECB);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[0], ctx->auth_keylen);
-	HW_DESC_SET_FLOW_MODE(&desc[0], S_DIN_to_AES);
-	HW_DESC_SET_SETUP_MODE(&desc[0], SETUP_LOAD_KEY0);
-
-	HW_DESC_INIT(&desc[1]);
-	HW_DESC_SET_DIN_CONST(&desc[1], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[1], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[1], ctx->auth_state.xcbc.xcbc_keys_dma_addr, AES_KEYSIZE_128, NS_BIT, 0);
-
-	HW_DESC_INIT(&desc[2]);
-	HW_DESC_SET_DIN_CONST(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[2], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+	set_din_type(&desc[0], DMA_DLLI,
+		     ctx->auth_state.xcbc.xcbc_keys_dma_addr, ctx->auth_keylen,
+		     NS_BIT);
+	set_cipher_mode(&desc[0], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[0], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_key_size_aes(&desc[0], ctx->auth_keylen);
+	set_flow_mode(&desc[0], S_DIN_to_AES);
+	set_setup_mode(&desc[0], SETUP_LOAD_KEY0);
+
+	hw_desc_init(&desc[1]);
+	set_din_const(&desc[1], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[1], DIN_AES_DOUT);
+	set_dout_dlli(&desc[1], ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+		      AES_KEYSIZE_128, NS_BIT, 0);
+
+	hw_desc_init(&desc[2]);
+	set_din_const(&desc[2], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[2], DIN_AES_DOUT);
+	set_dout_dlli(&desc[2], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
 					 + AES_KEYSIZE_128),
 			      AES_KEYSIZE_128, NS_BIT, 0);
 
-	HW_DESC_INIT(&desc[3]);
-	HW_DESC_SET_DIN_CONST(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[3], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
+	hw_desc_init(&desc[3]);
+	set_din_const(&desc[3], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[3], DIN_AES_DOUT);
+	set_dout_dlli(&desc[3], (ctx->auth_state.xcbc.xcbc_keys_dma_addr
 					  + 2 * AES_KEYSIZE_128),
 			      AES_KEYSIZE_128, NS_BIT, 0);
 
@@ -324,52 +327,51 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	/* calc derived HMAC key */
 	for (i = 0; i < 2; i++) {
 		/* Load hash initial state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-		HW_DESC_SET_DIN_SRAM(&desc[idx],
-			ssi_ahash_get_larval_digest_sram_addr(
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_din_sram(&desc[idx],
+			     ssi_ahash_get_larval_digest_sram_addr(
 				ctx->drvdata, ctx->auth_mode),
-			digest_size);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+			     digest_size);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 		/* Load the hash current length*/
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Prepare ipad key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_XOR_VAL(&desc[idx], hmacPadConst[i]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		hw_desc_init(&desc[idx]);
+		set_xor_val(&desc[idx], hmacPadConst[i]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 		idx++;
 
 		/* Perform HASH update */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				   ctx->auth_state.hmac.padded_authkey_dma_addr,
-				     SHA256_BLOCK_SIZE, NS_BIT);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-		HW_DESC_SET_XOR_ACTIVE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     ctx->auth_state.hmac.padded_authkey_dma_addr,
+			     SHA256_BLOCK_SIZE, NS_BIT);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_xor_active(&desc[idx]);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 
 		/* Get the digset */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx],
-				      (ctx->auth_state.hmac.ipad_opad_dma_addr +
-				       digest_ofs),
-				      digest_size, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hash_mode);
+		set_dout_dlli(&desc[idx],
+			      (ctx->auth_state.hmac.ipad_opad_dma_addr +
+			       digest_ofs), digest_size, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 		idx++;
 
 		digest_ofs += digest_size;
@@ -463,84 +465,74 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key, unsigned int keyl
 		SSI_UPDATE_DMA_ADDR_TO_48BIT(key_dma_addr, keylen);
 		if (keylen > blocksize) {
 			/* Load hash initial state */
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode);
-			HW_DESC_SET_DIN_SRAM(&desc[idx], larval_addr, digestsize);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_din_sram(&desc[idx], larval_addr, digestsize);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 			idx++;
 
 			/* Load the hash current length*/
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode);
-			HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 			idx++;
 
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     key_dma_addr,
-					     keylen, NS_BIT);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     key_dma_addr, keylen, NS_BIT);
+			set_flow_mode(&desc[idx], DIN_HASH);
 			idx++;
 
 			/* Get hashed key */
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hashmode);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					 padded_authkey_dma_addr,
-					 digestsize,
-					 NS_BIT, 0);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx],
-							HASH_PADDING_DISABLED);
-			HW_DESC_SET_CIPHER_CONFIG0(&desc[idx],
-						   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hashmode);
+			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+				      digestsize, NS_BIT, 0);
+			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+			set_cipher_config0(&desc[idx],
+					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 			idx++;
 
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_CONST(&desc[idx], 0, (blocksize - digestsize));
-			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      (padded_authkey_dma_addr + digestsize),
-					      (blocksize - digestsize),
-					      NS_BIT, 0);
+			hw_desc_init(&desc[idx]);
+			set_din_const(&desc[idx], 0, (blocksize - digestsize));
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], (padded_authkey_dma_addr +
+				      digestsize), (blocksize - digestsize),
+				      NS_BIT, 0);
 			idx++;
 		} else {
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     key_dma_addr,
-					     keylen, NS_BIT);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      (padded_authkey_dma_addr),
-					      keylen, NS_BIT, 0);
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+				     keylen, NS_BIT);
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+				      keylen, NS_BIT, 0);
 			idx++;
 
 			if ((blocksize - keylen) != 0) {
-				HW_DESC_INIT(&desc[idx]);
-				HW_DESC_SET_DIN_CONST(&desc[idx], 0,
-						      (blocksize - keylen));
-				HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-				HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					(padded_authkey_dma_addr + keylen),
-					(blocksize - keylen),
-					NS_BIT, 0);
+				hw_desc_init(&desc[idx]);
+				set_din_const(&desc[idx], 0,
+					      (blocksize - keylen));
+				set_flow_mode(&desc[idx], BYPASS);
+				set_dout_dlli(&desc[idx],
+					      (padded_authkey_dma_addr +
+					       keylen),
+					      (blocksize - keylen), NS_BIT, 0);
 				idx++;
 			}
 		}
 	} else {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0,
-				      (blocksize - keylen));
-		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			padded_authkey_dma_addr,
-			blocksize,
-			NS_BIT, 0);
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0, (blocksize - keylen));
+		set_flow_mode(&desc[idx], BYPASS);
+		set_dout_dlli(&desc[idx], padded_authkey_dma_addr,
+			      blocksize, NS_BIT, 0);
 		idx++;
 	}
 
@@ -768,24 +760,23 @@ ssi_aead_create_assoc_desc(
 	switch (assoc_dma_type) {
 	case SSI_DMA_BUF_DLLI:
 		SSI_LOG_DEBUG("ASSOC buffer type DLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			sg_dma_address(areq->src),
-			areq->assoclen, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC && (areq_ctx->cryptlen > 0) )
-			HW_DESC_SET_DIN_NOT_LAST_INDICATION(&desc[idx]);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, sg_dma_address(areq->src),
+			     areq->assoclen, NS_BIT); set_flow_mode(&desc[idx],
+			     flow_mode);
+		if ((ctx->auth_mode == DRV_HASH_XCBC_MAC) &&
+		    (areq_ctx->cryptlen > 0))
+			set_din_not_last_indication(&desc[idx]);
 		break;
 	case SSI_DMA_BUF_MLLI:
 		SSI_LOG_DEBUG("ASSOC buffer type MLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
-				     areq_ctx->assoc.sram_addr,
-				     areq_ctx->assoc.mlli_nents,
-				     NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
-		if (ctx->auth_mode == DRV_HASH_XCBC_MAC && (areq_ctx->cryptlen > 0) )
-			HW_DESC_SET_DIN_NOT_LAST_INDICATION(&desc[idx]);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->assoc.sram_addr,
+			     areq_ctx->assoc.mlli_nents, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
+		if ((ctx->auth_mode == DRV_HASH_XCBC_MAC) &&
+		    (areq_ctx->cryptlen > 0))
+			set_din_not_last_indication(&desc[idx]);
 		break;
 	case SSI_DMA_BUF_NULL:
 	default:
@@ -818,11 +809,11 @@ ssi_aead_process_authenc_data_desc(
 			(direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
 			areq_ctx->dstOffset : areq_ctx->srcOffset;
 		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type DLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			(sg_dma_address(cipher)+ offset), areq_ctx->cryptlen,
-			NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (sg_dma_address(cipher) + offset),
+			     areq_ctx->cryptlen, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	}
 	case SSI_DMA_BUF_MLLI:
@@ -844,10 +835,10 @@ ssi_aead_process_authenc_data_desc(
 		}
 
 		SSI_LOG_DEBUG("AUTHENC: SRC/DST buffer type MLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
-			mlli_addr, mlli_nents, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, mlli_addr, mlli_nents,
+			     NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	}
 	case SSI_DMA_BUF_NULL:
@@ -875,25 +866,24 @@ ssi_aead_process_cipher_data_desc(
 	switch (data_dma_type) {
 	case SSI_DMA_BUF_DLLI:
 		SSI_LOG_DEBUG("CIPHER: SRC/DST buffer type DLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			(sg_dma_address(areq_ctx->srcSgl)+areq_ctx->srcOffset),
-			areq_ctx->cryptlen, NS_BIT);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			(sg_dma_address(areq_ctx->dstSgl)+areq_ctx->dstOffset),
-			areq_ctx->cryptlen, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (sg_dma_address(areq_ctx->srcSgl) +
+			      areq_ctx->srcOffset), areq_ctx->cryptlen, NS_BIT);
+		set_dout_dlli(&desc[idx],
+			      (sg_dma_address(areq_ctx->dstSgl) +
+			       areq_ctx->dstOffset),
+			      areq_ctx->cryptlen, NS_BIT, 0);
+		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	case SSI_DMA_BUF_MLLI:
 		SSI_LOG_DEBUG("CIPHER: SRC/DST buffer type MLLI\n");
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
-			areq_ctx->src.sram_addr,
-			areq_ctx->src.mlli_nents, NS_BIT);
-		HW_DESC_SET_DOUT_MLLI(&desc[idx],
-			areq_ctx->dst.sram_addr,
-			areq_ctx->dst.mlli_nents, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI, areq_ctx->src.sram_addr,
+			     areq_ctx->src.mlli_nents, NS_BIT);
+		set_dout_mlli(&desc[idx], areq_ctx->dst.sram_addr,
+			      areq_ctx->dst.mlli_nents, NS_BIT, 0);
+		set_flow_mode(&desc[idx], flow_mode);
 		break;
 	case SSI_DMA_BUF_NULL:
 	default:
@@ -918,35 +908,36 @@ static inline void ssi_aead_process_digest_result_desc(
 
 	/* Get final ICV result */
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->icv_dma_addr,
-			ctx->authsize, NS_BIT, 1);
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		hw_desc_init(&desc[idx]);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_dout_dlli(&desc[idx], req_ctx->icv_dma_addr, ctx->authsize,
+			      NS_BIT, 1);
+		set_queue_last_ind(&desc[idx]);
 		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
-			HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
+			set_aes_not_hash_mode(&desc[idx]);
+			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
 		} else {
-			HW_DESC_SET_CIPHER_CONFIG0(&desc[idx],
-				HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+			set_cipher_config0(&desc[idx],
+					   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+			set_cipher_mode(&desc[idx], hash_mode);
 		}
 	} else { /*Decrypt*/
 		/* Get ICV out from hardware */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
-			ctx->authsize, NS_BIT, 1);
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+		hw_desc_init(&desc[idx]);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr,
+			      ctx->authsize, NS_BIT, 1);
+		set_queue_last_ind(&desc[idx]);
+		set_cipher_config0(&desc[idx],
+				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 		if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-			HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+			set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+			set_aes_not_hash_mode(&desc[idx]);
 		} else {
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+			set_cipher_mode(&desc[idx], hash_mode);
 		}
 	}
 
@@ -966,35 +957,35 @@ static inline void ssi_aead_setup_cipher_desc(
 	int direct = req_ctx->gen_ctx.op_type;
 
 	/* Setup cipher state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direct);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], ctx->flow_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-		req_ctx->gen_ctx.iv_dma_addr, hw_iv_size, NS_BIT);
+	hw_desc_init(&desc[idx]);
+	set_cipher_config0(&desc[idx], direct);
+	set_flow_mode(&desc[idx], ctx->flow_mode);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
+		     hw_iv_size, NS_BIT);
 	if (ctx->cipher_mode == DRV_CIPHER_CTR) {
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 	} else {
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	}
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->cipher_mode);
+	set_cipher_mode(&desc[idx], ctx->cipher_mode);
 	idx++;
 
 	/* Setup enc. key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direct);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], ctx->flow_mode);
+	hw_desc_init(&desc[idx]);
+	set_cipher_config0(&desc[idx], direct);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], ctx->flow_mode);
 	if (ctx->flow_mode == S_DIN_to_AES) {
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			((ctx->enc_keylen == 24) ?
-			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen), NS_BIT);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
+		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+			     ((ctx->enc_keylen == 24) ? CC_AES_KEY_SIZE_MAX :
+			      ctx->enc_keylen), NS_BIT);
+		set_key_size_aes(&desc[idx], ctx->enc_keylen);
 	} else {
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			ctx->enc_keylen, NS_BIT);
-		HW_DESC_SET_KEY_SIZE_DES(&desc[idx], ctx->enc_keylen);
+		set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+			     ctx->enc_keylen, NS_BIT);
+		set_key_size_des(&desc[idx], ctx->enc_keylen);
 	}
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->cipher_mode);
+	set_cipher_mode(&desc[idx], ctx->cipher_mode);
 	idx++;
 
 	*seq_size = idx;
@@ -1017,9 +1008,9 @@ static inline void ssi_aead_process_cipher(
 	ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, &idx);
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* We must wait for DMA to write all cipher */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
 		idx++;
 	}
 
@@ -1040,23 +1031,24 @@ static inline void ssi_aead_hmac_setup_digest_desc(
 	unsigned int idx = *seq_size;
 
 	/* Loading hash ipad xor key state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-		ctx->auth_state.hmac.ipad_opad_dma_addr,
-		digest_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     ctx->auth_state.hmac.ipad_opad_dma_addr, digest_size,
+		     NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Load init. digest len (64 bytes) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-	HW_DESC_SET_DIN_SRAM(&desc[idx],
-		ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, hash_mode),
-		HASH_LEN_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_sram(&desc[idx],
+		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
+								hash_mode),
+								HASH_LEN_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	*seq_size = idx;
@@ -1072,55 +1064,53 @@ static inline void ssi_aead_xcbc_setup_digest_desc(
 	unsigned int idx = *seq_size;
 
 	/* Loading MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0, CC_AES_BLOCK_SIZE);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0, CC_AES_BLOCK_SIZE);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* Setup XCBC MAC K1 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     ctx->auth_state.xcbc.xcbc_keys_dma_addr,
-			     AES_KEYSIZE_128, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     ctx->auth_state.xcbc.xcbc_keys_dma_addr,
+		     AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* Setup XCBC MAC K2 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
-			      AES_KEYSIZE_128),
-			     AES_KEYSIZE_128, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
+		      AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* Setup XCBC MAC K3 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
-			      2 * AES_KEYSIZE_128),
-			     AES_KEYSIZE_128, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE2);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.xcbc.xcbc_keys_dma_addr +
+		      2 * AES_KEYSIZE_128), AES_KEYSIZE_128, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	*seq_size = idx;
@@ -1154,51 +1144,52 @@ static inline void ssi_aead_process_digest_scheme_desc(
 				CC_SHA1_DIGEST_SIZE : CC_SHA256_DIGEST_SIZE;
 	unsigned int idx = *seq_size;
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-	HW_DESC_SET_DOUT_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
-			HASH_LEN_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
-	HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		      HASH_LEN_SIZE);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	set_cipher_do(&desc[idx], DO_PAD);
 	idx++;
 
 	/* Get final ICV result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
-			digest_size);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
+	hw_desc_init(&desc[idx]);
+	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		      digest_size);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	set_cipher_mode(&desc[idx], hash_mode);
 	idx++;
 
 	/* Loading hash opad xor key state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-		(ctx->auth_state.hmac.ipad_opad_dma_addr + digest_size),
-		digest_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     (ctx->auth_state.hmac.ipad_opad_dma_addr + digest_size),
+		     digest_size, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Load init. digest len (64 bytes) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hash_mode);
-	HW_DESC_SET_DIN_SRAM(&desc[idx],
-		ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, hash_mode),
-		HASH_LEN_SIZE);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hash_mode);
+	set_din_sram(&desc[idx],
+		     ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata,
+								hash_mode),
+		     HASH_LEN_SIZE);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Perform HASH update */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_SRAM(&desc[idx], aead_handle->sram_workspace_addr,
-			digest_size);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_sram(&desc[idx], aead_handle->sram_workspace_addr,
+		     digest_size);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	*seq_size = idx;
@@ -1221,14 +1212,14 @@ static inline void ssi_aead_load_mlli_to_sram(
 			(unsigned int)ctx->drvdata->mlli_sram_addr,
 			req_ctx->mlli_params.mlli_len);
 		/* Copy MLLI table host-to-sram */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-			req_ctx->mlli_params.mlli_dma_addr,
-			req_ctx->mlli_params.mlli_len, NS_BIT);
-		HW_DESC_SET_DOUT_SRAM(&desc[*seq_size],
-			ctx->drvdata->mlli_sram_addr,
-			req_ctx->mlli_params.mlli_len);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], BYPASS);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->mlli_params.mlli_dma_addr,
+			     req_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[*seq_size],
+			      ctx->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[*seq_size], BYPASS);
 		(*seq_size)++;
 	}
 }
@@ -1477,55 +1468,51 @@ static inline int ssi_aead_ccm(
 	}
 
 	/* load key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			((ctx->enc_keylen == 24) ?
-			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen),
-			 NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
+		      ctx->enc_keylen), NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* load ctr state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			req_ctx->gen_ctx.iv_dma_addr,
-			     AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI,
+		     req_ctx->gen_ctx.iv_dma_addr, AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* load MAC key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			((ctx->enc_keylen == 24) ?
-			 CC_AES_KEY_SIZE_MAX : ctx->enc_keylen),
-			 NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ((ctx->enc_keylen == 24) ?  CC_AES_KEY_SIZE_MAX :
+		      ctx->enc_keylen), NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* load MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			req_ctx->mac_buf_dma_addr,
-			     AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 
@@ -1533,12 +1520,11 @@ static inline int ssi_aead_ccm(
 	if (req->assoclen > 0) {
 		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
 	} else {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				      sg_dma_address(&req_ctx->ccm_adata_sg),
-				     AES_BLOCK_SIZE + req_ctx->ccm_hdr_size,
-				     NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     sg_dma_address(&req_ctx->ccm_adata_sg),
+			     AES_BLOCK_SIZE + req_ctx->ccm_hdr_size, NS_BIT);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 	}
 
@@ -1548,40 +1534,39 @@ static inline int ssi_aead_ccm(
 	}
 
 	/* Read temporal MAC */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
-			      ctx->authsize, NS_BIT, 0);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, ctx->authsize,
+		      NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* load AES-CTR state (for last MAC calculation)*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     req_ctx->ccm_iv0_dma_addr ,
-			     AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->ccm_iv0_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* encrypt the "T" value and store MAC in mac_state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			req_ctx->mac_buf_dma_addr , ctx->authsize, NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_result , ctx->authsize, NS_BIT, 1);
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     ctx->authsize, NS_BIT);
+	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	*seq_size = idx;
@@ -1672,69 +1657,66 @@ static inline void ssi_aead_gcm_setup_ghash_desc(
 	unsigned int idx = *seq_size;
 
 	/* load key to AES*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			ctx->enc_keylen, NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ctx->enc_keylen, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* process one zero block to generate hkey */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx],
-				  req_ctx->hkey_dma_addr,
-				  AES_BLOCK_SIZE,
-				  NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_dlli(&desc[idx], req_ctx->hkey_dma_addr, AES_BLOCK_SIZE,
+		      NS_BIT, 0);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* Memory Barrier */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* Load GHASH subkey */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			req_ctx->hkey_dma_addr,
-				 AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->hkey_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Configure Hash Engine to work with GHASH.
 	   Since it was not possible to extend HASH submodes to add GHASH,
 	   The following command is necessary in order to select GHASH (according to HW designers)*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_DO(&desc[idx], 1); //1=AES_SK RKEK
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_do(&desc[idx], 1); //1=AES_SK RKEK
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	*seq_size = idx;
@@ -1751,27 +1733,27 @@ static inline void ssi_aead_gcm_setup_gctr_desc(
 	unsigned int idx = *seq_size;
 
 	/* load key to AES*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
-			ctx->enc_keylen, NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->enckey_dma_addr,
+		     ctx->enc_keylen, NS_BIT);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	if ((req_ctx->cryptlen != 0) && (req_ctx->plaintext_authenticate_only==false)){
 		/* load AES/CTR initial CTR value inc by 2*/
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				req_ctx->gcm_iv_inc2_dma_addr,
-					 AES_BLOCK_SIZE, NS_BIT);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+		set_key_size_aes(&desc[idx], ctx->enc_keylen);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     req_ctx->gcm_iv_inc2_dma_addr, AES_BLOCK_SIZE,
+			     NS_BIT);
+		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	}
 
@@ -1796,52 +1778,49 @@ static inline void ssi_aead_process_gcm_result_desc(
 	}
 
 	/* process(ghash) gcm_block_len */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-		req_ctx->gcm_block_len_dma_addr,
-		AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_block_len_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], req_ctx->mac_buf_dma_addr,
-				  AES_BLOCK_SIZE, NS_BIT, 0);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_dlli(&desc[idx], req_ctx->mac_buf_dma_addr, AES_BLOCK_SIZE,
+		      NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
 
 	idx++;
 
 	/* load AES/CTR initial CTR value inc by 1*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->enc_keylen);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				 req_ctx->gcm_iv_inc1_dma_addr,
-				 AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_key_size_aes(&desc[idx], ctx->enc_keylen);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->gcm_iv_inc1_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Memory Barrier */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* process GCTR on stored GHASH and store MAC in mac_state*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-		req_ctx->mac_buf_dma_addr,
-		AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_din_type(&desc[idx], DMA_DLLI, req_ctx->mac_buf_dma_addr,
+		     AES_BLOCK_SIZE, NS_BIT);
+	set_dout_dlli(&desc[idx], mac_result, ctx->authsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	*seq_size = idx;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index d245a2b..8f86fcd 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -489,96 +489,93 @@ ssi_blkcipher_create_setup_desc(
 	case DRV_CIPHER_CTR:
 	case DRV_CIPHER_OFB:
 		/* Load cipher state */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-				     iv_dma_addr, ivsize,
-				     NS_BIT);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
-		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr, ivsize,
+			     NS_BIT);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		if ((cipher_mode == DRV_CIPHER_CTR) ||
 		    (cipher_mode == DRV_CIPHER_OFB) ) {
-			HW_DESC_SET_SETUP_MODE(&desc[*seq_size],
-					       SETUP_LOAD_STATE1);
+			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 		} else {
-			HW_DESC_SET_SETUP_MODE(&desc[*seq_size],
-					       SETUP_LOAD_STATE0);
+			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
 		}
 		(*seq_size)++;
 		/*FALLTHROUGH*/
 	case DRV_CIPHER_ECB:
 		/* Load key */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
 		if (flow_mode == S_DIN_to_AES) {
 
 			if (ssi_is_hw_key(tfm)) {
-				HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key1_slot);
+				set_hw_crypto_key(&desc[*seq_size],
+						  ctx_p->hw.key1_slot);
 			} else {
-				HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-						     key_dma_addr,
-						     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len),
-						     NS_BIT);
+				set_din_type(&desc[*seq_size], DMA_DLLI,
+					     key_dma_addr, ((key_len == 24) ?
+							    AES_MAX_KEY_SIZE :
+							    key_len), NS_BIT);
 			}
-			HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len);
+			set_key_size_aes(&desc[*seq_size], key_len);
 		} else {
 			/*des*/
-			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-					     key_dma_addr, key_len,
-					     NS_BIT);
-			HW_DESC_SET_KEY_SIZE_DES(&desc[*seq_size], key_len);
+			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
+				     key_len, NS_BIT);
+			set_key_size_des(&desc[*seq_size], key_len);
 		}
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
-		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		(*seq_size)++;
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
 	case DRV_CIPHER_BITLOCKER:
 		/* Load AES key */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
 		if (ssi_is_hw_key(tfm)) {
-			HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key1_slot);
+			set_hw_crypto_key(&desc[*seq_size],
+					  ctx_p->hw.key1_slot);
 		} else {
-			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-					     key_dma_addr, key_len/2,
-					     NS_BIT);
+			set_din_type(&desc[*seq_size], DMA_DLLI, key_dma_addr,
+				     (key_len / 2), NS_BIT);
 		}
-		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
-		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		(*seq_size)++;
 
 		/* load XEX key */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
 		if (ssi_is_hw_key(tfm)) {
-			HW_DESC_SET_HW_CRYPTO_KEY(&desc[*seq_size], ctx_p->hw.key2_slot);
+			set_hw_crypto_key(&desc[*seq_size],
+					  ctx_p->hw.key2_slot);
 		} else {
-			HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-					     (key_dma_addr+key_len/2), key_len/2,
-					     NS_BIT);
+			set_din_type(&desc[*seq_size], DMA_DLLI,
+				     (key_dma_addr + (key_len / 2)),
+				     (key_len / 2), NS_BIT);
 		}
-		HW_DESC_SET_XEX_DATA_UNIT_SIZE(&desc[*seq_size], du_size);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], S_DIN_to_AES2);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
-		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
+		set_xex_data_unit_size(&desc[*seq_size], du_size);
+		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
 		(*seq_size)++;
 
 		/* Set state */
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE1);
-		HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[*seq_size], key_len/2);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-				     iv_dma_addr, CC_AES_BLOCK_SIZE,
-				     NS_BIT);
+		hw_desc_init(&desc[*seq_size]);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
 		(*seq_size)++;
 		break;
 	default:
@@ -599,40 +596,36 @@ static inline void ssi_blkcipher_create_multi2_setup_desc(
 
 	int direction = req_ctx->gen_ctx.op_type;
 	/* Load system key */
-	HW_DESC_INIT(&desc[*seq_size]);
-	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI, ctx_p->user.key_dma_addr,
-						CC_MULTI2_SYSTEM_KEY_SIZE,
-						NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
-	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[*seq_size]);
+	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
+	set_cipher_config0(&desc[*seq_size], direction);
+	set_din_type(&desc[*seq_size], DMA_DLLI, ctx_p->user.key_dma_addr,
+		     CC_MULTI2_SYSTEM_KEY_SIZE, NS_BIT);
+	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
+	set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 	(*seq_size)++;
 
 	/* load data key */
-	HW_DESC_INIT(&desc[*seq_size]);
-	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-					(ctx_p->user.key_dma_addr +
-						CC_MULTI2_SYSTEM_KEY_SIZE),
-				CC_MULTI2_DATA_KEY_SIZE, NS_BIT);
-	HW_DESC_SET_MULTI2_NUM_ROUNDS(&desc[*seq_size],
-						ctx_p->key_round_number);
-	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
-	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE0 );
+	hw_desc_init(&desc[*seq_size]);
+	set_din_type(&desc[*seq_size], DMA_DLLI,
+		     (ctx_p->user.key_dma_addr + CC_MULTI2_SYSTEM_KEY_SIZE),
+		     CC_MULTI2_DATA_KEY_SIZE, NS_BIT);
+	set_multi2_num_rounds(&desc[*seq_size], ctx_p->key_round_number);
+	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
+	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
+	set_cipher_config0(&desc[*seq_size], direction);
+	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
 	(*seq_size)++;
 
 
 	/* Set state */
-	HW_DESC_INIT(&desc[*seq_size]);
-	HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-			     req_ctx->gen_ctx.iv_dma_addr,
-			     ivsize, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[*seq_size], direction);
-	HW_DESC_SET_FLOW_MODE(&desc[*seq_size], ctx_p->flow_mode);
-	HW_DESC_SET_CIPHER_MODE(&desc[*seq_size], ctx_p->cipher_mode);
-	HW_DESC_SET_SETUP_MODE(&desc[*seq_size], SETUP_LOAD_STATE1);
+	hw_desc_init(&desc[*seq_size]);
+	set_din_type(&desc[*seq_size], DMA_DLLI, req_ctx->gen_ctx.iv_dma_addr,
+		     ivsize, NS_BIT);
+	set_cipher_config0(&desc[*seq_size], direction);
+	set_flow_mode(&desc[*seq_size], ctx_p->flow_mode);
+	set_cipher_mode(&desc[*seq_size], ctx_p->cipher_mode);
+	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 	(*seq_size)++;
 
 }
@@ -675,18 +668,15 @@ ssi_blkcipher_create_data_desc(
 		SSI_LOG_DEBUG(" data params addr 0x%llX length 0x%X \n",
 			     (unsigned long long)sg_dma_address(dst),
 			     nbytes);
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-				     sg_dma_address(src),
-				     nbytes, NS_BIT);
-		HW_DESC_SET_DOUT_DLLI(&desc[*seq_size],
-				      sg_dma_address(dst),
-				      nbytes,
-				      NS_BIT, (areq == NULL)? 0:1);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
+			     nbytes, NS_BIT);
+		set_dout_dlli(&desc[*seq_size], sg_dma_address(dst),
+			      nbytes, NS_BIT, (!areq ? 0 : 1));
 		if (areq != NULL) {
-			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
+			set_queue_last_ind(&desc[*seq_size]);
 		}
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 	} else {
 		/* bypass */
@@ -695,30 +685,29 @@ ssi_blkcipher_create_data_desc(
 			(unsigned long long)req_ctx->mlli_params.mlli_dma_addr,
 			req_ctx->mlli_params.mlli_len,
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_DLLI,
-				     req_ctx->mlli_params.mlli_dma_addr,
-				     req_ctx->mlli_params.mlli_len,
-				     NS_BIT);
-		HW_DESC_SET_DOUT_SRAM(&desc[*seq_size],
-				      ctx_p->drvdata->mlli_sram_addr,
-				      req_ctx->mlli_params.mlli_len);
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], BYPASS);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     req_ctx->mlli_params.mlli_dma_addr,
+			     req_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[*seq_size],
+			      ctx_p->drvdata->mlli_sram_addr,
+			      req_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[*seq_size], BYPASS);
 		(*seq_size)++;
 
-		HW_DESC_INIT(&desc[*seq_size]);
-		HW_DESC_SET_DIN_TYPE(&desc[*seq_size], DMA_MLLI,
-			ctx_p->drvdata->mlli_sram_addr,
-				     req_ctx->in_mlli_nents, NS_BIT);
+		hw_desc_init(&desc[*seq_size]);
+		set_din_type(&desc[*seq_size], DMA_MLLI,
+			     ctx_p->drvdata->mlli_sram_addr,
+			     req_ctx->in_mlli_nents, NS_BIT);
 		if (req_ctx->out_nents == 0) {
 			SSI_LOG_DEBUG(" din/dout params addr 0x%08X "
 				     "addr 0x%08X\n",
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr,
 			(unsigned int)ctx_p->drvdata->mlli_sram_addr);
-			HW_DESC_SET_DOUT_MLLI(&desc[*seq_size],
-			ctx_p->drvdata->mlli_sram_addr,
-					      req_ctx->in_mlli_nents,
-					      NS_BIT,(areq == NULL)? 0:1);
+			set_dout_mlli(&desc[*seq_size],
+				      ctx_p->drvdata->mlli_sram_addr,
+				      req_ctx->in_mlli_nents, NS_BIT,
+				      (!areq ? 0 : 1));
 		} else {
 			SSI_LOG_DEBUG(" din/dout params "
 				     "addr 0x%08X addr 0x%08X\n",
@@ -726,16 +715,17 @@ ssi_blkcipher_create_data_desc(
 				(unsigned int)ctx_p->drvdata->mlli_sram_addr +
 				(u32)LLI_ENTRY_BYTE_SIZE *
 							req_ctx->in_nents);
-			HW_DESC_SET_DOUT_MLLI(&desc[*seq_size],
-				(ctx_p->drvdata->mlli_sram_addr +
-				LLI_ENTRY_BYTE_SIZE *
-						req_ctx->in_mlli_nents),
-				req_ctx->out_mlli_nents, NS_BIT,(areq == NULL)? 0:1);
+			set_dout_mlli(&desc[*seq_size],
+				      (ctx_p->drvdata->mlli_sram_addr +
+				       (LLI_ENTRY_BYTE_SIZE *
+					req_ctx->in_mlli_nents)),
+				      req_ctx->out_mlli_nents, NS_BIT,
+				      (!areq ? 0 : 1));
 		}
 		if (areq != NULL) {
-			HW_DESC_SET_QUEUE_LAST_IND(&desc[*seq_size]);
+			set_queue_last_ind(&desc[*seq_size]);
 		}
-		HW_DESC_SET_FLOW_MODE(&desc[*seq_size], flow_mode);
+		set_flow_mode(&desc[*seq_size], flow_mode);
 		(*seq_size)++;
 	}
 }
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 45fc23f..38c7709 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -41,16 +41,16 @@
 #include "dx_reg_base_host.h"
 #include "dx_host.h"
 #define DX_CC_HOST_VIRT /* must be defined before including dx_cc_regs.h */
-#include "cc_hw_queue_defs.h"
 #include "cc_regs.h"
 #include "dx_reg_common.h"
 #include "cc_hal.h"
-#include "ssi_sram_mgr.h"
 #define CC_SUPPORT_SHA DX_DEV_SHA_MAX
 #include "cc_crypto_ctx.h"
 #include "ssi_sysfs.h"
 #include "hash_defs.h"
 #include "ssi_fips_local.h"
+#include "cc_hw_queue_defs.h"
+#include "ssi_sram_mgr.h"
 
 #define DRV_MODULE_VERSION "3.0"
 
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 7c7c922..e94158b 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -325,74 +325,73 @@ ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 	case DRV_CIPHER_CTR:
 	case DRV_CIPHER_OFB:
 		/* Load cipher state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     iv_dma_addr, iv_len, NS_BIT);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     iv_dma_addr, iv_len, NS_BIT);
+		set_cipher_config0(&desc[idx], direction);
+		set_flow_mode(&desc[idx], s_flow_mode);
+		set_cipher_mode(&desc[idx], cipher_mode);
 		if ((cipher_mode == DRV_CIPHER_CTR) ||
 		    (cipher_mode == DRV_CIPHER_OFB) ) {
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 		} else {
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		}
 		idx++;
 		/*FALLTHROUGH*/
 	case DRV_CIPHER_ECB:
 		/* Load key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], cipher_mode);
+		set_cipher_config0(&desc[idx], direction);
 		if (is_aes) {
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     key_dma_addr,
-					     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len),
-					     NS_BIT);
-			HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
+			set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+				     ((key_len == 24) ? AES_MAX_KEY_SIZE :
+				      key_len), NS_BIT);
+			set_key_size_aes(&desc[idx], key_len);
 		} else {/*des*/
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     key_dma_addr, key_len,
-					     NS_BIT);
-			HW_DESC_SET_KEY_SIZE_DES(&desc[idx], key_len);
+			set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+				     key_len, NS_BIT);
+			set_key_size_des(&desc[idx], key_len);
 		}
-		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		set_flow_mode(&desc[idx], s_flow_mode);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 		break;
 	case DRV_CIPHER_XTS:
 		/* Load AES key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     key_dma_addr, key_len/2, NS_BIT);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], cipher_mode);
+		set_cipher_config0(&desc[idx], direction);
+		set_din_type(&desc[idx], DMA_DLLI, key_dma_addr, (key_len / 2),
+			     NS_BIT);
+		set_key_size_aes(&desc[idx], (key_len / 2));
+		set_flow_mode(&desc[idx], s_flow_mode);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* load XEX key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     (key_dma_addr+key_len/2), key_len/2, NS_BIT);
-		HW_DESC_SET_XEX_DATA_UNIT_SIZE(&desc[idx], data_size);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_XEX_KEY);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], cipher_mode);
+		set_cipher_config0(&desc[idx], direction);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (key_dma_addr + (key_len / 2)),
+			     (key_len / 2), NS_BIT);
+		set_xex_data_unit_size(&desc[idx], data_size);
+		set_flow_mode(&desc[idx], s_flow_mode);
+		set_key_size_aes(&desc[idx], (key_len / 2));
+		set_setup_mode(&desc[idx], SETUP_LOAD_XEX_KEY);
 		idx++;
 
 		/* Set state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], cipher_mode);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], direction);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len/2);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], s_flow_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     iv_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
+		hw_desc_init(&desc[idx]);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+		set_cipher_mode(&desc[idx], cipher_mode);
+		set_cipher_config0(&desc[idx], direction);
+		set_key_size_aes(&desc[idx], (key_len / 2));
+		set_flow_mode(&desc[idx], s_flow_mode);
+		set_din_type(&desc[idx], DMA_DLLI, iv_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
 		idx++;
 		break;
 	default:
@@ -401,10 +400,10 @@ ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 	}
 
 	/* create data descriptor */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, data_size, NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], dout_dma_addr, data_size, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], is_aes ? DIN_AES_DOUT : DIN_DES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, data_size, NS_BIT);
+	set_dout_dlli(&desc[idx], dout_dma_addr, data_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], is_aes ? DIN_AES_DOUT : DIN_DES_DOUT);
 	idx++;
 
 	/* perform the operation - Lock HW and push sequence */
@@ -499,42 +498,42 @@ ssi_cmac_fips_run_test(struct ssi_drvdata *drvdata,
 	int idx = 0;
 
 	/* Setup CMAC Key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
-			     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len), NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+		     ((key_len == 24) ? AES_MAX_KEY_SIZE : key_len), NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], key_len);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Load MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, digest_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, digest_dma_addr, CC_AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], key_len);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 
 	//ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     din_dma_addr,
-			     din_len, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, din_len, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], digest_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
+	hw_desc_init(&desc[idx]);
+	set_dout_dlli(&desc[idx], digest_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT,
+		      0);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
 	idx++;
 
 	/* perform the operation - Lock HW and push sequence */
@@ -644,41 +643,43 @@ ssi_hash_fips_run_test(struct ssi_drvdata *drvdata,
 	int idx = 0;
 
 	/* Load initial digest */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, initial_digest_dma_addr, inter_digestsize, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, initial_digest_dma_addr,
+		     inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Load the hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* data descriptor */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, data_in_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, data_in_size, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	if (unlikely((hash_mode == DRV_HASH_MD5) ||
 		     (hash_mode == DRV_HASH_SHA384) ||
 		     (hash_mode == DRV_HASH_SHA512))) {
-		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+		set_bytes_swap(&desc[idx], 1);
 	} else {
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config0(&desc[idx],
+				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 	}
 	idx++;
 
@@ -830,20 +831,19 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	unsigned int hmacPadConst[2] = { HMAC_OPAD_CONST, HMAC_IPAD_CONST };
 
 	// assume (key_size <= block_size)
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr, key_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, key_size, NS_BIT, 0);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr, key_size, NS_BIT);
+	set_flow_mode(&desc[idx], BYPASS);
+	set_dout_dlli(&desc[idx], k0_dma_addr, key_size, NS_BIT, 0);
 	idx++;
 
 	// if needed, append Key with zeros to create K0
 	if ((block_size - key_size) != 0) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, (block_size - key_size));
-		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx],
-				      (k0_dma_addr + key_size), (block_size - key_size),
-				      NS_BIT, 0);
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0, (block_size - key_size));
+		set_flow_mode(&desc[idx], BYPASS);
+		set_dout_dlli(&desc[idx], (k0_dma_addr + key_size),
+			      (block_size - key_size), NS_BIT, 0);
 		idx++;
 	}
 
@@ -858,50 +858,48 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	/* calc derived HMAC key */
 	for (i = 0; i < 2; i++) {
 		/* Load hash initial state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, initial_digest_dma_addr, inter_digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hw_mode);
+		set_din_type(&desc[idx], DMA_DLLI, initial_digest_dma_addr,
+			     inter_digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 
 		/* Load the hash current length*/
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], hw_mode);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Prepare opad/ipad key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_XOR_VAL(&desc[idx], hmacPadConst[i]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		hw_desc_init(&desc[idx]);
+		set_xor_val(&desc[idx], hmacPadConst[i]);
+		set_cipher_mode(&desc[idx], hw_mode);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 		idx++;
 
 		/* Perform HASH update */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     k0_dma_addr,
-				     block_size, NS_BIT);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx],hw_mode);
-		HW_DESC_SET_XOR_ACTIVE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, k0_dma_addr, block_size,
+			     NS_BIT);
+		set_cipher_mode(&desc[idx], hw_mode);
+		set_xor_active(&desc[idx]);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 
 		if (i == 0) {
 			/* First iteration - calc H(K0^opad) into tmp_digest_dma_addr */
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      tmp_digest_dma_addr,
-					      inter_digestsize,
-					      NS_BIT, 0);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], hw_mode);
+			set_dout_dlli(&desc[idx], tmp_digest_dma_addr,
+				      inter_digestsize, NS_BIT, 0);
+			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 			idx++;
 
 			// is this needed?? or continue with current descriptors??
@@ -916,35 +914,34 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	}
 
 	/* data descriptor */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     din_dma_addr, data_in_size,
-			     NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, data_in_size, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	/* HW last hash block padding (aka. "DO_PAD") */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
-	HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_dout_dlli(&desc[idx], k0_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	set_cipher_do(&desc[idx], DO_PAD);
 	idx++;
 
 	/* store the hash digest result in the context */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], k0_dma_addr, digest_size, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_dout_dlli(&desc[idx], k0_dma_addr, digest_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	if (unlikely((hash_mode == DRV_HASH_MD5) ||
 		     (hash_mode == DRV_HASH_SHA384) ||
 		     (hash_mode == DRV_HASH_SHA512))) {
-		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+		set_bytes_swap(&desc[idx], 1);
 	} else {
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config0(&desc[idx],
+				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 	}
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	idx++;
 
 	/* at this point:
@@ -953,48 +950,51 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	   */
 
 	/* Loading hash opad xor key state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, tmp_digest_dma_addr, inter_digestsize, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, tmp_digest_dma_addr,
+		     inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Load the hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* Perform HASH update */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, k0_dma_addr, digest_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, k0_dma_addr, digest_size, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], hw_mode);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, digest_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	if (unlikely((hash_mode == DRV_HASH_MD5) ||
 		     (hash_mode == DRV_HASH_SHA384) ||
 		     (hash_mode == DRV_HASH_SHA512))) {
-		HW_DESC_SET_BYTES_SWAP(&desc[idx], 1);
+		set_bytes_swap(&desc[idx], 1);
 	} else {
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config0(&desc[idx],
+				   HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 	}
 	idx++;
 
@@ -1142,99 +1142,102 @@ ssi_ccm_fips_run_test(struct ssi_drvdata *drvdata,
 	}
 
 	/* load key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
-			     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ? CC_AES_KEY_SIZE_MAX : key_size),
-			     NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+		     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ?
+		     CC_AES_KEY_SIZE_MAX : key_size), NS_BIT)
+	set_key_size_aes(&desc[idx], key_size);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* load ctr state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     iv_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_key_size_aes(&desc[idx], key_size);
+	set_din_type(&desc[idx], DMA_DLLI, iv_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* load MAC key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, key_dma_addr,
-			     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ? CC_AES_KEY_SIZE_MAX : key_size),
-			     NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr,
+		     ((key_size == NIST_AESCCM_192_BIT_KEY_SIZE) ?
+		     CC_AES_KEY_SIZE_MAX : key_size), NS_BIT);
+	set_key_size_aes(&desc[idx], key_size);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* load MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_key_size_aes(&desc[idx], key_size);
+	set_din_type(&desc[idx], DMA_DLLI, mac_res_dma_addr,
+		     NIST_AESCCM_TAG_SIZE, NS_BIT);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* prcess assoc data */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, b0_a0_adata_dma_addr, b0_a0_adata_size, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, b0_a0_adata_dma_addr,
+		     b0_a0_adata_size, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	/* process the cipher */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, din_dma_addr, din_size, NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], dout_dma_addr, din_size, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], cipher_flow_mode);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, din_size, NS_BIT);
+	set_dout_dlli(&desc[idx], dout_dma_addr, din_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], cipher_flow_mode);
 	idx++;
 
 	/* Read temporal MAC */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CBC_MAC);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT, 0);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CBC_MAC);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE,
+		      NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* load AES-CTR state (for last MAC calculation)*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CTR);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     ctr_cnt_0_dma_addr,
-			     AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, ctr_cnt_0_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_key_size_aes(&desc[idx], key_size);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Memory Barrier */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* encrypt the "T" value and store MAC inplace */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, mac_res_dma_addr,
+		     NIST_AESCCM_TAG_SIZE, NS_BIT);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, NIST_AESCCM_TAG_SIZE,
+		      NS_BIT, 0);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* perform the operation - Lock HW and push sequence */
@@ -1372,70 +1375,65 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 //	ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
 /////////////////////////////////   1   ////////////////////////////////////
 
-	/* load key to AES*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx],
-			     DMA_DLLI, key_dma_addr, key_size,
-			     NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	/* load key to AES */
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr, key_size, NS_BIT);
+	set_key_size_aes(&desc[idx], key_size);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* process one zero block to generate hkey */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			      hkey_dma_addr, AES_BLOCK_SIZE,
-			      NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_dlli(&desc[idx], hkey_dma_addr, AES_BLOCK_SIZE, NS_BIT, 0);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* Memory Barrier */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* Load GHASH subkey */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     hkey_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, hkey_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Configure Hash Engine to work with GHASH.
 	   Since it was not possible to extend HASH submodes to add GHASH,
 	   The following command is necessary in order to select GHASH (according to HW designers)*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_DO(&desc[idx], 1); //1=AES_SK RKEK
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_do(&desc[idx], 1); //1=AES_SK RKEK
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	/* Load GHASH initial STATE (which is 0). (for any hash there is an initial state) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x0, AES_BLOCK_SIZE);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x0, AES_BLOCK_SIZE);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_aes_not_hash_mode(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 
@@ -1446,11 +1444,9 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 //		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
 /////////////////////////////////   2   ////////////////////////////////////
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     adata_dma_addr, adata_size,
-			     NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, adata_dma_addr, adata_size, NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 
@@ -1459,27 +1455,24 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 /////////////////////////////////   3   ////////////////////////////////////
 
 	/* load key to AES*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     key_dma_addr, key_size,
-			     NS_BIT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_din_type(&desc[idx], DMA_DLLI, key_dma_addr, key_size, NS_BIT);
+	set_key_size_aes(&desc[idx], key_size);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* load AES/CTR initial CTR value inc by 2*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     iv_inc2_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_key_size_aes(&desc[idx], key_size);
+	set_din_type(&desc[idx], DMA_DLLI, iv_inc2_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 
@@ -1489,14 +1482,10 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 //		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
 /////////////////////////////////   4   ////////////////////////////////////
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     din_dma_addr, din_size,
-			     NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			      dout_dma_addr, din_size,
-			      NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], cipher_flow_mode);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, din_dma_addr, din_size, NS_BIT);
+	set_dout_dlli(&desc[idx], dout_dma_addr, din_size, NS_BIT, 0);
+	set_flow_mode(&desc[idx], cipher_flow_mode);
 	idx++;
 
 
@@ -1505,53 +1494,46 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 /////////////////////////////////   5   ////////////////////////////////////
 
 	/* prcess(ghash) gcm_block_len */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     block_len_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, block_len_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_flow_mode(&desc[idx], DIN_HASH);
 	idx++;
 
 	/* Store GHASH state after GHASH(Associated Data + Cipher +LenBlock) */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_HASH_HW_GHASH);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			      mac_res_dma_addr, AES_BLOCK_SIZE,
-			      NS_BIT, 0);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_AES_NOT_HASH_MODE(&desc[idx]);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_HASH_HW_GHASH);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, AES_BLOCK_SIZE, NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_aes_not_hash_mode(&desc[idx]);
 	idx++;
 
 	/* load AES/CTR initial CTR value inc by 1*/
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_size);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     iv_inc1_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_key_size_aes(&desc[idx], key_size);
+	set_din_type(&desc[idx], DMA_DLLI, iv_inc1_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Memory Barrier */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+	hw_desc_init(&desc[idx]);
+	set_din_no_dma(&desc[idx], 0, 0xfffff0);
+	set_dout_no_dma(&desc[idx], 0, 0, 1);
 	idx++;
 
 	/* process GCTR on stored GHASH and store MAC inplace */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_GCTR);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-			     mac_res_dma_addr, AES_BLOCK_SIZE,
-			     NS_BIT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx],
-			      mac_res_dma_addr, AES_BLOCK_SIZE,
-			      NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_GCTR);
+	set_din_type(&desc[idx], DMA_DLLI, mac_res_dma_addr, AES_BLOCK_SIZE,
+		     NS_BIT);
+	set_dout_dlli(&desc[idx], mac_res_dma_addr, AES_BLOCK_SIZE, NS_BIT, 0);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* perform the operation - Lock HW and push sequence */
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 8585f73..04d757f 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -125,9 +125,9 @@ static inline void ssi_set_hash_endianity(u32 mode, struct cc_hw_desc *desc)
 	if (unlikely((mode == DRV_HASH_MD5) ||
 		(mode == DRV_HASH_SHA384) ||
 		(mode == DRV_HASH_SHA512))) {
-		HW_DESC_SET_BYTES_SWAP(desc, 1);
+		set_bytes_swap(desc, 1);
 	} else {
-		HW_DESC_SET_CIPHER_CONFIG0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
+		set_cipher_config0(desc, HASH_DIGEST_RESULT_LITTLE_ENDIAN);
 	}
 }
 
@@ -251,10 +251,11 @@ static int ssi_hash_map_request(struct device *dev,
 	} else { /*hash*/
 		/* Copy the initial digests if hash flow. The SRAM contains the
 		initial digests in the expected order for all SHA* */
-		HW_DESC_INIT(&desc);
-		HW_DESC_SET_DIN_SRAM(&desc, larval_digest_addr, ctx->inter_digestsize);
-		HW_DESC_SET_DOUT_DLLI(&desc, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc, BYPASS);
+		hw_desc_init(&desc);
+		set_din_sram(&desc, larval_digest_addr, ctx->inter_digestsize);
+		set_dout_dlli(&desc, state->digest_buff_dma_addr,
+			      ctx->inter_digestsize, NS_BIT, 0);
+		set_flow_mode(&desc, BYPASS);
 
 		rc = send_request(ctx->drvdata, &ssi_req, &desc, 1, 0);
 		if (unlikely(rc != 0)) {
@@ -486,96 +487,108 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	}
 
 	/* If HMAC then load hash IPAD xor key, if HASH then load initial digest */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	if (is_hmac) {
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     ctx->inter_digestsize, NS_BIT);
 	} else {
-		HW_DESC_SET_DIN_SRAM(&desc[idx], larval_digest_addr, ctx->inter_digestsize);
+		set_din_sram(&desc[idx], larval_digest_addr,
+			     ctx->inter_digestsize);
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Load the hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 
 	if (is_hmac) {
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     state->digest_bytes_len_dma_addr, HASH_LEN_SIZE,
+			     NS_BIT);
 	} else {
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
 		if (likely(nbytes != 0)) {
-			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		} else {
-			HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+			set_cipher_do(&desc[idx], DO_PAD);
 		}
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	if (is_hmac) {
 		/* HW last hash block padding (aka. "DO_PAD") */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
-		HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      HASH_LEN_SIZE, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+		set_cipher_do(&desc[idx], DO_PAD);
 		idx++;
 
 		/* store the hash digest result in the context */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, digestsize, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      digestsize, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
 
 		/* Loading hash opad xor key state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr, ctx->inter_digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
+			     ctx->inter_digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 		/* Load the hash current length */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_SRAM(&desc[idx], ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
-		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_sram(&desc[idx],
+			     ssi_ahash_get_initial_digest_len_sram_addr(
+ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
 		idx++;
 
 		/* Perform HASH update */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, digestsize, NS_BIT, async_req? 1:0);   /*TODO*/
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
+		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		set_queue_last_ind(&desc[idx]);
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	ssi_set_hash_endianity(ctx->hash_mode, &desc[idx]);
 	idx++;
 
@@ -644,39 +657,43 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 	}
 
 	/* Restore hash digest */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 	/* Restore hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	/* store the hash digest result in context */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT, 0);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+		      ctx->inter_digestsize, NS_BIT, 0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	idx++;
 
 	/* store current hash length in context */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT, async_req? 1:0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
+		      HASH_LEN_SIZE, NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		set_queue_last_ind(&desc[idx]);
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	idx++;
 
 	if (async_req) {
@@ -735,75 +752,84 @@ static int ssi_hash_finup(struct ahash_req_ctx *state,
 	}
 
 	/* Restore hash digest */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Restore hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	if (is_hmac) {
 		/* Store the hash digest result in the context */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, digestsize, NS_BIT, 0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      digestsize, NS_BIT, 0);
 		ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
 
 		/* Loading hash OPAD xor key state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr, ctx->inter_digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
+			     ctx->inter_digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 		/* Load the hash current length */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_SRAM(&desc[idx], ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
-		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_sram(&desc[idx],
+			     ssi_ahash_get_initial_digest_len_sram_addr(
+ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
 		idx++;
 
 		/* Perform HASH update on last digest */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, digestsize, NS_BIT, async_req? 1:0); /*TODO*/
+	hw_desc_init(&desc[idx]);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
+		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		set_queue_last_ind(&desc[idx]);
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
 	if (async_req) {
@@ -867,84 +893,93 @@ static int ssi_hash_final(struct ahash_req_ctx *state,
 	}
 
 	/* Restore hash digest */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     ctx->inter_digestsize, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 	idx++;
 
 	/* Restore hash current length */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
+		     HASH_LEN_SIZE, NS_BIT);
+	set_flow_mode(&desc[idx], S_DIN_to_HASH);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
 	ssi_hash_create_data_desc(state, ctx, DIN_HASH, desc, false, &idx);
 
 	/* "DO-PAD" must be enabled only when writing current length to HW */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_DO(&desc[idx], DO_PAD);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_bytes_len_dma_addr, HASH_LEN_SIZE, NS_BIT, 0);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE1);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
+	hw_desc_init(&desc[idx]);
+	set_cipher_do(&desc[idx], DO_PAD);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
+		      HASH_LEN_SIZE, NS_BIT, 0);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	idx++;
 
 	if (is_hmac) {
 		/* Store the hash digest result in the context */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, digestsize, NS_BIT, 0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      digestsize, NS_BIT, 0);
 		ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
 
 		/* Loading hash OPAD xor key state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr, ctx->inter_digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_type(&desc[idx], DMA_DLLI, state->opad_digest_dma_addr,
+			     ctx->inter_digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 		/* Load the hash current length */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_SRAM(&desc[idx], ssi_ahash_get_initial_digest_len_sram_addr(ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
-		HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_sram(&desc[idx],
+			     ssi_ahash_get_initial_digest_len_sram_addr(
+ctx->drvdata, ctx->hash_mode), HASH_LEN_SIZE);
+		set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Memory Barrier: wait for IPAD/OPAD axi write to complete */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
 		idx++;
 
 		/* Perform HASH update on last digest */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, digestsize, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     digestsize, NS_BIT);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, digestsize, NS_BIT, async_req? 1:0);
+	hw_desc_init(&desc[idx]);
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
+		      NS_BIT, (async_req ? 1 : 0));
 	if (async_req) {
-		HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
+		set_queue_last_ind(&desc[idx]);
 	}
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-	HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
 	if (async_req) {
@@ -1051,79 +1086,76 @@ static int ssi_hash_setkey(void *hash,
 
 		if (keylen > blocksize) {
 			/* Load hash initial state */
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-			HW_DESC_SET_DIN_SRAM(&desc[idx], larval_addr,
-					ctx->inter_digestsize);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_din_sram(&desc[idx], larval_addr,
+				     ctx->inter_digestsize);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 			idx++;
 
 			/* Load the hash current length*/
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-			HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_ENABLED);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
+			set_flow_mode(&desc[idx], S_DIN_to_HASH);
+			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 			idx++;
 
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     ctx->key_params.key_dma_addr,
-					     keylen, NS_BIT);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     ctx->key_params.key_dma_addr, keylen,
+				     NS_BIT);
+			set_flow_mode(&desc[idx], DIN_HASH);
 			idx++;
 
 			/* Get hashed key */
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx], ctx->opad_tmp_keys_dma_addr,
-					      digestsize, NS_BIT, 0);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-			HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-			HW_DESC_SET_CIPHER_CONFIG1(&desc[idx], HASH_PADDING_DISABLED);
+			hw_desc_init(&desc[idx]);
+			set_cipher_mode(&desc[idx], ctx->hw_mode);
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      digestsize, NS_BIT, 0);
+			set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+			set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+			set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 			ssi_set_hash_endianity(ctx->hash_mode,&desc[idx]);
 			idx++;
 
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_CONST(&desc[idx], 0, (blocksize - digestsize));
-			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      (ctx->opad_tmp_keys_dma_addr + digestsize),
-					      (blocksize - digestsize),
-					      NS_BIT, 0);
+			hw_desc_init(&desc[idx]);
+			set_din_const(&desc[idx], 0, (blocksize - digestsize));
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
+						   digestsize),
+				      (blocksize - digestsize), NS_BIT, 0);
 			idx++;
 		} else {
-			HW_DESC_INIT(&desc[idx]);
-			HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-					     ctx->key_params.key_dma_addr,
-					     keylen, NS_BIT);
-			HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					(ctx->opad_tmp_keys_dma_addr),
-					keylen, NS_BIT, 0);
+			hw_desc_init(&desc[idx]);
+			set_din_type(&desc[idx], DMA_DLLI,
+				     ctx->key_params.key_dma_addr, keylen,
+				     NS_BIT);
+			set_flow_mode(&desc[idx], BYPASS);
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      keylen, NS_BIT, 0);
 			idx++;
 
 			if ((blocksize - keylen) != 0) {
-				HW_DESC_INIT(&desc[idx]);
-				HW_DESC_SET_DIN_CONST(&desc[idx], 0, (blocksize - keylen));
-				HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-				HW_DESC_SET_DOUT_DLLI(&desc[idx],
-						      (ctx->opad_tmp_keys_dma_addr + keylen),
-						      (blocksize - keylen),
-						      NS_BIT, 0);
+				hw_desc_init(&desc[idx]);
+				set_din_const(&desc[idx], 0,
+					      (blocksize - keylen));
+				set_flow_mode(&desc[idx], BYPASS);
+				set_dout_dlli(&desc[idx],
+					      (ctx->opad_tmp_keys_dma_addr +
+					       keylen), (blocksize - keylen),
+					      NS_BIT, 0);
 				idx++;
 			}
 		}
 	} else {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, blocksize);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx],
-				      (ctx->opad_tmp_keys_dma_addr),
-				      blocksize,
-				      NS_BIT, 0);
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0, blocksize);
+		set_flow_mode(&desc[idx], BYPASS);
+		set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr),
+			      blocksize, NS_BIT, 0);
 		idx++;
 	}
 
@@ -1136,55 +1168,49 @@ static int ssi_hash_setkey(void *hash,
 	/* calc derived HMAC key */
 	for (idx = 0, i = 0; i < 2; i++) {
 		/* Load hash initial state */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_SRAM(&desc[idx], larval_addr,
-				ctx->inter_digestsize);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_sram(&desc[idx], larval_addr, ctx->inter_digestsize);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
 		idx++;
 
 		/* Load the hash current length*/
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0, HASH_LEN_SIZE);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_din_const(&desc[idx], 0, HASH_LEN_SIZE);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 		/* Prepare ipad key */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_XOR_VAL(&desc[idx], hmacPadConst[i]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_HASH);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
+		hw_desc_init(&desc[idx]);
+		set_xor_val(&desc[idx], hmacPadConst[i]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_flow_mode(&desc[idx], S_DIN_to_HASH);
+		set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
 		idx++;
 
 		/* Perform HASH update */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     ctx->opad_tmp_keys_dma_addr,
-				     blocksize, NS_BIT);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx],ctx->hw_mode);
-		HW_DESC_SET_XOR_ACTIVE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_HASH);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
+			     blocksize, NS_BIT);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_xor_active(&desc[idx]);
+		set_flow_mode(&desc[idx], DIN_HASH);
 		idx++;
 
 		/* Get the IPAD/OPAD xor key (Note, IPAD is the initial digest of the first HASH "update" state) */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		if (i > 0) /* Not first iteration */
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      ctx->opad_tmp_keys_dma_addr,
-					      ctx->inter_digestsize,
-					      NS_BIT, 0);
+			set_dout_dlli(&desc[idx], ctx->opad_tmp_keys_dma_addr,
+				      ctx->inter_digestsize, NS_BIT, 0);
 		else /* First iteration */
-			HW_DESC_SET_DOUT_DLLI(&desc[idx],
-					      ctx->digest_buff_dma_addr,
-					      ctx->inter_digestsize,
-					      NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_HASH_to_DOUT);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+			set_dout_dlli(&desc[idx], ctx->digest_buff_dma_addr,
+				      ctx->inter_digestsize, NS_BIT, 0);
+		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
+		set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 		idx++;
 	}
 
@@ -1252,35 +1278,36 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
 
 	ctx->is_hmac = true;
 	/* 1. Load the AES key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->key_params.key_dma_addr, keylen, NS_BIT);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], keylen);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->key_params.key_dma_addr,
+		     keylen, NS_BIT);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+	set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_ENCRYPT);
+	set_key_size_aes(&desc[idx], keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x01010101, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
 					   XCBC_MAC_K1_OFFSET),
 			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x02020202, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
 					   XCBC_MAC_K2_OFFSET),
 			      CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
 
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_CONST(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
+	hw_desc_init(&desc[idx]);
+	set_din_const(&desc[idx], 0x03030303, CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], DIN_AES_DOUT);
+	set_dout_dlli(&desc[idx], (ctx->opad_tmp_keys_dma_addr +
 					   XCBC_MAC_K3_OFFSET),
 			       CC_AES_128_BIT_KEY_SIZE, NS_BIT, 0);
 	idx++;
@@ -1503,12 +1530,13 @@ static int ssi_mac_update(struct ahash_request *req)
 	ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, true, &idx);
 
 	/* store the hash digest result in context */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, ctx->inter_digestsize, NS_BIT, 1);
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
+	hw_desc_init(&desc[idx]);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+		      ctx->inter_digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
 	idx++;
 
 	/* Setup DX request structure */
@@ -1573,30 +1601,31 @@ static int ssi_mac_final(struct ahash_request *req)
 
 	if (state->xcbc_count && (rem_cnt == 0)) {
 		/* Load key for ECB decryption */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_ECB);
-		HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     (ctx->opad_tmp_keys_dma_addr +
-				      XCBC_MAC_K1_OFFSET),
-				    keySize, NS_BIT);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], keyLen);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
-		HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], DRV_CIPHER_ECB);
+		set_cipher_config0(&desc[idx], DRV_CRYPTO_DIRECTION_DECRYPT);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     (ctx->opad_tmp_keys_dma_addr +
+			      XCBC_MAC_K1_OFFSET), keySize, NS_BIT);
+		set_key_size_aes(&desc[idx], keyLen);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
+		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
 
 
 		/* Initiate decryption of block state to previous block_state-XOR-M[n] */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
-		HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_buff_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT,0);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
+		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
+			      CC_AES_BLOCK_SIZE, NS_BIT, 0);
+		set_flow_mode(&desc[idx], DIN_AES_DOUT);
 		idx++;
 
 		/* Memory Barrier: wait for axi write to complete */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
-		HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
+		hw_desc_init(&desc[idx]);
+		set_din_no_dma(&desc[idx], 0, 0xfffff0);
+		set_dout_no_dma(&desc[idx], 0, 0, 1);
 		idx++;
 	}
 
@@ -1607,28 +1636,30 @@ static int ssi_mac_final(struct ahash_request *req)
 	}
 
 	if (state->xcbc_count == 0) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], keyLen);
-		HW_DESC_SET_CMAC_SIZE0_MODE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], keyLen);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else if (rem_cnt > 0) {
 		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	} else {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_CONST(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], DIN_AES_DOUT);
+		hw_desc_init(&desc[idx]);
+		set_din_const(&desc[idx], 0x00, CC_AES_BLOCK_SIZE);
+		set_flow_mode(&desc[idx], DIN_AES_DOUT);
 		idx++;
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, digestsize, NS_BIT, 1); /*TODO*/
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	hw_desc_init(&desc[idx]);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
@@ -1685,23 +1716,25 @@ static int ssi_mac_finup(struct ahash_request *req)
 	}
 
 	if (req->nbytes == 0) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], key_len);
-		HW_DESC_SET_CMAC_SIZE0_MODE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], key_len);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
 		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, digestsize, NS_BIT, 1); /*TODO*/
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	hw_desc_init(&desc[idx]);
+	/* TODO */
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      digestsize, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
@@ -1760,24 +1793,25 @@ static int ssi_mac_digest(struct ahash_request *req)
 	}
 
 	if (req->nbytes == 0) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
-		HW_DESC_SET_KEY_SIZE_AES(&desc[idx], keyLen);
-		HW_DESC_SET_CMAC_SIZE0_MODE(&desc[idx]);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+		hw_desc_init(&desc[idx]);
+		set_cipher_mode(&desc[idx], ctx->hw_mode);
+		set_key_size_aes(&desc[idx], keyLen);
+		set_cmac_size0_mode(&desc[idx]);
+		set_flow_mode(&desc[idx], S_DIN_to_AES);
 		idx++;
 	} else {
 		ssi_hash_create_data_desc(state, ctx, DIN_AES_DOUT, desc, false, &idx);
 	}
 
 	/* Get final MAC result */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DOUT_DLLI(&desc[idx], state->digest_result_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT,1);
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[idx]);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_AES_to_DOUT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_WRITE_STATE0);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx],DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], ctx->hw_mode);
+	hw_desc_init(&desc[idx]);
+	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
+		      CC_AES_BLOCK_SIZE, NS_BIT, 1);
+	set_queue_last_ind(&desc[idx]);
+	set_flow_mode(&desc[idx], S_AES_to_DOUT);
+	set_setup_mode(&desc[idx], SETUP_WRITE_STATE0);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	idx++;
 
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 1);
@@ -2551,49 +2585,50 @@ static void ssi_hash_create_xcbc_setup(struct ahash_request *areq,
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	/* Setup XCBC MAC K1 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr
-						    + XCBC_MAC_K1_OFFSET),
-			     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
+					    XCBC_MAC_K1_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Setup XCBC MAC K2 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr
-						    + XCBC_MAC_K2_OFFSET),
-			      CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
+					    XCBC_MAC_K2_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE1);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Setup XCBC MAC K3 */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr
-						    + XCBC_MAC_K3_OFFSET),
-			     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE2);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, (ctx->opad_tmp_keys_dma_addr +
+					    XCBC_MAC_K3_OFFSET),
+		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE2);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Loading MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_XCBC_MAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     CC_AES_BLOCK_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 	*seq_size = idx;
 }
@@ -2608,24 +2643,26 @@ static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	/* Setup CMAC Key */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
-		((ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE : ctx->key_params.keylen), NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->key_params.keylen);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, ctx->opad_tmp_keys_dma_addr,
+		     ((ctx->key_params.keylen == 24) ? AES_MAX_KEY_SIZE :
+		      ctx->key_params.keylen), NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 
 	/* Load MAC state */
-	HW_DESC_INIT(&desc[idx]);
-	HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
-	HW_DESC_SET_SETUP_MODE(&desc[idx], SETUP_LOAD_STATE0);
-	HW_DESC_SET_CIPHER_MODE(&desc[idx], DRV_CIPHER_CMAC);
-	HW_DESC_SET_CIPHER_CONFIG0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_KEY_SIZE_AES(&desc[idx], ctx->key_params.keylen);
-	HW_DESC_SET_FLOW_MODE(&desc[idx], S_DIN_to_AES);
+	hw_desc_init(&desc[idx]);
+	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
+		     CC_AES_BLOCK_SIZE, NS_BIT);
+	set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
+	set_cipher_mode(&desc[idx], DRV_CIPHER_CMAC);
+	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_key_size_aes(&desc[idx], ctx->key_params.keylen);
+	set_flow_mode(&desc[idx], S_DIN_to_AES);
 	idx++;
 	*seq_size = idx;
 }
@@ -2640,11 +2677,11 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
 	unsigned int idx = *seq_size;
 
 	if (likely(areq_ctx->data_dma_buf_type == SSI_DMA_BUF_DLLI)) {
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     sg_dma_address(areq_ctx->curr_sg),
-				     areq_ctx->curr_sg->length, NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     sg_dma_address(areq_ctx->curr_sg),
+			     areq_ctx->curr_sg->length, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
 		idx++;
 	} else {
 		if (areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
@@ -2653,27 +2690,24 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
 			return;
 		}
 		/* bypass */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_DLLI,
-				     areq_ctx->mlli_params.mlli_dma_addr,
-				     areq_ctx->mlli_params.mlli_len,
-				     NS_BIT);
-		HW_DESC_SET_DOUT_SRAM(&desc[idx],
-				      ctx->drvdata->mlli_sram_addr,
-				      areq_ctx->mlli_params.mlli_len);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], BYPASS);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_DLLI,
+			     areq_ctx->mlli_params.mlli_dma_addr,
+			     areq_ctx->mlli_params.mlli_len, NS_BIT);
+		set_dout_sram(&desc[idx], ctx->drvdata->mlli_sram_addr,
+			      areq_ctx->mlli_params.mlli_len);
+		set_flow_mode(&desc[idx], BYPASS);
 		idx++;
 		/* process */
-		HW_DESC_INIT(&desc[idx]);
-		HW_DESC_SET_DIN_TYPE(&desc[idx], DMA_MLLI,
-				     ctx->drvdata->mlli_sram_addr,
-				     areq_ctx->mlli_nents,
-				     NS_BIT);
-		HW_DESC_SET_FLOW_MODE(&desc[idx], flow_mode);
+		hw_desc_init(&desc[idx]);
+		set_din_type(&desc[idx], DMA_MLLI,
+			     ctx->drvdata->mlli_sram_addr,
+			     areq_ctx->mlli_nents, NS_BIT);
+		set_flow_mode(&desc[idx], flow_mode);
 		idx++;
 	}
 	if (is_not_last_data) {
-		HW_DESC_SET_DIN_NOT_LAST_INDICATION(&desc[idx-1]);
+		set_din_not_last_indication(&desc[(idx - 1)]);
 	}
 	/* return updated desc sequence size */
 	*seq_size = idx;
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 1bb6f89..d58ee7d 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -68,37 +68,37 @@ static int ssi_ivgen_generate_pool(
 		return -EINVAL;
 	}
 	/* Setup key */
-	HW_DESC_INIT(&iv_seq[idx]);
-	HW_DESC_SET_DIN_SRAM(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
-	HW_DESC_SET_SETUP_MODE(&iv_seq[idx], SETUP_LOAD_KEY0);
-	HW_DESC_SET_CIPHER_CONFIG0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], S_DIN_to_AES);
-	HW_DESC_SET_KEY_SIZE_AES(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_CIPHER_MODE(&iv_seq[idx], DRV_CIPHER_CTR);
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_key, AES_KEYSIZE_128);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_KEY0);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
 	idx++;
 
 	/* Setup cipher state */
-	HW_DESC_INIT(&iv_seq[idx]);
-	HW_DESC_SET_DIN_SRAM(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
-	HW_DESC_SET_CIPHER_CONFIG0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
-	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], S_DIN_to_AES);
-	HW_DESC_SET_SETUP_MODE(&iv_seq[idx], SETUP_LOAD_STATE1);
-	HW_DESC_SET_KEY_SIZE_AES(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
-	HW_DESC_SET_CIPHER_MODE(&iv_seq[idx], DRV_CIPHER_CTR);
+	hw_desc_init(&iv_seq[idx]);
+	set_din_sram(&iv_seq[idx], ivgen_ctx->ctr_iv, CC_AES_IV_SIZE);
+	set_cipher_config0(&iv_seq[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
+	set_flow_mode(&iv_seq[idx], S_DIN_to_AES);
+	set_setup_mode(&iv_seq[idx], SETUP_LOAD_STATE1);
+	set_key_size_aes(&iv_seq[idx], CC_AES_128_BIT_KEY_SIZE);
+	set_cipher_mode(&iv_seq[idx], DRV_CIPHER_CTR);
 	idx++;
 
 	/* Perform dummy encrypt to skip first block */
-	HW_DESC_INIT(&iv_seq[idx]);
-	HW_DESC_SET_DIN_CONST(&iv_seq[idx], 0, CC_AES_IV_SIZE);
-	HW_DESC_SET_DOUT_SRAM(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
-	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], DIN_AES_DOUT);
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, CC_AES_IV_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, CC_AES_IV_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
 	idx++;
 
 	/* Generate IV pool */
-	HW_DESC_INIT(&iv_seq[idx]);
-	HW_DESC_SET_DIN_CONST(&iv_seq[idx], 0, SSI_IVPOOL_SIZE);
-	HW_DESC_SET_DOUT_SRAM(&iv_seq[idx], ivgen_ctx->pool, SSI_IVPOOL_SIZE);
-	HW_DESC_SET_FLOW_MODE(&iv_seq[idx], DIN_AES_DOUT);
+	hw_desc_init(&iv_seq[idx]);
+	set_din_const(&iv_seq[idx], 0, SSI_IVPOOL_SIZE);
+	set_dout_sram(&iv_seq[idx], ivgen_ctx->pool, SSI_IVPOOL_SIZE);
+	set_flow_mode(&iv_seq[idx], DIN_AES_DOUT);
 	idx++;
 
 	*iv_seq_len = idx; /* Update sequence length */
@@ -132,13 +132,12 @@ int ssi_ivgen_init_sram_pool(struct ssi_drvdata *drvdata)
 	ivgen_ctx->ctr_iv = ivgen_ctx->pool + AES_KEYSIZE_128;
 
 	/* Copy initial enc. key and IV to SRAM at a single descriptor */
-	HW_DESC_INIT(&iv_seq[iv_seq_len]);
-	HW_DESC_SET_DIN_TYPE(&iv_seq[iv_seq_len], DMA_DLLI,
-		ivgen_ctx->pool_meta_dma, SSI_IVPOOL_META_SIZE,
-		NS_BIT);
-	HW_DESC_SET_DOUT_SRAM(&iv_seq[iv_seq_len], ivgen_ctx->pool,
-		SSI_IVPOOL_META_SIZE);
-	HW_DESC_SET_FLOW_MODE(&iv_seq[iv_seq_len], BYPASS);
+	hw_desc_init(&iv_seq[iv_seq_len]);
+	set_din_type(&iv_seq[iv_seq_len], DMA_DLLI, ivgen_ctx->pool_meta_dma,
+		     SSI_IVPOOL_META_SIZE, NS_BIT);
+	set_dout_sram(&iv_seq[iv_seq_len], ivgen_ctx->pool,
+		      SSI_IVPOOL_META_SIZE);
+	set_flow_mode(&iv_seq[iv_seq_len], BYPASS);
 	iv_seq_len++;
 
 	/* Generate initial pool */
@@ -267,21 +266,21 @@ int ssi_ivgen_getiv(
 
 	for (t = 0; t < iv_out_dma_len; t++) {
 		/* Acquire IV from pool */
-		HW_DESC_INIT(&iv_seq[idx]);
-		HW_DESC_SET_DIN_SRAM(&iv_seq[idx],
-			ivgen_ctx->pool + ivgen_ctx->next_iv_ofs,
-			iv_out_size);
-		HW_DESC_SET_DOUT_DLLI(&iv_seq[idx], iv_out_dma[t],
-			iv_out_size, NS_BIT, 0);
-		HW_DESC_SET_FLOW_MODE(&iv_seq[idx], BYPASS);
+		hw_desc_init(&iv_seq[idx]);
+		set_din_sram(&iv_seq[idx], (ivgen_ctx->pool +
+					    ivgen_ctx->next_iv_ofs),
+			     iv_out_size);
+		set_dout_dlli(&iv_seq[idx], iv_out_dma[t], iv_out_size,
+			      NS_BIT, 0);
+		set_flow_mode(&iv_seq[idx], BYPASS);
 		idx++;
 	}
 
 	/* Bypass operation is proceeded by crypto sequence, hence must
 	*  assure bypass-write-transaction by a memory barrier */
-	HW_DESC_INIT(&iv_seq[idx]);
-	HW_DESC_SET_DIN_NO_DMA(&iv_seq[idx], 0, 0xfffff0);
-	HW_DESC_SET_DOUT_NO_DMA(&iv_seq[idx], 0, 0, 1);
+	hw_desc_init(&iv_seq[idx]);
+	set_din_no_dma(&iv_seq[idx], 0, 0xfffff0);
+	set_dout_no_dma(&iv_seq[idx], 0, 0, 1);
 	idx++;
 
 	*iv_seq_len = idx; /* update seq length */
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 48c2450..44f11fb 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -47,7 +47,7 @@
  */
 #define INIT_CC_MONITOR_DESC(desc_p) \
 do { \
-	HW_DESC_INIT(desc_p); \
+	hw_desc_init(desc_p); \
 	HW_DESC_SET_DIN_MONITOR_CNTR(desc_p); \
 } while (0)
 
@@ -73,9 +73,9 @@ do { \
 do { \
 	if ((is_monitored) == true) { \
 		struct cc_hw_desc barrier_desc; \
-		HW_DESC_INIT(&barrier_desc); \
-		HW_DESC_SET_DIN_NO_DMA(&barrier_desc, 0, 0xfffff0); \
-		HW_DESC_SET_DOUT_NO_DMA(&barrier_desc, 0, 0, 1); \
+		hw_desc_init(&barrier_desc); \
+		set_din_no_dma(&barrier_desc, 0, 0xfffff0); \
+		set_dout_no_dma(&barrier_desc, 0, 0, 1); \
 		enqueue_seq((cc_base_addr), &barrier_desc, 1); \
 		enqueue_seq((cc_base_addr), (desc_p), 1); \
 	} \
@@ -224,13 +224,12 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 							     sizeof(u32));
 
 	/* Init. "dummy" completion descriptor */
-	HW_DESC_INIT(&req_mgr_h->compl_desc);
-	HW_DESC_SET_DIN_CONST(&req_mgr_h->compl_desc, 0, sizeof(u32));
-	HW_DESC_SET_DOUT_DLLI(&req_mgr_h->compl_desc,
-		req_mgr_h->dummy_comp_buff_dma,
-		sizeof(u32), NS_BIT, 1);
-	HW_DESC_SET_FLOW_MODE(&req_mgr_h->compl_desc, BYPASS);
-	HW_DESC_SET_QUEUE_LAST_IND(&req_mgr_h->compl_desc);
+	hw_desc_init(&req_mgr_h->compl_desc);
+	set_din_const(&req_mgr_h->compl_desc, 0, sizeof(u32));
+	set_dout_dlli(&req_mgr_h->compl_desc, req_mgr_h->dummy_comp_buff_dma,
+		      sizeof(u32), NS_BIT, 1);
+	set_flow_mode(&req_mgr_h->compl_desc, BYPASS);
+	set_queue_last_ind(&req_mgr_h->compl_desc);
 
 #ifdef CC_CYCLE_COUNT
 	/* For CC-HW cycle performance trace */
@@ -514,7 +513,7 @@ int send_request_init(
 	if (unlikely(rc != 0 )) {
 		return rc;
 	}
-	HW_DESC_SET_QUEUE_LAST_IND(&desc[len-1]);
+	set_queue_last_ind(&desc[(len - 1)]);
 
 	enqueue_seq(cc_base, desc, len);
 
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index bd7078d..c8ab55e 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -127,10 +127,10 @@ void ssi_sram_mgr_const2sram_desc(
 	unsigned int idx = *seq_len;
 
 	for (i = 0; i < nelement; i++, idx++) {
-		HW_DESC_INIT(&seq[idx]);
-		HW_DESC_SET_DIN_CONST(&seq[idx], src[i], sizeof(u32));
-		HW_DESC_SET_DOUT_SRAM(&seq[idx], dst + (i * sizeof(u32)), sizeof(u32));
-		HW_DESC_SET_FLOW_MODE(&seq[idx], BYPASS);
+		hw_desc_init(&seq[idx]);
+		set_din_const(&seq[idx], src[i], sizeof(u32));
+		set_dout_sram(&seq[idx], dst + (i * sizeof(u32)), sizeof(u32));
+		set_flow_mode(&seq[idx], BYPASS);
 	}
 
 	*seq_len = idx;
-- 
2.1.4
