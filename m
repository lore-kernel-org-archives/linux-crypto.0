Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE8DC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68EA222BE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uIGw6UPH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJBORp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39313 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfJBORo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so7190051wml.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmuuAqRzPZh0E74Jry6k34vaegwkUQMiM0zjPLz+tsA=;
        b=uIGw6UPHuVu79PfMpOds4Kc5zn6vX3EgWiyZqRZg5lVLp4QEma+hXrnvsVDrKufPu3
         OhyGfqXyAmyL72sXoQMe6eofTIoa4g0uoLyTVY2MBp2ymjeYkvGL48WdMYlSZBuKNpFG
         Jww6lUi2UOI9tj566fyb8q6/ug6N5hcdlOtUFwsgPmxM653Y8uFrevtNLi2iks7pTPhR
         bmSthj7Wm0Nf/XzJ2TwUO7N9ovUPhhX6i3je7koK/NgQ057CJHDA6dmmdHkCgvf1yp1C
         HTENoC5ta/6ZZPV52h4qAJRIAuk6jYd7THQT6+XL+KXZGwvXLzsD0nJRWYC9ZvW8UfMf
         KkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmuuAqRzPZh0E74Jry6k34vaegwkUQMiM0zjPLz+tsA=;
        b=UA1z92TW938ahx4ECa7nZmmxlXBKk4An3t971+dubuaRRlv02EpF/gaBYGVapEACaH
         rVugRQDoRfDhHruBORXrsPoEHkDZDxZc4v+6fneZLrY2ZTeNB9BM/0BtXocAoiXCQKBc
         51gaiTYwcjaxDeAk6gU5kpWA05G6x+KFvI42isIs9rwlBvigSgqoGWp4NWzW4qIqOHd4
         Yj7Q+1hr3TsAO59hDcu5kTLXdzVZM10qs2ERuY2g9zxUc3rvP3T13nx08FL+QyUXGir2
         Ne/eL3LD13iqV9HPMMym0fy2gI2GUdLdpx7lwNzhapK994ZuDPzbaTdAN8cIcuePh6+A
         e4+w==
X-Gm-Message-State: APjAAAW3bVv0cmo1K+JYnN0/9WvNWApx8x3NTLsMo0ExWSfwMd2FFeiy
        aotyd+mJYIA5ovt7iBt5S+qw1V20aNKsJE+r
X-Google-Smtp-Source: APXvYqzLhY18cdBAmBMBP0kHc6Vflhy64HBuX+U4ye9YRAcTwBIymQeQe7/SA6KHtr/o5aMuD58ooA==
X-Received: by 2002:a7b:c112:: with SMTP id w18mr3263701wmi.88.1570025862744;
        Wed, 02 Oct 2019 07:17:42 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:42 -0700 (PDT)
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
Subject: [PATCH v2 03/20] crypto: arm64/chacha - expose arm64 ChaCha routine as library function
Date:   Wed,  2 Oct 2019 16:16:56 +0200
Message-Id: <20191002141713.31189-4-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/Kconfig            |  1 +
 arch/arm64/crypto/chacha-neon-glue.c | 30 ++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 4922c4451e7c..09aa69ccc792 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -104,6 +104,7 @@ config CRYPTO_CHACHA20_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
+	select CRYPTO_ARCH_HAVE_LIB_CHACHA
 
 config CRYPTO_NHPOLY1305_NEON
 	tristate "NHPoly1305 hash function using NEON instructions (for Adiantum)"
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index d4cc61bfe79d..982a07070675 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -59,6 +59,36 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
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
+	if (bytes <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
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
-- 
2.20.1

