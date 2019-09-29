Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62745C352A9
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C09321D7C
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n6531c2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbfI2RjH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50877 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbfI2RjC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so10780790wmg.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cBp6PywBGrrDFi1QW6lqAmfKN7mIcjSAmZn0xXGIqw0=;
        b=n6531c2xJzxbzbpw5U49hgV3g6MsO+gc/8vVog7Gk/AshBv1eI7AGcuEOa8NIABXmk
         lPuLy5AW76WWSLz6ca2hgTzcrMdBh2YkCFgEbCjGibtIOukb54o42aLmYcBSIXXsVUXM
         TvwqrjqSCgpVcGh9uYoBtC4OAQAmSa52qt0SlqcRtajyP2qYOVix2LBCeTQ7bCLJ6cCq
         ZO8R3ftIBa8N6wEJMRPfdRP9XKIP1KL/hFYcF1XfS00Ruqi1PISYd+pb20sd1zXmWImL
         jPdcJFn70r51ypjEzZx00UVhbAvRqcJ6TvukiAXtOxLjuGYoa93VzropMRuPvWu5+xZB
         S+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cBp6PywBGrrDFi1QW6lqAmfKN7mIcjSAmZn0xXGIqw0=;
        b=fRkFuPM9jf3TNdsZ7/aYMNCWAFK3GuRzDjy8NA3cVNKLuj7ctgbWzlYcjuKYHSnnj/
         nKowaCCQUpK3RCVL0a7XWxaPUApPVos0D2++mwXjAOKpj5+CGfxR1q8M1IOf3nnqmeoT
         yK+zTS67qAicoNEusaYFIPV88n+smmMEU8A4m3jMg2qauXS0Ov0okX6c3Wga9VNtbhYq
         DNSjUZd9t3H/S+UEOHfHEvkYps6GjduTvPa4HS3wiXEgFw6X+GBPU7NfLx8RIF+W3C3c
         SlI0tLRWH6AK0T+u6w7lllptcvsuBsERX2n50uUj/lHXzK7/lfcZc/IpCudakzgcUmYQ
         +nsA==
X-Gm-Message-State: APjAAAXujuBbQVUPxV6aAmMNKYCES1VMT0rCrfXFeKw+g0AoMxDvjQYe
        t3txZjZauD15ry9ZUxmsEyDWGbg7YQMR8AGb
X-Google-Smtp-Source: APXvYqztbHjeSBUe3gLQ7J81/5r0fdMHWBfHWrlHuH9tmjvuMQ7NBuTNEvL5JUg1niBGtWoyjJfHiw==
X-Received: by 2002:a7b:c0d4:: with SMTP id s20mr15045988wmh.101.1569778740451;
        Sun, 29 Sep 2019 10:39:00 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:38:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        Martin Willi <martin@strongswan.org>
Subject: [RFC PATCH 02/20] crypto: x86/chacha - expose SIMD ChaCha routine as library function
Date:   Sun, 29 Sep 2019 19:38:32 +0200
Message-Id: <20190929173850.26055-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wire the existing x86 SIMD ChaCha code into the new ChaCha library
interface.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha_glue.c | 14 ++++++++++++++
 crypto/Kconfig                |  1 +
 include/crypto/chacha.h       |  9 +++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index bc62daa8dafd..1ea31d77fa00 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -123,6 +123,20 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
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
index 5826381aca3a..780d080fc5ec 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1408,6 +1408,7 @@ config CRYPTO_CHACHA20_X86_64
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index c29d8f7d69ed..23747b20d470 100644
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
 
@@ -57,6 +63,9 @@ static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
 
 static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
 {
+	if (IS_ENABLED(CONFIG_X86_64))
+		state = PTR_ALIGN(state, 16);
+
 	chacha_init_generic(state, key, iv);
 }
 
-- 
2.17.1

