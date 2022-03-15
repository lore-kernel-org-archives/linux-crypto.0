Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DEDC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Mar 2022 09:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346786AbiCOJqY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346766AbiCOJqR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Mar 2022 05:46:17 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73FD4ECD6;
        Tue, 15 Mar 2022 02:45:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0V7HS1wm_1647337500;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0V7HS1wm_1647337500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Mar 2022 17:45:01 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Ard Biesheuvel <ardb@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>, zhuolong.lq@antfin.com
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 2/4] crypto: arm64/sm4-ce - rename to sm4-ce-cipher
Date:   Tue, 15 Mar 2022 17:44:52 +0800
Message-Id: <20220315094454.45269-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220315094454.45269-1-tianjia.zhang@linux.alibaba.com>
References: <20220315094454.45269-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The subsequent patches of the series will have an implementation
of SM4-ECB/CBC/CFB/CTR accelerated by the CE instruction set, which
conflicts with the current module name. In order to keep the naming
rules of the AES algorithm consistent, the sm4-ce algorithm is
renamed to sm4-ce-cipher.

In addition, the speed of sm4-ce-cipher is better than that of SM4
NEON. By the way, the priority of the algorithm is adjusted to 300,
which is also to leave room for the priority of SM4 NEON.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/arm64/crypto/Makefile                                | 4 ++--
 arch/arm64/crypto/{sm4-ce-core.S => sm4-ce-cipher-core.S} | 0
 arch/arm64/crypto/{sm4-ce-glue.c => sm4-ce-cipher-glue.c} | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/arm64/crypto/{sm4-ce-core.S => sm4-ce-cipher-core.S} (100%)
 rename arch/arm64/crypto/{sm4-ce-glue.c => sm4-ce-cipher-glue.c} (98%)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 09a805cc32d7..85863e610a2e 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -20,8 +20,8 @@ sha3-ce-y := sha3-ce-glue.o sha3-ce-core.o
 obj-$(CONFIG_CRYPTO_SM3_ARM64_CE) += sm3-ce.o
 sm3-ce-y := sm3-ce-glue.o sm3-ce-core.o
 
-obj-$(CONFIG_CRYPTO_SM4_ARM64_CE) += sm4-ce.o
-sm4-ce-y := sm4-ce-glue.o sm4-ce-core.o
+obj-$(CONFIG_CRYPTO_SM4_ARM64_CE) += sm4-ce-cipher.o
+sm4-ce-cipher-y := sm4-ce-cipher-glue.o sm4-ce-cipher-core.o
 
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-cipher-core.S
similarity index 100%
rename from arch/arm64/crypto/sm4-ce-core.S
rename to arch/arm64/crypto/sm4-ce-cipher-core.S
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-cipher-glue.c
similarity index 98%
rename from arch/arm64/crypto/sm4-ce-glue.c
rename to arch/arm64/crypto/sm4-ce-cipher-glue.c
index 9c93cfc4841b..76a34ef4abbb 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-cipher-glue.c
@@ -54,7 +54,7 @@ static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 static struct crypto_alg sm4_ce_alg = {
 	.cra_name			= "sm4",
 	.cra_driver_name		= "sm4-ce",
-	.cra_priority			= 200,
+	.cra_priority			= 300,
 	.cra_flags			= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize			= SM4_BLOCK_SIZE,
 	.cra_ctxsize			= sizeof(struct sm4_ctx),
-- 
2.24.3 (Apple Git-128)

