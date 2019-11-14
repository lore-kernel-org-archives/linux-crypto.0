Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF5AC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 07:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A7CE206DB
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 07:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfKNHi6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 02:38:58 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49486 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbfKNHi5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 02:38:57 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0BAAB6E6A2A03142BDCB;
        Thu, 14 Nov 2019 15:38:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Thu, 14 Nov 2019
 15:38:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <heiko.carstens@de.ibm.com>, <gor@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <freude@linux.ibm.com>,
        <ifranzki@linux.ibm.com>, <jschmidb@de.ibm.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] s390/crypto: Fix unsigned variable compared with zero
Date:   Thu, 14 Nov 2019 15:30:05 +0800
Message-ID: <20191114073005.47000-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

s390_crypto_shash_parmsize() return type is int, it
should not be stored in a unsigned variable, which
compared with zero.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 3c2eb6b76cab ("s390/crypto: Support for SHA3 via CPACF (MSA6)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 arch/s390/crypto/sha_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index d39e0f0..686fe7a 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -74,14 +74,17 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
 	u64 bits;
-	unsigned int n, mbl_offset;
+	unsigned int n;
+	int mbl_offset;
 
 	n = ctx->count % bsize;
 	bits = ctx->count * 8;
-	mbl_offset = s390_crypto_shash_parmsize(ctx->func) / sizeof(u32);
+	mbl_offset = s390_crypto_shash_parmsize(ctx->func);
 	if (mbl_offset < 0)
 		return -EINVAL;
 
+	mbl_offset = mbl_offset / sizeof(u32);
+
 	/* set total msg bit length (mbl) in CPACF parmblock */
 	switch (ctx->func) {
 	case CPACF_KLMD_SHA_1:
-- 
2.7.4


