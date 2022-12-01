Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943B6C43217
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 06:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiLAGZd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 01:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLAGZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 01:25:32 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA6948419
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2022 22:25:29 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NN5dp1ZC8z15MKy;
        Thu,  1 Dec 2022 14:24:46 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 14:25:26 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <james.hartley@imgtec.com>, <abrestic@chromium.org>,
        <will.thomas@imgtec.com>, <cuigaosheng1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: img-hash - Fix variable dereferenced before check 'hdev->req'
Date:   Thu, 1 Dec 2022 14:25:26 +0800
Message-ID: <20221201062526.4089-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Smatch report warning as follows:

drivers/crypto/img-hash.c:366 img_hash_dma_task() warn: variable
dereferenced before check 'hdev->req'

Variable dereferenced should be done after check 'hdev->req',
fix it.

Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
Fixes: 10badea259fa ("crypto: img-hash - Fix null pointer exception")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/crypto/img-hash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index d8e82d69745d..9629e98bd68b 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -358,12 +358,16 @@ static int img_hash_dma_init(struct img_hash_dev *hdev)
 static void img_hash_dma_task(unsigned long d)
 {
 	struct img_hash_dev *hdev = (struct img_hash_dev *)d;
-	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
+	struct img_hash_request_ctx *ctx;
 	u8 *addr;
 	size_t nbytes, bleft, wsend, len, tbc;
 	struct scatterlist tsg;
 
-	if (!hdev->req || !ctx->sg)
+	if (!hdev->req)
+		return;
+
+	ctx = ahash_request_ctx(hdev->req);
+	if (!ctx->sg)
 		return;
 
 	addr = sg_virt(ctx->sg);
-- 
2.25.1

