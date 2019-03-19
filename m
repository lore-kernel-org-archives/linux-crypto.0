Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214A9C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF9EC2075E
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfCSN6I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:58:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36132 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbfCSN6I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 09:58:08 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4A18B6D76509E424B1DD;
        Tue, 19 Mar 2019 21:58:04 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 21:57:54 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: brcm - remove unused array tag_to_hash_idx
Date:   Tue, 19 Mar 2019 21:57:49 +0800
Message-ID: <20190319135749.3188-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

It's never used since introduction in commit
9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/bcm/spu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index dbb5c03..2baf6d7 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -22,9 +22,6 @@
 #include "spum.h"
 #include "cipher.h"
 
-/* This array is based on the hash algo type supported in spu.h */
-char *tag_to_hash_idx[] = { "none", "md5", "sha1", "sha224", "sha256" };
-
 char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
 	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
 
-- 
2.7.4


