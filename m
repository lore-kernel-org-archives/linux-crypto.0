Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A7C433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C8A221F1
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600275109;
	bh=8acf8dUH6GiKq8Ed33yHe0O0HLMpSsQM/jVHtUreTmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E55k+DQKfRlwIBdgWLAWeZZj8je/mP0earrMSV6pRap7fxnLvB4Kko7hhmIdyRlOi
	 hiad4iUQgyp6vo4LF/JiD9jsLKIecFBwsyYjDpaftFKl9tYBGAVOSygSRrFHREz8/s
	 vuV1pmQzgCGd7xJemtZs3W+sxZQFafTa1aQWR/JQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgIPQvf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 12:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgIPQd2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 12:33:28 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA0CB21D90;
        Wed, 16 Sep 2020 12:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600259817;
        bh=8acf8dUH6GiKq8Ed33yHe0O0HLMpSsQM/jVHtUreTmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsJ97UW/s6BtwtRf12CuusLiINQ/p/sQEI9nZHq6A5PuwcXI8/NcxwEevNogz3jff
         CKbX96zC2JTUMS0BcYnitK+es5Cr61GDKARUKy4fFVAETk70eDXhUr18k5ux2OM8j7
         mpa6HlLeK8+T2RuICcy/QgwvsHUCQx7myE1IsO6Q=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/3] crypto: arm/aes-neonbs - use typed init/exit routines for XTS
Date:   Wed, 16 Sep 2020 15:36:42 +0300
Message-Id: <20200916123642.20805-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916123642.20805-1-ardb@kernel.org>
References: <20200916123642.20805-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the typed skcipher init/exit routines instead of the generic
cra_init/_exit routines when instantiating/releasing the XTS
skciphers.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/aes-neonbs-glue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index e1603ec7e815..bda8bf17631e 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -314,9 +314,9 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return aesbs_setkey(tfm, in_key, key_len);
 }
 
-static int xts_init(struct crypto_tfm *tfm)
+static int xts_init(struct crypto_skcipher *tfm)
 {
-	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->cts_tfm = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(ctx->cts_tfm))
@@ -329,9 +329,9 @@ static int xts_init(struct crypto_tfm *tfm)
 	return PTR_ERR_OR_ZERO(ctx->tweak_tfm);
 }
 
-static void xts_exit(struct crypto_tfm *tfm)
+static void xts_exit(struct crypto_skcipher *tfm)
 {
-	struct aesbs_xts_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_cipher(ctx->tweak_tfm);
 	crypto_free_cipher(ctx->cts_tfm);
@@ -493,8 +493,6 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_ctxsize	= sizeof(struct aesbs_xts_ctx),
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-	.base.cra_init		= xts_init,
-	.base.cra_exit		= xts_exit,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
@@ -503,6 +501,8 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= aesbs_xts_setkey,
 	.encrypt		= xts_encrypt,
 	.decrypt		= xts_decrypt,
+	.init			= xts_init,
+	.exit			= xts_exit,
 } };
 
 static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
-- 
2.17.1

