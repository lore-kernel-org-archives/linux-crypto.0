Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A307EFA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FE421925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mgVxfcan"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503402AbfJQTKf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46452 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503401AbfJQTKe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so3565601wrv.13
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VeTscAH7qXCH6lFksvt1TqtwSxZKXaqXGgVPc2ULCIo=;
        b=mgVxfcanRL35asSXPUcVnqf/+ZpWkwcbbQdcSjvlZep4CA52X0UWhbqxK8KnJZZDb5
         33h8ERiu/GxknmAvOKhHSgTpq5H06RxGfvFRMCw/YfELm9sLa7n3Gyrp/JaEI2h6Cmxa
         BsPOZNKS2fBWIRTRNyIAgXg1JxiUJopVBTIuK63bMnVIxexE/qYt7dGKTg7NukoPyOU6
         HY9vyqWxv79GqVQ1hSlgoe5Vw4uRlxkN+zkT0pWDbXt8Q72yUAgN5+quL0790PTWSPXm
         N+BNMuzBWV0Ul47BHpmRDjK6ZsdtZkxFflknmqDGLD51UHOaEyXiajGVoDz1fACZXAp3
         vO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VeTscAH7qXCH6lFksvt1TqtwSxZKXaqXGgVPc2ULCIo=;
        b=NOMdNS2wdjZgZmn/HxtXEYTcV3O0xXMt4IQtSn7ckdO90Aq/vaOmc0vBeJeHZgiYIt
         ig89EHzNmf45bzwpIIa0PNhK04h6SArccCk3kk+yFhg2mmrZw7E2ifO8U43x0n6kDnjB
         VtdmG/uKDv6DB7JX48Kd+bNFucjeqlFvnE7O3Y2uaaU42jUoPk0e3gT+/FyzkXRI/+bF
         riaFuf/VYSCJ7K4993BnU8kKfBQGdnDFM6xBjxToG/WboHlwcQMZ3u2YrV2hL87M8zNR
         CGy9KsohWVWoXDFaBsYChsycK/Ol1U+JWFcptRbJ5p+rhklKPrHWqCTsbm+1FoNAPBA1
         tLgg==
X-Gm-Message-State: APjAAAUo2FSglcJTcWb1pSOlAKEkbUkala+HaFBbhV0F7oei2TVXCDgQ
        SdHmDu3E56B53cBxkUQ/Md9ZvJQVh7AxkY3W
X-Google-Smtp-Source: APXvYqxM4ykaljuZArP0CKlsR+IlkdD9dOiPVqF8/ikNhtxUl7jL11gExpz4CIwdFBNcsLjk/Xhddg==
X-Received: by 2002:adf:e74b:: with SMTP id c11mr4219795wrn.250.1571339431463;
        Thu, 17 Oct 2019 12:10:31 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:30 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 24/35] crypto: blake2s - implement generic shash driver
Date:   Thu, 17 Oct 2019 21:09:21 +0200
Message-Id: <20191017190932.1947-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire up our newly added Blake2s implementation via the shash API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig                    |   4 +
 crypto/Makefile                   |   1 +
 crypto/blake2s-generic.c          | 171 ++++++++++++++++++++
 include/crypto/internal/blake2s.h |   5 +
 4 files changed, 181 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9fc0f722f1b2..c0f299279df8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1021,6 +1021,10 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 	  This is the x86_64 CLMUL-NI accelerated implementation of
 	  GHASH, the hash function used in GCM (Galois/Counter mode).
 
+config CRYPTO_BLAKE2S
+	tristate "BLAKE2s hash function"
+	select CRYPTO_LIB_BLAKE2S_GENERIC
+
 comment "Ciphers"
 
 config CRYPTO_AES
diff --git a/crypto/Makefile b/crypto/Makefile
index aa740c8492b9..ecc69a726460 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 crypto_user-y := crypto_user_base.o
 crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
+obj-$(CONFIG_CRYPTO_BLAKE2S) += blake2s-generic.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
diff --git a/crypto/blake2s-generic.c b/crypto/blake2s-generic.c
new file mode 100644
index 000000000000..ed0c74640470
--- /dev/null
+++ b/crypto/blake2s-generic.c
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

