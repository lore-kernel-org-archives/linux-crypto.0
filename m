Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B81C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00E0A21928
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZEyCF1H/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbfI2RjF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35920 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbfI2RjD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so10215486wmc.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p4KKhW/ILVWczJ+i+Rd5vVeZAxxdEodk6kG2Ndh76c8=;
        b=ZEyCF1H/kwGHAmCX7wDAnQK5bIXTg6qZpWC74qnqY63TcIy3pIPkbxc2sTcCg8luZz
         q6N80FqXhB6heMzg+6M6s1ZbjhQiwAwKiwJl5kzEEEf1cYK4WUbFQw0Y8Uj+g2yzNTFv
         9fIVOzRuCjBrBFS7wUp7S242oOoi/7zLsDBJXmprJa01APm+Y1j9gH7WuPc3Sv9tpTmn
         gp/wOHtBOLF70hK4Ck/P8+gHxV0M45lPFCwc8RZ69k6RaE5dcvL+kHTgC1pnah7DR9qV
         1R25ncK0DlZangay+d/xk81n4/XgAm9mJJk2QNmAn+QVgPO/Snle8BXiIFez++yRTcwv
         i5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p4KKhW/ILVWczJ+i+Rd5vVeZAxxdEodk6kG2Ndh76c8=;
        b=dnybO73yMN+jiQZC1B9vjlloqd0+t5tgJIbrFVbLoSECOUcueggOw/igcnt4CV8dbV
         OqHnugZ9RdIdwhAKu9kiSy0b7Qz3Ua3jXBUOZ7JSknrQhopTdWLeZIHwCTR62gMTKCq7
         kRxUcJLe0a33iD7mQ7nTRwZbaOFAI44+lh8vnAhT6vDRNq7g9hJl8NOomdDV3mIkfOCJ
         roXEqO17m5l72uTfkQvCtmGQuNdLDPq8DU+VOa/dtKaoJdHLWN0umQDzVKjuXmxfi/cQ
         SgJiceE2KgMsOKZZ029eH2VAsMs5h/gbARlVyC47AdgqFhbGkJwhMo3g6zTtAfxIjvOl
         BMlA==
X-Gm-Message-State: APjAAAXEP+FjXMxFdIpHttf183YtkOHXvDmrL90LFa8lEWkHugfc9i2r
        PI2NwDo0QgYHL+RUiJnbkgYSnTZiLoQk6BYJ
X-Google-Smtp-Source: APXvYqzVdpPLvIDo6NIyGdTbXVnTjBD0y591JV31mPDmv2K9ZBqqpbGFCqJX0x7FjrJ/UiHpEQSckg==
X-Received: by 2002:a05:600c:290c:: with SMTP id i12mr14943151wmd.77.1569778742225;
        Sun, 29 Sep 2019 10:39:02 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:01 -0700 (PDT)
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
Subject: [RFC PATCH 03/20] crypto: arm64/chacha - expose arm64 ChaCha routine as library function
Date:   Sun, 29 Sep 2019 19:38:33 +0200
Message-Id: <20190929173850.26055-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Expose the accelerated NEON ChaCha routine directly as a symbol
export so that users of the ChaCha library can use it directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig            |  1 +
 arch/arm64/crypto/chacha-neon-glue.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

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
index d4cc61bfe79d..26c12b19a4ad 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -59,6 +59,18 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
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
2.17.1

