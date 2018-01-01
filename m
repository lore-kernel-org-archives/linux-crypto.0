From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 23/26] stating: ccree: fix allocation of void sized buf
Date: Mon,  1 Jan 2018 12:06:50 +0000
Message-ID: <1514808421-21993-24-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
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

We were allocating buffers using sizeof(*struct->field) where field was
type void.  Fix it by having a local variable with the real type.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_debugfs.c   | 3 ++-
 drivers/staging/ccree/ssi_ivgen.c    | 9 ++++-----
 drivers/staging/ccree/ssi_sram_mgr.c | 9 ++++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 62bf011..140c04b 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -6,6 +6,7 @@
 #include <linux/stringify.h>
 #include "ssi_driver.h"
 #include "cc_crypto_ctx.h"
+#include "cc_debugfs.h"
 
 struct cc_debugfs_ctx {
 	struct dentry *dir;
@@ -24,7 +25,7 @@ struct cc_debugfs_ctx {
  */
 static struct dentry *cc_debugfs_dir;
 
-struct debugfs_reg32 debug_regs[] = {
+static struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(HOST_SIGNATURE),
 	CC_DEBUG_REG(HOST_IRR),
 	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 8051fa1..44acded 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -175,13 +175,10 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 	int rc;
 
 	/* Allocate "this" context */
-	drvdata->ivgen_handle = kzalloc(sizeof(*drvdata->ivgen_handle),
-					GFP_KERNEL);
-	if (!drvdata->ivgen_handle)
+	ivgen_ctx = kzalloc(sizeof(*ivgen_ctx), GFP_KERNEL);
+	if (!ivgen_ctx)
 		return -ENOMEM;
 
-	ivgen_ctx = drvdata->ivgen_handle;
-
 	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
@@ -200,6 +197,8 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 		goto out;
 	}
 
+	drvdata->ivgen_handle = ivgen_ctx;
+
 	return cc_init_iv_sram(drvdata);
 
 out:
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index 0613aaf..5bf37bf 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -32,13 +32,16 @@ void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
  */
 int cc_sram_mgr_init(struct cc_drvdata *drvdata)
 {
+	struct cc_sram_ctx *ctx;
+
 	/* Allocate "this" context */
-	drvdata->sram_mgr_handle = kzalloc(sizeof(*drvdata->sram_mgr_handle),
-					   GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 
-	if (!drvdata->sram_mgr_handle)
+	if (!ctx)
 		return -ENOMEM;
 
+	drvdata->sram_mgr_handle = ctx;
+
 	return 0;
 }
 
-- 
2.7.4
