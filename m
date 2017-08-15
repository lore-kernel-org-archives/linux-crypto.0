From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 18/22] staging: ccree: move over to BIT macro for bit defines
Date: Tue, 15 Aug 2017 09:26:46 +0300
Message-ID: <1502778412-16255-19-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use BIT macro for bit definitions where needed.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.h | 10 +++++-----
 drivers/staging/ccree/ssi_driver.c |  3 ++-
 drivers/staging/ccree/ssi_driver.h |  6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/ssi_cipher.h
index 296b375..c9a83df 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/ssi_cipher.h
@@ -27,11 +27,11 @@
 #include "ssi_buffer_mgr.h"
 
 /* Crypto cipher flags */
-#define CC_CRYPTO_CIPHER_KEY_KFDE0    (1 << 0)
-#define CC_CRYPTO_CIPHER_KEY_KFDE1    (1 << 1)
-#define CC_CRYPTO_CIPHER_KEY_KFDE2    (1 << 2)
-#define CC_CRYPTO_CIPHER_KEY_KFDE3    (1 << 3)
-#define CC_CRYPTO_CIPHER_DU_SIZE_512B (1 << 4)
+#define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
+#define CC_CRYPTO_CIPHER_KEY_KFDE1	BIT(1)
+#define CC_CRYPTO_CIPHER_KEY_KFDE2	BIT(2)
+#define CC_CRYPTO_CIPHER_KEY_KFDE3	BIT(3)
+#define CC_CRYPTO_CIPHER_DU_SIZE_512B	BIT(4)
 
 #define CC_CRYPTO_CIPHER_KEY_KFDE_MASK (CC_CRYPTO_CIPHER_KEY_KFDE0 | CC_CRYPTO_CIPHER_KEY_KFDE1 | CC_CRYPTO_CIPHER_KEY_KFDE2 | CC_CRYPTO_CIPHER_KEY_KFDE3)
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 91c0b71..6ec5287 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -202,7 +202,8 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
-	val = (~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK | SSI_GPR0_IRQ_MASK));
+	val = (unsigned int)(~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK |
+			       SSI_GPR0_IRQ_MASK));
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
 
 #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index e37a55a..0b9c7e6 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -68,12 +68,12 @@
 #define SSI_AXI_IRQ_MASK ((1 << DX_AXIM_CFG_BRESPMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_RRESPMASK_BIT_SHIFT) |	\
 			(1 << DX_AXIM_CFG_INFLTMASK_BIT_SHIFT) | (1 << DX_AXIM_CFG_COMPMASK_BIT_SHIFT))
 
-#define SSI_AXI_ERR_IRQ_MASK (1 << DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
+#define SSI_AXI_ERR_IRQ_MASK BIT(DX_HOST_IRR_AXI_ERR_INT_BIT_SHIFT)
 
-#define SSI_COMP_IRQ_MASK (1 << DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
+#define SSI_COMP_IRQ_MASK BIT(DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
 
 /* TEE FIPS status interrupt */
-#define SSI_GPR0_IRQ_MASK (1 << DX_HOST_IRR_GPR0_BIT_SHIFT)
+#define SSI_GPR0_IRQ_MASK BIT(DX_HOST_IRR_GPR0_BIT_SHIFT)
 
 #define SSI_CRA_PRIO 3000
 
-- 
2.1.4
