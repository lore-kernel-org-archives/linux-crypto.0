Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6434FC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A55D23715
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgLQS4D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgLQS4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 13:56:02 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/2] crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled
Date:   Thu, 17 Dec 2020 19:55:15 +0100
Message-Id: <20201217185516.26969-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 69b6f2e817e5b ("crypto: arm64/aes-neon - limit exposed routines if
faster driver is enabled") intended to hide modes from the plain NEON
driver that are also implemented by the faster bit sliced NEON one if
both are enabled. However, the defined() CPP function does not detect
if the bit sliced NEON driver is enabled as a module. So instead, let's
use IS_ENABLED() here.

Fixes: 69b6f2e817e5b ("crypto: arm64/aes-neon - limit exposed routines if ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 34b8a89197be..cafb5b96be0e 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -55,7 +55,7 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_mac_update		neon_aes_mac_update
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
 #endif
-#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
@@ -650,7 +650,7 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
 	.base = {
 		.cra_name		= "__ecb(aes)",
 		.cra_driver_name	= "__ecb-aes-" MODE,
-- 
2.17.1

