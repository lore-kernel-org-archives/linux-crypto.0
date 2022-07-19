Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D56C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 04:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiGSETO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 00:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiGSETI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 00:19:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C9C32BA6;
        Mon, 18 Jul 2022 21:19:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ln59y55DmzjX4G;
        Tue, 19 Jul 2022 12:16:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 19 Jul
 2022 12:19:04 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liulongfang@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <xuzaibo@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH v2] crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc mem during softirq
Date:   Tue, 19 Jul 2022 12:23:23 +0800
Message-ID: <20220719042323.260146-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The hpre encryption driver may be used to encrypt and decrypt packets
during the rx softirq, it is not allowed to use GFP_KERNEL.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
This patch is not tested, compiled only.
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 97d54c1465c2..3ba6f15deafc 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -252,7 +252,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 	if (unlikely(shift < 0))
 		return -EINVAL;
 
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_KERNEL);
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_ATOMIC);
 	if (unlikely(!ptr))
 		return -ENOMEM;
 
-- 
2.17.1

