Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED51FC433E9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 16:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC53323124
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 16:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgLVQI4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 11:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbgLVQI4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 11:08:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47398229C6;
        Tue, 22 Dec 2020 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608653295;
        bh=1qEDt73l2lvqf/QsBzA4dX9WhWOGcn8Pwy++s2khGz4=;
        h=From:To:Cc:Subject:Date:From;
        b=U9s87Ii65VYkAfHgiNnV5TxmlbPE05lnurbE2BccW93q2jpYi2Ac1QB1+5gwd8h0i
         86RlG4CLXeR0e46DeOUIGl7wPQ6VByD/cDv1iSrEtgdFk4fkVqVx95a8//WPWDVM3P
         ISJsdckGXDHjgeCtcdpJciNenz1WkwBkexJDA6tkBcKEuntaIQKYulMlmTFuRvy8M4
         XF0bN8E9+imhQjjKKzhjfRB2dxuciFmDt8YTDTDdBNcs8FrNTOtrA74tKhcWpPI4l5
         Q/2A62JEWQk0pUBHIPV5ZYJckqX1qrrJ0IcTqjhdE3FKZSFQ15DJSaNxmtTQkBNP2F
         9y2ezhhaQ0O1A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: x86/aes-ni-xts - recover and improve performance
Date:   Tue, 22 Dec 2020 17:06:27 +0100
Message-Id: <20201222160629.22268-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES-NI implementation of XTS was impacted significantly by the retpoline
changes, which is due to the fact that both its asm helper and the chaining
mode glue library use indirect calls for processing small quantitities of
data

So let's fix this, by:
- creating a minimal, backportable fix that recovers most of the performance,
  by reducing the number of indirect calls substantially;
- for future releases, rewrite the XTS implementation completely, and replace
  the glue helper with a core asm routine that is more flexible, making the C
  code wrapper much more straight-forward.

This results in a substantial performance improvement: around ~2x for 1k and
4k blocks, and more than 3x for ~1k blocks that require ciphertext stealing
(benchmarked using tcrypt using 1420 byte blocks - full results below)

It also allows us to enable the same driver for i386.

Cc: Megha Dey <megha.dey@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (2):
  crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
  crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper

 arch/x86/crypto/aesni-intel_asm.S  | 353 ++++++++++++++++----
 arch/x86/crypto/aesni-intel_glue.c | 230 +++++++------
 2 files changed, 412 insertions(+), 171 deletions(-)

-- 
2.17.1

Benchmarked using tcrypt on a Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
Requires patch below to get tcrypt to benchmark 1420 byte blocks.

BEFORE

testing speed of async xts(aes) (xts-aes-aesni) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 8030565 operations in 1 seconds (128489040 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 4760527 operations in 1 seconds (304673728 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 5250541 operations in 1 seconds (1344138496 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 2163398 operations in 1 seconds (2215319552 bytes)
tcrypt: test 4 (256 bit key, 1420 byte blocks): 1036396 operations in 1 seconds (1471682320 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 568192 operations in 1 seconds (2327314432 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 7916395 operations in 1 seconds (126662320 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 4783114 operations in 1 seconds (306119296 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 4916568 operations in 1 seconds (1258641408 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 1898349 operations in 1 seconds (1943909376 bytes)
tcrypt: test 10 (512 bit key, 1420 byte blocks): 970328 operations in 1 seconds (1377865760 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 499687 operations in 1 seconds (2046717952 bytes)


AFTER

testing speed of async xts(aes) (xts-aes-aesni) encryption
tcrypt: test 0 (256 bit key, 16 byte blocks): 11977048 operations in 1 seconds (191632768 bytes)
tcrypt: test 1 (256 bit key, 64 byte blocks): 10504479 operations in 1 seconds (672286656 bytes)
tcrypt: test 2 (256 bit key, 256 byte blocks): 7929809 operations in 1 seconds (2030031104 bytes)
tcrypt: test 3 (256 bit key, 1024 byte blocks): 3992118 operations in 1 seconds (4087928832 bytes)
tcrypt: test 4 (256 bit key, 1420 byte blocks): 3160481 operations in 1 seconds (4487883020 bytes)
tcrypt: test 5 (256 bit key, 4096 byte blocks): 1240437 operations in 1 seconds (5080829952 bytes)
tcrypt: test 6 (512 bit key, 16 byte blocks): 11694652 operations in 1 seconds (187114432 bytes)
tcrypt: test 7 (512 bit key, 64 byte blocks): 9739536 operations in 1 seconds (623330304 bytes)
tcrypt: test 8 (512 bit key, 256 byte blocks): 6833613 operations in 1 seconds (1749404928 bytes)
tcrypt: test 9 (512 bit key, 1024 byte blocks): 3121421 operations in 1 seconds (3196335104 bytes)
tcrypt: test 10 (512 bit key, 1420 byte blocks): 2421563 operations in 1 seconds (3438619460 bytes)
tcrypt: test 11 (512 bit key, 4096 byte blocks): 941964 operations in 1 seconds (3858284544 bytes)


diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2054cd6f55cf..ac8b0d087927 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -994,12 +994,13 @@ static struct skcipher_alg aesni_skciphers[] = {
 			.cra_driver_name	= "__xts-aes-aesni",
 			.cra_priority		= 401,
 			.cra_flags		= CRYPTO_ALG_INTERNAL,
-			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_blocksize		= 1,//AES_BLOCK_SIZE,
 			.cra_ctxsize		= XTS_AES_CTX_SIZE,
 			.cra_module		= THIS_MODULE,
 		},
 		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.chunksize	= AES_BLOCK_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
 		.setkey		= xts_aesni_setkey,
 		.encrypt	= xts_encrypt,
diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..7ade682f1241 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -416,11 +416,12 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
+	inst->alg.base.cra_blocksize = 1,//XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
 				       (__alignof__(u64) - 1);
 
 	inst->alg.ivsize = XTS_BLOCK_SIZE;
+	inst->alg.chunksize = XTS_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;
 
