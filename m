Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B4AC001E0
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 14:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjGaOHq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjGaOH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 10:07:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47BF3C39
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 07:05:29 -0700 (PDT)
Received: from dggpemm100020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RF0Mh6hK3zVjkb;
        Mon, 31 Jul 2023 22:03:44 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm100020.china.huawei.com (7.185.36.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 22:05:26 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 31 Jul
 2023 22:05:26 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     <jiajie.ho@starfivetech.com>, <william.qiu@starfivetech.com>,
        <herbert@gondor.apana.org.au>, <huan.feng@starfivetech.com>,
        <davem@davemloft.net>, <yangyingliang@huawei.com>
Subject: [PATCH -next] crypto: starfive - fix return value check in starfive_aes_prepare_req()
Date:   Mon, 31 Jul 2023 22:02:49 +0800
Message-ID: <20230731140249.2691001-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kzalloc() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: e22471c2331c ("crypto: starfive - Add AES skcipher and aead support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/crypto/starfive/jh7110-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 04dd7958054f..278dfa4aa743 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -496,8 +496,8 @@ static int starfive_aes_prepare_req(struct skcipher_request *req,
 
 	if (cryp->assoclen) {
 		rctx->adata = kzalloc(ALIGN(cryp->assoclen, AES_BLOCK_SIZE), GFP_KERNEL);
-		if (IS_ERR(rctx->adata))
-			return dev_err_probe(cryp->dev, PTR_ERR(rctx->adata),
+		if (!rctx->adata)
+			return dev_err_probe(cryp->dev, -ENOMEM,
 					     "Failed to alloc memory for adata");
 
 		scatterwalk_copychunks(rctx->adata, &cryp->in_walk, cryp->assoclen, 0);
-- 
2.25.1

