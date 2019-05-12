Return-Path: <SRS0=UR19=TM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D87C04AB4
	for <linux-crypto@archiver.kernel.org>; Sun, 12 May 2019 09:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2760216C4
	for <linux-crypto@archiver.kernel.org>; Sun, 12 May 2019 09:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfELJIG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 May 2019 05:08:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7743 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfELJIF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 May 2019 05:08:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 595DCEB198AB1B5A4E50;
        Sun, 12 May 2019 17:08:01 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Sun, 12 May 2019
 17:07:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] arm/sha512 - Make sha512_arm_final static
Date:   Sun, 12 May 2019 17:05:40 +0800
Message-ID: <20190512090540.36472-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix sparse warning:

arch/arm/crypto/sha512-glue.c:40:5: warning:
 symbol 'sha512_arm_final' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 arch/arm/crypto/sha512-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/sha512-glue.c b/arch/arm/crypto/sha512-glue.c
index 86540cd..23fc381 100644
--- a/arch/arm/crypto/sha512-glue.c
+++ b/arch/arm/crypto/sha512-glue.c
@@ -37,7 +37,7 @@ int sha512_arm_update(struct shash_desc *desc, const u8 *data,
 		(sha512_block_fn *)sha512_block_data_order);
 }
 
-int sha512_arm_final(struct shash_desc *desc, u8 *out)
+static int sha512_arm_final(struct shash_desc *desc, u8 *out)
 {
 	sha512_base_do_finalize(desc,
 		(sha512_block_fn *)sha512_block_data_order);
-- 
2.7.4


