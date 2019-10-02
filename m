Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937DBC35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A267222C0
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B+lm8R/n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfJBORo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52801 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfJBORn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so7410765wmh.2
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9eoG0Ja/MkKdV4fIyrYwW1AyCVa60yb4N0sHgj42YTs=;
        b=B+lm8R/nN/ZWjtHJoIeJNWQxYFloKyi1DRQo8Ky/B8LNhnhVxligrSXzQdCWBJvZHZ
         8gRjC3oe8686Iha7gOdKkCj3/QtNBsIQw632s7nA2hxw5awYOp/UVJXyUhHCBDZvthfy
         sS51VSaokdKNQJRAhc1jBg+JPWlV/K0VpaXQ0KGtRdA0Ost8du9jjqYJa/wqgImMARog
         QDdEmNhwMtoMOdRV+1yh02s2LwT6EzmLAMZr4sCo7feIsgUl6KApHFsW1wC4Es8hOEoh
         hkihIRQRp8qiGqdO8YYMcbhWoxTRN7IooneWfm8Rx1l8STr+56YmzHRfYqv8ozVRPJVn
         WbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9eoG0Ja/MkKdV4fIyrYwW1AyCVa60yb4N0sHgj42YTs=;
        b=H5YSnrQzlEN3Fv7yATUEfoyXIEjJyd/KOb8iuEdEZhTglm1SZ+tPIYdCSiNwgSXuZL
         EGy92h+BkPuZqzkyk+x9gLxa3BrlKT5vkwnya4t1AAlUMtHFI2GrvTUF4nDFFZ+PNe64
         WSgO95Y1HwOnQ3HNynUnCnoMdytjZ1z38Ct6V/NkDlnY9Na/IluH3RQ9lAA3S+U0SwyS
         vZUsP+4kp1EM+8w+Bjn9uWsT7xosD+YnlIWj0RnjCt/yNQrZyoEiKlJc7jI6e3Ymx/zV
         aytPdg7NrJ+jXlOKEZjqbf3MN20PyMnnSM3Div3345xuJ4ZNx8Hr9NZRtHfYACmLo3Pn
         5P0g==
X-Gm-Message-State: APjAAAX1ls3GQr4XGdk3hJhEsHj+uyMtGQSRgLB80rXlGGb53pJEZb0j
        JxwvAXcUTsi0O7zZVm2yce58hfPcPL0KSMoU
X-Google-Smtp-Source: APXvYqx2jSDqFkEG0V1c9ieZBWD4ZB279jmvaZYLiBkr52PdQhmLUrASDchxLjfBa9SyUojhMMmBKw==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr3033643wmd.1.1570025861369;
        Wed, 02 Oct 2019 07:17:41 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 02/20] crypto: x86/chacha - expose SIMD ChaCha routine as library function
Date:   Wed,  2 Oct 2019 16:16:55 +0200
Message-Id: <20191002141713.31189-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire the existing x86 SIMD ChaCha code into the new ChaCha library
interface.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha_glue.c | 36 ++++++++++++++++++++
 crypto/Kconfig                |  1 +
 include/crypto/chacha.h       |  6 ++++
 3 files changed, 43 insertions(+)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index bc62daa8dafd..fd9ef42842cf 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -123,6 +123,42 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	if (!crypto_simd_usable()) {
+		hchacha_block_generic(state, stream, nrounds);
+	} else {
+		kernel_fpu_begin();
+		hchacha_block_ssse3(state, stream, nrounds);
+		kernel_fpu_end();
+	}
+}
+EXPORT_SYMBOL(hchacha_block);
+
+void chacha_init(u32 *state, const u32 *key, const u8 *iv)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	chacha_init_generic(state, key, iv);
+}
+EXPORT_SYMBOL(chacha_init);
+
+void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
+		  int nrounds)
+{
+	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
+
+	if (bytes <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
+	kernel_fpu_begin();
+	chacha_dosimd(state, dst, src, bytes, nrounds);
+	kernel_fpu_end();
+}
+EXPORT_SYMBOL(chacha_crypt);
+
 static int chacha_simd_stream_xor(struct skcipher_walk *walk,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 074b125819b0..f90b53a526ba 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1436,6 +1436,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index 95a4a0ff4f7d..58192096679d 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -25,6 +25,12 @@
 #define CHACHA_BLOCK_SIZE	64
 #define CHACHAPOLY_IV_SIZE	12
 
+#ifdef CONFIG_X86_64
+#define CHACHA_STATE_WORDS	((CHACHA_BLOCK_SIZE + 12) / sizeof(u32))
+#else
+#define CHACHA_STATE_WORDS	(CHACHA_BLOCK_SIZE / sizeof(u32))
+#endif
+
 /* 192-bit nonce, then 64-bit stream position */
 #define XCHACHA_IV_SIZE		32
 
-- 
2.20.1

