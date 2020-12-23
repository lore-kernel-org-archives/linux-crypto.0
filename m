Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D73C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE5C522482
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgLWINf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgLWINf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 048B1224B0;
        Wed, 23 Dec 2020 08:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711174;
        bh=AwolWcU1J9aB45wmv29fRS/pK38QTPj+/7OvPBNmghs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl6T8XcJDi8VRbKkup4cgCKOYtpu9bkypOmsem76aK04D66bNx12XkRQBh34AzWJ6
         skwBlyJTJf724l2kw7h43nbKBF6WG2ePRq/4iYbea9EzshxWZeWnFgI0ipdlaavO6b
         Q5dKyDyjGMC3lTxO7JKWjsU4rTiLt4Ir364ET1rqLWJkNb4HM3M7UJySJuTa303xvf
         1dDWjKc6ejT4oPIsFDknL6WQSTSXlzK18bsEKLlSWAyfe37mvZ3v8KDZf13CUObjKy
         EAqxgxmk13uvAKj0ekXpLJedzztG754ahTsBQkMc+snhT0JUQQvNrKPfutMD96vT8z
         G4TuNdtAlx04g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 02/14] crypto: x86/blake2s - define shash_alg structs using macros
Date:   Wed, 23 Dec 2020 00:09:51 -0800
Message-Id: <20201223081003.373663-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The shash_alg structs for the four variants of BLAKE2s are identical
except for the algorithm name, driver name, and digest size.  So, avoid
code duplication by using a macro to define these structs.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
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

