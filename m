Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD55FC28D13
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 08:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiHYIlu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 04:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiHYIlo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 04:41:44 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5380792C2;
        Thu, 25 Aug 2022 01:41:42 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MCxH30HPQzGpqB;
        Thu, 25 Aug 2022 16:39:59 +0800 (CST)
Received: from dggphis33418.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 25 Aug 2022 16:41:39 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next 1/2] crypto: api - Fix IS_ERR() vs NULL check
Date:   Thu, 25 Aug 2022 16:41:37 +0800
Message-ID: <20220825084138.1881954-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220825084138.1881954-1-cuigaosheng1@huawei.com>
References: <20220825084138.1881954-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto_alloc_test_larval() will return null if manager is disabled,
it may not return error pointers, so using IS_ERR_OR_NULL()
to check the return value to fix this.

The __crypto_register_alg() will return null if manager is disabled,
it may not return error pointers, so using IS_ERR_OR_NULL()
to check the return value to fix this.

Fixes: cad439fc040e ("crypto: api - Do not create test larvals if manager is disabled")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/algapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5c69ff8e8fa5..5a080b8aaa11 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -283,7 +283,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	}
 
 	larval = crypto_alloc_test_larval(alg);
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		goto out;
 
 	list_add(&alg->cra_list, &crypto_alg_list);
@@ -651,7 +651,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	inst->alg.cra_flags |= (fips_internal & CRYPTO_ALG_FIPS_INTERNAL);
 
 	larval = __crypto_register_alg(&inst->alg);
-	if (IS_ERR(larval))
+	if (IS_ERR_OR_NULL(larval))
 		goto unlock;
 	else if (larval)
 		larval->test_started = true;
-- 
2.25.1

