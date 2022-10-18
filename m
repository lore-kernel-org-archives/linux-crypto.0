Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68339C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 07:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJRHLk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 03:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJRHLF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 03:11:05 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1766BA98F2;
        Tue, 18 Oct 2022 00:10:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VSTWskf_1666077026;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VSTWskf_1666077026)
          by smtp.aliyun-inc.com;
          Tue, 18 Oct 2022 15:10:27 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v2 08/15] crypto: arm64/sm4 - export reusable CE acceleration functions
Date:   Tue, 18 Oct 2022 15:09:59 +0800
Message-Id: <20221018071006.5717-9-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20221018071006.5717-1-tianjia.zhang@linux.alibaba.com>
References: <20221018071006.5717-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the accelerated implementation of the SM4 algorithm using the Crypto
Extension instructions, there are some functions that can be reused in
the upcoming accelerated implementation of the GCM/CCM mode, and the
CBC/CFB encryption is reused in the optimized implementation of SVESM4.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/arm64/crypto/sm4-ce-glue.c |  5 +++++
 arch/arm64/crypto/sm4-ce.h      | 16 ++++++++++++++++
 2 files changed, 21 insertions(+)
 create mode 100644 arch/arm64/crypto/sm4-ce.h

diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index ff2d8442d473..63abcadc684b 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -36,6 +36,11 @@ asmlinkage void sm4_ce_cfb_dec(const u32 *rkey, u8 *dst, const u8 *src,
 asmlinkage void sm4_ce_ctr_enc(const u32 *rkey, u8 *dst, const u8 *src,
 			       u8 *iv, unsigned int nblks);
 
+EXPORT_SYMBOL(sm4_ce_expand_key);
+EXPORT_SYMBOL(sm4_ce_crypt_block);
+EXPORT_SYMBOL(sm4_ce_cbc_enc);
+EXPORT_SYMBOL(sm4_ce_cfb_enc);
+
 static int sm4_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		      unsigned int key_len)
 {
diff --git a/arch/arm64/crypto/sm4-ce.h b/arch/arm64/crypto/sm4-ce.h
new file mode 100644
index 000000000000..109c21b37590
--- /dev/null
+++ b/arch/arm64/crypto/sm4-ce.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SM4 common functions for Crypto Extensions
+ * Copyright (C) 2022 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
+ */
+
+void sm4_ce_expand_key(const u8 *key, u32 *rkey_enc, u32 *rkey_dec,
+		       const u32 *fk, const u32 *ck);
+
+void sm4_ce_crypt_block(const u32 *rkey, u8 *dst, const u8 *src);
+
+void sm4_ce_cbc_enc(const u32 *rkey_enc, u8 *dst, const u8 *src,
+		    u8 *iv, unsigned int nblocks);
+
+void sm4_ce_cfb_enc(const u32 *rkey_enc, u8 *dst, const u8 *src,
+		    u8 *iv, unsigned int nblocks);
-- 
2.24.3 (Apple Git-128)

