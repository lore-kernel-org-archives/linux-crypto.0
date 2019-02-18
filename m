Return-Path: <SRS0=tWXW=QZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62091C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 14:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F75221736
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 14:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388649AbfBROf0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:35:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387410AbfBROfZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 09:35:25 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 61DB63989A8A724538A3;
        Mon, 18 Feb 2019 22:35:22 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 22:35:18 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <mcoquelin.stm32@gmail.com>, <clabbe.montjoie@gmail.com>,
        <gilad@benyossef.com>, <ebiggers@google.com>,
        <keescook@chromium.org>, <alexandre.torgue@st.com>
Subject: [PATCH] crypto: stm32 drop pointless static qualifier in stm32_hash_remove()
Date:   Mon, 18 Feb 2019 22:49:00 +0800
Message-ID: <20190218144900.142544-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need to have the struct stm32_hash_dev *hdev static
since new value always be assigned before use it.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/crypto/stm32/stm32-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 590d7352837e..4a6cc8a3045d 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1564,7 +1564,7 @@ static int stm32_hash_probe(struct platform_device *pdev)
 
 static int stm32_hash_remove(struct platform_device *pdev)
 {
-	static struct stm32_hash_dev *hdev;
+	struct stm32_hash_dev *hdev;
 	int ret;
 
 	hdev = platform_get_drvdata(pdev);
-- 
2.20.1

