Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB685C77B7E
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Apr 2023 10:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDOKMG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Apr 2023 06:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjDOKMD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Apr 2023 06:12:03 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10307358C;
        Sat, 15 Apr 2023 03:12:02 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Pz8CV3xsRz17SYK;
        Sat, 15 Apr 2023 18:08:22 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 18:12:00 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10 4/4] crypto: api - Fix boot-up crash when crypto manager is disabled
Date:   Sat, 15 Apr 2023 18:11:58 +0800
Message-ID: <20230415101158.1648486-5-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
References: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

When the crypto manager is disabled, we need to explicitly set
the crypto algorithms' tested status so that they can be used.

Fixes: cad439fc040e ("crypto: api - Do not create test larvals if...")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reported-by: Ido Schimmel <idosch@idosch.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 crypto/algapi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f6481cb79946..0d0c3e937e36 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -284,6 +284,8 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
 	if (larval)
 		list_add(&larval->alg.cra_list, &crypto_alg_list);
+	else
+		alg->cra_flags |= CRYPTO_ALG_TESTED;
 
 	crypto_stats_init(alg);
 
-- 
2.25.1

