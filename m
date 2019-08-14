Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF7AC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112D02083B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNJbF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:31:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726998AbfHNJbE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 05:31:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4AD07D03B26C8358703B;
        Wed, 14 Aug 2019 17:31:01 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 14 Aug 2019 17:30:50 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 5/5] crypto: hisilicon - fix error handle in hisi_zip_create_req_q
Date:   Wed, 14 Aug 2019 17:28:39 +0800
Message-ID: <1565774919-31853-6-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1565774919-31853-1-git-send-email-wangzhou1@hisilicon.com>
References: <1565774919-31853-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Directly return error in the first loop in hisi_zip_create_req_q.

Fixes: 62c455ca853e ("crypto: hisilicon - add HiSilicon ZIP accelerator support")
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 3033513..5a3f84d 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -223,8 +223,10 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 					    sizeof(long), GFP_KERNEL);
 		if (!req_q->req_bitmap) {
 			ret = -ENOMEM;
-			if (i == 1)
-				goto err_free_loop0;
+			if (i == 0)
+				return ret;
+
+			goto err_free_loop0;
 		}
 		rwlock_init(&req_q->req_lock);
 
-- 
2.8.1

