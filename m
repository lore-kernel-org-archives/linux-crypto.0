From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 2/5] crypto: chelsio - check for sg null
Date: Thu, 11 Jan 2018 16:45:49 +0530
Message-ID: <2bc173de2778088da18456c78b52bbe76dff67eb.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:37823 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933649AbeAKLQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:05 -0500
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add warning message if sg is NULL after skipping bytes.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f6b1161..280377f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -574,7 +574,8 @@ static void  ulptx_walk_add_sg(struct ulptx_walk *walk,
 			skip = 0;
 		}
 	}
-	if (walk->nents == 0) {
+	WARN(!sg, "SG should not be null here\n");
+	if (sg && (walk->nents == 0)) {
 		small = min_t(unsigned int, sg_dma_len(sg) - skip_len, len);
 		sgmin = min_t(unsigned int, small, CHCR_SRC_SG_SIZE);
 		walk->sgl->len0 = cpu_to_be32(sgmin);
-- 
2.1.4
