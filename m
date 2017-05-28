From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/12] staging: ccree: cleanup lli access macro
Date: Sun, 28 May 2017 17:40:29 +0300
Message-ID: <1495982440-10047-5-git-send-email-gilad@benyossef.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The Linked List Item descriptors were being accessed via
a baroque set of defines and macro. Re-factor for structs
and inline function for readability and sanity.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_lli_defs.h    | 65 +++++++++++++++++++---------------
 drivers/staging/ccree/ssi_buffer_mgr.c | 45 +++++------------------
 2 files changed, 44 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 857b94f..c6b2917 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -28,36 +28,43 @@
 
 #define CC_MAX_MLLI_ENTRY_SIZE 0x10000
 
-#define LLI_SET_ADDR(__lli_p, __addr) do {				\
-		u32 *lli_p = (u32 *)__lli_p;				\
-		typeof(__addr) addr = __addr;				\
-									\
-		BITFIELD_SET(lli_p[LLI_WORD0_OFFSET],			\
-			LLI_LADDR_BIT_OFFSET,				\
-			LLI_LADDR_BIT_SIZE, (addr & U32_MAX));		\
-									\
-		BITFIELD_SET(lli_p[LLI_WORD1_OFFSET],			\
-			LLI_HADDR_BIT_OFFSET,				\
-			LLI_HADDR_BIT_SIZE, MSB64(addr));		\
-	} while (0)
-
-#define LLI_SET_SIZE(lli_p, size)					\
-		BITFIELD_SET(((u32 *)(lli_p))[LLI_WORD1_OFFSET],	\
-		LLI_SIZE_BIT_OFFSET, LLI_SIZE_BIT_SIZE, size)
+#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
+#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
+#define MLLI_TABLE_MIN_ALIGNMENT 4 /* 32 bit alignment */
+#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
+#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES (2 * LLI_MAX_NUM_OF_DATA_ENTRIES + \
+				       LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)
+
+struct cc_lli_entry {
+#ifndef __LITTLE_ENDIAN__
+	u32 addr_lsb;
+	u16 size;
+	u16 addr_msb;
+#else /* __BIG_ENDIAN__ */
+	u16 addr_msb;
+	u16 size;
+	u32 addr_lsb;
+#endif
+} __packed;
 
 /* Size of entry */
-#define LLI_ENTRY_WORD_SIZE 2
-#define LLI_ENTRY_BYTE_SIZE (LLI_ENTRY_WORD_SIZE * sizeof(u32))
-
-/* Word0[31:0] = ADDR[31:0] */
-#define LLI_WORD0_OFFSET 0
-#define LLI_LADDR_BIT_OFFSET 0
-#define LLI_LADDR_BIT_SIZE 32
-/* Word1[31:16] = ADDR[47:32]; Word1[15:0] = SIZE */
-#define LLI_WORD1_OFFSET 1
-#define LLI_SIZE_BIT_OFFSET 0
-#define LLI_SIZE_BIT_SIZE 16
-#define LLI_HADDR_BIT_OFFSET 16
-#define LLI_HADDR_BIT_SIZE 16
+#define LLI_ENTRY_BYTE_SIZE sizeof(struct cc_lli_entry)
+
+static inline void cc_lli_set_addr(u32 *lli_p, dma_addr_t addr)
+{
+	struct cc_lli_entry *entry = (struct cc_lli_entry *)lli_p;
+
+	entry->addr_lsb = (addr & U32_MAX);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	entry->addr_msb = (addr >> 16);
+#endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
+}
+
+static inline void cc_lli_set_size(u32 *lli_p, u32 size)
+{
+	struct cc_lli_entry *entry = (struct cc_lli_entry *)lli_p;
+
+	entry->size = size;
+}
 
 #endif /*_CC_LLI_DEFS_H_*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 0affe1f..5de1656 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -33,42 +33,15 @@
 #include "ssi_hash.h"
 #include "ssi_aead.h"
 
-#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
-#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
-#define MLLI_TABLE_MIN_ALIGNMENT 4 /*Force the MLLI table to be align to uint32 */
-#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
-#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES (2*LLI_MAX_NUM_OF_DATA_ENTRIES + \
-					LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES )
-
 #ifdef CC_DEBUG
-#define DUMP_SGL(sg) \
-	while (sg) { \
-		SSI_LOG_DEBUG("page=%p offset=%u length=%u (dma_len=%u) " \
-			     "dma_addr=%08x\n", sg_page(sg), (sg)->offset, \
-			(sg)->length, sg_dma_len(sg), (sg)->dma_address); \
-		(sg) = sg_next(sg); \
-	}
-#define DUMP_MLLI_TABLE(mlli_p, nents) \
-	do { \
-		SSI_LOG_DEBUG("mlli=%pK nents=%u\n", (mlli_p), (nents)); \
-		while((nents)--) { \
-			SSI_LOG_DEBUG("addr=0x%08X size=0x%08X\n", \
-			     (mlli_p)[LLI_WORD0_OFFSET], \
-			     (mlli_p)[LLI_WORD1_OFFSET]); \
-			(mlli_p) += LLI_ENTRY_WORD_SIZE; \
-		} \
-	} while (0)
 #define GET_DMA_BUFFER_TYPE(buff_type) ( \
 	((buff_type) == SSI_DMA_BUF_NULL) ? "BUF_NULL" : \
 	((buff_type) == SSI_DMA_BUF_DLLI) ? "BUF_DLLI" : \
 	((buff_type) == SSI_DMA_BUF_MLLI) ? "BUF_MLLI" : "BUF_INVALID")
 #else
-#define DX_BUFFER_MGR_DUMP_SGL(sg)
-#define DX_BUFFER_MGR_DUMP_MLLI_TABLE(mlli_p, nents)
 #define GET_DMA_BUFFER_TYPE(buff_type)
 #endif
 
-
 enum dma_buffer_type {
 	DMA_NULL_TYPE = -1,
 	DMA_SGL_TYPE = 1,
@@ -186,22 +159,20 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 
 	/*handle buffer longer than 64 kbytes */
 	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE ) {
-		LLI_SET_ADDR(mlli_entry_p,buff_dma);
-		LLI_SET_SIZE(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
-		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
-			   mlli_entry_p[LLI_WORD0_OFFSET],
-			   mlli_entry_p[LLI_WORD1_OFFSET]);
+		cc_lli_set_addr(mlli_entry_p, buff_dma);
+		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
+		SSI_LOG_DEBUG("entry[%d]: word0=0x%08X word1=%08X\n",
+			      *curr_nents, mlli_entry_p[0], mlli_entry_p[1]);
 		buff_dma += CC_MAX_MLLI_ENTRY_SIZE;
 		buff_size -= CC_MAX_MLLI_ENTRY_SIZE;
 		mlli_entry_p = mlli_entry_p + 2;
 		(*curr_nents)++;
 	}
 	/*Last entry */
-	LLI_SET_ADDR(mlli_entry_p,buff_dma);
-	LLI_SET_SIZE(mlli_entry_p, buff_size);
-	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
-		   mlli_entry_p[LLI_WORD0_OFFSET],
-		   mlli_entry_p[LLI_WORD1_OFFSET]);
+	cc_lli_set_addr(mlli_entry_p, buff_dma);
+	cc_lli_set_size(mlli_entry_p, buff_size);
+	SSI_LOG_DEBUG("entry[%d]: word0=0x%08X word1=%08X\n", *curr_nents,
+		      mlli_entry_p[0], mlli_entry_p[1]);
 	mlli_entry_p = mlli_entry_p + 2;
 	*mlli_entry_pp = mlli_entry_p;
 	(*curr_nents)++;
-- 
2.1.4
