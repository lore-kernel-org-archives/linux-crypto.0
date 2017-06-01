From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 09/20] staging: ccree: refactor LLI access macros
Date: Thu,  1 Jun 2017 14:02:59 +0300
Message-ID: <1496314993-30229-10-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Linked List Item descriptors were being programmed via
a set of macros which suffer a few problems:
- Use of macros rather than inline leaves out parameter type
  checking and risks multiple macro parameter evaluation side
  effects.
- Implemented via hand rolled versions of bitfield operations.

This patch refactors LLI programming into a set of
of inline functions using generic kernel bitfield access
infrastructure, thus resolving the above issues and opening
the way later on to drop the hand rolled bitfield macros
once additional users are dropped in later patches in the
series.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_lli_defs.h    | 39 ++++++++++++++++++----------------
 drivers/staging/ccree/ssi_buffer_mgr.c |  8 +++----
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 857b94f..876dde0 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -26,24 +26,7 @@
  */
 #define DLLI_SIZE_BIT_SIZE	0x18
 
-#define CC_MAX_MLLI_ENTRY_SIZE 0x10000
-
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
+#define CC_MAX_MLLI_ENTRY_SIZE 0xFFFF
 
 /* Size of entry */
 #define LLI_ENTRY_WORD_SIZE 2
@@ -60,4 +43,24 @@
 #define LLI_HADDR_BIT_OFFSET 16
 #define LLI_HADDR_BIT_SIZE 16
 
+#define LLI_SIZE_MASK GENMASK((LLI_SIZE_BIT_SIZE - 1), LLI_SIZE_BIT_OFFSET)
+#define LLI_HADDR_MASK GENMASK( \
+			       (LLI_HADDR_BIT_OFFSET + LLI_HADDR_BIT_SIZE - 1),\
+				LLI_HADDR_BIT_OFFSET)
+
+static inline void cc_lli_set_addr(u32 *lli_p, dma_addr_t addr)
+{
+	lli_p[LLI_WORD0_OFFSET] = (addr & U32_MAX);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	lli_p[LLI_WORD1_OFFSET] &= ~LLI_HADDR_MASK;
+	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_HADDR_MASK, (addr >> 16));
+#endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
+}
+
+static inline void cc_lli_set_size(u32 *lli_p, u16 size)
+{
+	lli_p[LLI_WORD1_OFFSET] &= ~LLI_SIZE_MASK;
+	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_SIZE_MASK, size);
+}
+
 #endif /*_CC_LLI_DEFS_H_*/
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 0affe1f..28dc724 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -186,8 +186,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 
 	/*handle buffer longer than 64 kbytes */
 	while (buff_size > CC_MAX_MLLI_ENTRY_SIZE ) {
-		LLI_SET_ADDR(mlli_entry_p,buff_dma);
-		LLI_SET_SIZE(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
+		cc_lli_set_addr(mlli_entry_p, buff_dma);
+		cc_lli_set_size(mlli_entry_p, CC_MAX_MLLI_ENTRY_SIZE);
 		SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
 			   mlli_entry_p[LLI_WORD0_OFFSET],
 			   mlli_entry_p[LLI_WORD1_OFFSET]);
@@ -197,8 +197,8 @@ static inline int ssi_buffer_mgr_render_buff_to_mlli(
 		(*curr_nents)++;
 	}
 	/*Last entry */
-	LLI_SET_ADDR(mlli_entry_p,buff_dma);
-	LLI_SET_SIZE(mlli_entry_p, buff_size);
+	cc_lli_set_addr(mlli_entry_p, buff_dma);
+	cc_lli_set_size(mlli_entry_p, buff_size);
 	SSI_LOG_DEBUG("entry[%d]: single_buff=0x%08X size=%08X\n",*curr_nents,
 		   mlli_entry_p[LLI_WORD0_OFFSET],
 		   mlli_entry_p[LLI_WORD1_OFFSET]);
-- 
2.1.4
