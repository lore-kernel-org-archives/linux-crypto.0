Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC6AC4320A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E9061040
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbhHFJpl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:45:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13289 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbhHFJpk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:45:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gh0p61Fllz83Ms;
        Fri,  6 Aug 2021 17:40:30 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 17:45:23 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 17:45:23 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 1/5] crypto: hisilicon/sec - fixup icv checking enabled on Kunpeng 930
Date:   Fri, 6 Aug 2021 17:44:22 +0800
Message-ID: <1628243066-32648-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628243066-32648-1-git-send-email-yekai13@huawei.com>
References: <1628243066-32648-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixup icv(integrity check value) checking enabled wrong on
Kunpeng 930

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 6a45bd23..bf93c98 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1614,7 +1614,7 @@ static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
 		sqe3->auth_mac_key |= cpu_to_le32((u32)SEC_AUTH_TYPE1);
 		sqe3->huk_iv_seq &= SEC_CIPHER_AUTH_V3;
 	} else {
-		sqe3->auth_mac_key |= cpu_to_le32((u32)SEC_AUTH_TYPE1);
+		sqe3->auth_mac_key |= cpu_to_le32((u32)SEC_AUTH_TYPE2);
 		sqe3->huk_iv_seq |= SEC_AUTH_CIPHER_V3;
 	}
 	sqe3->a_len_key = cpu_to_le32(c_req->c_len + aq->assoclen);
-- 
2.7.4

