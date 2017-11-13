From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 17/24] staging: ccree: refactor code with local vars
Date: Mon, 13 Nov 2017 14:45:45 +0000
Message-ID: <1510584358-29473-18-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

Refactor the queue handling loop using local variables for better
code readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 001bbe9..a2a82ef 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -476,6 +476,8 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
+	unsigned int *tail = &request_mgr_handle->req_queue_tail;
+	unsigned int *head = &request_mgr_handle->req_queue_head;
 #if defined(CONFIG_PM)
 	int rc = 0;
 #endif
@@ -484,18 +486,17 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 		request_mgr_handle->axi_completed--;
 
 		/* Dequeue request */
-		if (unlikely(request_mgr_handle->req_queue_head ==
-			     request_mgr_handle->req_queue_tail)) {
+		if (unlikely(*head == *tail)) {
 			/* We are supposed to handle a completion but our
 			 * queue is empty. This is not normal. Return and
 			 * hope for the best.
 			 */
 			dev_err(dev, "Request queue is empty head == tail %u\n",
-				request_mgr_handle->req_queue_head);
+				*head);
 			break;
 		}
 
-		ssi_req = &request_mgr_handle->req_queue[request_mgr_handle->req_queue_tail];
+		ssi_req = &request_mgr_handle->req_queue[*tail];
 
 #ifdef FLUSH_CACHE_ALL
 		flush_cache_all();
@@ -516,11 +517,8 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 
 		if (likely(ssi_req->user_cb))
 			ssi_req->user_cb(dev, ssi_req->user_arg);
-		request_mgr_handle->req_queue_tail =
-			(request_mgr_handle->req_queue_tail + 1) &
-			(MAX_REQUEST_QUEUE_SIZE - 1);
-		dev_dbg(dev, "Dequeue request tail=%u\n",
-			request_mgr_handle->req_queue_tail);
+		*tail = (*tail + 1) & (MAX_REQUEST_QUEUE_SIZE - 1);
+		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
 			request_mgr_handle->axi_completed);
 #if defined(CONFIG_PM)
-- 
2.7.4
