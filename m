Return-Path: <SRS0=tWXW=QZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E28C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 08:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDDF72084D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 08:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbfBRIqN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 03:46:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727423AbfBRIqN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 03:46:13 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D4D8ECE0E8781D9C789D;
        Mon, 18 Feb 2019 16:46:09 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 16:45:59 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: marvell - Remove set but not used variable 'ivsize'
Date:   Mon, 18 Feb 2019 08:59:47 +0000
Message-ID: <20190218085947.3800-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/marvell/cipher.c: In function 'mv_cesa_skcipher_dma_req_init':
drivers/crypto/marvell/cipher.c:325:15: warning:
 variable 'ivsize' set but not used [-Wunused-but-set-variable]

It's not used any more after 0c99620f0ac1 ("crypto: marvell - Use an unique
pool to copy results of requests")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/marvell/cipher.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 066830dcc53e..fb279b3a1ca1 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -322,7 +322,6 @@ static int mv_cesa_skcipher_dma_req_init(struct skcipher_request *req,
 	struct mv_cesa_skcipher_dma_iter iter;
 	bool skip_ctx = false;
 	int ret;
-	unsigned int ivsize;
 
 	basereq->chain.first = NULL;
 	basereq->chain.last = NULL;
@@ -381,7 +380,6 @@ static int mv_cesa_skcipher_dma_req_init(struct skcipher_request *req,
 	} while (mv_cesa_skcipher_req_iter_next_op(&iter));
 
 	/* Add output data for IV */
-	ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(req));
 	ret = mv_cesa_dma_add_result_op(&basereq->chain, CESA_SA_CFG_SRAM_OFFSET,
 				    CESA_SA_DATA_SRAM_OFFSET,
 				    CESA_TDMA_SRC_IN_SRAM, flags);



