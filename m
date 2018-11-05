Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:14594 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729047AbeKEVxY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 16:53:24 -0500
From: John Garry <john.garry@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <Jonathan.Cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon -  Fix reference after free of memories on error path
Date: Mon, 5 Nov 2018 20:35:15 +0800
Message-ID: <1541421315-25623-3-git-send-email-john.garry@huawei.com>
In-Reply-To: <1541421315-25623-1-git-send-email-john.garry@huawei.com>
References: <1541421315-25623-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

coccicheck currently warns of the following issues in the driver:
drivers/crypto/hisilicon/sec/sec_algs.c:864:51-66: ERROR: reference preceded by free on line 812
drivers/crypto/hisilicon/sec/sec_algs.c:864:40-49: ERROR: reference preceded by free on line 813
drivers/crypto/hisilicon/sec/sec_algs.c:861:8-24: ERROR: reference preceded by free on line 814
drivers/crypto/hisilicon/sec/sec_algs.c:860:41-51: ERROR: reference preceded by free on line 815
drivers/crypto/hisilicon/sec/sec_algs.c:867:7-18: ERROR: reference preceded by free on line 816

It would appear than on certain error paths that we may attempt reference-
after-free some memories.

This patch fixes those issues. The solution doesn't look perfect, but
having same memories free'd possibly from separate functions makes it
tricky.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 32c6c02..cdc4f9a 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -808,13 +808,6 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	 * more refined but this is unlikely to happen so no need.
 	 */
 
-	/* Cleanup - all elements in pointer arrays have been coppied */
-	kfree(splits_in_nents);
-	kfree(splits_in);
-	kfree(splits_out_nents);
-	kfree(splits_out);
-	kfree(split_sizes);
-
 	/* Grab a big lock for a long time to avoid concurrency issues */
 	mutex_lock(&queue->queuelock);
 
@@ -829,13 +822,13 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	     (!queue->havesoftqueue ||
 	      kfifo_avail(&queue->softqueue) > steps)) ||
 	    !list_empty(&ctx->backlog)) {
+		ret = -EBUSY;
 		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
 			mutex_unlock(&queue->queuelock);
-			return -EBUSY;
+			goto out;
 		}
 
-		ret = -EBUSY;
 		mutex_unlock(&queue->queuelock);
 		goto err_free_elements;
 	}
@@ -844,7 +837,15 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
 	if (ret)
 		goto err_free_elements;
 
-	return -EINPROGRESS;
+	ret = -EINPROGRESS;
+out:
+	/* Cleanup - all elements in pointer arrays have been copied */
+	kfree(splits_in_nents);
+	kfree(splits_in);
+	kfree(splits_out_nents);
+	kfree(splits_out);
+	kfree(split_sizes);
+	return ret;
 
 err_free_elements:
 	list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
-- 
1.9.1
