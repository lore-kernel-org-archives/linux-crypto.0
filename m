Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEC6C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 06:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E6E21726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 06:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfAWGzp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:55:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbfAWGzp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 01:55:45 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5058D2948338A18FFAB3;
        Wed, 23 Jan 2019 14:55:42 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Wed, 23 Jan 2019
 14:55:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <harsh@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: chelsio - Fix passing zero to 'PTR_ERR' warning in chcr_aead_op
Date:   Wed, 23 Jan 2019 14:55:17 +0800
Message-ID: <20190123065517.16988-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a static code checker warning:
drivers/crypto/chelsio/chcr_algo.c:3681
 chcr_aead_op() warn: passing zero to 'PTR_ERR'

Fixes: 2debd3325e55 ("crypto: chcr - Add AEAD algos.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index adc1b30..18b8a71 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3676,9 +3676,9 @@ static int chcr_aead_op(struct aead_request *req,
 	/* Form a WR from req */
 	skb = create_wr_fn(req, u_ctx->lldi.rxq_ids[a_ctx(tfm)->rx_qidx], size);
 
-	if (IS_ERR(skb) || !skb) {
+	if (IS_ERR_OR_NULL(skb)) {
 		chcr_dec_wrcount(cdev);
-		return PTR_ERR(skb);
+		return PTR_ERR_OR_ZERO(skb);
 	}
 
 	skb->dev = u_ctx->lldi.ports[0];
-- 
2.7.0


