From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] staging: ccree: fix 64 bit scatter/gather DMA ops
Date: Mon, 30 Oct 2017 13:38:03 +0000
Message-ID: <1509370683-10725-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix a wrong offset used in splitting a 64 DMA address to MSB/LSB
parts needed for scatter/gather HW descriptors causing operations
relying on them to fail on 64 bit platforms.

Fixes: c6f7f2f4591f ("staging: ccree: refactor LLI access macros")
Reported-by: Stuart Yoder <stuart.yoder@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/ccree/cc_lli_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 851d390..a9c417b 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -59,7 +59,7 @@ static inline void cc_lli_set_addr(u32 *lli_p, dma_addr_t addr)
 	lli_p[LLI_WORD0_OFFSET] = (addr & U32_MAX);
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	lli_p[LLI_WORD1_OFFSET] &= ~LLI_HADDR_MASK;
-	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_HADDR_MASK, (addr >> 16));
+	lli_p[LLI_WORD1_OFFSET] |= FIELD_PREP(LLI_HADDR_MASK, (addr >> 32));
 #endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT */
 }
 
-- 
2.7.4
