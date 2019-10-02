Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4474BC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 07:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 164E3218DE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 07:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dx6Uturi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfJBHzS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 03:55:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46374 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJBHzR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 03:55:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so18387981wrv.13
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 00:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A8XGPQpdTard1ApbywwLwIjfjiFlJGx3ALBeAc9ozt4=;
        b=Dx6UturiW0NJ9L4H3toluQCphAT9eUOfVqQQnns7QawoVdH+XCyg+J9ZKT5g7QRUUi
         FMrpeHzNE1EgnbvsuiqV8MSA2NspM+GqDRXsxJ9z0qeXHXtotHPyItF9JJbjqduCt9QO
         kmcLK7bnVeubXabuhjQ0vz6C8M0WDiE+WPfqrlnFPAsKZwj5ZNjhpL6BZnZjjse8OpGT
         c9xy69+e9Cy88mCCfllS2MD0XysysItECDVIZdFmBbLwPQ7gNibO2QlEzR5pTom7kkZa
         AYu9VXZw1IoCp0josxWXB7vFDEg9EL+oWmriwqtfVWXFkGna5DC7yvamQm8qQD6e8gNm
         kA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A8XGPQpdTard1ApbywwLwIjfjiFlJGx3ALBeAc9ozt4=;
        b=JsJ1HNvNuhuOO0eGqlCRXbVrZyHuyHAAjvxW/DsoZ3kMAuOKxOVvPda94KGd9jarBV
         ZHro9pApn3qwDqUYYJXX/6+V+VpcU+D1ti1b2gM12dUE03pdQo31u5ogQ7Bgqjta56j/
         QKkN9/hnHvrrYMnSTYfM96b9qr3tPj6PAYaPuG0uBs1T3gybcIcbzX1gosLG3UGgI0NJ
         Ib3/TNA0Qs4lbx73wUDIkpoePyBiSLC6qRbcbqiJBxRlCU6timnXHPHnPbHZx5a3qkfO
         luWvP+R/8LYeLTzcXcWz8F3wb/3QlDzVj0AEsOdRT6z14YkTUHAWqnXHqckSMJ69RMro
         1wXw==
X-Gm-Message-State: APjAAAW9lDIWHisszqh7aiuGogY+vwJrPfrwDILcHWNu2RhihiIjk7sb
        8O0Y7fP2U8FYPMNm1v6OOw0wbJ6N4TvZSs46
X-Google-Smtp-Source: APXvYqyVl8jzv9iiOwTYhbHZcaeKvBZFNIhKFCTiCLE/aSC/bO08zrrcNpBMTGl4W2T3kkryZYBzEg==
X-Received: by 2002:a5d:6885:: with SMTP id h5mr1575256wru.92.1570002915785;
        Wed, 02 Oct 2019 00:55:15 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:1d6f:6259:a948:207b])
        by smtp.gmail.com with ESMTPSA id s1sm24942360wrg.80.2019.10.02.00.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 00:55:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, arnd@arndb.de,
        natechancellor@gmail.com, ndesaulniers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicitly
Date:   Wed,  2 Oct 2019 09:54:48 +0200
Message-Id: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that the Clang compiler has taken it upon itself to police the
compiler command line, and reject combinations for arguments it views
as incompatible, the AEGIS128 no longer builds correctly, and errors
out like this:

  clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
  architecture does not support it [-Winvalid-command-line-argument]

So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
FPU profile we specify. Since neither were actually supported by GCC
versions before 4.8, let's tighten the Kconfig dependencies as well so
we won't run into errors when building with an ancient compiler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig  | 1 +
 crypto/Makefile | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e928f88b6206..b138b68329dc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -331,6 +331,7 @@ config CRYPTO_AEGIS128
 config CRYPTO_AEGIS128_SIMD
 	bool "Support SIMD acceleration for AEGIS-128"
 	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
+	depends on !ARM || CC_IS_CLANG || GCC_VERSION >= 40800
 	default y
 
 config CRYPTO_AEGIS128_AESNI_SSE2
diff --git a/crypto/Makefile b/crypto/Makefile
index fcb1ee679782..aa740c8492b9 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -93,7 +93,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
 ifeq ($(ARCH),arm)
-CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
 CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
-- 
2.20.1

