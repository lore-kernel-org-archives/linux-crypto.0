Return-Path: <SRS0=NifF=5A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11743C0044D
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 02:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8663205F4
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 02:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCOCiv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Mar 2020 22:38:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727066AbgCOCiv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Mar 2020 22:38:51 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 350EFD0140A75CBEFE3F;
        Sat, 14 Mar 2020 18:52:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 14 Mar 2020 18:52:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: chelsio - remove set but not used variable 'adap'
Date:   Sat, 14 Mar 2020 10:44:41 +0000
Message-ID: <20200314104441.79953-1-yuehaibing@huawei.com>
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

drivers/crypto/chelsio/chcr_algo.c: In function 'chcr_device_init':
drivers/crypto/chelsio/chcr_algo.c:1440:18: warning:
 variable 'adap' set but not used [-Wunused-but-set-variable]
 
commit 567be3a5d227 ("crypto: chelsio - Use multiple txq/rxq per tfm
to process the requests") involved this unused variable.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 8952732c0b7d..c29b80dd30d8 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1437,7 +1437,6 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
 static int chcr_device_init(struct chcr_context *ctx)
 {
 	struct uld_ctx *u_ctx = NULL;
-	struct adapter *adap;
 	int txq_perchan, ntxq;
 	int err = 0, rxq_perchan;
 
@@ -1448,7 +1447,6 @@ static int chcr_device_init(struct chcr_context *ctx)
 			goto out;
 		}
 		ctx->dev = &u_ctx->dev;
-		adap = padap(ctx->dev);
 		ntxq = u_ctx->lldi.ntxq;
 		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
 		txq_perchan = ntxq / u_ctx->lldi.nchan;



