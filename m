From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 1/4] crypto: ccp - Change mode for detailed CCP init messages
Date: Mon, 30 Jan 2017 08:28:23 -0600
Message-ID: <20170130142823.8459.75355.stgit@taos>
References: <20170130142414.8459.71539.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0070.outbound.protection.outlook.com ([104.47.42.70]:57632
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753231AbdA3O2l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 09:28:41 -0500
In-Reply-To: <20170130142414.8459.71539.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCP initialization messages only need to be sent to
syslog in debug mode.


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index e2ce819..5fb6c8c 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -532,7 +532,7 @@ static int ccp_find_lsb_regions(struct ccp_cmd_queue *cmd_q, u64 status)
 		status >>= LSB_REGION_WIDTH;
 	}
 	queues = bitmap_weight(cmd_q->lsbmask, MAX_LSB_CNT);
-	dev_info(cmd_q->ccp->dev, "Queue %d can access %d LSB regions\n",
+	dev_dbg(cmd_q->ccp->dev, "Queue %d can access %d LSB regions\n",
 		 cmd_q->id, queues);
 
 	return queues ? 0 : -EINVAL;
@@ -574,7 +574,7 @@ static int ccp_find_and_assign_lsb_to_q(struct ccp_device *ccp,
 					 */
 					cmd_q->lsb = bitno;
 					bitmap_clear(lsb_pub, bitno, 1);
-					dev_info(ccp->dev,
+					dev_dbg(ccp->dev,
 						 "Queue %d gets LSB %d\n",
 						 i, bitno);
 					break;
@@ -732,7 +732,6 @@ static int ccp5_init(struct ccp_device *ccp)
 		ret = -EIO;
 		goto e_pool;
 	}
-	dev_notice(dev, "%u command queues available\n", ccp->cmd_q_count);
 
 	/* Turn off the queues and disable interrupts until ready */
 	for (i = 0; i < ccp->cmd_q_count; i++) {
