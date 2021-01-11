Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63315C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E5E2242A
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 16:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbhAKQxh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389086AbhAKQxh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 11:53:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB0A22ADF;
        Mon, 11 Jan 2021 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610383976;
        bh=1sXKue0EfaLTfGbGolSyeQaFsOf9FB5CSBB20r3snh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTIqcUHR/Xe1KQN+Cjvq/6quoa+HxCnDNH8wxbMS0t3hEukQTaw2/dcMc6C3Qf0xd
         e1PDAaKHqObTbnuozgyCo0LVRzoeL8Gp/vqCjojq4Y/deRZh322ceqg9Upicsn/qAW
         nvPP0TfnVgeaFKbgOPM2PWjfgyRdUnBfg28lgbpgXAqU83yJ/1b28SBEA+ONGG8x+i
         HX5FVQb+1GKeZtn1+TRAMxl3YbEkvJBq3d09vnk81t+F+fVImyQMDjm/g6OZZS52/I
         H1V90AnEN1mhI6GA8vHW+/kIrnDorL+K99R6B61cpJVvrWYfSiYu3ppHWrC3johyg5
         MskgvZuunBduQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/7] crypto: generic/crc-t10dif - expose both arch and generic shashes
Date:   Mon, 11 Jan 2021 17:52:33 +0100
Message-Id: <20210111165237.18178-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
References: <20210111165237.18178-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to retain the ability to check accelerated implementations of
CRC-T10DIF against the generic C implementation, expose both via the
generic crypto API shash driver. This relies on the arch specific version
to be registered beforehand - this will generally be the case, given that
the modules in question are autoloaded via CPU feature matching, but
let's use a module soft-dependency as well to trigger a load of such
modules if they exist on the system.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/crct10dif_generic.c | 100 ++++++++++++++------
 1 file changed, 72 insertions(+), 28 deletions(-)

diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index e843982073bb..7878eda7513e 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -48,8 +48,8 @@ static int chksum_init(struct shash_desc *desc)
 	return 0;
 }
 
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
+static int chksum_generic_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int length)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
@@ -65,54 +65,97 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
+static int __chksum_generic_finup(__u16 crc, const u8 *data, unsigned int len,
+				  u8 *out)
 {
 	*(__u16 *)out = crc_t10dif_generic(crc, data, len);
 	return 0;
 }
 
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
+static int chksum_generic_finup(struct shash_desc *desc, const u8 *data,
+				unsigned int len, u8 *out)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	return __chksum_finup(ctx->crc, data, len, out);
+	return __chksum_generic_finup(ctx->crc, data, len, out);
 }
 
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
+static int chksum_generic_digest(struct shash_desc *desc, const u8 *data,
+				 unsigned int length, u8 *out)
 {
-	return __chksum_finup(0, data, length, out);
+	return __chksum_generic_finup(0, data, length, out);
 }
 
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
-		.cra_driver_name	=	"crct10dif-generic",
-		.cra_priority		=	100,
-		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		=	THIS_MODULE,
-	}
-};
+static int chksum_arch_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = crc_t10dif_update(ctx->crc, data, length);
+	return 0;
+}
+
+static int __chksum_arch_finup(__u16 crc, const u8 *data, unsigned int len,
+			       u8 *out)
+{
+	*(__u16 *)out = crc_t10dif_update(crc, data, len);
+	return 0;
+}
+
+static int chksum_arch_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksum_arch_finup(ctx->crc, data, len, out);
+}
+
+static int chksum_arch_digest(struct shash_desc *desc, const u8 *data,
+			      unsigned int length, u8 *out)
+{
+	return __chksum_arch_finup(0, data, length, out);
+}
+
+static struct shash_alg algs[] = {{
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= chksum_init,
+	.update			= chksum_generic_update,
+	.final			= chksum_final,
+	.finup			= chksum_generic_finup,
+	.digest			= chksum_generic_digest,
+	.descsize		= sizeof(struct chksum_desc_ctx),
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-generic",
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
+	.init			= chksum_init,
+	.update			= chksum_arch_update,
+	.final			= chksum_final,
+	.finup			= chksum_arch_finup,
+	.digest			= chksum_arch_digest,
+	.descsize		= sizeof(struct chksum_desc_ctx),
+
+	.base.cra_name		= "crct10dif",
+	.base.cra_driver_name	= "crct10dif-arch",
+	.base.cra_priority	= 100,
+	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}};
 
 static int __init crct10dif_mod_init(void)
 {
-	return crypto_register_shash(&alg);
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit crct10dif_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-subsys_initcall(crct10dif_mod_init);
+module_init(crct10dif_mod_init);
 module_exit(crct10dif_mod_fini);
 
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
@@ -120,3 +163,4 @@ MODULE_DESCRIPTION("T10 DIF CRC calculation.");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("crct10dif");
 MODULE_ALIAS_CRYPTO("crct10dif-generic");
+MODULE_SOFTDEP("pre: crct10dif-arch");
-- 
2.17.1

