Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC78C3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 03:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4919E22CEA
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 03:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfIDDEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 23:04:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33988 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727701AbfIDDEX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 23:04:23 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ACDD0E8BC4200A95E5CD;
        Wed,  4 Sep 2019 11:04:21 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:04:14 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <arno@natisbad.org>, <joro@8bytes.org>,
        <gregkh@linuxfoundation.org>
CC:     <zhongjiang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] crypto: marvell: Use kzfree rather than its implementation
Date:   Wed, 4 Sep 2019 11:01:17 +0800
Message-ID: <1567566079-7412-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567566079-7412-1-git-send-email-zhongjiang@huawei.com>
References: <1567566079-7412-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kzfree instead of memset() + kfree().

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/crypto/marvell/hash.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 0f0ac85..a2b35fb 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -1148,8 +1148,7 @@ static int mv_cesa_ahmac_pad_init(struct ahash_request *req,
 		}
 
 		/* Set the memory region to 0 to avoid any leak. */
-		memset(keydup, 0, keylen);
-		kfree(keydup);
+		kzfree(keydup);
 
 		if (ret)
 			return ret;
-- 
1.7.12.4

