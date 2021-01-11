Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BCAC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E816F2250F
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbhAKQyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387574AbhAKQyM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:54:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D421122B51;
        Mon, 11 Jan 2021 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383980;
        bh=0knrbaQvNbxq4+wTxIRfAEHDDOjfn9lPOK3J0RS2wsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNP1z2yEtNYn2IluLxqp/o0+rEF26hdwmv3ZaPxixw1ec2wO+cQfAynV7qXpmFNSh
         8QlcMjnhtiZakLf47Kv9JcS3hcSpFgi5+LWYKqNJHAQbXVzv3UYlsC0w8gtg0jVozZ
         TEZ936rmwxxf22Lb8doQjal5l5azFKRJCO1lr0corPbOWC5RbTfYIr3zmSbpGFOyQL
         eSBzZR7Jo2NdjdAKvMgRbxwmX3slB0ThWGpfAriRERKSD9fQWSsATey1bvEVM4ixTP
         JBRjgEm08cdqcs0+uuDErb7vBU4s7d0XOXBr335G6NBX0H4WwJJNtAIAnr+32ZMDFK
         3n+g3QUhxEMuQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/7] crypto: arm/crc-t10dif - convert to static call library API
Date:   Mon, 11 Jan 2021 17:52:35 +0100
Message-Id: <20210111165237.18178-6-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Get rid of the shash boilerplate, and register the accelerated ARM
version of the CRC-T10DIF algorithm with the library interface instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/crct10dif-ce-glue.c | 58 ++++----------------
 1 file changed, 11 insertions(+), 47 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index e9191a8c87b9..ce21f958fd49 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -5,13 +5,13 @@
  * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
  */
 
+#include <linux/cpufeature.h>
 #include <linux/crc-t10dif.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 
-#include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 
 #include <asm/neon.h>
@@ -21,68 +21,32 @@
 
 asmlinkage u16 crc_t10dif_pmull(u16 init_crc, const u8 *buf, size_t len);
 
-static int crct10dif_init(struct shash_desc *desc)
+static u16 crc_t10dif_arm(u16 crc, const u8 *data, size_t len)
 {
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = 0;
-	return 0;
-}
-
-static int crct10dif_update(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
+	if (len >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull(*crc, data, length);
+		crc = crc_t10dif_pmull(crc, data, len);
 		kernel_neon_end();
 	} else {
-		*crc = crc_t10dif_generic(*crc, data, length);
+		crc = crc_t10dif_generic(crc, data, len);
 	}
-
-	return 0;
+	return crc;
 }
 
-static int crct10dif_final(struct shash_desc *desc, u8 *out)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*(u16 *)out = *crc;
-	return 0;
-}
-
-static struct shash_alg crc_t10dif_alg = {
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= crct10dif_init,
-	.update			= crct10dif_update,
-	.final			= crct10dif_final,
-	.descsize		= CRC_T10DIF_DIGEST_SIZE,
-
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-arm-ce",
-	.base.cra_priority	= 200,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-};
-
 static int __init crc_t10dif_mod_init(void)
 {
-	if (!(elf_hwcap2 & HWCAP2_PMULL))
-		return -ENODEV;
-
-	return crypto_register_shash(&crc_t10dif_alg);
+	return crc_t10dif_register(crc_t10dif_arm, "crct10dif-arm-ce");
 }
 
 static void __exit crc_t10dif_mod_exit(void)
 {
-	crypto_unregister_shash(&crc_t10dif_alg);
+	crc_t10dif_unregister();
 }
 
-module_init(crc_t10dif_mod_init);
+module_cpu_feature_match(PMULL, crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("crct10dif");
+MODULE_ALIAS("crct10dif-arch");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
2.17.1

