Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6A0C4707F
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A074561419
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhEYIJn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 04:09:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5548 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhEYIJP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 04:09:15 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fq5kl32NqzwTPD;
        Tue, 25 May 2021 15:46:55 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 15:49:41 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500019.china.huawei.com
 (7.185.36.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 25 May
 2021 15:49:40 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-fsdevel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH 1/2] crypto: af_alg - use DIV_ROUND_UP helper macro for calculations
Date:   Tue, 25 May 2021 16:15:19 +0800
Message-ID: <1621930520-515336-2-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1621930520-515336-1-git-send-email-wubo40@huawei.com>
References: <1621930520-515336-1-git-send-email-wubo40@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

Replace open coded divisor calculations with the DIV_ROUND_UP kernel
macro for better readability.

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 18cc82d..8bd288d 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -411,7 +411,7 @@ int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
 	if (n < 0)
 		return n;
 
-	npages = (off + n + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	npages = DIV_ROUND_UP(off + n, PAGE_SIZE);
 	if (WARN_ON(npages == 0))
 		return -EINVAL;
 	/* Add one extra for linking */
-- 
1.8.3.1

