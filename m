From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 23/24] staging: ccree: simplify freeing SRAM memory address
Date: Tue, 12 Dec 2017 14:53:09 +0000
Message-ID: <1513090395-7938-24-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

The code freeing the SRAM memory address was zeroing the address
on release although there is nothing secret about it. Simplify
the code by simply calling kfree directly.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_sram_mgr.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index b664e9b..f72d64a 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -32,13 +32,8 @@ struct cc_sram_ctx {
  */
 void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
 {
-	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
-
 	/* Free "this" context */
-	if (smgr_ctx) {
-		memset(smgr_ctx, 0, sizeof(struct cc_sram_ctx));
-		kfree(smgr_ctx);
-	}
+	kfree(drvdata->sram_mgr_handle);
 }
 
 /**
-- 
2.7.4
