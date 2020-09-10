Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD460C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9794C20809
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgIJMUq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:20:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730386AbgIJMRx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 08:17:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B998B96AFB02AB6847EC;
        Thu, 10 Sep 2020 19:26:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Sep 2020 19:26:39 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] crypto: hisilicon/hpre - adjust some coding style
Date:   Thu, 10 Sep 2020 19:25:21 +0800
Message-ID: <1599737122-20734-3-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
References: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust some coding style to make code aligned.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d685992..0cbe99a1 100644
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

