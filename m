Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB26AC11F7E
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 23:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9592861474
	for <linux-crypto@archiver.kernel.org>; Sun,  4 Jul 2021 23:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGDXIS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 4 Jul 2021 19:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230497AbhGDXIB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF12861364;
        Sun,  4 Jul 2021 23:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439925;
        bh=nSAQl4N0ksjmALGA8Vfx17EaJJ31UKUQVACEeMKFCyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgDmN8cTROO+EAKGR/aX2j/4qPWj8zuSvrYini9wHFWq2uSz57KJYmjEaOR5HfU2n
         BMyHSu/hejluqTI73XF+kxPTavKq9lQ7ygpqFKEGaDV/u5Y/4y0fKwmH9+v+Ji2CnT
         ooXFwstfMzNpN969/Gq1Riv6s4HY9IwNYElLfH5BNzX+3ETi8bZ7ShL24dtDCB1Xy5
         Q4FtXngGU+DtplJNA/v+7n2fwTcUIFXBsQ494OW8gy2R8Ye0fB2ObUjoblcBd1ZGcR
         c/JW6IJBT1FaNgaxvIb+Y/Zzmod2uOLnKQ8X8cvKZSIgvOji/ycxbkQRqk0C7nE7Vn
         OTH0JigCyyw/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 47/85] crypto: hisilicon/sec - fixup 3des minimum key size declaration
Date:   Sun,  4 Jul 2021 19:03:42 -0400
Message-Id: <20210704230420.1488358-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 6161f40c630bd7ced5f236cd5fbabec06e47afae ]

Fixup the 3des algorithm  minimum key size declaration.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 133aede8bf07..b43fad8b9e8d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1541,11 +1541,11 @@ static struct skcipher_alg sec_skciphers[] = {
 			 AES_BLOCK_SIZE, AES_BLOCK_SIZE)
 
 	SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb,
-			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
+			 SEC_DES3_3KEY_SIZE, SEC_DES3_3KEY_SIZE,
 			 DES3_EDE_BLOCK_SIZE, 0)
 
 	SEC_SKCIPHER_ALG("cbc(des3_ede)", sec_setkey_3des_cbc,
-			 SEC_DES3_2KEY_SIZE, SEC_DES3_3KEY_SIZE,
+			 SEC_DES3_3KEY_SIZE, SEC_DES3_3KEY_SIZE,
 			 DES3_EDE_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE)
 
 	SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,
-- 
2.30.2

