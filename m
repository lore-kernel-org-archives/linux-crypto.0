Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E9EC77B61
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Apr 2023 12:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbjDYM5P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Apr 2023 08:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbjDYM5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2023 08:57:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A0819A5
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2023 05:57:12 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q5MRn0LPvzsR6D;
        Tue, 25 Apr 2023 20:55:33 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 20:57:09 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: jitter - change module_init(jent_mod_init) to subsys_initcall(jent_mod_init)
Date:   Tue, 25 Apr 2023 20:57:09 +0800
Message-ID: <20230425125709.39470-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
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

The ecdh-nist-p256 algorithm will depend on jitterentropy_rng,
and when they are built into kernel, the order of registration
should be done such that the underlying algorithms are ready
before the ones on top are registered.

Now ecdh is initialized with subsys_initcall but jitterentropy_rng
is initialized with module_init.

This patch will change module_init(jent_mod_init) to
subsys_initcall(jent_mod_init), so jitterentropy_rng will be
registered before ecdh-nist-p256 when they are built into kernel.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/jitterentropy-kcapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index b9edfaa51b27..563c1ea8c8fe 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -205,7 +205,7 @@ static void __exit jent_mod_exit(void)
 	crypto_unregister_rng(&jent_alg);
 }
 
-module_init(jent_mod_init);
+subsys_initcall(jent_mod_init);
 module_exit(jent_mod_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.25.1

