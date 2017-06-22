From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 7/7] staging: ccree: use signal safe completion wait
Date: Thu, 22 Jun 2017 16:37:01 +0300
Message-ID: <1498138623-6126-8-git-send-email-gilad@benyossef.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We were waiting for a completion notification of HW DMA
operation using an interruptible wait which can result
in data corruption if a signal interrupted us while
DMA was not yet completed.

Fix this by moving to uninterrupted wait.

Fixes: abefd6741d ("staging: ccree: introduce CryptoCell HW driver").

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index cffc8de..87f5ab6 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -382,7 +382,8 @@ int send_request(
 		/* Wait upon sequence completion.
 		 *  Return "0" -Operation done successfully.
 		 */
-		return wait_for_completion_interruptible(&ssi_req->seq_compl);
+		wait_for_completion(&ssi_req->seq_compl);
+		return 0;
 	} else {
 		/* Operation still in process */
 		return -EINPROGRESS;
-- 
2.1.4
