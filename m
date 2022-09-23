Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F45C6FA86
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 09:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiIWJIq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiIWJIe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 05:08:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648A712ED82
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 02:08:28 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYmT93T2czpTdY;
        Fri, 23 Sep 2022 17:05:33 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 17:08:24 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ardb@kernel.org>, <t-kristo@ti.com>, <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/3] crypto: bcm - Simplify obtain the name for cipher
Date:   Fri, 23 Sep 2022 17:08:21 +0800
Message-ID: <20220923090823.509656-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923090823.509656-1-cuigaosheng1@huawei.com>
References: <20220923090823.509656-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto_ahash_alg_name(tfm) can obtain the name for cipher in
include/crypto/hash.h, but now the function is not in use, so we
use it to simplify the code, and optimize the code structure.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/crypto/bcm/cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 053315e260c2..c8c799428fe0 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -1928,7 +1928,7 @@ static int ahash_enqueue(struct ahash_request *req)
 	/* SPU2 hardware does not compute hash of zero length data */
 	if ((rctx->is_final == 1) && (rctx->total_todo == 0) &&
 	    (iproc_priv.spu.spu_type == SPU_TYPE_SPU2)) {
-		alg_name = crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
+		alg_name = crypto_ahash_alg_name(tfm);
 		flow_log("Doing %sfinal %s zero-len hash request in software\n",
 			 rctx->is_final ? "" : "non-", alg_name);
 		err = do_shash((unsigned char *)alg_name, req->result,
@@ -2029,7 +2029,7 @@ static int ahash_init(struct ahash_request *req)
 		 * supported by the hardware, we need to handle it in software
 		 * by calling synchronous hash functions.
 		 */
-		alg_name = crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
+		alg_name = crypto_ahash_alg_name(tfm);
 		hash = crypto_alloc_shash(alg_name, 0, 0);
 		if (IS_ERR(hash)) {
 			ret = PTR_ERR(hash);
-- 
2.25.1

