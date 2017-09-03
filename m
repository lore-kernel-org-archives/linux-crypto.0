From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 6/8] staging: ccree: move over to BIT macro for bit defines
Date: Sun,  3 Sep 2017 17:57:41 +0300
Message-ID: <1504450664-28252-7-git-send-email-gilad@benyossef.com>
References: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
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
index 8f1d7af..6d16220 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -185,7 +185,8 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
-	val = (~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK | SSI_GPR0_IRQ_MASK));
+	val = (unsigned int)(~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK |
+			       SSI_GPR0_IRQ_MASK));
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
 
 #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 9b6476d..06a3c48 100644
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
