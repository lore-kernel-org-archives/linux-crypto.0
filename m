From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: ssi_cipher.c: Make comment more comprehensible.
Date: Thu,  7 Sep 2017 02:26:30 +0530
Message-ID: <1504731390-9536-1-git-send-email-srishtishar@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Edited comment to make it more comprehensible.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 - Make comment more comprehensible , instead of just correcting typos.
 drivers/staging/ccree/ssi_cipher.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 99232b2..fec2faa 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -702,7 +702,9 @@ static int ssi_blkcipher_complete(struct device *dev,

 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);

-	/*Set the inflight counter value to local variable*/
+	/*
+	 * Save inflight_counter in a local variable.
+	 */
 	inflight_counter =  ctx_p->drvdata->inflight_counter;
 	/*Decrease the inflight counter*/
 	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
--
2.7.4
