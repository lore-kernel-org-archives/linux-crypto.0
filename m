Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9BEC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 09:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3D464F69
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 09:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCSJQz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 05:16:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14096 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhCSJQa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 05:16:30 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1yrn6rVVz19GfJ;
        Fri, 19 Mar 2021 17:14:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 17:16:18 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: Correct an error in the comments
Date:   Fri, 19 Mar 2021 17:13:34 +0800
Message-ID: <1616145214-40494-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove repeated word 'bit' in comments.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 0798a18..63ba70b 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -137,7 +137,7 @@ bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 }
 EXPORT_SYMBOL(vli_is_zero);
 
-/* Returns nonzero if bit bit of vli is set. */
+/* Returns nonzero if bit of vli is set. */
 static u64 vli_test_bit(const u64 *vli, unsigned int bit)
 {
 	return (vli[bit / 64] & ((u64)1 << (bit % 64)));
-- 
2.8.1

