From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: ccp: remove unused variable qim
Date: Thu, 12 Oct 2017 17:55:41 +0100
Message-ID: <20171012165541.32256-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40282 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752877AbdJLQzp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 12:55:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable qim is assigned but never read, it is redundant and can
be removed.

Cleans up clang warning: Value stored to 'qim' is never read

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function as v3")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 65604fc65e8f..44a4d2779b15 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -788,13 +788,12 @@ static int ccp5_init(struct ccp_device *ccp)
 	struct ccp_cmd_queue *cmd_q;
 	struct dma_pool *dma_pool;
 	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
-	unsigned int qmr, qim, i;
+	unsigned int qmr, i;
 	u64 status;
 	u32 status_lo, status_hi;
 	int ret;
 
 	/* Find available queues */
-	qim = 0;
 	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
 	for (i = 0; i < MAX_HW_QUEUES; i++) {
 
-- 
2.14.1
