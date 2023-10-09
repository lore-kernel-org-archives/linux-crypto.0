Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902B1E95A8F
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 02:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjJICbk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Oct 2023 22:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjJICbj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Oct 2023 22:31:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378EDA4
        for <linux-crypto@vger.kernel.org>; Sun,  8 Oct 2023 19:31:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB198C433C8
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 02:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696818697;
        bh=Feh/OVxfH+KaiAz1gTi1nyZT5ehS7HxVo07IXTl+OkM=;
        h=From:To:Subject:Date:From;
        b=tuqIKCNfFo098VY1mevounV4okcIAVTdIwC1F98UUVlQg3SE2yKZhuhyBM5d74BZl
         QP55VO+Pn1IbRcgJjXIXKedw0eYJUJjhns5M2cSbnP7H/fT6rgoiH3yyW08dg67Lrq
         HfPmODJZnNwWt+M1BFqtr720KOW8iYQMlrY2+BzR71XrT0lcSntdBcZ+1oeWwcV/TC
         EaxlxJZXr52QKj2eSsOuMBUzXBfJvMMqjBGWvPK7nsckR+54bEljxhhFn9fwrUUWW2
         2FSAgc5Q16L686C5HteenSmmWc0D4zi7bPMEouUK6KwDZKZBJ37wsukDEQSZloDWdD
         b74qqOIsPc6xQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: xts - use 'spawn' for underlying single-block cipher
Date:   Sun,  8 Oct 2023 19:31:16 -0700
Message-ID: <20231009023116.266210-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since commit adad556efcdd ("crypto: api - Fix built-in testing
dependency failures"), the following warning appears when booting an
x86_64 kernel that is configured with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and CONFIG_CRYPTO_AES_NI_INTEL=y,
even when CONFIG_CRYPTO_XTS=y and CONFIG_CRYPTO_AES=y:

    alg: skcipher: skipping comparison tests for xts-aes-aesni because xts(ecb(aes-generic)) is unavailable

This is caused by an issue in the xts template where it allocates an
"aes" single-block cipher without declaring a dependency on it via the
crypto_spawn mechanism.  This issue was exposed by the above commit
because it reversed the order that the algorithms are tested in.

Specifically, when "xts(ecb(aes-generic))" is instantiated and tested
during the comparison tests for "xts-aes-aesni", the "xts" template
allocates an "aes" crypto_cipher for encrypting tweaks.  This resolves
to "aes-aesni".  (Getting "aes-aesni" instead of "aes-generic" here is a
bit weird, but it's apparently intended.)  Due to the above-mentioned
commit, the testing of "aes-aesni", and the finalization of its
registration, now happens at this point instead of before.  At the end
of that, crypto_remove_spawns() unregisters all algorithm instances that
depend on a lower-priority "aes" implementation such as "aes-generic"
but that do not depend on "aes-aesni".  However, because "xts" does not
use the crypto_spawn mechanism for its "aes", its dependency on
"aes-aesni" is not recognized by crypto_remove_spawns().  Thus,
crypto_remove_spawns() unexpectedly unregisters "xts(ecb(aes-generic))".

Fix this issue by making the "xts" template use the crypto_spawn
mechanism for its "aes" dependency, like what other templates do.

Note, this fix could be applied as far back as commit f1c131b45410
("crypto: xts - Convert to skcipher").  However, the issue only got
exposed by the much more recent changes to how the crypto API runs the
self-tests, so there should be no need to backport this to very old
kernels.  Also, an alternative fix would be to flip the list iteration
order in crypto_start_tests() to restore the original testing order.
I'm thinking we should do that too, since the original order seems more
natural, but it shouldn't be relied on for correctness.

Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/xts.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 548b302c6c6a0..2cabf9e657868 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -21,21 +21,21 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
 struct xts_tfm_ctx {
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 };
 
 struct xts_instance_ctx {
 	struct crypto_skcipher_spawn spawn;
-	char name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_cipher_spawn tweak_spawn;
 };
 
 struct xts_request_ctx {
 	le128 t;
 	struct scatterlist *tail;
 	struct scatterlist sg[2];
 	struct skcipher_request subreq;
 };
 
 static int xts_setkey(struct crypto_skcipher *parent, const u8 *key,
@@ -299,21 +299,21 @@ static int xts_init_tfm(struct crypto_skcipher *tfm)
 	struct xts_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *child;
 	struct crypto_cipher *tweak;
 
 	child = crypto_spawn_skcipher(&ictx->spawn);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
 
 	ctx->child = child;
 
-	tweak = crypto_alloc_cipher(ictx->name, 0, 0);
+	tweak = crypto_spawn_cipher(&ictx->tweak_spawn);
 	if (IS_ERR(tweak)) {
 		crypto_free_skcipher(ctx->child);
 		return PTR_ERR(tweak);
 	}
 
 	ctx->tweak = tweak;
 
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
 					 sizeof(struct xts_request_ctx));
 
@@ -326,29 +326,31 @@ static void xts_exit_tfm(struct crypto_skcipher *tfm)
 
 	crypto_free_skcipher(ctx->child);
 	crypto_free_cipher(ctx->tweak);
 }
 
 static void xts_free_instance(struct skcipher_instance *inst)
 {
 	struct xts_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->spawn);
+	crypto_drop_cipher(&ictx->tweak_spawn);
 	kfree(inst);
 }
 
 static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
 	struct xts_instance_ctx *ctx;
 	struct skcipher_alg *alg;
 	const char *cipher_name;
+	char name[CRYPTO_MAX_ALG_NAME];
 	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
 		return PTR_ERR(cipher_name);
@@ -356,27 +358,27 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 
 	ctx = skcipher_instance_ctx(inst);
 
 	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
 				   cipher_name, 0, mask);
 	if (err == -ENOENT) {
 		err = -ENAMETOOLONG;
-		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
+		if (snprintf(name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
 
 		err = crypto_grab_skcipher(&ctx->spawn,
 					   skcipher_crypto_instance(inst),
-					   ctx->name, 0, mask);
+					   name, 0, mask);
 	}
 
 	if (err)
 		goto err_free_inst;
 
 	alg = crypto_skcipher_spawn_alg(&ctx->spawn);
 
 	err = -EINVAL;
 	if (alg->base.cra_blocksize != XTS_BLOCK_SIZE)
 		goto err_free_inst;
@@ -391,37 +393,42 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -EINVAL;
 	cipher_name = alg->base.cra_name;
 
 	/* Alas we screwed up the naming so we have to mangle the
 	 * cipher name.
 	 */
 	if (!strncmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(ctx->name, cipher_name + 4, sizeof(ctx->name));
+		len = strscpy(name, cipher_name + 4, sizeof(name));
 		if (len < 2)
 			goto err_free_inst;
 
-		if (ctx->name[len - 1] != ')')
+		if (name[len - 1] != ')')
 			goto err_free_inst;
 
-		ctx->name[len - 1] = 0;
+		name[len - 1] = 0;
 
 		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "xts(%s)", ctx->name) >= CRYPTO_MAX_ALG_NAME) {
+			     "xts(%s)", name) >= CRYPTO_MAX_ALG_NAME) {
 			err = -ENAMETOOLONG;
 			goto err_free_inst;
 		}
 	} else
 		goto err_free_inst;
 
+	err = crypto_grab_cipher(&ctx->tweak_spawn,
+				 skcipher_crypto_instance(inst), name, 0, mask);
+	if (err)
+		goto err_free_inst;
+
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = XTS_BLOCK_SIZE;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask |
 				       (__alignof__(u64) - 1);
 
 	inst->alg.ivsize = XTS_BLOCK_SIZE;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) * 2;
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) * 2;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct xts_tfm_ctx);

base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20
-- 
2.42.0

