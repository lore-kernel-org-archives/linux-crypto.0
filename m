Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BC3ECE596
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE432070B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OR7aBirK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfJGQqd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54494 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfJGQqd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so204582wmp.4
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oruMzlzw7GcV2sRKVbWRaila+GettxXX0AhrwqUiGGI=;
        b=OR7aBirKEAL8XGv75qPw86bCueah3VpvtuoUp3Oh0eYMqEjdbhXY9mmOtOLbYfzdI8
         zsmzrspcZfamJ06K5ix1QnVlg2vumBRlfMC3UgZFIBf7jiNZJ4JJyfJ30pd015fWN7Ja
         foScPDNypYFSR/GTPNs1hZSAGn/bCzNKF59EsCGxm+ckqLnh6XaAXz42IpTtT1Qetj8R
         2CjcPG2dGxMs7VlimsdhGFcxx0TTiThyEdZ3zoIzGeBIkXNMPUpveX6ClqI4Upyv49Qq
         E5zuzdKEFqTTw9k2JdR9PDDkuVeaCoS9f+wMHLyhJ4CRgbhG0isC3AXuI9Pv/wiUEMGe
         i2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oruMzlzw7GcV2sRKVbWRaila+GettxXX0AhrwqUiGGI=;
        b=Bzppd8JTIgzd337Z8YjlAOQrCBjObHqz2IVtu657N4ZtLdG6MFt4CY8Cnkw2DjZ9wS
         NAmAsHmE6tA6T+6LSPFJ5DTifu67/eht/hKjpGbq5IEABFsaXWiJYYd+V/OKpJ4TJzY6
         DSkOe03GeQjtJmn/GBw9QE463weNJ8XGc4KYUwWuyruc5QUOhT4wDI8x7IJ5gnNlokI9
         zL96txJCHcdEX72LAWDmfJSt7Gm+m7pyvZ92LnUCX0hMe6Edmif3GPHxW4YKXqzLIgiY
         yn56i4e+39vOJb5i21T4nfo07J6NW49lGITAbjpavWIogWKK9/ebWHuiBeso0WS6A34s
         ZqhA==
X-Gm-Message-State: APjAAAWDAiq3XpGBGA4BwcvpTVLMj/w3KcX1d3JbZQ+ThXdQBpyg//SH
        HEQsQitjlp6qpuXY50yo/qpEhad/m1JSNg==
X-Google-Smtp-Source: APXvYqwbNmTFFjI1dvhyQ0TMBA42Y0Mznp5yUBP+B7iz1deJSCrEUezP7rQRbORMxDKBvDRhyBLT4w==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr172770wmc.106.1570466790311;
        Mon, 07 Oct 2019 09:46:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:29 -0700 (PDT)
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
Subject: [PATCH v3 08/29] crypto: arm/chacha - expose ARM ChaCha routine as library function
Date:   Mon,  7 Oct 2019 18:45:49 +0200
Message-Id: <20191007164610.6881-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/chacha-glue.c | 45 +++++++++++++++++++-
 2 files changed, 44 insertions(+), 2 deletions(-)

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
index 63168e905273..f797601a15a3 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -29,6 +30,8 @@ asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 asmlinkage void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
 			     const u32 *state, int nrounds);
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_neon);
+
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
@@ -55,6 +58,42 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) ||
+	    !static_branch_likely(&use_neon) || !crypto_simd_usable()) {
+		hchacha_block_arm(state, stream, nrounds);
+	} else {
+		kernel_neon_begin();
+		hchacha_block_neon(state, stream, nrounds);
+		kernel_neon_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init);
+
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds)
+{
+	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) ||
+	    !static_branch_likely(&use_neon) ||
+	    bytes <= CHACHA_BLOCK_SIZE || !crypto_simd_usable()) {
+		chacha_doarm(dst, src, bytes, state, nrounds);
+		state[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
+		return;
+	}
+
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
+}
+EXPORT_SYMBOL(chacha_crypt);
+
 static int chacha_stream_xor(struct skcipher_request *req,
 			     const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -108,7 +147,7 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		if (!do_neon) {
+		if (!static_branch_likely(&use_neon) || !do_neon) {
 			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
 				     nbytes, state, ctx->nrounds);
 			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
@@ -160,7 +199,7 @@ static int xchacha_neon(struct skcipher_request *req)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (!crypto_simd_usable()) {
+	if (!static_branch_likely(&use_neon) || !crypto_simd_usable()) {
 		hchacha_block_arm(state, subctx.key, ctx->nrounds);
 	} else {
 		kernel_neon_begin();
@@ -309,6 +348,8 @@ static int __init chacha_simd_mod_init(void)
 			for (i = 0; i < ARRAY_SIZE(neon_algs); i++)
 				neon_algs[i].base.cra_priority = 0;
 			break;
+		default:
+			static_branch_enable(&use_neon);
 		}
 
 		err = crypto_register_skciphers(neon_algs, ARRAY_SIZE(neon_algs));
-- 
2.20.1

