Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72686C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7032242A
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389098AbhAKQxj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389086AbhAKQxj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:53:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 257EB22B30;
        Mon, 11 Jan 2021 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383978;
        bh=bDMPvU8UNU86OkjcEmn2+senxHqtQ5Y473/EwGLnoI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7M53jAAcVKo1ZOMeLfLeZPJwEvn/bAtaWxYSu1gLnIMfhX1TmqVIVu3jNCn1StD0
         iSvdT9n8Iq6MzxoNLdkAmIIHsAW3B9kJNQ+ghEopNXA26Fn9NuEYep3aORIs6K82CQ
         0H61NDs5EW3JcGRUKcVagBBTy9AsrmWtiW6XHvNDwOF2XhSkb0FwPyBUttz+EbEUpB
         r2DENp7N5gYwhykjqSY0rr1hiUcrSpPXHbVYDzRh3jZFVmuQM9NbM1yF2Q90pjOwOh
         pUor2XFcvL5ZdVGRer9RoIn8FLhfbJp7gPowmZw8hG6EWelE+fwHvSr+/HlgP6eoYV
         jCqMTXLjfdUZw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/7] crypto: x86/crc-t10dif - convert to static call library API
Date:   Mon, 11 Jan 2021 17:52:34 +0100
Message-Id: <20210111165237.18178-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Get rid of the shash boilerplate, and register the accelerated x86
version of the CRC-T10DIF algorithm with the library interface instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/crct10dif-pclmul_glue.c | 90 +++-----------------
 1 file changed, 10 insertions(+), 80 deletions(-)

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 71291d5af9f4..6f06499d96a3 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -25,7 +25,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/string.h>
@@ -36,82 +35,17 @@
 
 asmlinkage u16 crc_t10dif_pcl(u16 init_crc, const u8 *buf, size_t len);
 
-struct chksum_desc_ctx {
-	__u16 crc;
-};
-
-static int chksum_init(struct shash_desc *desc)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = 0;
-
-	return 0;
-}
-
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	if (length >= 16 && crypto_simd_usable()) {
-		kernel_fpu_begin();
-		ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
-		kernel_fpu_end();
-	} else
-		ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_final(struct shash_desc *desc, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*(__u16 *)out = ctx->crc;
-	return 0;
-}
-
-static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
+static u16 crc_t10dif_x86(u16 crc, const u8 *data, size_t len)
 {
 	if (len >= 16 && crypto_simd_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(crc, data, len);
+		crc = crc_t10dif_pcl(crc, data, len);
 		kernel_fpu_end();
-	} else
-		*(__u16 *)out = crc_t10dif_generic(crc, data, len);
-	return 0;
-}
-
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(ctx->crc, data, len, out);
-}
-
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
-{
-	return __chksum_finup(0, data, length, out);
-}
-
-static struct shash_alg alg = {
-	.digestsize		=	CRC_T10DIF_DIGEST_SIZE,
-	.init		=	chksum_init,
-	.update		=	chksum_update,
-	.final		=	chksum_final,
-	.finup		=	chksum_finup,
-	.digest		=	chksum_digest,
-	.descsize		=	sizeof(struct chksum_desc_ctx),
-	.base			=	{
-		.cra_name		=	"crct10dif",
-		.cra_driver_name	=	"crct10dif-pclmul",
-		.cra_priority		=	200,
-		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		=	THIS_MODULE,
+	} else {
+		crc = crc_t10dif_generic(crc, data, len);
 	}
-};
+	return crc;
+}
 
 static const struct x86_cpu_id crct10dif_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL),
@@ -121,15 +55,12 @@ MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
 
 static int __init crct10dif_intel_mod_init(void)
 {
-	if (!x86_match_cpu(crct10dif_cpu_id))
-		return -ENODEV;
-
-	return crypto_register_shash(&alg);
+	return crc_t10dif_register(crc_t10dif_x86, "crct10dif-pclmul");
 }
 
 static void __exit crct10dif_intel_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crc_t10dif_unregister();
 }
 
 module_init(crct10dif_intel_mod_init);
@@ -138,6 +69,5 @@ module_exit(crct10dif_intel_mod_fini);
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
 MODULE_DESCRIPTION("T10 DIF CRC calculation accelerated with PCLMULQDQ.");
 MODULE_LICENSE("GPL");
-
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-pclmul");
+MODULE_ALIAS("crct10dif-arch");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
-- 
2.17.1

