Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A62C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 13:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiI0Nmj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 09:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiI0Nmf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 09:42:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73782E3EC1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 06:42:34 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4McLMY4JR6zpSvx;
        Tue, 27 Sep 2022 21:39:37 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 21:42:32 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <thomas.lendacky@amd.com>, <john.allen@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] crypto: ccp - Remove unused struct ccp_crypto_cpu
Date:   Tue, 27 Sep 2022 13:39:55 +0000
Message-ID: <20220927133955.104353-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After commit bc3854476f36("crypto: ccp - Use a single queue for proper ordering
of tfm requests"), no one use struct ccp_crypto_cpu, so remove it.

Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 5976530c00a8..c8f3345c66e2 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -78,13 +78,6 @@ struct ccp_crypto_cmd {
 	int ret;
 };
 
-struct ccp_crypto_cpu {
-	struct work_struct work;
-	struct completion completion;
-	struct ccp_crypto_cmd *crypto_cmd;
-	int err;
-};
-
 static inline bool ccp_crypto_success(int err)
 {
 	if (err && (err != -EINPROGRESS) && (err != -EBUSY))
-- 
2.17.1

