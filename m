From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: cavium: fix leak on curr if curr->head fails to be allocated
Date: Fri, 17 Feb 2017 15:57:43 +0000
Message-ID: <20170217155743.31525-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46975 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934127AbdBQP5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 10:57:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The exit path when curr->head cannot be allocated fails to kfree the
earlier allocated curr.  Fix this by kfree'ing it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/cavium/cpt/cptvf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 527bdc3..3247c7f 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -242,6 +242,7 @@ static int alloc_command_queues(struct cpt_vf *cptvf,
 			if (!curr->head) {
 				dev_err(&pdev->dev, "Command Q (%d) chunk (%d) allocation failed\n",
 					i, queue->nchunks);
+				kfree(curr);
 				goto cmd_qfail;
 			}
 
-- 
2.10.2
