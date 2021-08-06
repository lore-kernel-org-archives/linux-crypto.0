Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD61C4320E
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D41B61040
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Aug 2021 09:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbhHFJpl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:45:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8373 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbhHFJpk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Aug 2021 05:45:40 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gh0qG5ZLQz84bg;
        Fri,  6 Aug 2021 17:41:30 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH v2 3/5] crypto: hisilicon/sec - fix the max length of AAD for the CCM mode
Date:   Fri, 6 Aug 2021 17:44:24 +0800
Message-ID: <1628243066-32648-4-git-send-email-yekai13@huawei.com>
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

Fix the maximum length of AAD for the CCM mode due to the hardware limited.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 890faf8..387fb3c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -63,6 +63,7 @@
 #define SEC_AUTH_CIPHER		0x1
 #define SEC_MAX_MAC_LEN		64
 #define SEC_MAX_AAD_LEN		65535
+#define SEC_MAX_CCM_AAD_LEN	65279
 #define SEC_TOTAL_MAC_SZ	(SEC_MAX_MAC_LEN * QM_Q_DEPTH)
 
 #define SEC_PBUF_SZ			512
@@ -2218,6 +2219,10 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	}
 
 	if (c_mode == SEC_CMODE_CCM) {
+		if (unlikely(req->assoclen > SEC_MAX_CCM_AAD_LEN)) {
+			dev_err_ratelimited(dev, "CCM input aad parameter is too long!\n");
+			return -EINVAL;
+		}
 		ret = aead_iv_demension_check(req);
 		if (ret) {
 			dev_err(dev, "aead input iv param error!\n");
-- 
2.7.4

