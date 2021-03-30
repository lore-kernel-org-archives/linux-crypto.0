Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5AEC433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 07:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED4061999
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 07:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhC3Hl6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 03:41:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14957 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbhC3Hls (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 03:41:48 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F8hDG5QWBzyNJ5;
        Tue, 30 Mar 2021 15:39:42 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 15:41:36 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 1/5] crypto: hisilicon/sgl - fixup coding style
Date:   Tue, 30 Mar 2021 15:39:02 +0800
Message-ID: <1617089946-48078-2-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617089946-48078-1-git-send-email-yekai13@huawei.com>
References: <1617089946-48078-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

use a macro replace of a magic number.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 3bff639..bd5ef40 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -9,6 +9,7 @@
 #define HISI_ACC_SGL_NR_MAX		256
 #define HISI_ACC_SGL_ALIGN_SIZE		64
 #define HISI_ACC_MEM_BLOCK_NR		5
+#define HISI_ACC_BLOCK_SIZE_MAX_SHIFT	31
 
 struct acc_hw_sge {
 	dma_addr_t buf;
@@ -67,7 +68,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
 		   sizeof(struct hisi_acc_hw_sgl);
 	block_size = 1 << (PAGE_SHIFT + MAX_ORDER <= 32 ?
-			   PAGE_SHIFT + MAX_ORDER - 1 : 31);
+			   PAGE_SHIFT + MAX_ORDER - 1 :
+			   HISI_ACC_BLOCK_SIZE_MAX_SHIFT);
 	sgl_num_per_block = block_size / sgl_size;
 	block_num = count / sgl_num_per_block;
 	remain_sgl = count % sgl_num_per_block;
-- 
2.8.1

