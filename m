Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796D1C43464
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1B1207D3
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgISDPc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:15:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13322 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbgISDP3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 23:15:29 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 358CAC1E4FE391C56244;
        Sat, 19 Sep 2020 11:15:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 11:15:17 +0800
From:   yumeng 00484669 <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] crypto: hisilicon/hpre - adjust some coding style
Date:   Sat, 19 Sep 2020 11:13:51 +0800
Message-ID: <1600485232-39831-3-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
References: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Meng Yu <yumeng18@huawei.com>

Adjust some coding style to make code aligned.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 678a5ee..8bdaca0 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -188,8 +188,7 @@ static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 		hpre_req->dst = NULL;
 		dma_dir = DMA_FROM_DEVICE;
 	}
-	*tmp = dma_map_single(dev, sg_virt(data),
-			      len, dma_dir);
+	*tmp = dma_map_single(dev, sg_virt(data), len, dma_dir);
 	if (unlikely(dma_mapping_error(dev, *tmp))) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
@@ -239,8 +238,8 @@ static int hpre_hw_data_init(struct hpre_asym_request *hpre_req,
 	    ((is_dh && !is_src) || !is_dh))
 		ret = hpre_get_data_dma_addr(hpre_req, data, len, is_src, &tmp);
 	else
-		ret = hpre_prepare_dma_buf(hpre_req, data, len,
-					  is_src, &tmp);
+		ret = hpre_prepare_dma_buf(hpre_req, data, len, is_src, &tmp);
+
 	if (unlikely(ret))
 		return ret;
 
@@ -267,11 +266,9 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 
 	if (src) {
 		if (req->src)
-			dma_free_coherent(dev, ctx->key_sz,
-					  req->src, tmp);
+			dma_free_coherent(dev, ctx->key_sz, req->src, tmp);
 		else
-			dma_unmap_single(dev, tmp,
-					 ctx->key_sz, DMA_TO_DEVICE);
+			dma_unmap_single(dev, tmp, ctx->key_sz, DMA_TO_DEVICE);
 	}
 
 	tmp = le64_to_cpu(sqe->out);
-- 
2.8.1

