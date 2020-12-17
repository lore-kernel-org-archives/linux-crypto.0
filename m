Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B21DC2BBCD
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57CA233FE
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 22:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbgLQW0V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732078AbgLQW0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 17:26:21 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 07/11] crypto: x86/blake2s - define shash_alg structs using macros
Date:   Thu, 17 Dec 2020 14:21:34 -0800
Message-Id: <20201217222138.170526-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217222138.170526-1-ebiggers@kernel.org>
References: <20201217222138.170526-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The shash_alg structs for the four variants of BLAKE2s are identical
except for the algorithm name, driver name, and digest size.  So, avoid
code duplication by using a macro to define these structs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/blake2s-glue.c | 84 ++++++++++------------------------
 1 file changed, 23 insertions(+), 61 deletions(-)

diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index c025a01cf7084..4dcb2ee89efc9 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -129,67 +129,29 @@ static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg blake2s_algs[] = {{
-	.base.cra_name		= "blake2s-128",
-	.base.cra_driver_name	= "blake2s-128-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_128_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-160",
-	.base.cra_driver_name	= "blake2s-160-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_160_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-224",
-	.base.cra_driver_name	= "blake2s-224-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_224_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}, {
-	.base.cra_name		= "blake2s-256",
-	.base.cra_driver_name	= "blake2s-256-x86",
-	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= BLAKE2S_256_HASH_SIZE,
-	.setkey			= crypto_blake2s_setkey,
-	.init			= crypto_blake2s_init,
-	.update			= crypto_blake2s_update,
-	.final			= crypto_blake2s_final,
-	.descsize		= sizeof(struct blake2s_state),
-}};
+#define BLAKE2S_ALG(name, driver_name, digest_size)			\
+	{								\
+		.base.cra_name		= name,				\
+		.base.cra_driver_name	= driver_name,			\
+		.base.cra_priority	= 200,				\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_blocksize	= BLAKE2S_BLOCK_SIZE,		\
+		.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx), \
+		.base.cra_module	= THIS_MODULE,			\
+		.digestsize		= digest_size,			\
+		.setkey			= crypto_blake2s_setkey,	\
+		.init			= crypto_blake2s_init,		\
+		.update			= crypto_blake2s_update,	\
+		.final			= crypto_blake2s_final,		\
+		.descsize		= sizeof(struct blake2s_state),	\
+	}
+
+static struct shash_alg blake2s_algs[] = {
+	BLAKE2S_ALG("blake2s-128", "blake2s-128-x86", BLAKE2S_128_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-160", "blake2s-160-x86", BLAKE2S_160_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-224", "blake2s-224-x86", BLAKE2S_224_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-256", "blake2s-256-x86", BLAKE2S_256_HASH_SIZE),
+};
 
 static int __init blake2s_mod_init(void)
 {
-- 
2.29.2

