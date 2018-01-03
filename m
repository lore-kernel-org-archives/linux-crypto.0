From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 23/27] stating: ccree: fix allocation of void sized buf
Date: Wed,  3 Jan 2018 13:35:30 +0000
Message-ID: <1514986544-5888-24-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We were allocating buffers using sizeof(*struct->field) where field was
type void.  Fix it by having a local variable with the real type.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_ivgen.c    | 9 ++++-----
 drivers/staging/ccree/ssi_sram_mgr.c | 9 ++++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 94a0502..9d8d307 100644
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
index e178385..3a93299 100644
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
