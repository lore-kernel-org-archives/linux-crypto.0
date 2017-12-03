From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/10] staging: ccree: remove braces for single statement
 blocks
Date: Sun,  3 Dec 2017 13:58:16 +0000
Message-ID: <1512309503-29766-6-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

Remove braces from single statement if clause.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e890cb6..5f34336 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -228,9 +228,8 @@ static int request_mgr_queues_status_check(
 	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
 			cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots) {
+		if (req_mgr_h->q_free_slots < req_mgr_h->min_free_hw_slots)
 			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
-		}
 
 		if (req_mgr_h->q_free_slots >= total_seq_len) {
 			/* If there is enough place return */
-- 
2.7.4
