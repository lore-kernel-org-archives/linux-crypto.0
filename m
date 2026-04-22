Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE42B2E62B3
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878245; cv=none; b=ibfUjOzSTFntmQNDX8hm9eI/jTgmdCbJZG2V2TuOUVAhqp20F9beMo/0AK6dp9YprlJfP0QPaNVQA7+cj5hiyyOdovVjF4QN3IOGVci2QE/Ngv2VUtgI4TM9xJMoiH4REtKNyeDfmXncXhTdA7nY3X4oP0SEQLyNNbCeIhUMB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878245; c=relaxed/simple;
	bh=S0jdlR98LVTH5mhAHN+BpHBYWm7+wEd/4hTcfzLpSI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bwpm8zqJpKZYx7qQsGLfr0CRolVqslT0ciHGJlq6SAjCp+LXihkUk806sIagV9/1iXWjUsI1mrcYLdUOCtE8qe9QXpu+98KAQNh+5Hml4J85XlkJb7ZaA4DyanVEx9AtZ0fnudiIyz+aDH2vLT07USbYNxLqQ837hkDlYcwvGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ky0N6idk; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ky0N6idk"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4411a215f17so2745606f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878242; x=1777483042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=38FJmf1CbLYI1AGt06YyNFECBDz7thiyI1GjGiYf7zE=;
        b=ky0N6idkT4b3+k7+idVG0PaeBVedArb9ft67tAlBRCp4Ba9TuuzwaSHc3h+zfQZ5yD
         d4rjnoXQvJUp4MInGo0Z+AGPw43wYZwKtZ5FUaYBLMXRbqI/eHz0oCdRvLctyS6OubOf
         fXKWkQOX4u7xsxMb2xRHPOA6iilrRg8+/UqpUQOTei7A9CcTo4S4e6V7R3bWcKWcOELI
         NMyn5i51crMf1zYeUCugReigj4hZjeprj7py3Z/S51xSQc0EWr3E6nnECGdeCHFKh16q
         +IN3m1t+aP+E8Zs8spt8Cx6I2PK7EahBA9twj7Oy0M1w6u+3mMgcRwhnaYZborxu3yiI
         SImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878242; x=1777483042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=38FJmf1CbLYI1AGt06YyNFECBDz7thiyI1GjGiYf7zE=;
        b=IoAtGspOceWlRKTgKdUAbE+NjO2rGxel2UkJzeEahJhUk38lXe3qwUcNrkyOT+Fhua
         E0armmkNtErYkmUJTpfWcBBm/tNsI2/g6E61K6YGKsjU4zFca+2tYBNle5naskQQm/Y9
         +WVf/uiJNvFGPmRL0e8TBUmi22MomUcNTVuxif6Ah8zHCLvtiJ2XKH53LQCJC5WviZFm
         Vv0YeQI4OWDiUmFIbR3YKdDWIF0EygtH+nvh1uWwUde1TjAi7KRNLB+HbqFJJGhl37wR
         alkaxqcLTgCyIUB4zI1E5dToyIk2kjuBA8qjcMUBsXy0L3NpVR46x66J3aGXgkKIqVUG
         CSow==
X-Gm-Message-State: AOJu0YzqK8OdVWVLeNxagIoRgFvp8dZkWDMT9lHIIYAXxbeU5NnT2uSN
	bN8PAffq6pPQyGtjPhfX/g66Q1FeoaGU+hzqOhDyKtzVWSYN0YL+6Ob7/kT91pSvVpui7Zf3UA=
	=
X-Received: from wmtf4.prod.google.com ([2002:a05:600c:8b44:b0:489:1b01:386f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e4f:b0:488:d6eb:e63c
 with SMTP id 5b1f17b1804b1-488fb778703mr339429635e9.15.1776878242278; Wed, 22
 Apr 2026 10:17:22 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:17:02 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2567; i=ardb@kernel.org;
 h=from:subject; bh=GF0mnodrUh6rjEZUVMaX/cFwNwIG3vT9XIt19bfi9Io=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMl08Sa4CSz5Jv/mx/0/gpfqP9q6tPUq9HJIn7vsjVO3
 VUwqfDsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPJaGT4Zx9xW+Vp/vMfuczL
 uusVThx9c/M7i7bmo+TM24XM08yK7jAyrF/ysc5vmkD96tril/ei7p7TFhMwfMptsfJnxvHau9u MWQA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-16-ardb+git@google.com>
Subject: [PATCH 6/8] crypto: aegis128 - Use neon-intrinsics.h on ARM too
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Use the asm/neon-intrinsics.h header on ARM as well as arm64, so that
the calling code does not have to know the difference.

Clean up the Makefile a bit while at it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Makefile              | 10 ++++------
 crypto/aegis128-neon-inner.c |  4 +---
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 162242593c7c..69d1a18e8519 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -103,13 +103,14 @@ obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
 
+CFLAGS_aegis128-neon-inner.o += $(CC_FLAGS_FPU)
+CFLAGS_REMOVE_aegis128-neon-inner.o += $(CC_FLAGS_NO_FPU)
 ifeq ($(ARCH),arm)
-CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
-CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
+CFLAGS_aegis128-neon-inner.o += -march=armv8-a -mfpu=crypto-neon-fp-armv8
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
 ifeq ($(ARCH),arm64)
-aegis128-cflags-y := -ffreestanding -mcpu=generic+crypto
+aegis128-cflags-y := -mcpu=generic+crypto
 aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
 				       -ffixed-q19 -ffixed-q20 -ffixed-q21 \
 				       -ffixed-q22 -ffixed-q23 -ffixed-q24 \
@@ -117,11 +118,8 @@ aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
 				       -ffixed-q28 -ffixed-q29 -ffixed-q30 \
 				       -ffixed-q31
 CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
-CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
-# Enable <arm_neon.h>
-CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index b6a52a386b22..56b534eeb680 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -3,13 +3,11 @@
  * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#ifdef CONFIG_ARM64
 #include <asm/neon-intrinsics.h>
 
+#ifdef CONFIG_ARM64
 #define AES_ROUND	"aese %0.16b, %1.16b \n\t aesmc %0.16b, %0.16b"
 #else
-#include <arm_neon.h>
-
 #define AES_ROUND	"aese.8 %q0, %q1 \n\t aesmc.8 %q0, %q0"
 #endif
 
-- 
2.54.0.rc1.555.g9c883467ad-goog

