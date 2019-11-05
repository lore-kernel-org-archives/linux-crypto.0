Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C2FC1747C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 14:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705FD21A4A
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 14:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389798AbfKEOep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:34:45 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389763AbfKEOek (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 09:34:40 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5685F8DD25CC4EF26B11;
        Tue,  5 Nov 2019 22:34:38 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 5 Nov 2019 22:34:28 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <tanshukun1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] crypto: hisilicon: move label err to #ifdef CONFIG_NUMA
Date:   Tue, 5 Nov 2019 22:33:40 +0800
Message-ID: <20191105143340.32950-1-maowenan@huawei.com>
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

If CONFIG_NUMA is not set, there is error in function
find_zip_device:
drivers/crypto/hisilicon/zip/zip_main.c:154:13: error:
head undeclared (first use in this function)
  free_list(&head);

This is because CONFIG_NUMA is not defined, it should move
label err to #ifdef CONFIG_NUMA.

Fixes: 700f7d0d29c7 ("crypto: hisilicon - fix to return sub-optimal device when best device has no qps")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 255b63c..0504fb2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -150,10 +150,12 @@ struct hisi_zip *find_zip_device(int node)
 
 	return ret;
 
+#ifdef CONFIG_NUMA
 err:
 	free_list(&head);
 	mutex_unlock(&hisi_zip_list_lock);
 	return NULL;
+#endif
 }
 
 struct hisi_zip_hw_error {
-- 
2.7.4

