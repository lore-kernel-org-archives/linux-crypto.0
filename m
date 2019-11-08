Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B2AC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C4322459
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215808;
	bh=Xir3CVB2oU2ezdIq8SEqCS7R5rQQwFz2gkTA2vDwxC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nB7RStXN/6YlGJVRlAjDWaoauq6VXN9vL8s91seIjbC+42Y84jsEl0MjYMfx0d84W
	 4MzbYTI5bQCYQ9KNYR7QabX/Wm2s7yyMY9UVyb15OiUoyXnLOh0eZDZYB0m1/cvMEg
	 r2fJbX7xzRwBT4NiPct7FiWRSuLt3PfxJmSrjdF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbfKHMX2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732314AbfKHMX2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:28 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED4D222D4;
        Fri,  8 Nov 2019 12:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215807;
        bh=Xir3CVB2oU2ezdIq8SEqCS7R5rQQwFz2gkTA2vDwxC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwmWnT7aU5IH35Bbiiv+IamZOUiEMNu3tDmb5J9lO76XKcgRQbD+xLePlxAXSwjNe
         cHcI0zD/ZI2i1z0/v5B9OMA9cjYAFGIJdu+jGy1/yzjKqMMLTeYw+1WkIsD1WXmMVm
         VpDXd1aLycoaY5BxF2zms44bVdrxZer5EymLjfiQ=
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
Subject: [PATCH v5 09/34] crypto: arm/chacha - expose ARM ChaCha routine as library function
Date:   Fri,  8 Nov 2019 13:22:15 +0100
Message-Id: <20191108122240.28479-10-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
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

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/Kconfig       |  1 +
 arch/arm/crypto/chacha-glue.c | 41 +++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 43452009ebd4..4d13b5201796 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -130,6 +130,7 @@ config CRYPTO_CRC32_ARM_CE
 config CRYPTO_CHACHA20_NEON
 	tristate "NEON and scalar accelerated ChaCha stream cipher algorithms"
 	select CRYPTO_SKCIPHER
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NEON accelerated NHPoly1305 hash function (for Adiantum)"
diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index eb40efb3eb34..3f0c057aa050 100644
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
@@ -269,6 +306,8 @@ static int __init chacha_simd_mod_init(void)
 			for (i = 0; i < ARRAY_SIZE(neon_algs); i++)
 				neon_algs[i].base.cra_priority = 0;
 			break;
+		default:
+			static_branch_enable(&use_neon);
 		}
 
 		err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
-- 
2.20.1

