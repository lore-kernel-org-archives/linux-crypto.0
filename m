Return-Path: <SRS0=bf8p=XK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5B2C4CECC
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 09:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51AAA20830
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 09:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfIOJ1Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Sep 2019 05:27:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42428 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfIOJ1X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Sep 2019 05:27:23 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F37E6BBF8125940F6708;
        Sun, 15 Sep 2019 17:27:20 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sun, 15 Sep 2019
 17:27:14 +0800
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <john.garry@huawei.com>, <Jonathan.Cameron@huawei.com>,
        <mcgrof@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Yunfeng Ye <yeyunfeng@huawei.com>
Subject: [PATCH 1/2] crypto: hisilicon - Fix double free in sec_free_hw_sgl()
Message-ID: <c9c52443-59a6-f909-f98b-eddffe999c2b@huawei.com>
Date:   Sun, 15 Sep 2019 17:26:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are two problems in sec_free_hw_sgl():

First, when sgl_current->next is valid, @hw_sgl will be freed in the
first loop, but it free again after the loop.

Second, sgl_current and sgl_current->next_sgl is not match when
dma_pool_free() is invoked, the third parameter should be the dma
address of sgl_current, but sgl_current->next_sgl is the dma address
of next chain, so use sgl_current->next_sgl is wrong.

Fix this by deleting the last dma_pool_free() in sec_free_hw_sgl(),
modifying the condition for while loop, and matching the address for
dma_pool_free().

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccd..8c789b8671fc 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -215,17 +215,18 @@ static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
 			    dma_addr_t psec_sgl, struct sec_dev_info *info)
 {
 	struct sec_hw_sgl *sgl_current, *sgl_next;
+	dma_addr_t sgl_next_dma;

-	if (!hw_sgl)
-		return;
 	sgl_current = hw_sgl;
-	while (sgl_current->next) {
+	while (sgl_current) {
 		sgl_next = sgl_current->next;
-		dma_pool_free(info->hw_sgl_pool, sgl_current,
-			      sgl_current->next_sgl);
+		sgl_next_dma = sgl_current->next_sgl;
+
+		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
+
 		sgl_current = sgl_next;
+		psec_sgl = sgl_next_dma;
 	}
-	dma_pool_free(info->hw_sgl_pool, hw_sgl, psec_sgl);
 }

 static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
-- 
2.23.0

