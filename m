Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D9BC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 11:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355382AbiCPLdB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355310AbiCPLcu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 07:32:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1EF1A82E;
        Wed, 16 Mar 2022 04:31:35 -0700 (PDT)
Received: from kwepemi100014.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KJSf331mTzcbGC;
        Wed, 16 Mar 2022 19:26:35 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi100014.china.huawei.com (7.221.188.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 19:31:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 19:31:33 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <tanghui20@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: hisilicon/qm - optimize the barrier operation
Date:   Wed, 16 Mar 2022 19:26:03 +0800
Message-ID: <20220316112603.4817-1-tanghui20@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A 'dma_wmb' barrier is enough to guarantee previous writes
before accessing by acc device in the outer shareable domain.

A 'smp_wmb' barrier is enough to guarantee previous writes
before accessing by other cpus in the inner shareble domain.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 453390044181..aec06810a6e0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -710,13 +710,13 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 
 	if (!IS_ENABLED(CONFIG_ARM64)) {
 		memcpy_toio(fun_base, src, 16);
-		wmb();
+		dma_wmb();
 		return;
 	}
 
 	asm volatile("ldp %0, %1, %3\n"
 		     "stp %0, %1, %2\n"
-		     "dsb sy\n"
+		     "dmb oshst\n"
 		     : "=&r" (tmp0),
 		       "=&r" (tmp1),
 		       "+Q" (*((char __iomem *)fun_base))
@@ -1004,7 +1004,7 @@ static void qm_set_qp_disable(struct hisi_qp *qp, int offset)
 	*addr = 1;
 
 	/* make sure setup is completed */
-	mb();
+	smp_wmb();
 }
 
 static void qm_disable_qp(struct hisi_qm *qm, u32 qp_id)
-- 
2.33.0

