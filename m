From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] staging: ccree: fix memory leaks in cc_ivgen_init
Date: Fri, 12 Jan 2018 16:10:18 +0000
Message-ID: <20180112161018.26595-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The current error exit path in function cc_ivgen_init via label
'out' free's resources from the drvdata->ivgen_handle context.
However, drvdata->ivgen_handle has not been assigned to the
context ivgen_ctx at this point, so the resources are not freed.
Fix this by setting drvdata->ivgen_handle to ivgen_ctx as early
as possible so that the clean up error exit return path can free
the resources.

Detected by CoveritScan, CID#1463795 ("Resource leak")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/ccree/cc_ivgen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/cc_ivgen.c b/drivers/staging/ccree/cc_ivgen.c
index 25a3131a93ce..c47f419b277b 100644
--- a/drivers/staging/ccree/cc_ivgen.c
+++ b/drivers/staging/ccree/cc_ivgen.c
@@ -178,6 +178,8 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 	if (!ivgen_ctx)
 		return -ENOMEM;
 
+	drvdata->ivgen_handle = ivgen_ctx;
+
 	/* Allocate pool's header for initial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, CC_IVPOOL_META_SIZE,
 						  &ivgen_ctx->pool_meta_dma,
@@ -196,8 +198,6 @@ int cc_ivgen_init(struct cc_drvdata *drvdata)
 		goto out;
 	}
 
-	drvdata->ivgen_handle = ivgen_ctx;
-
 	return cc_init_iv_sram(drvdata);
 
 out:
-- 
2.15.1
