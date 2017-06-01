From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 11/20] staging: ccree: remove unused debug macros
Date: Thu,  1 Jun 2017 14:03:01 +0300
Message-ID: <1496314993-30229-12-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:54484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751954AbdFALEs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2017 07:04:48 -0400
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DUMP_SGL() and DUMP_MLLI_TABLE() debug macros were
defined but not used anywhere and the difference of their
definitions for debug vs. none debug indicated this has
not being used in a while.

Remove the dead code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 25b2876..4864597 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -34,30 +34,11 @@
 #include "ssi_aead.h"
 
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
 
-- 
2.1.4
