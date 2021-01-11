Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5392BC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181BB22AAD
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbhAKQyQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387574AbhAKQyP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:54:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AC8E22BED;
        Mon, 11 Jan 2021 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383983;
        bh=M7+Zu321ZKbQuqu/bQyhrejFbYMgPSTQhX6ej4RnGKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbTPZD+cOFCZQ1KZizzjgCbiKxWG/RTuXvLdzlTApBKLgKDKCjw4m6tfmZ758Qx0w
         PBTkxKq7r1043sP2G+dxEVdH0QULIjKEr38e/EjLSZt5V/A05HwyKhQpr36Z7bomlv
         P8PRucXXtaolRxlxRS13MpZQd3RV1wzMKisk+26JR+RxiXQNXz/tp4/u7+t+y2EtLZ
         10CR0YCRQX6JSNMhxDN/ra7qCL7ZOHGzfV7dxC0/PLcwuDR34wkJKEg5CHqz7XliXT
         rRnkK93vxHbZZcO4aLSIhhKQsV5H97UNVvRg3ib9eU5Oyf6lukSjwWbnHPl74Omgax
         S+K71x6t2jC8w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 7/7] crypto: powerpc/crc-t10dif - convert to static call API
Date:   Mon, 11 Jan 2021 17:52:37 +0100
Message-Id: <20210111165237.18178-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Get rid of the shash boilerplate, and register the accelerated PowerPC
version of the CRC-T10DIF algorithm with the library interface instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c | 51 ++------------------
 1 file changed, 4 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
index 1dc8b6915178..26c7da181018 100644
--- a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -61,59 +60,17 @@ static u16 crct10dif_vpmsum(u16 crci, unsigned char const *p, size_t len)
 	return crc & 0xffff;
 }
 
-static int crct10dif_vpmsum_init(struct shash_desc *desc)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = 0;
-	return 0;
-}
-
-static int crct10dif_vpmsum_update(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = crct10dif_vpmsum(*crc, data, length);
-
-	return 0;
-}
-
-
-static int crct10dif_vpmsum_final(struct shash_desc *desc, u8 *out)
-{
-	u16 *crcp = shash_desc_ctx(desc);
-
-	*(u16 *)out = *crcp;
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.init		= crct10dif_vpmsum_init,
-	.update		= crct10dif_vpmsum_update,
-	.final		= crct10dif_vpmsum_final,
-	.descsize	= CRC_T10DIF_DIGEST_SIZE,
-	.digestsize	= CRC_T10DIF_DIGEST_SIZE,
-	.base		= {
-		.cra_name		= "crct10dif",
-		.cra_driver_name	= "crct10dif-vpmsum",
-		.cra_priority		= 200,
-		.cra_blocksize		= CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		= THIS_MODULE,
-	}
-};
-
 static int __init crct10dif_vpmsum_mod_init(void)
 {
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		return -ENODEV;
 
-	return crypto_register_shash(&alg);
+	return crc_t10dif_register(crct10dif_vpmsum, "crct10dif-vpmsum");
 }
 
 static void __exit crct10dif_vpmsum_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crc_t10dif_unregister();
 }
 
 module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, crct10dif_vpmsum_mod_init);
@@ -122,5 +79,5 @@ module_exit(crct10dif_vpmsum_mod_fini);
 MODULE_AUTHOR("Daniel Axtens <dja@axtens.net>");
 MODULE_DESCRIPTION("CRCT10DIF using vector polynomial multiply-sum instructions");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-vpmsum");
+MODULE_ALIAS("crct10dif-arch");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
2.17.1

