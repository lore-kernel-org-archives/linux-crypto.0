Return-Path: <SRS0=bf8p=XK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6490FC4CECC
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 09:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F8F620692
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 09:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfIOJbj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Sep 2019 05:31:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52676 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfIOJbj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Sep 2019 05:31:39 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 44F7ED3488973B84F1E8;
        Sun, 15 Sep 2019 17:31:37 +0800 (CST)
Received: from [127.0.0.1] (10.177.251.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sun, 15 Sep 2019
 17:31:26 +0800
Subject: [PATCH 2/2] crypto: hisilicon - Matching the dma address for
 dma_pool_free()
From:   Yunfeng Ye <yeyunfeng@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <john.garry@huawei.com>, <Jonathan.Cameron@huawei.com>,
        <mcgrof@kernel.org>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <c9c52443-59a6-f909-f98b-eddffe999c2b@huawei.com>
Message-ID: <04d1e050-db06-5348-d0d9-ca6e8f98c42c@huawei.com>
Date:   Sun, 15 Sep 2019 17:31:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c9c52443-59a6-f909-f98b-eddffe999c2b@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.251.225]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When dma_pool_zalloc() fail in sec_alloc_and_fill_hw_sgl(),
dma_pool_free() is invoked, but the parameters that sgl_current and
sgl_current->next_sgl is not match.

Using sec_free_hw_sgl() instead of the original free routine.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 44 +++++++++++--------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 8c789b8671fc..331a682415d1 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -153,6 +153,24 @@ static void sec_alg_skcipher_init_context(struct crypto_skcipher *atfm,
 				       ctx->cipher_alg);
 }

+static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
+			    dma_addr_t psec_sgl, struct sec_dev_info *info)
+{
+	struct sec_hw_sgl *sgl_current, *sgl_next;
+	dma_addr_t sgl_next_dma;
+
+	sgl_current = hw_sgl;
+	while (sgl_current) {
+		sgl_next = sgl_current->next;
+		sgl_next_dma = sgl_current->next_sgl;
+
+		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
+
+		sgl_current = sgl_next;
+		psec_sgl = sgl_next_dma;
+	}
+}
+
 static int sec_alloc_and_fill_hw_sgl(struct sec_hw_sgl **sec_sgl,
 				     dma_addr_t *psec_sgl,
 				     struct scatterlist *sgl,
@@ -199,36 +217,12 @@ static int sec_alloc_and_fill_hw_sgl(struct sec_hw_sgl **sec_sgl,
 	return 0;

 err_free_hw_sgls:
-	sgl_current = *sec_sgl;
-	while (sgl_current) {
-		sgl_next = sgl_current->next;
-		dma_pool_free(info->hw_sgl_pool, sgl_current,
-			      sgl_current->next_sgl);
-		sgl_current = sgl_next;
-	}
+	sec_free_hw_sgl(*sec_sgl, *psec_sgl, info);
 	*psec_sgl = 0;

 	return ret;
 }

-static void sec_free_hw_sgl(struct sec_hw_sgl *hw_sgl,
-			    dma_addr_t psec_sgl, struct sec_dev_info *info)
-{
-	struct sec_hw_sgl *sgl_current, *sgl_next;
-	dma_addr_t sgl_next_dma;
-
-	sgl_current = hw_sgl;
-	while (sgl_current) {
-		sgl_next = sgl_current->next;
-		sgl_next_dma = sgl_current->next_sgl;
-
-		dma_pool_free(info->hw_sgl_pool, sgl_current, psec_sgl);
-
-		sgl_current = sgl_next;
-		psec_sgl = sgl_next_dma;
-	}
-}
-
 static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen,
 				   enum sec_cipher_alg alg)
-- 
2.23.0

