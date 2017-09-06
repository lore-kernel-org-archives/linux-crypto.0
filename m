From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v4] Staging: ccree: ssi_cipher.c: Remove unused variable.
Date: Thu,  7 Sep 2017 03:35:53 +0530
Message-ID: <1504735553-13753-1-git-send-email-srishtishar@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove local variable inflight_counter, as it is never used.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Change in v4:
 -There is no longer a need to make the comment more comprehensible, as I
  have deleted the variable associated with it. The v3 of this patch was
  not based on the original patch, hence v4.
 drivers/staging/ccree/ssi_cipher.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 8d31a93..1ff3c8a 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -697,13 +697,10 @@ static int ssi_blkcipher_complete(struct device *dev,
 				  void __iomem *cc_base)
 {
 	int completion_error = 0;
-	u32 inflight_counter;
 	struct ablkcipher_request *req = (struct ablkcipher_request *)areq;

 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);

-	/*Set the inflight couter value to local variable*/
-	inflight_counter =  ctx_p->drvdata->inflight_counter;
 	/*Decrease the inflight counter*/
 	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
 		ctx_p->drvdata->inflight_counter--;
--
2.7.4
