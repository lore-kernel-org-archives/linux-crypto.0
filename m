Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B64EC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 592FB2084F
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfHNJbC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:31:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbfHNJa7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 05:30:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3A91F2AB08A1131FE742;
        Wed, 14 Aug 2019 17:30:56 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 14 Aug 2019 17:30:49 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 3/5] crypto: hisilicon - init curr_sgl_dma to fix compile warning
Date:   Wed, 14 Aug 2019 17:28:37 +0800
Message-ID: <1565774919-31853-4-git-send-email-wangzhou1@hisilicon.com>
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

Just init curr_sgl_dma = 0 to avoid compile warning.

Fixes: dfed0098ab91 ("crypto: hisilicon - add hardware SGL support")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/sgl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 8ef7679..e083d17 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -150,7 +150,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 			      u32 index, dma_addr_t *hw_sgl_dma)
 {
 	struct hisi_acc_hw_sgl *curr_hw_sgl;
-	dma_addr_t curr_sgl_dma;
+	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
 	int sg_n = sg_nents(sgl);
-- 
2.8.1

