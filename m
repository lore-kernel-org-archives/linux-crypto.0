Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877CBC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 03:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D53460F36
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 03:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGaD1i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jul 2021 23:27:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7905 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhGaD1h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jul 2021 23:27:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gc8k744Clz82Nq;
        Sat, 31 Jul 2021 11:23:43 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 31 Jul 2021 11:27:29 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 31 Jul
 2021 11:27:29 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 1/5] crypto: hisilicon/sec - fixup icv checking enabled on Kunpeng 930
Date:   Sat, 31 Jul 2021 11:26:32 +0800
Message-ID: <1627701996-4589-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627701996-4589-1-git-send-email-yekai13@huawei.com>
References: <1627701996-4589-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

