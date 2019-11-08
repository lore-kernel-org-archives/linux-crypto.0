Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A94C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEF2022499
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215852;
	bh=cV74xX0ftqZsH6EzildD6b19XNhPMTioWb6JBxE3NRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=P/KSytj4zq+TslK4MVo8tbiPNc2jqmMLxHfpsl2VNds9atINXzxYhkzS5f6N4MXyA
	 X42n0aZFZnyBEY4bn4k2btm9igIGdS3Qxr3TRrUW5bu+ax1OWRNO9TYirWCH6OCf1P
	 xb14/L0CBcoC+jrP89ULs1K4MpJNJnPquFXGq5co=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732516AbfKHMYM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732457AbfKHMYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:24:12 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A3F222490;
        Fri,  8 Nov 2019 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215850;
        bh=cV74xX0ftqZsH6EzildD6b19XNhPMTioWb6JBxE3NRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXdOU02jz4ejQ+1AQJm2ctXzkrsW7j5j3l4SgAXTwZeZSo3rz1hUagnrSTBjqrtnm
         2VoaGYSh1VMvUb6tnxi6dnEzTzcwRiaNcXgiQbxRdV2hyEiOe+mBFWGIcOC7cwjIMO
         2bX5aCo8OM8jrs8dMFkYvcaEKtM/gfHmUAR1Duqw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 24/34] crypto: blake2s - implement generic shash driver
Date:   Fri,  8 Nov 2019 13:22:30 +0100
Message-Id: <20191108122240.28479-25-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire up our newly added Blake2s implementation via the shash API.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig                    |  18 +++
 crypto/Makefile                   |   1 +
 crypto/blake2s_generic.c          | 171 ++++++++++++++++++++
 include/crypto/internal/blake2s.h |   5 +
 4 files changed, 195 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2668eed03c5f..3c23187eeeb1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -656,6 +656,24 @@ config CRYPTO_BLAKE2B
 
 	  See https://blake2.net for further information.
 
+config CRYPTO_BLAKE2S
+	tristate "BLAKE2s digest algorithm"
+	select CRYPTO_LIB_BLAKE2S_GENERIC
+	select CRYPTO_HASH
+	help
+	  Implementation of cryptographic hash function BLAKE2s
+	  optimized for 8-32bit platforms and can produce digests of any size
+	  between 1 to 32.  The keyed hash is also implemented.
+
+	  This module provides the following algorithms:
+
+	  - blake2s-128
+	  - blake2s-160
+	  - blake2s-224
+	  - blake2s-256
+
+	  See https://blake2.net for further information.
+
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index efe63940b4e9..e30d6271e0f3 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
+obj-$(CONFIG_CRYPTO_BLAKE2S) += blake2s_generic.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
new file mode 100644
index 000000000000..ed0c74640470
--- /dev/null
+++ b/crypto/blake2s_generic.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <crypto/internal/blake2s.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/hash.h>
+
+#include <linux/types.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static int crypto_blake2s_setkey(struct crypto_shash *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(tfm);
+
+	if (keylen == 0 || keylen > BLAKE2S_KEY_SIZE) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	memcpy(tctx->key, key, keylen);
+	tctx->keylen = keylen;
+
+	return 0;
+}
+
+static int crypto_blake2s_init(struct shash_desc *desc)
+{
+	struct blake2s_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	const int outlen = crypto_shash_digestsize(desc->tfm);
+
+	if (tctx->keylen)
+		blake2s_init_key(state, outlen, tctx->key, tctx->keylen);
+	else
+		blake2s_init(state, outlen);
+
+	return 0;
+}
+
+static int crypto_blake2s_update(struct shash_desc *desc, const u8 *in,
+				 unsigned int inlen)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
+
+	if (unlikely(!inlen))
+		return 0;
+	if (inlen > fill) {
+		memcpy(state->buf + state->buflen, in, fill);
+		blake2s_compress_generic(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
+		state->buflen = 0;
+		in += fill;
+		inlen -= fill;
+	}
+	if (inlen > BLAKE2S_BLOCK_SIZE) {
+		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
+		/* Hash one less (full) block than strictly possible */
+		blake2s_compress_generic(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
+		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
+	}
+	memcpy(state->buf + state->buflen, in, inlen);
+	state->buflen += inlen;
+
+	return 0;
+}
+
+static int crypto_blake2s_final(struct shash_desc *desc, u8 *out)
+{
+	struct blake2s_state *state = shash_desc_ctx(desc);
+
+	blake2s_set_lastblock(state);
+	memset(state->buf + state->buflen, 0,
+	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
+	blake2s_compress_generic(state, state->buf, 1, state->buflen);
+	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
+	memcpy(out, state->h, state->outlen);
+	memzero_explicit(state, sizeof(*state));
+
+	return 0;
+}
+
+static struct shash_alg blake2s_algs[] = {{
+	.base.cra_name		= "blake2s-128",
+	.base.cra_driver_name	= "blake2s-128-generic",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
+	.base.cra_priority	= 200,
+	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= BLAKE2S_128_HASH_SIZE,
+	.setkey			= crypto_blake2s_setkey,
+	.init			= crypto_blake2s_init,
+	.update			= crypto_blake2s_update,
+	.final			= crypto_blake2s_final,
+	.descsize		= sizeof(struct blake2s_state),
+}, {
+	.base.cra_name		= "blake2s-160",
+	.base.cra_driver_name	= "blake2s-160-generic",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
+	.base.cra_priority	= 200,
+	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= BLAKE2S_160_HASH_SIZE,
+	.setkey			= crypto_blake2s_setkey,
+	.init			= crypto_blake2s_init,
+	.update			= crypto_blake2s_update,
+	.final			= crypto_blake2s_final,
+	.descsize		= sizeof(struct blake2s_state),
+}, {
+	.base.cra_name		= "blake2s-224",
+	.base.cra_driver_name	= "blake2s-224-generic",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
+	.base.cra_priority	= 200,
+	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= BLAKE2S_224_HASH_SIZE,
+	.setkey			= crypto_blake2s_setkey,
+	.init			= crypto_blake2s_init,
+	.update			= crypto_blake2s_update,
+	.final			= crypto_blake2s_final,
+	.descsize		= sizeof(struct blake2s_state),
+}, {
+	.base.cra_name		= "blake2s-256",
+	.base.cra_driver_name	= "blake2s-256-generic",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_ctxsize	= sizeof(struct blake2s_tfm_ctx),
+	.base.cra_priority	= 200,
+	.base.cra_blocksize     = BLAKE2S_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+
+	.digestsize		= BLAKE2S_256_HASH_SIZE,
+	.setkey			= crypto_blake2s_setkey,
+	.init			= crypto_blake2s_init,
+	.update			= crypto_blake2s_update,
+	.final			= crypto_blake2s_final,
+	.descsize		= sizeof(struct blake2s_state),
+}};
+
+static int __init blake2s_mod_init(void)
+{
+	return crypto_register_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+}
+
+static void __exit blake2s_mod_exit(void)
+{
+	crypto_unregister_shashes(blake2s_algs, ARRAY_SIZE(blake2s_algs));
+}
+
+subsys_initcall(blake2s_mod_init);
+module_exit(blake2s_mod_exit);
+
+MODULE_ALIAS_CRYPTO("blake2s-128");
+MODULE_ALIAS_CRYPTO("blake2s-128-generic");
+MODULE_ALIAS_CRYPTO("blake2s-160");
+MODULE_ALIAS_CRYPTO("blake2s-160-generic");
+MODULE_ALIAS_CRYPTO("blake2s-224");
+MODULE_ALIAS_CRYPTO("blake2s-224-generic");
+MODULE_ALIAS_CRYPTO("blake2s-256");
+MODULE_ALIAS_CRYPTO("blake2s-256-generic");
+MODULE_LICENSE("GPL v2");
diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
index 941693effc7d..74ff77032e52 100644
--- a/include/crypto/internal/blake2s.h
+++ b/include/crypto/internal/blake2s.h
@@ -5,6 +5,11 @@
 
 #include <crypto/blake2s.h>
 
+struct blake2s_tfm_ctx {
+	u8 key[BLAKE2S_KEY_SIZE];
+	unsigned int keylen;
+};
+
 void blake2s_compress_generic(struct blake2s_state *state,const u8 *block,
 			      size_t nblocks, const u32 inc);
 
-- 
2.20.1

