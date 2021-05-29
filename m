Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E181C4708E
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729B861107
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 09:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhE2JDT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 05:03:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2347 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JDS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 05:03:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fsb5q387wz1BFmV;
        Sat, 29 May 2021 16:57:03 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:01:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 17:01:39 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/hpre - add check before gx modulo p
Date:   Sat, 29 May 2021 16:58:19 +0800
Message-ID: <1622278699-15092-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The result of gx modulo p is zero if gx is equal to p, so return
error immediately if gx is equal to p.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 6ba5d8a..323418b 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1841,8 +1841,12 @@ static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 	 * When src_data equals (2^255 - 19) ~  (2^255 - 1), it is out of p,
 	 * we get its modulus to p, and then use it.
 	 */
-	if (memcmp(ptr, p, ctx->key_sz) >= 0)
+	if (memcmp(ptr, p, ctx->key_sz) == 0) {
+		dev_err(dev, "gx is p!\n");
+		return -EINVAL;
+	} else if (memcmp(ptr, p, ctx->key_sz) > 0) {
 		hpre_curve25519_src_modulo_p(ptr);
+	}
 
 	hpre_req->src = ptr;
 	msg->in = cpu_to_le64(dma);
-- 
2.8.1

