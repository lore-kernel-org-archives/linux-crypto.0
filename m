Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AAAECE58C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A0020700
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zwWzZMuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfJGQqc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42496 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfJGQqc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id n14so16108727wrw.9
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NfX7i47p39yo/RVW8huYsh6QVmLLRY0IasIXMWLibVA=;
        b=zwWzZMuvYw5Wx0+9S7bOBeJVYoUpODrr85/N8lNDXkwKKcCAXTWZyytbbUcjXyb9Ex
         C09e3MMiBROgk0cBv7Ly50tUSXz8yB/+yA77m6eyYg5UsZhuzpiqxbShf4CTxoEvt6qK
         RhdylO+86VHbMH/voY15Mq5NHQ0VB6z8fSUB1ma1wdx/wdHKuKBXTKQzL0EnMp7GMONc
         Vle/Gu9O8e9zIFtp38pa5iz6pc4HMv9igESZb6zJfb8ulQk2qtVRL/NGBRlumzWzF7U3
         uN0mZhcBvXu8U6FrM7SHDb9zPDPMARyOlOsAOHEpn9h5m25Y+TODlUszPV0Ta+hQmAEV
         vDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NfX7i47p39yo/RVW8huYsh6QVmLLRY0IasIXMWLibVA=;
        b=iiXA6j2E9dHPyyNNiZAgksG84wEqHzI9LubDMzeN/+k8Q62r/SaxAmVHdYAkJgxSq+
         mt9QeF1NwR5hOyP2btz/wNg41jO90DrsRO2klWN9wPswnDFniFHKhekKddnu52QgQBxR
         3bE1TgwyXv5PWWD74UM2zmMqXSEUv/H5SjzoYfND4wxWAhlrUisY3KewSrEzArT/FPbj
         6jrML7rbciR187/pj4mrtrTM3WTmXLMenSSqzmPBjYeFIL0bCsH0HAt0sME7hlKyNWAN
         5JywNDfABGzWd4/JrTPaGnMoGZkvr0GFYkcODcDLeoLQy98q2Nz1+VcPjXkj3xvwvA8E
         qqXQ==
X-Gm-Message-State: APjAAAUeVCdGq5uAUbSnMHPXSXcrgOilqn2OGSFfJG0ZlCBc2ojgiH7C
        F7FvuSHouTszSFF3My8PLdnaS0mqgfqEEQ==
X-Google-Smtp-Source: APXvYqyI1d8Giul2E+Vp2ipkpIGsNHHxd10+PlNckAwZ2GaIoT53zcRGrxGr/QjmZMldoKexpu3VVw==
X-Received: by 2002:a05:6000:160e:: with SMTP id u14mr23184959wrb.29.1570466788751;
        Mon, 07 Oct 2019 09:46:28 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:27 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 07/29] crypto: arm/chacha - remove dependency on generic ChaCha driver
Date:   Mon,  7 Oct 2019 18:45:48 +0200
Message-Id: <20191007164610.6881-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of falling back to the generic ChaCha skcipher driver for
non-SIMD cases, use a fast scalar implementation for ARM authored
by Eric Biggers. This removes the module dependency on chacha-generic
altogether, which also simplifies things when we expose the ChaCha
library interface from this module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig              |   4 +-
 arch/arm/crypto/Makefile             |   3 +-
 arch/arm/crypto/chacha-glue.c        | 344 ++++++++++++++++++++
 arch/arm/crypto/chacha-neon-glue.c   | 202 ------------
 arch/arm/crypto/chacha-scalar-core.S |  65 ++--
 5 files changed, 379 insertions(+), 239 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b24df84a1d7a..a31b0b95548d 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -126,10 +126,8 @@ config CRYPTO_CRC32_ARM_CE
 	select CRYPTO_HASH
 
 config CRYPTO_CHACHA20_NEON
-	tristate "NEON accelerated ChaCha stream cipher algorithms"
-	depends on KERNEL_MODE_NEON
+	tristate "NEON and scalar accelerated ChaCha stream cipher algorithms"
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NEON accelerated NHPoly1305 hash function (for Adiantum)"
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 4180f3a13512..6b97dffcf90f 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -53,7 +53,8 @@ aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
 crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
 crc32-arm-ce-y:= crc32-ce-core.o crc32-ce-glue.o
-chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
+chacha-neon-y := chacha-scalar-core.o chacha-glue.o
+chacha-neon-$(CONFIG_KERNEL_MODE_NEON) += chacha-neon-core.o
 nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
 
 ifdef REGENERATE_ARM_CRYPTO
diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
new file mode 100644
index 000000000000..63168e905273
--- /dev/null
+++ b/arch/arm/crypto/chacha-glue.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM NEON accelerated ChaCha and XChaCha stream ciphers,
+ * including ChaCha20 (RFC7539)
+ *
+ * Copyright (C) 2016-2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2015 Martin Willi
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/chacha.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <asm/cputype.h>
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+
+asmlinkage void chacha_block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
+				      int nrounds);
+asmlinkage void chacha_4block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
+				       int nrounds);
+asmlinkage void hchacha_block_arm(const u32 *state, u32 *out, int nrounds);
+asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
+
+asmlinkage void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
+			     const u32 *state, int nrounds);
+
+static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
+			  unsigned int bytes, int nrounds)
+{
+	u8 buf[CHACHA_BLOCK_SIZE];
+
+	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
+		chacha_4block_xor_neon(state, dst, src, nrounds);
+		bytes -= CHACHA_BLOCK_SIZE * 4;
+		src += CHACHA_BLOCK_SIZE * 4;
+		dst += CHACHA_BLOCK_SIZE * 4;
+		state[12] += 4;
+	}
+	while (bytes >= CHACHA_BLOCK_SIZE) {
+		chacha_block_xor_neon(state, dst, src, nrounds);
+		bytes -= CHACHA_BLOCK_SIZE;
+		src += CHACHA_BLOCK_SIZE;
+		dst += CHACHA_BLOCK_SIZE;
+		state[12]++;
+	}
+	if (bytes) {
+		memcpy(buf, src, bytes);
+		chacha_block_xor_neon(state, buf, buf, nrounds);
+		memcpy(dst, buf, bytes);
+	}
+}
+
+static int chacha_stream_xor(struct skcipher_request *req,
+			     const struct chacha_ctx *ctx, const u8 *iv)
+{
+	struct skcipher_walk walk;
+	u32 state[16];
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	chacha_init_generic(state, ctx->key, iv);
+
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
+			     nbytes, state, ctx->nrounds);
+		state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
+static int chacha_arm(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return chacha_stream_xor(req, ctx, req->iv);
+}
+
+static int chacha_neon_stream_xor(struct skcipher_request *req,
+				  const struct chacha_ctx *ctx, const u8 *iv)
+{
+	struct skcipher_walk walk;
+	u32 state[16];
+	bool do_neon;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	chacha_init_generic(state, ctx->key, iv);
+
+	do_neon = (req->cryptlen > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
+		if (!do_neon) {
+			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
+				     nbytes, state, ctx->nrounds);
+			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
+		} else {
+			kernel_neon_begin();
+			chacha_doneon(state, walk.dst.virt.addr,
+				      walk.src.virt.addr, nbytes, ctx->nrounds);
+			kernel_neon_end();
+		}
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+	}
+
+	return err;
+}
+
+static int chacha_neon(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	return chacha_neon_stream_xor(req, ctx, req->iv);
+}
+
+static int xchacha_arm(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct chacha_ctx subctx;
+	u32 state[16];
+	u8 real_iv[16];
+
+	chacha_init_generic(state, ctx->key, req->iv);
+
+	hchacha_block_arm(state, subctx.key, ctx->nrounds);
+	subctx.nrounds = ctx->nrounds;
+
+	memcpy(&real_iv[0], req->iv + 24, 8);
+	memcpy(&real_iv[8], req->iv + 16, 8);
+	return chacha_stream_xor(req, &subctx, real_iv);
+}
+
+static int xchacha_neon(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct chacha_ctx subctx;
+	u32 state[16];
+	u8 real_iv[16];
+
+	chacha_init_generic(state, ctx->key, req->iv);
+
+	if (!crypto_simd_usable()) {
+		hchacha_block_arm(state, subctx.key, ctx->nrounds);
+	} else {
+		kernel_neon_begin();
+		hchacha_block_neon(state, subctx.key, ctx->nrounds);
+		kernel_neon_end();
+	}
+	subctx.nrounds = ctx->nrounds;
+
+	memcpy(&real_iv[0], req->iv + 24, 8);
+	memcpy(&real_iv[8], req->iv + 16, 8);
+	return chacha_neon_stream_xor(req, &subctx, real_iv);
+}
+
+static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 20);
+}
+
+static int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 12);
+}
+
+static struct skcipher_alg arm_algs[] = {
+	{
+		.base.cra_name		= "chacha20",
+		.base.cra_driver_name	= "chacha20-arm",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= CHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.setkey			= chacha20_setkey,
+		.encrypt		= chacha_arm,
+		.decrypt		= chacha_arm,
+	}, {
+		.base.cra_name		= "xchacha20",
+		.base.cra_driver_name	= "xchacha20-arm",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.setkey			= chacha20_setkey,
+		.encrypt		= xchacha_arm,
+		.decrypt		= xchacha_arm,
+	}, {
+		.base.cra_name		= "xchacha12",
+		.base.cra_driver_name	= "xchacha12-arm",
+		.base.cra_priority	= 200,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.setkey			= chacha12_setkey,
+		.encrypt		= xchacha_arm,
+		.decrypt		= xchacha_arm,
+	},
+};
+
+static struct skcipher_alg neon_algs[] = {
+	{
+		.base.cra_name		= "chacha20",
+		.base.cra_driver_name	= "chacha20-neon",
+		.base.cra_priority	= 300,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= CHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= chacha20_setkey,
+		.encrypt		= chacha_neon,
+		.decrypt		= chacha_neon,
+	}, {
+		.base.cra_name		= "xchacha20",
+		.base.cra_driver_name	= "xchacha20-neon",
+		.base.cra_priority	= 300,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= chacha20_setkey,
+		.encrypt		= xchacha_neon,
+		.decrypt		= xchacha_neon,
+	}, {
+		.base.cra_name		= "xchacha12",
+		.base.cra_driver_name	= "xchacha12-neon",
+		.base.cra_priority	= 300,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.setkey			= chacha12_setkey,
+		.encrypt		= xchacha_neon,
+		.decrypt		= xchacha_neon,
+	}
+};
+
+static int __init chacha_simd_mod_init(void)
+{
+	int err;
+
+	err = crypto_register_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+	if (err)
+		return err;
+
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON)) {
+		int i;
+
+		switch (read_cpuid_part()) {
+		case ARM_CPU_PART_CORTEX_A7:
+		case ARM_CPU_PART_CORTEX_A5:
+			/*
+			 * The Cortex-A7 and Cortex-A5 do not perform well with
+			 * the NEON implementation but do incredibly with the
+			 * scalar one and use less power.
+			 */
+			for (i = 0; i < ARRAY_SIZE(neon_algs); i++)
+				neon_algs[i].base.cra_priority = 0;
+			break;
+		}
+
+		err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
+		if (err)
+			crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+	}
+	return err;
+}
+
+static void __exit chacha_simd_mod_fini(void)
+{
+	crypto_unregister_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON))
+		crypto_unregister_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
+}
+
+module_init(chacha_simd_mod_init);
+module_exit(chacha_simd_mod_fini);
+
+MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (scalar and NEON accelerated)");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("chacha20");
+MODULE_ALIAS_CRYPTO("chacha20-arm");
+MODULE_ALIAS_CRYPTO("xchacha20");
+MODULE_ALIAS_CRYPTO("xchacha20-arm");
+MODULE_ALIAS_CRYPTO("xchacha12");
+MODULE_ALIAS_CRYPTO("xchacha12-arm");
+#ifdef CONFIG_KERNEL_MODE_NEON
+MODULE_ALIAS_CRYPTO("chacha20-neon");
+MODULE_ALIAS_CRYPTO("xchacha20-neon");
+MODULE_ALIAS_CRYPTO("xchacha12-neon");
+#endif
diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
deleted file mode 100644
index 26576772f18b..000000000000
--- a/arch/arm/crypto/chacha-neon-glue.c
+++ /dev/null
@@ -1,202 +0,0 @@
-/*
- * ARM NEON accelerated ChaCha and XChaCha stream ciphers,
- * including ChaCha20 (RFC7539)
- *
- * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on:
- * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/chacha.h>
-#include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-
-asmlinkage void chacha_block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
-				      int nrounds);
-asmlinkage void chacha_4block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
-				       int nrounds);
-asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
-
-static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
-			  unsigned int bytes, int nrounds)
-{
-	u8 buf[CHACHA_BLOCK_SIZE];
-
-	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-		chacha_4block_xor_neon(state, dst, src, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE * 4;
-		src += CHACHA_BLOCK_SIZE * 4;
-		dst += CHACHA_BLOCK_SIZE * 4;
-		state[12] += 4;
-	}
-	while (bytes >= CHACHA_BLOCK_SIZE) {
-		chacha_block_xor_neon(state, dst, src, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE;
-		src += CHACHA_BLOCK_SIZE;
-		dst += CHACHA_BLOCK_SIZE;
-		state[12]++;
-	}
-	if (bytes) {
-		memcpy(buf, src, bytes);
-		chacha_block_xor_neon(state, buf, buf, nrounds);
-		memcpy(dst, buf, bytes);
-	}
-}
-
-static int chacha_neon_stream_xor(struct skcipher_request *req,
-				  const struct chacha_ctx *ctx, const u8 *iv)
-{
-	struct skcipher_walk walk;
-	u32 state[16];
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	crypto_chacha_init(state, ctx, iv);
-
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
-
-		kernel_neon_begin();
-		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes, ctx->nrounds);
-		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
-}
-
-static int chacha_neon(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_chacha_crypt(req);
-
-	return chacha_neon_stream_xor(req, ctx, req->iv);
-}
-
-static int xchacha_neon(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct chacha_ctx subctx;
-	u32 state[16];
-	u8 real_iv[16];
-
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_xchacha_crypt(req);
-
-	crypto_chacha_init(state, ctx, req->iv);
-
-	kernel_neon_begin();
-	hchacha_block_neon(state, subctx.key, ctx->nrounds);
-	kernel_neon_end();
-	subctx.nrounds = ctx->nrounds;
-
-	memcpy(&real_iv[0], req->iv + 24, 8);
-	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_neon_stream_xor(req, &subctx, real_iv);
-}
-
-static struct skcipher_alg algs[] = {
-	{
-		.base.cra_name		= "chacha20",
-		.base.cra_driver_name	= "chacha20-neon",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= CHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= chacha_neon,
-		.decrypt		= chacha_neon,
-	}, {
-		.base.cra_name		= "xchacha20",
-		.base.cra_driver_name	= "xchacha20-neon",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= xchacha_neon,
-		.decrypt		= xchacha_neon,
-	}, {
-		.base.cra_name		= "xchacha12",
-		.base.cra_driver_name	= "xchacha12-neon",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
-
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.walksize		= 4 * CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha12_setkey,
-		.encrypt		= xchacha_neon,
-		.decrypt		= xchacha_neon,
-	}
-};
-
-static int __init chacha_simd_mod_init(void)
-{
-	if (!(elf_hwcap & HWCAP_NEON))
-		return -ENODEV;
-
-	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
-}
-
-static void __exit chacha_simd_mod_fini(void)
-{
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
-}
-
-module_init(chacha_simd_mod_init);
-module_exit(chacha_simd_mod_fini);
-
-MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (NEON accelerated)");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("chacha20");
-MODULE_ALIAS_CRYPTO("chacha20-neon");
-MODULE_ALIAS_CRYPTO("xchacha20");
-MODULE_ALIAS_CRYPTO("xchacha20-neon");
-MODULE_ALIAS_CRYPTO("xchacha12");
-MODULE_ALIAS_CRYPTO("xchacha12-neon");
diff --git a/arch/arm/crypto/chacha-scalar-core.S b/arch/arm/crypto/chacha-scalar-core.S
index 2140319b64a0..0970ae107590 100644
--- a/arch/arm/crypto/chacha-scalar-core.S
+++ b/arch/arm/crypto/chacha-scalar-core.S
@@ -41,14 +41,6 @@
 	X14	.req	r12
 	X15	.req	r14
 
-.Lexpand_32byte_k:
-	// "expand 32-byte k"
-	.word	0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
-
-#ifdef __thumb2__
-#  define adrl adr
-#endif
-
 .macro __rev		out, in,  t0, t1, t2
 .if __LINUX_ARM_ARCH__ >= 6
 	rev		\out, \in
@@ -391,61 +383,65 @@
 .endm	// _chacha
 
 /*
- * void chacha20_arm(u8 *out, const u8 *in, size_t len, const u32 key[8],
- *		     const u32 iv[4]);
+ * void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
+ *		     u32 *state, int nrounds);
  */
-ENTRY(chacha20_arm)
+ENTRY(chacha_doarm)
 	cmp		r2, #0			// len == 0?
 	reteq		lr
 
+	ldr		ip, [sp]
+	cmp		ip, #12
+
 	push		{r0-r2,r4-r11,lr}
 
 	// Push state x0-x15 onto stack.
 	// Also store an extra copy of x10-x11 just before the state.
 
-	ldr		r4, [sp, #48]		// iv
-	mov		r0, sp
-	sub		sp, #80
-
-	// iv: x12-x15
-	ldm		r4, {X12,X13,X14,X15}
-	stmdb		r0!, {X12,X13,X14,X15}
+	add		X12, r3, #48
+	ldm		X12, {X12,X13,X14,X15}
+	push		{X12,X13,X14,X15}
+	sub		sp, sp, #64
 
-	// key: x4-x11
-	__ldrd		X8_X10, X9_X11, r3, 24
+	__ldrd		X8_X10, X9_X11, r3, 40
 	__strd		X8_X10, X9_X11, sp, 8
-	stmdb		r0!, {X8_X10, X9_X11}
-	ldm		r3, {X4-X9_X11}
-	stmdb		r0!, {X4-X9_X11}
-
-	// constants: x0-x3
-	adrl		X3, .Lexpand_32byte_k
-	ldm		X3, {X0-X3}
+	__strd		X8_X10, X9_X11, sp, 56
+	ldm		r3, {X0-X9_X11}
 	__strd		X0, X1, sp, 16
 	__strd		X2, X3, sp, 24
+	__strd		X4, X5, sp, 32
+	__strd		X6, X7, sp, 40
+	__strd		X8_X10, X9_X11, sp, 48
 
+	beq		1f
 	_chacha		20
 
-	add		sp, #76
+0:	add		sp, #76
 	pop		{r4-r11, pc}
-ENDPROC(chacha20_arm)
+
+1:	_chacha		12
+	b		0b
+ENDPROC(chacha_doarm)
 
 /*
- * void hchacha20_arm(const u32 state[16], u32 out[8]);
+ * void hchacha_block_arm(const u32 state[16], u32 out[8], int nrounds);
  */
-ENTRY(hchacha20_arm)
+ENTRY(hchacha_block_arm)
 	push		{r1,r4-r11,lr}
 
+	cmp		r2, #12			// ChaCha12 ?
+
 	mov		r14, r0
 	ldmia		r14!, {r0-r11}		// load x0-x11
 	push		{r10-r11}		// store x10-x11 to stack
 	ldm		r14, {r10-r12,r14}	// load x12-x15
 	sub		sp, #8
 
+	beq		1f
 	_chacha_permute	20
 
 	// Skip over (unused0-unused1, x10-x11)
-	add		sp, #16
+0:	add		sp, #16
 
 	// Fix up rotations of x12-x15
 	ror		X12, X12, #drot
@@ -458,4 +454,7 @@ ENTRY(hchacha20_arm)
 	stm		r4, {X0,X1,X2,X3,X12,X13,X14,X15}
 
 	pop		{r4-r11,pc}
-ENDPROC(hchacha20_arm)
+
+1:	_chacha_permute	12
+	b		0b
+ENDPROC(hchacha_block_arm)
-- 
2.20.1

