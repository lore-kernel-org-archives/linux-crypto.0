Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2F1C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Feb 2022 11:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiBPLo1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Feb 2022 06:44:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiBPLo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Feb 2022 06:44:26 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE0C8567A;
        Wed, 16 Feb 2022 03:44:13 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JzGHS1t6Wz8wl6;
        Wed, 16 Feb 2022 19:40:52 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 16 Feb
 2022 19:44:11 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <yuehaibing@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] crypto: x86/blowfish - Remove unused inline functions
Date:   Wed, 16 Feb 2022 19:44:06 +0800
Message-ID: <20220216114406.22108-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is unused after commit c0a64926c53e ("crypto: x86/blowfish - drop CTR mode implementation")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 arch/x86/crypto/blowfish_glue.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index a880e0b1c255..fda6066437aa 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -32,24 +32,12 @@ static inline void blowfish_enc_blk(struct bf_ctx *ctx, u8 *dst, const u8 *src)
 	__blowfish_enc_blk(ctx, dst, src, false);
 }
 
-static inline void blowfish_enc_blk_xor(struct bf_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__blowfish_enc_blk(ctx, dst, src, true);
-}
-
 static inline void blowfish_enc_blk_4way(struct bf_ctx *ctx, u8 *dst,
 					 const u8 *src)
 {
 	__blowfish_enc_blk_4way(ctx, dst, src, false);
 }
 
-static inline void blowfish_enc_blk_xor_4way(struct bf_ctx *ctx, u8 *dst,
-				      const u8 *src)
-{
-	__blowfish_enc_blk_4way(ctx, dst, src, true);
-}
-
 static void blowfish_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	blowfish_enc_blk(crypto_tfm_ctx(tfm), dst, src);
-- 
2.17.1

