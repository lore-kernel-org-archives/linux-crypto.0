Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EBDC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C9D619B9
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhCaJdZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:33:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15059 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhCaJdL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 05:33:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F9Ldf5GzmzNrJL;
        Wed, 31 Mar 2021 17:30:30 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Wed, 31 Mar 2021
 17:33:02 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 4/5] crypto: hisilicon/sgl - fix the soft sg map to hardware sg
Date:   Wed, 31 Mar 2021 17:30:31 +0800
Message-ID: <1617183032-30983-5-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617183032-30983-1-git-send-email-yekai13@huawei.com>
References: <1617183032-30983-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The buffer of the hardware sge needs to be initialized by
soft sgl.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index d04e551..7f11e41 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -176,6 +176,7 @@ static void sg_map_to_hw_sg(struct scatterlist *sgl,
 {
 	hw_sge->buf = sg_dma_address(sgl);
 	hw_sge->len = cpu_to_le32(sg_dma_len(sgl));
+	hw_sge->page_ctrl = sg_virt(sgl);
 }
 
 static void inc_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
-- 
2.8.1

