Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AADC10F0E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 02:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773A52084F
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 02:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfDJCgt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:36:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5705 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfDJCgt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 22:36:49 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C94AC13B77615A1594F0;
        Wed, 10 Apr 2019 10:36:46 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Wed, 10 Apr 2019 10:36:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: remove set but not used variable 'fini'
Date:   Wed, 10 Apr 2019 02:47:42 +0000
Message-ID: <20190410024742.2103-1-yuehaibing@huawei.com>
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

drivers/crypto/mxs-dcp.c: In function 'dcp_chan_thread_sha':
drivers/crypto/mxs-dcp.c:707:11: warning:
 variable 'fini' set but not used [-Wunused-but-set-variable]

It's not used since commit d80771c08363 ("crypto: mxs-dcp - Fix wait
logic on chan threads"),so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/mxs-dcp.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 494cfc4272f3..b4429891e368 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -700,11 +700,7 @@ static int dcp_chan_thread_sha(void *data)
 
 	struct crypto_async_request *backlog;
 	struct crypto_async_request *arq;
-
-	struct dcp_sha_req_ctx *rctx;
-
-	struct ahash_request *req;
-	int ret, fini;
+	int ret;
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -725,11 +721,7 @@ static int dcp_chan_thread_sha(void *data)
 			backlog->complete(backlog, -EINPROGRESS);
 
 		if (arq) {
-			req = ahash_request_cast(arq);
-			rctx = ahash_request_ctx(req);
-
 			ret = dcp_sha_req_to_buf(arq);
-			fini = rctx->fini;
 			arq->complete(arq, ret);
 		}
 	}



