Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4B0FA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 684C121835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="euKOtiAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503384AbfJQTKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37728 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503387AbfJQTKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so3682721wmc.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1BZFKQh4dFsI0CY4Tdkg4GCkEZnZ05oiXvCaqESz0Zg=;
        b=euKOtiAb8QNlVFl1X8LHJcEXBTt2rh2H+/nPek23rT4MPsktA+/uYWD13kXR9p8ZBV
         j1Yu87tUaqLpCI6cE1NYcCJQ9i8rXkiG0GCyizIvtjRbURvFw6oqWxQ0pcKeRq81Uy9l
         Suksb5j/41PCc8lp8EpfF7eOjLXgSHP50aYj0/ktaOQSRxQTtL0RRDSHyO9MocEacb9s
         D5iOB/tzn9kuGu6doDCEW7CxclB0n0blSNuTEtV0mDK9rGNWtRk1OhuLZvQaLSyWWIJb
         xaNtyzvugFx4LIKv0X6l0oMco1pGZAwxQ1SCkEw3Gyu/PoAkwAeX7Vc9H3LjED8N6SR7
         izWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1BZFKQh4dFsI0CY4Tdkg4GCkEZnZ05oiXvCaqESz0Zg=;
        b=sc1PxBkv1BoTD3+MEtAG2uApv/chxwtbSp/ERyMK/J9PSbLqUdb0tVFr0636kkCPL0
         MNGZ3f8tMJehY7+mnFgT1ViJabrhqNjUiVd1ksr/mZtdeGg27ZhiqHfiGTcT0lYqRAyr
         y+0mZEItU4IZly6KcMcjnFmH9CIuZLi+E9J/6NdcU5HkQB3kcSLzvJG97SCEWw+RNhjl
         2w9Kyz3or9jKY7NbzxJhp0wS7TyjGyVlM/WPvAYjLH853Tb69Eq1Nw5RUEpwhZL/8KZa
         rRSAPeqoXGbWlPf7VRvVR0sNQ1s4rPjxWWvgXLcju4LcPwHzgN5nUJ5OWynvX0kLA8zp
         RnfQ==
X-Gm-Message-State: APjAAAXH+RxZVg0gbKmma/Pm+FTSWAWz0+vvLx/MQ/u92Kww1RTriYQt
        2H18yBKPH+2B9Nq08etqVpnkXHMieX3zOz9Y
X-Google-Smtp-Source: APXvYqzvjaIzBsDwnIqRekfEdTTksP1ZXqqzVpNocB2wuS+ZzE+LsywzV+Y73XAuZsDeY94tF7urAw==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr4395274wmc.14.1571339404242;
        Thu, 17 Oct 2019 12:10:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:03 -0700 (PDT)
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
Subject: [PATCH v4 09/35] crypto: arm/chacha - expose ARM ChaCha routine as library function
Date:   Thu, 17 Oct 2019 21:09:06 +0200
Message-Id: <20191017190932.1947-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the accelerated NEON ChaCha routine directly as a symbol
export so that users of the ChaCha library API can use it directly.

Given that calls into the library API will always go through the
routines in this module if it is enabled, switch to static keys
to select the optimal implementation available (which may be none
at all, in which case we defer to the generic implementation for
all invocations).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig       |  1 +
 arch/arm/crypto/chacha-glue.c | 41 +++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index a31b0b95548d..265da3801e4f 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -128,6 +128,7 @@ config CRYPTO_CRC32_ARM_CE
 config CRYPTO_CHACHA20_NEON
 	tristate "NEON and scalar accelerated ChaCha stream cipher algorithms"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NEON accelerated NHPoly1305 hash function (for Adiantum)"
diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 2c0f76bc08b2..fc6e69184d59 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -29,9 +30,11 @@ asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 asmlinkage void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
 			     const u32 *state, int nrounds);
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_neon);
+
 static inline bool neon_usable(void)
 {
-	return crypto_simd_usable();
+	return static_branch_likely(&use_neon) && crypto_simd_usable();
 }
 
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
@@ -60,6 +63,40 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable()) {
+		hchacha_block_arm(state, stream, nrounds);
+	} else {
+		kernel_neon_begin();
+		hchacha_block_neon(state, stream, nrounds);
+		kernel_neon_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block_arch);
+
+void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init_arch);
+
+void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		       int nrounds)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable() ||
+	    bytes <= CHACHA_BLOCK_SIZE) {
+		chacha_doarm(dst, src, bytes, state, nrounds);
+		state[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
+		return;
+	}
+
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
+}
+EXPORT_SYMBOL(chacha_crypt_arch);
+
 static int chacha_stream_xor(struct skcipher_request *req,
 			     const struct chacha_ctx *ctx, const u8 *iv,
 			     bool neon)
@@ -281,6 +318,8 @@ static int __init chacha_simd_mod_init(void)
 			for (i = 0; i < ARRAY_SIZE(neon_algs); i++)
 				neon_algs[i].base.cra_priority = 0;
 			break;
+		default:
+			static_branch_enable(&use_neon);
 		}
 
 		err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
-- 
2.20.1

