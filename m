Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD95EC43460
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8246E61026
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhDIJHD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:07:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16869 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhDIJHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 05:07:02 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGsf44xy3zlWy2;
        Fri,  9 Apr 2021 17:05:00 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Fri, 9 Apr 2021
 17:06:38 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH v3 1/5] crypto: hisilicon/sgl - add a comment for block size initialization
Date:   Fri, 9 Apr 2021 17:04:00 +0800
Message-ID: <1617959044-11023-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617959044-11023-1-git-send-email-yekai13@huawei.com>
References: <1617959044-11023-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This seems "32" and "31" is obfuscating, It might be better to add a comment,
which explain it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 3bff639..cf1629c 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -66,6 +66,11 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 
 	sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
 		   sizeof(struct hisi_acc_hw_sgl);
+
+	/*
+	 * the pool may allocate a block of memory of size PAGE_SIZE * 2^(MAX_ORDER - 1),
+	 * block size may exceed 2^31 on ia64, so the max of block size is 2^31
+	 */
 	block_size = 1 << (PAGE_SHIFT + MAX_ORDER <= 32 ?
 			   PAGE_SHIFT + MAX_ORDER - 1 : 31);
 	sgl_num_per_block = block_size / sgl_size;
-- 
2.8.1

