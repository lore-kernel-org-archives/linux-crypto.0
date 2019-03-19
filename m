Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168A1C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE83720828
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfCSNvY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:51:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfCSNvY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 09:51:24 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 03499B650285510BC16F;
        Tue, 19 Mar 2019 21:51:19 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 21:51:11 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <thomas.lendacky@amd.com>,
        <gary.hook@amd.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: ccp - Make ccp_register_rsa_alg static
Date:   Tue, 19 Mar 2019 21:50:35 +0800
Message-ID: <20190319135035.22056-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/crypto/ccp/ccp-crypto-rsa.c:251:5:
 warning: symbol 'ccp_register_rsa_alg' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccp/ccp-crypto-rsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
index 05850df..0b8aab00 100644
--- a/drivers/crypto/ccp/ccp-crypto-rsa.c
+++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
@@ -248,7 +248,8 @@ static struct ccp_rsa_def rsa_algs[] = {
 	}
 };
 
-int ccp_register_rsa_alg(struct list_head *head, const struct ccp_rsa_def *def)
+static int ccp_register_rsa_alg(struct list_head *head,
+			        const struct ccp_rsa_def *def)
 {
 	struct ccp_crypto_akcipher_alg *ccp_alg;
 	struct akcipher_alg *alg;
-- 
2.7.4


