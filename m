Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5898DC35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3021721D82
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t10WMUy7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfJBORq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51932 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbfJBORq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so7417361wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/QbjOJPCo19W05ViTuArld7J+S6ZXXUJyNczgP4mU/c=;
        b=t10WMUy7IMMg8xayMWCjw986RYIFjZULF97FIr9zmglkv8SB/hOldht1+SVnaApgA/
         DvLtIQQVL7tlUWdcHwLabBmfLuwRYQSNPO/82NBSirWj26JN4eh1hFvBsnJ/JvzROiNT
         rMgKh6guPtdHY2ZjEI59pPjhODJNBI3no5GtY77sGcIz4wUjqY3jDXTnHS3yRGnNhAan
         Y+nB4lmBUenevQSu2KqXhvnry7tIx3ZJyOPgypCsQB18oomKj4cplzViwz97z8alXULW
         qYDO2O0yYgL99lmUwZsTgQKoFqyMJX2e2uoQRxzy2k8ymOTtdoKcvClHzBhRGnydsZ3E
         I8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/QbjOJPCo19W05ViTuArld7J+S6ZXXUJyNczgP4mU/c=;
        b=NZlofuKbzIqQnWMzMyfNDBiyx5vJpAt62oYPpT8mILqlhowgwbM3cgX0o8kjqJYIuC
         Ka483OEMfSadga7yuDANiilSk2ni2tQuz/8PyvhitWKEvKMkH/uhp4LAExc8MR0yE4S5
         bmo+KFi6whJg8MVcIzaaR2t5Ahy/tBFjG/VZFPTOdJXktLDiCuhMjKvxHUtjPRP1T07a
         s+7BwtkXBEgXzw8aTNGpjJ9yNu5iNwRcM/u4j0yU1MEYGCodSl2njedts0onCPOrZwyI
         pVGQCW04vBAZZ+oXkYrqaSrUbcniTf1uUqz2J2ynXu8z8VzJGLvVBZjIGQjeGL3lgC0Z
         8WPw==
X-Gm-Message-State: APjAAAXMVuh6+5Rpo5ZcZrtjWYoMy/G8LAxXjdnEx3K3BCHYK19ktNQ5
        lnsfvOxHbW9STdKs2K5vn7VgMidka2zJX5gQ
X-Google-Smtp-Source: APXvYqyBsvK7yZ+rdjsagnHFTO4kZw+WOi4779XP5HwWQH2Emrz9UEKVX3rgQvlISk90HAAGFZnO6w==
X-Received: by 2002:a1c:4108:: with SMTP id o8mr3288419wma.129.1570025864186;
        Wed, 02 Oct 2019 07:17:44 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:43 -0700 (PDT)
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
Subject: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine as library function
Date:   Wed,  2 Oct 2019 16:16:57 +0200
Message-Id: <20191002141713.31189-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the accelerated NEON ChaCha routine directly as a symbol
export so that users of the ChaCha library can use it directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig            |  1 +
 arch/arm/crypto/chacha-neon-glue.c | 40 ++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b24df84a1d7a..70e4d5fe5bdb 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -130,6 +130,7 @@ config CRYPTO_CHACHA20_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NEON accelerated NHPoly1305 hash function (for Adiantum)"
diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
index 26576772f18b..eee0f6e4f5d2 100644
--- a/arch/arm/crypto/chacha-neon-glue.c
+++ b/arch/arm/crypto/chacha-neon-glue.c
@@ -36,6 +36,8 @@ asmlinkage void chacha_4block_xor_neon(const u32 *state, u8 *dst, const u8 *src,
 				       int nrounds);
 asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 
+static bool have_neon __ro_after_init;
+
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
@@ -62,6 +64,36 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
+void hchacha_block(const u32 *state, u32 *stream, int nrounds)
+{
+	if (!crypto_simd_usable()) {
+		hchacha_block_generic(state, stream, nrounds);
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
+	if (!have_neon || bytes <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
+		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
+
+	kernel_neon_begin();
+	chacha_doneon(state, dst, src, bytes, nrounds);
+	kernel_neon_end();
+}
+EXPORT_SYMBOL(chacha_crypt);
+
 static int chacha_neon_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -177,15 +209,17 @@ static struct skcipher_alg algs[] = {
 
 static int __init chacha_simd_mod_init(void)
 {
-	if (!(elf_hwcap & HWCAP_NEON))
-		return -ENODEV;
+	have_neon = (elf_hwcap & HWCAP_NEON);
+	if (!have_neon)
+		return 0;
 
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit chacha_simd_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	if (have_neon)
+		crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(chacha_simd_mod_init);
-- 
2.20.1

