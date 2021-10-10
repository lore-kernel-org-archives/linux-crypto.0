Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC274C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Oct 2021 16:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7609860231
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Oct 2021 16:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhJJQCo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Oct 2021 12:02:44 -0400
Received: from mx22.baidu.com ([220.181.50.185]:52118 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231842AbhJJQCn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Oct 2021 12:02:43 -0400
Received: from BC-Mail-Ex23.internal.baidu.com (unknown [172.31.51.17])
        by Forcepoint Email with ESMTPS id ED7DB433CF7D7CA2F05B;
        Mon, 11 Oct 2021 00:00:37 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex23.internal.baidu.com (172.31.51.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 11 Oct 2021 00:00:37 +0800
Received: from localhost.localdomain (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 11 Oct 2021 00:00:37 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: octeontx2 - Use dma_alloc_coherent() instead of kzalloc/dma_map_single()
Date:   Mon, 11 Oct 2021 00:00:04 +0800
Message-ID: <20211010160010.435-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex13.internal.baidu.com (172.31.51.53) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replacing kzalloc/kfree/dma_map_single/dma_unmap_single()
with dma_alloc_coherent/dma_free_coherent() helps to reduce
code size, and simplify the code, and coherent DMA will not
clear the cache every time.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index dff34b3ec09e..60d62ce049a6 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1449,18 +1449,11 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
 	len = compl_rlen + LOADFVC_RLEN;
 
-	result = kzalloc(len, GFP_KERNEL);
+	result = dma_alloc_coherent(&pdev->dev, len, &rptr_baddr, GFP_KERNEL);
 	if (!result) {
 		ret = -ENOMEM;
 		goto lf_cleanup;
 	}
-	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
-				    DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
-		dev_err(&pdev->dev, "DMA mapping failed\n");
-		ret = -EFAULT;
-		goto free_result;
-	}
 	rptr = (u8 *)result + compl_rlen;
 
 	/* Fill in the command */
@@ -1489,11 +1482,9 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
 		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
 	}
-	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
+	dma_free_coherent(&pdev->dev, len, (void *)result, rptr_baddr);
 	cptpf->is_eng_caps_discovered = true;
 
-free_result:
-	kfree(result);
 lf_cleanup:
 	otx2_cptlf_shutdown(&cptpf->lfs);
 delete_grps:
-- 
2.25.1

