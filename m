From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/5] crypto: ccree: correct host regs offset
Date: Thu, 24 May 2018 15:19:06 +0100
Message-ID: <1527171551-21979-2-git-send-email-gilad@benyossef.com>
References: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org
To: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527171551-21979-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The product signature and HW revision register have different offset on the
older HW revisions.
This fixes the problem of the driver failing sanity check on silicon
despite working on the FPGA emulation systems.

Fixes: 27b3b22dd98c ("crypto: ccree - add support for older HW revs")
Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_debugfs.c   | 7 +++++--
 drivers/crypto/ccree/cc_driver.c    | 8 ++++++--
 drivers/crypto/ccree/cc_driver.h    | 2 ++
 drivers/crypto/ccree/cc_host_regs.h | 6 ++++--
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 08f8db4..5ca184e 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -26,7 +26,8 @@ struct cc_debugfs_ctx {
 static struct dentry *cc_debugfs_dir;
 
 static struct debugfs_reg32 debug_regs[] = {
-	CC_DEBUG_REG(HOST_SIGNATURE),
+	{ .name = "SIGNATURE" }, /* Must be 0th */
+	{ .name = "VERSION" }, /* Must be 1st */
 	CC_DEBUG_REG(HOST_IRR),
 	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
 	CC_DEBUG_REG(AXIM_MON_ERR),
@@ -34,7 +35,6 @@ static struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(HOST_IMR),
 	CC_DEBUG_REG(AXIM_CFG),
 	CC_DEBUG_REG(AXIM_CACHE_PARAMS),
-	CC_DEBUG_REG(HOST_VERSION),
 	CC_DEBUG_REG(GPR_HOST),
 	CC_DEBUG_REG(AXIM_MON_COMP),
 };
@@ -58,6 +58,9 @@ int cc_debugfs_init(struct cc_drvdata *drvdata)
 	struct debugfs_regset32 *regset;
 	struct dentry *file;
 
+	debug_regs[0].offset = drvdata->sig_offset;
+	debug_regs[1].offset = drvdata->ver_offset;
+
 	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 89ce013..6f93ce7 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -207,9 +207,13 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (hw_rev->rev >= CC_HW_REV_712) {
 		new_drvdata->hash_len_sz = HASH_LEN_SIZE_712;
 		new_drvdata->axim_mon_offset = CC_REG(AXIM_MON_COMP);
+		new_drvdata->sig_offset = CC_REG(HOST_SIGNATURE_712);
+		new_drvdata->ver_offset = CC_REG(HOST_VERSION_712);
 	} else {
 		new_drvdata->hash_len_sz = HASH_LEN_SIZE_630;
 		new_drvdata->axim_mon_offset = CC_REG(AXIM_MON_COMP8);
+		new_drvdata->sig_offset = CC_REG(HOST_SIGNATURE_630);
+		new_drvdata->ver_offset = CC_REG(HOST_VERSION_630);
 	}
 
 	platform_set_drvdata(plat_dev, new_drvdata);
@@ -276,7 +280,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	/* Verify correct mapping */
-	signature_val = cc_ioread(new_drvdata, CC_REG(HOST_SIGNATURE));
+	signature_val = cc_ioread(new_drvdata, new_drvdata->sig_offset);
 	if (signature_val != hw_rev->sig) {
 		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
 			signature_val, hw_rev->sig);
@@ -287,7 +291,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	/* Display HW versions */
 	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
-		 hw_rev->name, cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
+		 hw_rev->name, cc_ioread(new_drvdata, new_drvdata->ver_offset),
 		 DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 2048fde..95f82b2 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -129,6 +129,8 @@ struct cc_drvdata {
 	enum cc_hw_rev hw_rev;
 	u32 hash_len_sz;
 	u32 axim_mon_offset;
+	u32 sig_offset;
+	u32 ver_offset;
 };
 
 struct cc_crypto_alg {
diff --git a/drivers/crypto/ccree/cc_host_regs.h b/drivers/crypto/ccree/cc_host_regs.h
index f510018..616b2e1 100644
--- a/drivers/crypto/ccree/cc_host_regs.h
+++ b/drivers/crypto/ccree/cc_host_regs.h
@@ -45,7 +45,8 @@
 #define CC_HOST_ICR_DSCRPTR_WATERMARK_QUEUE0_CLEAR_BIT_SIZE	0x1UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SHIFT	0x17UL
 #define CC_HOST_ICR_AXIM_COMP_INT_CLEAR_BIT_SIZE	0x1UL
-#define CC_HOST_SIGNATURE_REG_OFFSET	0xA24UL
+#define CC_HOST_SIGNATURE_712_REG_OFFSET	0xA24UL
+#define CC_HOST_SIGNATURE_630_REG_OFFSET	0xAC8UL
 #define CC_HOST_SIGNATURE_VALUE_BIT_SHIFT	0x0UL
 #define CC_HOST_SIGNATURE_VALUE_BIT_SIZE	0x20UL
 #define CC_HOST_BOOT_REG_OFFSET	0xA28UL
@@ -105,7 +106,8 @@
 #define CC_HOST_BOOT_ONLY_ENCRYPT_LOCAL_BIT_SIZE	0x1UL
 #define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SHIFT	0x1EUL
 #define CC_HOST_BOOT_AES_EXISTS_LOCAL_BIT_SIZE	0x1UL
-#define CC_HOST_VERSION_REG_OFFSET	0xA40UL
+#define CC_HOST_VERSION_712_REG_OFFSET	0xA40UL
+#define CC_HOST_VERSION_630_REG_OFFSET	0xAD8UL
 #define CC_HOST_VERSION_VALUE_BIT_SHIFT	0x0UL
 #define CC_HOST_VERSION_VALUE_BIT_SIZE	0x20UL
 #define CC_HOST_KFDE0_VALID_REG_OFFSET	0xA60UL
-- 
2.7.4
