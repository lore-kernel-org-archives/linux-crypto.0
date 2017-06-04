From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 08/18] staging: ccree: move request_mgr to generic bitfield ops
Date: Sun,  4 Jun 2017 11:02:29 +0300
Message-ID: <1496563362-7954-9-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

request_mgr was using custom bit field macros. move over to
standard kernel bitfield ops.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_regs.h         |  5 +++++
 drivers/staging/ccree/ssi_request_mgr.c | 27 +++++++++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 1513412..6abb6ff 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -26,6 +26,11 @@
 
 #include "cc_bitops.h"
 
+#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
+#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
+		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
+		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+
 /* Register Offset macro */
 #define CC_REG_OFFSET(unit_name, reg_name)               \
 	(DX_BASE_ ## unit_name + DX_ ## reg_name ## _REG_OFFSET)
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2382f32..7c2d88a 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -35,8 +35,6 @@
 
 #define SSI_MAX_POLL_ITER	10
 
-#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
-
 struct ssi_request_mgr_handle {
 	/* Request manager resources */
 	unsigned int hw_queue_size; /* HW capability */
@@ -502,6 +500,15 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	}
 }
 
+static inline u32 cc_axi_comp_count(void __iomem *cc_base)
+{
+	/* The CC_HAL_READ_REGISTER macro implictly requires and uses
+	 * a base MMIO register address variable named cc_base.
+	 */
+	return FIELD_GET(AXIM_MON_COMP_VALUE,
+			 CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+}
+
 /* Deferred service handler, run as interrupt-fired tasklet */
 static void comp_handler(unsigned long devarg)
 {
@@ -521,25 +528,25 @@ static void comp_handler(unsigned long devarg)
 		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
 
 		/* Avoid race with above clear: Test completion counter once more */
-		request_mgr_handle->axi_completed += CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE,
-			CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+		request_mgr_handle->axi_completed +=
+				cc_axi_comp_count(cc_base);
 
 		while (request_mgr_handle->axi_completed) {
 			do {
 				proc_completions(drvdata);
-				/* At this point (after proc_completions()), request_mgr_handle->axi_completed is always 0.
-				 * The following assignment was changed to = (previously was +=) to conform KW restrictions.
+				/* At this point (after proc_completions()),
+				 * request_mgr_handle->axi_completed is 0.
 				 */
-				request_mgr_handle->axi_completed = CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE,
-					CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+				request_mgr_handle->axi_completed =
+						cc_axi_comp_count(cc_base);
 			} while (request_mgr_handle->axi_completed > 0);
 
 			/* To avoid the interrupt from firing as we unmask it, we clear it now */
 			CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
 
 			/* Avoid race with above clear: Test completion counter once more */
-			request_mgr_handle->axi_completed += CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE,
-				CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+			request_mgr_handle->axi_completed +=
+					cc_axi_comp_count(cc_base);
 		}
 
 	}
-- 
2.1.4
