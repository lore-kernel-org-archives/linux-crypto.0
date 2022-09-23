Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F483ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 09:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiIWJIp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiIWJIe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 05:08:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1105312E436
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 02:08:27 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYmRg2LNVzlXSd;
        Fri, 23 Sep 2022 17:04:15 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 17:08:24 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ardb@kernel.org>, <t-kristo@ti.com>, <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 3/3] crypto: scatterwalk - Remove unused inline function scatterwalk_aligned()
Date:   Fri, 23 Sep 2022 17:08:23 +0800
Message-ID: <20220923090823.509656-4-cuigaosheng1@huawei.com>
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

The scatterwalk_aligned() are no longer used since removing blkcipher
and ablkcipher support, all use of it has been removed since
commit d63007eb954e ("crypto: ablkcipher - remove deprecated
and unused ablkcipher support"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 include/crypto/scatterwalk.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 6407b4b61350..ccdb05f68a75 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -46,12 +46,6 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
 	walk->offset += nbytes;
 }
 
-static inline unsigned int scatterwalk_aligned(struct scatter_walk *walk,
-					       unsigned int alignmask)
-{
-	return !(walk->offset & alignmask);
-}
-
 static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 {
 	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
-- 
2.25.1

