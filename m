From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/26] staging: ccree: remove unused leftover field
Date: Mon,  1 Jan 2018 12:06:35 +0000
Message-ID: <1514808421-21993-9-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
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

Remove the unused monitor_desc field.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index bf66286..5812ffd 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -32,7 +32,6 @@ struct cc_req_mgr_handle {
 	struct cc_hw_desc compl_desc;
 	u8 *dummy_comp_buff;
 	dma_addr_t dummy_comp_buff_dma;
-	struct cc_hw_desc monitor_desc;
 
 #ifdef COMP_IN_WQ
 	struct workqueue_struct *workq;
-- 
2.7.4
