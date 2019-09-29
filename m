Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6B1C32793
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C13B21D7B
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="STvI54kF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfI2RjG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37208 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730226AbfI2RjF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so8455146wro.4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Db287ko6zQqbNHe2YgcEJlShSLuvRxzkUrp4l5J8zd0=;
        b=STvI54kFXNvpfueHy5Bm5uWEwsHLIz5Wjpn72Y/5A+xbfVWDP9nbIOg0OUQtIasaOk
         D/jYnOeT21TgavJGJfWAZRCg994PVeFRtDo8zyg5ExznQLgy4L0uqiIiURKc/H2mXaLL
         X4sp5Fv3F8dQu5YphyqoWXIhL3oaFX/k8aGswrCaDX0qhxh19BStbK4cgEaaeRPk2lrO
         ZWevdItbYQ6Rco5eucZR4TdaRWwhIP5y4xEup8nLnmUqX//Aqkng64EuXz+oHXrODeKv
         YogqQVQ+P2Bpm0csoWPa5FhkXazJJi7ZZ0NYce/vBfdVIC0nMyXY4eYQybHsSXxXxyJR
         sANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Db287ko6zQqbNHe2YgcEJlShSLuvRxzkUrp4l5J8zd0=;
        b=K2gPgmVRKpM/fcNH5yQ6c5JSP5Ja1wMVl598glvxp5Q52YeSmLCQWvBrdhnfILciVd
         zw84Whuhpfe/Ox07mtlwqdDnabezbEOaiSaiWRDSUomsSISVB4ESFhgmUu2qaULxBCNO
         HjfHK7sE3CWRWFymdHTgzRWj2GEQwJbzaD/ZLI0vo2Xq250t1JaHEx6rm21Iff+PPy3B
         2HdI9Pj9JGsm8e0W8ZjgVpgeDRIj+V8YKuSY8DsDToxtEVKWxWYzBz7jSuHr6Ufc/siw
         X6SG6QZbt+bgJhe6FImCtV4MLkuFnhuGz20IXi6McobaKgwVsWrb1Npk6d+vtsn8SRzn
         +7oQ==
X-Gm-Message-State: APjAAAV/ZIAk4aZwjPtKsAV1T9sI8HXDhW+JS0oSky5HezHDMGnFFAie
        BBimiucUbCQhodLN01sSdF9QdpDh0AvpGrLe
X-Google-Smtp-Source: APXvYqykJ3hVfBYWkhZ9pwlioP+dugWSdXdQ52qcXBMaWaLbW9AGLyWW2Qu/3gtwz1RkBnj9rlcnTg==
X-Received: by 2002:adf:c7cf:: with SMTP id y15mr10662252wrg.54.1569778744018;
        Sun, 29 Sep 2019 10:39:04 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:03 -0700 (PDT)
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
Subject: [RFC PATCH 04/20] crypto: arm/chacha - expose ARM ChaCha routine as library function
Date:   Sun, 29 Sep 2019 19:38:34 +0200
Message-Id: <20190929173850.26055-5-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/Kconfig            |  1 +
 arch/arm/crypto/chacha-neon-glue.c | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

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
index 26576772f18b..1a32c6e5c885 100644
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
@@ -62,6 +64,18 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
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
@@ -177,8 +191,9 @@ static struct skcipher_alg algs[] = {
 
 static int __init chacha_simd_mod_init(void)
 {
-	if (!(elf_hwcap & HWCAP_NEON))
-		return -ENODEV;
+	have_neon = (elf_hwcap & HWCAP_NEON);
+	if (!have_neon)
+		return 0;
 
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
-- 
2.17.1

