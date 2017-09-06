From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v3] Staging: ccree: ssi_cipher.c: Remove unused variable.
Date: Thu,  7 Sep 2017 02:43:46 +0530
Message-ID: <1504732426-9765-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, outreachy-kernel@googlegroups.com,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Srishti Sharma <srishtishar@gmail.com>, linux-crypto@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Remove local variable inflight_counter ,as it is never used.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v3:
 - There was no longer a need to make the comment more comprehensible as
   I have deleted the variable associated with it because it is unused .
 drivers/staging/ccree/ssi_cipher.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index fec2faa..609ebe4 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -702,10 +702,7 @@ static int ssi_blkcipher_complete(struct device *dev,

 	ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);

-	/*
-	 * Save inflight_counter in a local variable.
-	 */
-	inflight_counter =  ctx_p->drvdata->inflight_counter;
+
 	/*Decrease the inflight counter*/
 	if (ctx_p->flow_mode == BYPASS && ctx_p->drvdata->inflight_counter > 0)
 		ctx_p->drvdata->inflight_counter--;
--
2.7.4
