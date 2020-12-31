Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8951EC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F07920795
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 16:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgLaQmp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 11:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgLaQmp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 11:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 744FD20798;
        Thu, 31 Dec 2020 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609432924;
        bh=gALniMUSs2DvymYTnIhGco9GudAx5geJ0b9iioQM+UM=;
        h=From:To:Cc:Subject:Date:From;
        b=hi1tyo1rrG0cUFwBX8om/k33B1CfE8VTUKH0tFhLvYhueomRb7BJJq7SVfJ2/4y2c
         0SQahNyqLEfJFf/4ZeA+Tli4DI9XCnhkVQ/r3RdopaNEkT65sASDGkkYaHZq4yQ/o5
         kvOQt1r4gZctep1As7x5RB4MKP70gkGgiDHxSR/kIMp7YEaD7yBe3z6KtNpjlrbpnt
         VArwTdQcBBeZvSkfpa2HxF/VzJhAOvFkyk1SNLuBk7Gns5VRKJViIczMBLWgfJB2IV
         191sCtXuJ/A8moFpKoQzZKLZIcyMrsdeAxvMnrfLbAW1xgWV7l7GJCofH4PCQz6Evt
         JOSzN53hU3CJw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v2 0/2] crypto: x86/aes-ni-xts - recover and improve performance
Date:   Thu, 31 Dec 2020 17:41:53 +0100
Message-Id: <20201231164155.21792-1-ardb@kernel.org>
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

Changes since v1:
- use 'test LEN, LEN' instead of 'cmp $0, LEN' to get shorter opcodes, as
  suggested by Uros
- rebase to get rid of false dependencies on other changes that are in flight.

NOTE: patch #2 depends on [0], which provides the permutation table used for
      ciphertext stealing

[0] https://lore.kernel.org/linux-crypto/20201207233402.17472-1-ardb@kernel.org/

Cc: Megha Dey <megha.dey@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uros Bizjak <ubizjak@gmail.com>

Ard Biesheuvel (2):
  crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
  crypto: x86/aes-ni-xts - rewrite and drop indirections via glue helper

 arch/x86/crypto/aesni-intel_asm.S  | 353 ++++++++++++++++----
 arch/x86/crypto/aesni-intel_glue.c | 229 +++++++------
 crypto/Kconfig                     |   1 -
 3 files changed, 411 insertions(+), 172 deletions(-)

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
                        .cra_driver_name        = "__xts-aes-aesni",
                        .cra_priority           = 401,
                        .cra_flags              = CRYPTO_ALG_INTERNAL,
-                       .cra_blocksize          = AES_BLOCK_SIZE,
+                       .cra_blocksize          = 1,//AES_BLOCK_SIZE,
                        .cra_ctxsize            = XTS_AES_CTX_SIZE,
                        .cra_module             = THIS_MODULE,
                },
                .min_keysize    = 2 * AES_MIN_KEY_SIZE,
                .max_keysize    = 2 * AES_MAX_KEY_SIZE,
+               .chunksize      = AES_BLOCK_SIZE,
                .ivsize         = AES_BLOCK_SIZE,
                .setkey         = xts_aesni_setkey,
                .encrypt        = xts_encrypt,
diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..7ade682f1241 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -416,11 +416,12 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
                goto err_free_inst;

        inst->alg.base.cra_priority = alg->base.cra_priority;
-       inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
+       inst->alg.base.cra_blocksize = 1,//XTS_BLOCK_SIZE;
        inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
                                       (__alignof__(u64) - 1);

        inst->alg.ivsize = XTS_BLOCK_SIZE;
+       inst->alg.chunksize = XTS_BLOCK_SIZE;
        inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
        inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;
