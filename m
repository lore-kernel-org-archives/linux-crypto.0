From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 3/3] staging: ccree: remove dead code
Date: Thu,  2 Nov 2017 08:10:23 +0000
Message-ID: <1509610224-14708-4-git-send-email-gilad@benyossef.com>
References: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
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

The inflight_counter field is updated in a single location and
never used. Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 4 ----
 drivers/staging/ccree/ssi_driver.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 0b69103..ee85cbf 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -697,10 +697,6 @@ static int ssi_blkcipher_complete(struct device *dev,
 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
 	kfree(req_ctx->iv);
 
-	/*Decrease the inflight counter*/
-	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
-		ctx_p->drvdata->inflight_counter--;
-
 	if (areq) {
 		/*
 		 * The crypto API expects us to set the req->info to the last
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 488f665..e01c880 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -134,7 +134,6 @@ struct ssi_drvdata {
 	void *fips_handle;
 	void *ivgen_handle;
 	void *sram_mgr_handle;
-	u32 inflight_counter;
 	struct clk *clk;
 	bool coherent;
 };
-- 
2.7.4
