Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E192EC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D662070B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgLWINf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727712AbgLWINe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:13:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C5922482;
        Wed, 23 Dec 2020 08:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711173;
        bh=/JOeDVsRKecFgqhYuedJ9WzTU2siPkilHRHczO28l8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wl+Ffinee7BFY+nx97KgW6rOgIk0E4ofkHa8ND6e9IkVmfxdQeHGdZC7eCYC43wjZ
         hIMltVJ7HwHBms18VmDXcKdN2IgzHSha0X20Eq9ywO9UPIsEV4fQSn4A8F4IE+Ofog
         fex3tPySB78CEZYDRsGlAQlhSIsYk2r4WqsrZAraEdV3vQ1C0W6WKFH8Qw9GkEb35s
         GKvTuyARJzf0hufuL03J4tohT78ekFCq2c6QF6qursb7vYCiXUv7qI5uv29lc1LiQp
         jFpdNRpGbT3NdYqxwAP8PSfbmclIo1BR6FHipG3Yag9RH1LOr6wSJmhnNghAV8EnZP
         iIQOMTDTlvsZg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 01/14] crypto: blake2s - define shash_alg structs using macros
Date:   Wed, 23 Dec 2020 00:09:50 -0800
Message-Id: <20201223081003.373663-2-ebiggers@kernel.org>
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
 crypto/blake2s_generic.c | 88 ++++++++++++----------------------------
 1 file changed, 27 insertions(+), 61 deletions(-)

diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index 005783ff45ad0..e3aa6e7ff3d83 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -83,67 +83,33 @@ static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static struct shash_alg blake2s_algs[] = {{
-	.base.cra_name		= "blake2s-128",
-	.base.cra_driver_name	= "blake2s-128-generic",
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
-	.base.cra_driver_name	= "blake2s-160-generic",
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
-	.base.cra_driver_name	= "blake2s-224-generic",
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
-	.base.cra_driver_name	= "blake2s-256-generic",
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
+		.base.cra_priority	= 100,				\
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
+	BLAKE2S_ALG("blake2s-128", "blake2s-128-generic",
+		    BLAKE2S_128_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-160", "blake2s-160-generic",
+		    BLAKE2S_160_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-224", "blake2s-224-generic",
+		    BLAKE2S_224_HASH_SIZE),
+	BLAKE2S_ALG("blake2s-256", "blake2s-256-generic",
+		    BLAKE2S_256_HASH_SIZE),
+};
 
 static int __init blake2s_mod_init(void)
 {
-- 
2.29.2

