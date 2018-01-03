From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 12/27] staging: ccree: failing the suspend is not an error
Date: Wed,  3 Jan 2018 13:35:19 +0000
Message-ID: <1514986544-5888-13-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

PM suspend returning a none zero value is not an error. It simply
indicates a suspend is not advised right now so don't treat it as
an error.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index db3b29f..e99c148 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -598,9 +598,6 @@ static void proc_completions(struct cc_drvdata *drvdata)
 						drvdata->request_mgr_handle;
 	unsigned int *tail = &request_mgr_handle->req_queue_tail;
 	unsigned int *head = &request_mgr_handle->req_queue_head;
-#if defined(CONFIG_PM)
-	int rc = 0;
-#endif
 
 	while (request_mgr_handle->axi_completed) {
 		request_mgr_handle->axi_completed--;
@@ -625,10 +622,7 @@ static void proc_completions(struct cc_drvdata *drvdata)
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
 			request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM)
-		rc = cc_pm_put_suspend(dev);
-		if (rc)
-			dev_err(dev, "Failed to set runtime suspension %d\n",
-				rc);
+		cc_pm_put_suspend(dev);
 #endif
 	}
 }
-- 
2.7.4
