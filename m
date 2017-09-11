From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH v2] Staging: ccree: Remove unused variable monitor_lock
Date: Mon, 11 Sep 2017 21:58:37 +0530
Message-ID: <1505147317-13411-1-git-send-email-srishtishar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 outreachy-kernel@googlegroups.com, Srishti Sharma <srishtishar@gmail.com>,
 linux-crypto@vger.kernel.org
To: gilad@benyossef.com
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

Remove the variable monitor_lock as it is not used anywhere.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
Changes in v2:
 -The variable that was not to be declared as volatile can be
  eliminated as it is not being used anywhere.

 drivers/staging/ccree/ssi_request_mgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e5c2f92..b94a91f 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -49,7 +49,6 @@ struct ssi_request_mgr_handle {
 	dma_addr_t dummy_comp_buff_dma;
 	struct cc_hw_desc monitor_desc;

-	volatile unsigned long monitor_lock;
 #ifdef COMP_IN_WQ
 	struct workqueue_struct *workq;
 	struct delayed_work compwork;
--
2.7.4
