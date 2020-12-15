Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EB8C2BBD4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED20F22D05
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgLPABf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgLOXyb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:31 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH 2/5] crypto: blake2b - define shash_alg structs using macros
Date:   Tue, 15 Dec 2020 15:47:05 -0800
Message-Id: <20201215234708.105527-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201215234708.105527-1-ebiggers@kernel.org>
References: <20201215234708.105527-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The shash_alg structs for the four variants of BLAKE2b are identical
except for the algorithm name, driver name, and digest size.  So, avoid
code duplication by using a macro to define these structs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2b_generic.c | 82 ++++++++++++----------------------------
 1 file changed, 25 insertions(+), 57 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 83942f511075e..0e38e3e48297c 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -236,64 +236,32 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg blake2b_algs[] = {
-	{
-		.base.cra_name		= "blake2b-160",
-		.base.cra_driver_name	= "blake2b-160-generic",
-		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_160_HASH_SIZE,
-		.setkey			= blake2b_setkey,
-		.init			= blake2b_init,
-		.update			= blake2b_update,
-		.final			= blake2b_final,
-		.descsize		= sizeof(struct blake2b_state),
-	}, {
-		.base.cra_name		= "blake2b-256",
-		.base.cra_driver_name	= "blake2b-256-generic",
-		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_256_HASH_SIZE,
-		.setkey			= blake2b_setkey,
-		.init			= blake2b_init,
-		.update			= blake2b_update,
-		.final			= blake2b_final,
-		.descsize		= sizeof(struct blake2b_state),
-	}, {
-		.base.cra_name		= "blake2b-384",
-		.base.cra_driver_name	= "blake2b-384-generic",
-		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_384_HASH_SIZE,
-		.setkey			= blake2b_setkey,
-		.init			= blake2b_init,
-		.update			= blake2b_update,
-		.final			= blake2b_final,
-		.descsize		= sizeof(struct blake2b_state),
-	}, {
-		.base.cra_name		= "blake2b-512",
-		.base.cra_driver_name	= "blake2b-512-generic",
-		.base.cra_priority	= 100,
-		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.digestsize		= BLAKE2B_512_HASH_SIZE,
-		.setkey			= blake2b_setkey,
-		.init			= blake2b_init,
-		.update			= blake2b_update,
-		.final			= blake2b_final,
-		.descsize		= sizeof(struct blake2b_state),
+#define BLAKE2B_ALG(name, driver_name, digest_size)			\
+	{								\
+		.base.cra_name		= name,				\
+		.base.cra_driver_name	= driver_name,			\
+		.base.cra_priority	= 100,				\
+		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,	\
+		.base.cra_blocksize	= BLAKE2B_BLOCK_SIZE,		\
+		.base.cra_ctxsize	= sizeof(struct blake2b_tfm_ctx), \
+		.base.cra_module	= THIS_MODULE,			\
+		.digestsize		= digest_size,			\
+		.setkey			= blake2b_setkey,		\
+		.init			= blake2b_init,			\
+		.update			= blake2b_update,		\
+		.final			= blake2b_final,		\
+		.descsize		= sizeof(struct blake2b_state),	\
 	}
+
+static struct shash_alg blake2b_algs[] = {
+	BLAKE2B_ALG("blake2b-160", "blake2b-160-generic",
+		    BLAKE2B_160_HASH_SIZE),
+	BLAKE2B_ALG("blake2b-256", "blake2b-256-generic",
+		    BLAKE2B_256_HASH_SIZE),
+	BLAKE2B_ALG("blake2b-384", "blake2b-384-generic",
+		    BLAKE2B_384_HASH_SIZE),
+	BLAKE2B_ALG("blake2b-512", "blake2b-512-generic",
+		    BLAKE2B_512_HASH_SIZE),
 };
 
 static int __init blake2b_mod_init(void)
-- 
2.29.2

