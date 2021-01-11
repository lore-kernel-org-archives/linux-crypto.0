Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1443AC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39BB22288
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389154AbhAKQyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389053AbhAKQyM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:54:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 927D722BE9;
        Mon, 11 Jan 2021 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383981;
        bh=O6/RYp8CVubXs/Bqm7W26Mnby0JlQwuVMOuvid3rSkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hoki5xpiTdOzKYr9+8cag6XptcMh+EYuDSaouNdNXNRsZdgiD8dl4Or6xD6ABg4FZ
         TKa5vmJvf9qCowHM5lTQsiKsv9i0aZ8ZG6MAerMG2M/x1E/AvYAg1ZhBEJuu8Ogcde
         +XYjn366ZFEMgEVHczsrFr+N+FiWot6nKvFJxeq+6oadHitN7SoRxuoiquKL8U3iA4
         7tObAkNy3/HfPsoUNV3P2MTRoimZiTxO/epEMhbc+oUTIHWFcG+rO7J9FPFR2Vv70N
         lu9IzMse/BZNmxO0OBaQJgWuUS/HdKeRyQVzvUhQIA6AgHhWdDV2uRUBfKT4lVjwJ0
         +mWDTqZ97kN2w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/7] crypto: arm64/crc-t10dif - convert to static call API
Date:   Mon, 11 Jan 2021 17:52:36 +0100
Message-Id: <20210111165237.18178-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Get rid of the shash boilerplate, and register the accelerated arm64
version of the CRC-T10DIF algorithm with the library interface instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-glue.c | 85 ++++----------------
 1 file changed, 15 insertions(+), 70 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index ccc3f6067742..70c730866d4a 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 
-#include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 
 #include <asm/neon.h>
@@ -23,97 +22,43 @@
 asmlinkage u16 crc_t10dif_pmull_p8(u16 init_crc, const u8 *buf, size_t len);
 asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 *buf, size_t len);
 
-static int crct10dif_init(struct shash_desc *desc)
+static u16 crct10dif_update_pmull_p8(u16 crc, const u8 *data, size_t length)
 {
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = 0;
-	return 0;
-}
-
-static int crct10dif_update_pmull_p8(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull_p8(*crc, data, length);
+		crc = crc_t10dif_pmull_p8(crc, data, length);
 		kernel_neon_end();
 	} else {
-		*crc = crc_t10dif_generic(*crc, data, length);
+		crc = crc_t10dif_generic(crc, data, length);
 	}
-
-	return 0;
+	return crc;
 }
 
-static int crct10dif_update_pmull_p64(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
+static u16 crct10dif_update_pmull_p64(u16 crc, const u8 *data, size_t length)
 {
-	u16 *crc = shash_desc_ctx(desc);
-
 	if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
 		kernel_neon_begin();
-		*crc = crc_t10dif_pmull_p64(*crc, data, length);
+		crc = crc_t10dif_pmull_p64(crc, data, length);
 		kernel_neon_end();
 	} else {
-		*crc = crc_t10dif_generic(*crc, data, length);
+		crc = crc_t10dif_generic(crc, data, length);
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
-static struct shash_alg crc_t10dif_alg[] = {{
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= crct10dif_init,
-	.update			= crct10dif_update_pmull_p8,
-	.final			= crct10dif_final,
-	.descsize		= CRC_T10DIF_DIGEST_SIZE,
-
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-arm64-neon",
-	.base.cra_priority	= 100,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}, {
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= crct10dif_init,
-	.update			= crct10dif_update_pmull_p64,
-	.final			= crct10dif_final,
-	.descsize		= CRC_T10DIF_DIGEST_SIZE,
-
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-arm64-ce",
-	.base.cra_priority	= 200,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-}};
-
 static int __init crc_t10dif_mod_init(void)
 {
 	if (cpu_have_named_feature(PMULL))
-		return crypto_register_shashes(crc_t10dif_alg,
-					       ARRAY_SIZE(crc_t10dif_alg));
+		return crc_t10dif_register(crct10dif_update_pmull_p64,
+					   "crct10dif-arm64-ce");
 	else
-		/* only register the first array element */
-		return crypto_register_shash(crc_t10dif_alg);
+		return crc_t10dif_register(crct10dif_update_pmull_p8,
+					   "crct10dif-arm64-neon");
 }
 
 static void __exit crc_t10dif_mod_exit(void)
 {
-	if (cpu_have_named_feature(PMULL))
-		crypto_unregister_shashes(crc_t10dif_alg,
-					  ARRAY_SIZE(crc_t10dif_alg));
-	else
-		crypto_unregister_shash(crc_t10dif_alg);
+	crc_t10dif_unregister();
 }
 
 module_cpu_feature_match(ASIMD, crc_t10dif_mod_init);
@@ -121,5 +66,5 @@ module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-arm64-ce");
+MODULE_ALIAS("crct10dif-arch");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
2.17.1

