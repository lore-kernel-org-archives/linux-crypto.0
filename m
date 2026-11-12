Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794502069;
	b=ygph5zDbBAXqkDeYjYx9OpJGPXhxYDi95wwp1LzrrZXnGY6ZAXGH04LABYYYNuH//YRG
	 lNkECRubvVZ49mn9f4NFVz2yicwUAIhKkXUdb/VgfG31wZU2N37etmNoKFz90piXDGxBL
	 3jEsTBIGWV1MZmJVA5RN0SCFN51+h0zsOWnYGtlajFPO1OvHpsiehmIaFGtXsS0MrWalG
	 eoRKV8QpT9dtik7ixI5woO6/h0R0jHbJdnEFp7v0COrRDVuNWCocWWe+/WS7PvHbxmgrA
	 wFJgCG5QRydGtNaAVRDdfyQfGxcjLepdG3QBI3fDGikgNItrSXZZe5dfprxdimaDxYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794502069;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=UvV6HGi9oiVYZf4XDro1ctjnSHQonQYB6FX1PwWgzbg=;
	b=ZapCBVuTb7VAlxNdgjkLzvfIk+rzj/rsUVrJpmlXEuBdoZAQX4dKZrJ0NNamr8HtzECR
	 /VVbsBmv0a4jZhYMxqSzXpoV5VzOk3M7kcMIrHjto5nglf1IeD9d4HxzrT846P6OwMkvb
	 M6LGr5RoJhqVNBy1MmI40EvNiz/HzNCGMWKYcjhLxooty/SUiqs2vsT+ez1twLP3WicW3
	 0dSBJmygPfKnL//3gTHg0hyib4uemTBN/Z859BgrRgLbbd2OM6gTdgvhmt1ZWEEm/kysh
	 SG11l8sE9v6Q2adGwY8FuUvEKTVdm815U++p5NBl9RYdECyDMcHTiC3EPKqJJoeQndw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f1YiEA7e;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FA4606A885
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 16:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72FA4606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f1YiEA7e
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4d1684d1b3so420914366b.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794502067; x=1795106867; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UvV6HGi9oiVYZf4XDro1ctjnSHQonQYB6FX1PwWgzbg=;
        b=f1YiEA7eDU4Jz1GzwSvfgN8ept2AXfG0fsbzpSONZS6U4a0geJbdsBgqJqy1Ftj3Qw
         J8PaLxJ7G5WVbYJKlBCQeYpqjTniva0OQuj2IPNmYsnV4tiJSOSl/Hj0inwRDF5Zqy0W
         +pkH7usMu7Qn72lLKcRiwQ74PteDb0TRjUgV/UIO5fRo0GITcbvNlL9l2n8JV4vlsH0N
         pyMRz42WBgTKVdDkNnEc0NDEzuJIvSlcACtfC1fMvaFHJIysYkREVLAKC/hMFGy+9r5t
         7hE/we0RCH0YsrWKjZKgWZBm623SyCBbfuMlq/tuLmkSSFYcZx6ZecLA548jeM2PN3JQ
         zmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794502067; x=1795106867;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UvV6HGi9oiVYZf4XDro1ctjnSHQonQYB6FX1PwWgzbg=;
        b=cwhlXHcgSsReqZsHOJNApaNwSW2Ur2BRz4zxnXS2ijJrecH73uTOUm3AwfdXEXmN4o
         mtTbVINhOrajNxzhZZPWsfLcQKddS3XPGU8QVK23fmad/M0OjHHHyvqykgjXZ6Vtgs5Q
         stn3L9J5H+aYFjR6VP7VYjjjEt3PxBEcj6hZU1a+hnQFqxZY/WCRSzHAtE+8hg0eWMme
         lHgm/vX5L/xo8JEJsf8i3UY+yVAWedYtfzWZvRcG9OfQKxPpu/nW58Rce29wUheYovP0
         2FXuaDJ2DjIooravGkwsCPMG5Ed6/ZWmP3VgizxaaeT1B34MADMFlILAdzBNnSwmYP4/
         Q6dQ==
X-Gm-Message-State: APuU4Z83Ta4Sidcs9T3u3d6fEmgXxe1WVaBSFJT0iGt2O03xW7dINb9u
	NcYjN5WHkb4mI881zGyksJkmiYm9O3jKO5MhcaPQbWMsZLRwlbLDmIAnR7zTUacZmu1hMwx2oUA
	5hiAFv8aI1jpqDuUknczXl8KO6rh2OK5pwrR1eSBZawkPtEYlxwtfb4KcX13oKrUvJJjvIya2kw
	FxwGjo1X0rcaDyCxslo2zfdnqxor1zY06bTQ==
X-Received: from ejeh14.prod.google.com ([2002:a17:906:398e:b0:c3f:b33c:8124])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:d54b:b0:c27:420b:7c79
 with SMTP id a640c23a62f3a-c5066d5fcddmr569744266b.48.1794502066374; Thu, 12
 Nov 2026 08:47:46 -0800 (PST)
Date: Thu, 12 Nov 2026 17:44:18 +0100
In-Reply-To: <20261112164419.1769428-4-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112164419.1769428-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=57868; i=ardb@kernel.org;
 h=from:subject; bh=yTbNJUFwyMyIi2Bg8laCj934eTtdkR33tgJ3rMbMVUY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevrm2dvlN2OMxcvUveMEvD5nHsr4HOvi/KXBfln/G15b
 ar5Q5Z0lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgImEPmX4K/HxRnxch43V4hhR
 0ZiidYmvqqLfTLIRWJik65rHE+ipz8jwVIJ5WcHL1xpyJReLPzMpfUgv3/RG6KRFem75nT0LFWI 4AA==
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112164419.1769428-6-ardb+git@google.com>
Subject: [PATCH 2/2] crypto: remove aegis128 support
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Antonio Quartulli <antonio@mandelbit.com>, 
	"=?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?=" <omosnacek@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Even the people that are invested in Aegis appear to have lost interest
in aegis128: it did win the CAESAR competition but is no longer covered
by RFC 10032, which does list some other variants that competed as well.

So let's delete it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/m68k/configs/amiga_defconfig    |   1 -
 arch/m68k/configs/apollo_defconfig   |   1 -
 arch/m68k/configs/atari_defconfig    |   1 -
 arch/m68k/configs/bvme6000_defconfig |   1 -
 arch/m68k/configs/hp300_defconfig    |   1 -
 arch/m68k/configs/mac_defconfig      |   1 -
 arch/m68k/configs/multi_defconfig    |   1 -
 arch/m68k/configs/mvme147_defconfig  |   1 -
 arch/m68k/configs/mvme16x_defconfig  |   1 -
 arch/m68k/configs/q40_defconfig      |   1 -
 arch/m68k/configs/sun3_defconfig     |   1 -
 arch/m68k/configs/sun3x_defconfig    |   1 -
 arch/s390/configs/debug_defconfig    |   1 -
 arch/s390/configs/defconfig          |   1 -
 crypto/Kconfig                       |  17 -
 crypto/Makefile                      |  20 -
 crypto/aegis-neon.h                  |  17 -
 crypto/aegis.h                       |  79 ---
 crypto/aegis128-core.c               | 577 --------------------
 crypto/aegis128-neon-inner.c         | 343 ------------
 crypto/aegis128-neon.c               |  60 --
 crypto/tcrypt.c                      |   7 -
 crypto/testmgr.c                     |   6 -
 crypto/testmgr.h                     | 444 ---------------
 24 files changed, 1584 deletions(-)

diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index e2d474e8cb8f..787defb894dd 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -531,7 +531,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 77669e31bb5a..8b8cea4643ed 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -485,7 +485,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index 43ed1e317ae2..c36793ed8d49 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -510,7 +510,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index 44c1a2228d5f..53bc0e1dcf8c 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -477,7 +477,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 7ab25377bfe8..9412fc91a831 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -487,7 +487,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index 13f642884a94..1e092dd7c1f7 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -506,7 +506,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 1bbd2aa653c0..fbfbd3644626 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -596,7 +596,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 3bfc36faf8d5..6209dacde6f4 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -477,7 +477,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 41ceed87c78a..a937c428d2d5 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -478,7 +478,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index af4b5c6e4655..fb2c07c194ae 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -496,7 +496,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 1140951fefe7..7ba77810a688 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -475,7 +475,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index bc9358e71ee0..0810c9fb3daf 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -475,7 +475,6 @@ CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_XTS=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=m
 CONFIG_CRYPTO_RMD160=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d44674b63715..2a1b312a04d2 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -805,7 +805,6 @@ CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index e00e252d4694..94d4646999b3 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -789,7 +789,6 @@ CONFIG_CRYPTO_ADIANTUM=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_HCTR2=m
 CONFIG_CRYPTO_LRW=m
-CONFIG_CRYPTO_AEGIS128=m
 CONFIG_CRYPTO_GCM=y
 CONFIG_CRYPTO_SEQIV=y
 CONFIG_CRYPTO_MD4=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 981d5dc422d4..7bb06b817d55 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -743,23 +743,6 @@ endmenu
 
 menu "AEAD (authenticated encryption with associated data) ciphers"
 
-config CRYPTO_AEGIS128
-	tristate "AEGIS-128"
-	select CRYPTO_AEAD
-	select CRYPTO_LIB_AES  # for AES S-box tables
-	help
-	  AEGIS-128 AEAD algorithm
-
-config CRYPTO_AEGIS128_SIMD
-	bool "AEGIS-128 (arm NEON, arm64 NEON)"
-	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
-	default y
-	help
-	  AEGIS-128 AEAD algorithm
-
-	  Architecture: arm or arm64 using:
-	  - NEON (Advanced SIMD) extension
-
 config CRYPTO_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305"
 	select CRYPTO_CHACHA20
diff --git a/crypto/Makefile b/crypto/Makefile
index 33bb5ad595e8..4db99bba1048 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -96,26 +96,6 @@ obj-$(CONFIG_CRYPTO_ADIANTUM) += adiantum.o
 obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
-obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
-aegis128-y := aegis128-core.o
-
-CFLAGS_aegis128-neon-inner.o += $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_aegis128-neon-inner.o += $(CC_FLAGS_NO_FPU)
-ifeq ($(ARCH),arm)
-CFLAGS_aegis128-neon-inner.o += -march=armv8-a -mfpu=crypto-neon-fp-armv8
-aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
-endif
-ifeq ($(ARCH),arm64)
-aegis128-cflags-y := -mcpu=generic+crypto
-aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
-				       -ffixed-q19 -ffixed-q20 -ffixed-q21 \
-				       -ffixed-q22 -ffixed-q23 -ffixed-q24 \
-				       -ffixed-q25 -ffixed-q26 -ffixed-q27 \
-				       -ffixed-q28 -ffixed-q29 -ffixed-q30 \
-				       -ffixed-q31
-CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
-aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
-endif
 
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
diff --git a/crypto/aegis-neon.h b/crypto/aegis-neon.h
deleted file mode 100644
index 61e5614b45de..000000000000
--- a/crypto/aegis-neon.h
+++ /dev/null
@@ -1,17 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-
-#ifndef _AEGIS_NEON_H
-#define _AEGIS_NEON_H
-
-void crypto_aegis128_init_neon(void *state, const void *key, const void *iv);
-void crypto_aegis128_update_neon(void *state, const void *msg);
-void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
-					unsigned int size);
-void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
-					unsigned int size);
-int crypto_aegis128_final_neon(void *state, void *tag_xor,
-			       unsigned int assoclen,
-			       unsigned int cryptlen,
-			       unsigned int authsize);
-
-#endif
diff --git a/crypto/aegis.h b/crypto/aegis.h
deleted file mode 100644
index ffcf8e85ea69..000000000000
--- a/crypto/aegis.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * AEGIS common definitions
- *
- * Copyright (c) 2018 Ondrej Mosnacek <omosnacek@gmail.com>
- * Copyright (c) 2018 Red Hat, Inc. All rights reserved.
- */
-
-#ifndef _CRYPTO_AEGIS_H
-#define _CRYPTO_AEGIS_H
-
-#include <crypto/aes.h>
-#include <linux/bitops.h>
-#include <linux/types.h>
-
-#define AEGIS_BLOCK_SIZE 16
-
-union aegis_block {
-	__le64 words64[AEGIS_BLOCK_SIZE / sizeof(__le64)];
-	__le32 words32[AEGIS_BLOCK_SIZE / sizeof(__le32)];
-	u8 bytes[AEGIS_BLOCK_SIZE];
-};
-
-struct aegis_state;
-
-extern int aegis128_have_aes_insn;
-
-#define AEGIS_BLOCK_ALIGN (__alignof__(union aegis_block))
-#define AEGIS_ALIGNED(p) IS_ALIGNED((uintptr_t)p, AEGIS_BLOCK_ALIGN)
-
-bool crypto_aegis128_have_simd(void);
-void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
-void crypto_aegis128_init_simd(struct aegis_state *state,
-			       const union aegis_block *key,
-			       const u8 *iv);
-void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size);
-int crypto_aegis128_final_simd(struct aegis_state *state,
-			       union aegis_block *tag_xor,
-			       unsigned int assoclen,
-			       unsigned int cryptlen,
-			       unsigned int authsize);
-
-static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,
-						   const union aegis_block *src)
-{
-	dst->words64[0] ^= src->words64[0];
-	dst->words64[1] ^= src->words64[1];
-}
-
-static __always_inline void crypto_aegis_block_and(union aegis_block *dst,
-						   const union aegis_block *src)
-{
-	dst->words64[0] &= src->words64[0];
-	dst->words64[1] &= src->words64[1];
-}
-
-static __always_inline void crypto_aegis_aesenc(union aegis_block *dst,
-						const union aegis_block *src,
-						const union aegis_block *key)
-{
-	const u8  *s  = src->bytes;
-	const u32 *t = aes_enc_tab;
-	u32 d0, d1, d2, d3;
-
-	d0 = t[s[ 0]] ^ rol32(t[s[ 5]], 8) ^ rol32(t[s[10]], 16) ^ rol32(t[s[15]], 24);
-	d1 = t[s[ 4]] ^ rol32(t[s[ 9]], 8) ^ rol32(t[s[14]], 16) ^ rol32(t[s[ 3]], 24);
-	d2 = t[s[ 8]] ^ rol32(t[s[13]], 8) ^ rol32(t[s[ 2]], 16) ^ rol32(t[s[ 7]], 24);
-	d3 = t[s[12]] ^ rol32(t[s[ 1]], 8) ^ rol32(t[s[ 6]], 16) ^ rol32(t[s[11]], 24);
-
-	dst->words32[0] = cpu_to_le32(d0) ^ key->words32[0];
-	dst->words32[1] = cpu_to_le32(d1) ^ key->words32[1];
-	dst->words32[2] = cpu_to_le32(d2) ^ key->words32[2];
-	dst->words32[3] = cpu_to_le32(d3) ^ key->words32[3];
-}
-
-#endif /* _CRYPTO_AEGIS_H */
diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
deleted file mode 100644
index ca80d861345d..000000000000
--- a/crypto/aegis128-core.c
+++ /dev/null
@@ -1,577 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * The AEGIS-128 Authenticated-Encryption Algorithm
- *
- * Copyright (c) 2017-2018 Ondrej Mosnacek <omosnacek@gmail.com>
- * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/aead.h>
-#include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/jump_label.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/scatterlist.h>
-
-#include <asm/simd.h>
-
-#include "aegis.h"
-
-#define AEGIS128_NONCE_SIZE 16
-#define AEGIS128_STATE_BLOCKS 5
-#define AEGIS128_KEY_SIZE 16
-#define AEGIS128_MIN_AUTH_SIZE 8
-#define AEGIS128_MAX_AUTH_SIZE 16
-
-struct aegis_state {
-	union aegis_block blocks[AEGIS128_STATE_BLOCKS];
-};
-
-struct aegis_ctx {
-	union aegis_block key;
-};
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_simd);
-
-static const union aegis_block crypto_aegis_const[2] = {
-	{ .words64 = {
-		cpu_to_le64(U64_C(0x0d08050302010100)),
-		cpu_to_le64(U64_C(0x6279e99059372215)),
-	} },
-	{ .words64 = {
-		cpu_to_le64(U64_C(0xf12fc26d55183ddb)),
-		cpu_to_le64(U64_C(0xdd28b57342311120)),
-	} },
-};
-
-static bool aegis128_do_simd(void)
-{
-#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
-	if (static_branch_likely(&have_simd))
-		return crypto_simd_usable();
-#endif
-	return false;
-}
-
-static void crypto_aegis128_update(struct aegis_state *state)
-{
-	union aegis_block tmp;
-	unsigned int i;
-
-	tmp = state->blocks[AEGIS128_STATE_BLOCKS - 1];
-	for (i = AEGIS128_STATE_BLOCKS - 1; i > 0; i--)
-		crypto_aegis_aesenc(&state->blocks[i], &state->blocks[i - 1],
-				    &state->blocks[i]);
-	crypto_aegis_aesenc(&state->blocks[0], &tmp, &state->blocks[0]);
-}
-
-static void crypto_aegis128_update_a(struct aegis_state *state,
-				     const union aegis_block *msg,
-				     bool do_simd)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
-		crypto_aegis128_update_simd(state, msg);
-		return;
-	}
-
-	crypto_aegis128_update(state);
-	crypto_aegis_block_xor(&state->blocks[0], msg);
-}
-
-static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg,
-				     bool do_simd)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
-		crypto_aegis128_update_simd(state, msg);
-		return;
-	}
-
-	crypto_aegis128_update(state);
-	crypto_xor(state->blocks[0].bytes, msg, AEGIS_BLOCK_SIZE);
-}
-
-static void crypto_aegis128_init(struct aegis_state *state,
-				 const union aegis_block *key,
-				 const u8 *iv)
-{
-	union aegis_block key_iv;
-	unsigned int i;
-
-	key_iv = *key;
-	crypto_xor(key_iv.bytes, iv, AEGIS_BLOCK_SIZE);
-
-	state->blocks[0] = key_iv;
-	state->blocks[1] = crypto_aegis_const[1];
-	state->blocks[2] = crypto_aegis_const[0];
-	state->blocks[3] = *key;
-	state->blocks[4] = *key;
-
-	crypto_aegis_block_xor(&state->blocks[3], &crypto_aegis_const[0]);
-	crypto_aegis_block_xor(&state->blocks[4], &crypto_aegis_const[1]);
-
-	for (i = 0; i < 5; i++) {
-		crypto_aegis128_update_a(state, key, false);
-		crypto_aegis128_update_a(state, &key_iv, false);
-	}
-}
-
-static void crypto_aegis128_ad(struct aegis_state *state,
-			       const u8 *src, unsigned int size,
-			       bool do_simd)
-{
-	if (AEGIS_ALIGNED(src)) {
-		const union aegis_block *src_blk =
-				(const union aegis_block *)src;
-
-		while (size >= AEGIS_BLOCK_SIZE) {
-			crypto_aegis128_update_a(state, src_blk, do_simd);
-
-			size -= AEGIS_BLOCK_SIZE;
-			src_blk++;
-		}
-	} else {
-		while (size >= AEGIS_BLOCK_SIZE) {
-			crypto_aegis128_update_u(state, src, do_simd);
-
-			size -= AEGIS_BLOCK_SIZE;
-			src += AEGIS_BLOCK_SIZE;
-		}
-	}
-}
-
-static void crypto_aegis128_wipe_chunk(struct aegis_state *state, u8 *dst,
-				       const u8 *src, unsigned int size)
-{
-	memzero_explicit(dst, size);
-}
-
-static void crypto_aegis128_encrypt_chunk(struct aegis_state *state, u8 *dst,
-					  const u8 *src, unsigned int size)
-{
-	union aegis_block tmp;
-
-	if (AEGIS_ALIGNED(src) && AEGIS_ALIGNED(dst)) {
-		while (size >= AEGIS_BLOCK_SIZE) {
-			union aegis_block *dst_blk =
-					(union aegis_block *)dst;
-			const union aegis_block *src_blk =
-					(const union aegis_block *)src;
-
-			tmp = state->blocks[2];
-			crypto_aegis_block_and(&tmp, &state->blocks[3]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-			crypto_aegis_block_xor(&tmp, src_blk);
-
-			crypto_aegis128_update_a(state, src_blk, false);
-
-			*dst_blk = tmp;
-
-			size -= AEGIS_BLOCK_SIZE;
-			src += AEGIS_BLOCK_SIZE;
-			dst += AEGIS_BLOCK_SIZE;
-		}
-	} else {
-		while (size >= AEGIS_BLOCK_SIZE) {
-			tmp = state->blocks[2];
-			crypto_aegis_block_and(&tmp, &state->blocks[3]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-			crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
-
-			crypto_aegis128_update_u(state, src, false);
-
-			memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
-
-			size -= AEGIS_BLOCK_SIZE;
-			src += AEGIS_BLOCK_SIZE;
-			dst += AEGIS_BLOCK_SIZE;
-		}
-	}
-
-	if (size > 0) {
-		union aegis_block msg = {};
-		memcpy(msg.bytes, src, size);
-
-		tmp = state->blocks[2];
-		crypto_aegis_block_and(&tmp, &state->blocks[3]);
-		crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-		crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-
-		crypto_aegis128_update_a(state, &msg, false);
-
-		crypto_aegis_block_xor(&msg, &tmp);
-
-		memcpy(dst, msg.bytes, size);
-	}
-}
-
-static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
-					  const u8 *src, unsigned int size)
-{
-	union aegis_block tmp;
-
-	if (AEGIS_ALIGNED(src) && AEGIS_ALIGNED(dst)) {
-		while (size >= AEGIS_BLOCK_SIZE) {
-			union aegis_block *dst_blk =
-					(union aegis_block *)dst;
-			const union aegis_block *src_blk =
-					(const union aegis_block *)src;
-
-			tmp = state->blocks[2];
-			crypto_aegis_block_and(&tmp, &state->blocks[3]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-			crypto_aegis_block_xor(&tmp, src_blk);
-
-			crypto_aegis128_update_a(state, &tmp, false);
-
-			*dst_blk = tmp;
-
-			size -= AEGIS_BLOCK_SIZE;
-			src += AEGIS_BLOCK_SIZE;
-			dst += AEGIS_BLOCK_SIZE;
-		}
-	} else {
-		while (size >= AEGIS_BLOCK_SIZE) {
-			tmp = state->blocks[2];
-			crypto_aegis_block_and(&tmp, &state->blocks[3]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-			crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
-
-			crypto_aegis128_update_a(state, &tmp, false);
-
-			memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
-
-			size -= AEGIS_BLOCK_SIZE;
-			src += AEGIS_BLOCK_SIZE;
-			dst += AEGIS_BLOCK_SIZE;
-		}
-	}
-
-	if (size > 0) {
-		union aegis_block msg = {};
-		memcpy(msg.bytes, src, size);
-
-		tmp = state->blocks[2];
-		crypto_aegis_block_and(&tmp, &state->blocks[3]);
-		crypto_aegis_block_xor(&tmp, &state->blocks[4]);
-		crypto_aegis_block_xor(&tmp, &state->blocks[1]);
-		crypto_aegis_block_xor(&msg, &tmp);
-
-		memset(msg.bytes + size, 0, AEGIS_BLOCK_SIZE - size);
-
-		crypto_aegis128_update_a(state, &msg, false);
-
-		memcpy(dst, msg.bytes, size);
-	}
-}
-
-static void crypto_aegis128_process_ad(struct aegis_state *state,
-				       struct scatterlist *sg_src,
-				       unsigned int assoclen,
-				       bool do_simd)
-{
-	struct scatter_walk walk;
-	union aegis_block buf;
-	unsigned int pos = 0;
-
-	scatterwalk_start(&walk, sg_src);
-	while (assoclen != 0) {
-		unsigned int size = scatterwalk_next(&walk, assoclen);
-		const u8 *src = walk.addr;
-		unsigned int left = size;
-
-		if (pos + size >= AEGIS_BLOCK_SIZE) {
-			if (pos > 0) {
-				unsigned int fill = AEGIS_BLOCK_SIZE - pos;
-				memcpy(buf.bytes + pos, src, fill);
-				crypto_aegis128_update_a(state, &buf, do_simd);
-				pos = 0;
-				left -= fill;
-				src += fill;
-			}
-
-			crypto_aegis128_ad(state, src, left, do_simd);
-			src += left & ~(AEGIS_BLOCK_SIZE - 1);
-			left &= AEGIS_BLOCK_SIZE - 1;
-		}
-
-		memcpy(buf.bytes + pos, src, left);
-
-		pos += left;
-		assoclen -= size;
-		scatterwalk_done_src(&walk, size);
-	}
-
-	if (pos > 0) {
-		memset(buf.bytes + pos, 0, AEGIS_BLOCK_SIZE - pos);
-		crypto_aegis128_update_a(state, &buf, do_simd);
-	}
-}
-
-static __always_inline
-int crypto_aegis128_process_crypt(struct aegis_state *state,
-				  struct skcipher_walk *walk,
-				  void (*crypt)(struct aegis_state *state,
-						u8 *dst,
-						const u8 *src,
-						unsigned int size))
-{
-	int err = 0;
-
-	while (walk->nbytes) {
-		unsigned int nbytes = walk->nbytes;
-
-		if (nbytes < walk->total)
-			nbytes = round_down(nbytes, walk->stride);
-
-		crypt(state, walk->dst.virt.addr, walk->src.virt.addr, nbytes);
-
-		err = skcipher_walk_done(walk, walk->nbytes - nbytes);
-	}
-	return err;
-}
-
-static void crypto_aegis128_final(struct aegis_state *state,
-				  union aegis_block *tag_xor,
-				  u64 assoclen, u64 cryptlen)
-{
-	u64 assocbits = assoclen * 8;
-	u64 cryptbits = cryptlen * 8;
-
-	union aegis_block tmp;
-	unsigned int i;
-
-	tmp.words64[0] = cpu_to_le64(assocbits);
-	tmp.words64[1] = cpu_to_le64(cryptbits);
-
-	crypto_aegis_block_xor(&tmp, &state->blocks[3]);
-
-	for (i = 0; i < 7; i++)
-		crypto_aegis128_update_a(state, &tmp, false);
-
-	for (i = 0; i < AEGIS128_STATE_BLOCKS; i++)
-		crypto_aegis_block_xor(tag_xor, &state->blocks[i]);
-}
-
-static int crypto_aegis128_setkey(struct crypto_aead *aead, const u8 *key,
-				  unsigned int keylen)
-{
-	struct aegis_ctx *ctx = crypto_aead_ctx(aead);
-
-	if (keylen != AEGIS128_KEY_SIZE)
-		return -EINVAL;
-
-	memcpy(ctx->key.bytes, key, AEGIS128_KEY_SIZE);
-	return 0;
-}
-
-static int crypto_aegis128_setauthsize(struct crypto_aead *tfm,
-				       unsigned int authsize)
-{
-	if (authsize > AEGIS128_MAX_AUTH_SIZE)
-		return -EINVAL;
-	if (authsize < AEGIS128_MIN_AUTH_SIZE)
-		return -EINVAL;
-	return 0;
-}
-
-static int crypto_aegis128_encrypt_generic(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	union aegis_block tag = {};
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
-	unsigned int cryptlen = req->cryptlen;
-	struct skcipher_walk walk;
-	struct aegis_state state;
-
-	skcipher_walk_aead_encrypt(&walk, req, false);
-	crypto_aegis128_init(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen, false);
-	crypto_aegis128_process_crypt(&state, &walk,
-				      crypto_aegis128_encrypt_chunk);
-	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-
-	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
-				 authsize, 1);
-	return 0;
-}
-
-static int crypto_aegis128_decrypt_generic(struct aead_request *req)
-{
-	static const u8 zeros[AEGIS128_MAX_AUTH_SIZE] = {};
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	union aegis_block tag;
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	unsigned int cryptlen = req->cryptlen - authsize;
-	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
-	struct skcipher_walk walk;
-	struct aegis_state state;
-
-	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
-				 authsize, 0);
-
-	skcipher_walk_aead_decrypt(&walk, req, false);
-	crypto_aegis128_init(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen, false);
-	crypto_aegis128_process_crypt(&state, &walk,
-				      crypto_aegis128_decrypt_chunk);
-	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-
-	if (unlikely(crypto_memneq(tag.bytes, zeros, authsize))) {
-		/*
-		 * From Chapter 4. 'Security Analysis' of the AEGIS spec [0]
-		 *
-		 * "3. If verification fails, the decrypted plaintext and the
-		 *     wrong authentication tag should not be given as output."
-		 *
-		 * [0] https://competitions.cr.yp.to/round3/aegisv11.pdf
-		 */
-		skcipher_walk_aead_decrypt(&walk, req, false);
-		crypto_aegis128_process_crypt(NULL, &walk,
-					      crypto_aegis128_wipe_chunk);
-		memzero_explicit(&tag, sizeof(tag));
-		return -EBADMSG;
-	}
-	return 0;
-}
-
-static int crypto_aegis128_encrypt_simd(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	union aegis_block tag = {};
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
-	unsigned int cryptlen = req->cryptlen;
-	struct skcipher_walk walk;
-	struct aegis_state state;
-
-	if (!aegis128_do_simd())
-		return crypto_aegis128_encrypt_generic(req);
-
-	skcipher_walk_aead_encrypt(&walk, req, false);
-	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen, true);
-	crypto_aegis128_process_crypt(&state, &walk,
-				      crypto_aegis128_encrypt_chunk_simd);
-	crypto_aegis128_final_simd(&state, &tag, req->assoclen, cryptlen, 0);
-
-	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
-				 authsize, 1);
-	return 0;
-}
-
-static int crypto_aegis128_decrypt_simd(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	union aegis_block tag;
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	unsigned int cryptlen = req->cryptlen - authsize;
-	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
-	struct skcipher_walk walk;
-	struct aegis_state state;
-
-	if (!aegis128_do_simd())
-		return crypto_aegis128_decrypt_generic(req);
-
-	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
-				 authsize, 0);
-
-	skcipher_walk_aead_decrypt(&walk, req, false);
-	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen, true);
-	crypto_aegis128_process_crypt(&state, &walk,
-				      crypto_aegis128_decrypt_chunk_simd);
-
-	if (unlikely(crypto_aegis128_final_simd(&state, &tag, req->assoclen,
-						cryptlen, authsize))) {
-		skcipher_walk_aead_decrypt(&walk, req, false);
-		crypto_aegis128_process_crypt(NULL, &walk,
-					      crypto_aegis128_wipe_chunk);
-		return -EBADMSG;
-	}
-	return 0;
-}
-
-static struct aead_alg crypto_aegis128_alg_generic = {
-	.setkey			= crypto_aegis128_setkey,
-	.setauthsize		= crypto_aegis128_setauthsize,
-	.encrypt		= crypto_aegis128_encrypt_generic,
-	.decrypt		= crypto_aegis128_decrypt_generic,
-
-	.ivsize			= AEGIS128_NONCE_SIZE,
-	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
-	.chunksize		= AEGIS_BLOCK_SIZE,
-
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
-	.base.cra_priority	= 100,
-	.base.cra_name		= "aegis128",
-	.base.cra_driver_name	= "aegis128-generic",
-	.base.cra_module	= THIS_MODULE,
-};
-
-static struct aead_alg crypto_aegis128_alg_simd = {
-	.setkey			= crypto_aegis128_setkey,
-	.setauthsize		= crypto_aegis128_setauthsize,
-	.encrypt		= crypto_aegis128_encrypt_simd,
-	.decrypt		= crypto_aegis128_decrypt_simd,
-
-	.ivsize			= AEGIS128_NONCE_SIZE,
-	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
-	.chunksize		= AEGIS_BLOCK_SIZE,
-
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
-	.base.cra_priority	= 200,
-	.base.cra_name		= "aegis128",
-	.base.cra_driver_name	= "aegis128-simd",
-	.base.cra_module	= THIS_MODULE,
-};
-
-static int __init crypto_aegis128_module_init(void)
-{
-	int ret;
-
-	ret = crypto_register_aead(&crypto_aegis128_alg_generic);
-	if (ret)
-		return ret;
-
-	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
-	    crypto_aegis128_have_simd()) {
-		ret = crypto_register_aead(&crypto_aegis128_alg_simd);
-		if (ret) {
-			crypto_unregister_aead(&crypto_aegis128_alg_generic);
-			return ret;
-		}
-		static_branch_enable(&have_simd);
-	}
-	return 0;
-}
-
-static void __exit crypto_aegis128_module_exit(void)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
-	    crypto_aegis128_have_simd())
-		crypto_unregister_aead(&crypto_aegis128_alg_simd);
-
-	crypto_unregister_aead(&crypto_aegis128_alg_generic);
-}
-
-module_init(crypto_aegis128_module_init);
-module_exit(crypto_aegis128_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
-MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm");
-MODULE_ALIAS_CRYPTO("aegis128");
-MODULE_ALIAS_CRYPTO("aegis128-generic");
-MODULE_ALIAS_CRYPTO("aegis128-simd");
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
deleted file mode 100644
index 56b534eeb680..000000000000
--- a/crypto/aegis128-neon-inner.c
+++ /dev/null
@@ -1,343 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
- */
-
-#include <asm/neon-intrinsics.h>
-
-#ifdef CONFIG_ARM64
-#define AES_ROUND	"aese %0.16b, %1.16b \n\t aesmc %0.16b, %0.16b"
-#else
-#define AES_ROUND	"aese.8 %q0, %q1 \n\t aesmc.8 %q0, %q0"
-#endif
-
-#define AEGIS_BLOCK_SIZE	16
-
-#include <stddef.h>
-#include "aegis-neon.h"
-
-extern int aegis128_have_aes_insn;
-
-void *memcpy(void *dest, const void *src, size_t n);
-
-struct aegis128_state {
-	uint8x16_t v[5];
-};
-
-extern const uint8_t crypto_aes_sbox[];
-
-static struct aegis128_state aegis128_load_state_neon(const void *state)
-{
-	return (struct aegis128_state){ {
-		vld1q_u8(state),
-		vld1q_u8(state + 16),
-		vld1q_u8(state + 32),
-		vld1q_u8(state + 48),
-		vld1q_u8(state + 64)
-	} };
-}
-
-static void aegis128_save_state_neon(struct aegis128_state st, void *state)
-{
-	vst1q_u8(state, st.v[0]);
-	vst1q_u8(state + 16, st.v[1]);
-	vst1q_u8(state + 32, st.v[2]);
-	vst1q_u8(state + 48, st.v[3]);
-	vst1q_u8(state + 64, st.v[4]);
-}
-
-static inline __attribute__((always_inline))
-uint8x16_t aegis_aes_round(uint8x16_t w)
-{
-	uint8x16_t z = {};
-
-#ifdef CONFIG_ARM64
-	if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
-		static const uint8_t shift_rows[] = {
-			0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
-			0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb,
-		};
-		static const uint8_t ror32by8[] = {
-			0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
-			0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,
-		};
-		uint8x16_t v;
-
-		// shift rows
-		w = vqtbl1q_u8(w, vld1q_u8(shift_rows));
-
-		// sub bytes
-#ifndef CONFIG_CC_IS_GCC
-		v = vqtbl4q_u8(vld1q_u8_x4(crypto_aes_sbox), w);
-		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x40), w - 0x40);
-		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x80), w - 0x80);
-		v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0xc0), w - 0xc0);
-#else
-		asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
-		w -= 0x40;
-		asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
-		w -= 0x40;
-		asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
-		w -= 0x40;
-		asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
-#endif
-
-		// mix columns
-		w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
-		w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
-		w ^= vqtbl1q_u8(v ^ w, vld1q_u8(ror32by8));
-
-		return w;
-	}
-#endif
-
-	/*
-	 * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
-	 * to force the compiler to issue the aese/aesmc instructions in pairs.
-	 * This is much faster on many cores, where the instruction pair can
-	 * execute in a single cycle.
-	 */
-	asm(AES_ROUND : "+w"(w) : "w"(z));
-	return w;
-}
-
-static inline __attribute__((always_inline))
-struct aegis128_state aegis128_update_neon(struct aegis128_state st,
-					   uint8x16_t m)
-{
-	m       ^= aegis_aes_round(st.v[4]);
-	st.v[4] ^= aegis_aes_round(st.v[3]);
-	st.v[3] ^= aegis_aes_round(st.v[2]);
-	st.v[2] ^= aegis_aes_round(st.v[1]);
-	st.v[1] ^= aegis_aes_round(st.v[0]);
-	st.v[0] ^= m;
-
-	return st;
-}
-
-static inline __attribute__((always_inline))
-void preload_sbox(void)
-{
-	if (!IS_ENABLED(CONFIG_ARM64) ||
-	    !IS_ENABLED(CONFIG_CC_IS_GCC) ||
-	    __builtin_expect(aegis128_have_aes_insn, 1))
-		return;
-
-	asm("ld1	{v16.16b-v19.16b}, [%0], #64	\n\t"
-	    "ld1	{v20.16b-v23.16b}, [%0], #64	\n\t"
-	    "ld1	{v24.16b-v27.16b}, [%0], #64	\n\t"
-	    "ld1	{v28.16b-v31.16b}, [%0]		\n\t"
-	    :: "r"(crypto_aes_sbox));
-}
-
-void crypto_aegis128_init_neon(void *state, const void *key, const void *iv)
-{
-	static const uint8_t const0[] = {
-		0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d,
-		0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62,
-	};
-	static const uint8_t const1[] = {
-		0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1,
-		0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd,
-	};
-	uint8x16_t k = vld1q_u8(key);
-	uint8x16_t kiv = k ^ vld1q_u8(iv);
-	struct aegis128_state st = {{
-		kiv,
-		vld1q_u8(const1),
-		vld1q_u8(const0),
-		k ^ vld1q_u8(const0),
-		k ^ vld1q_u8(const1),
-	}};
-	int i;
-
-	preload_sbox();
-
-	for (i = 0; i < 5; i++) {
-		st = aegis128_update_neon(st, k);
-		st = aegis128_update_neon(st, kiv);
-	}
-	aegis128_save_state_neon(st, state);
-}
-
-void crypto_aegis128_update_neon(void *state, const void *msg)
-{
-	struct aegis128_state st = aegis128_load_state_neon(state);
-
-	preload_sbox();
-
-	st = aegis128_update_neon(st, vld1q_u8(msg));
-
-	aegis128_save_state_neon(st, state);
-}
-
-#ifdef CONFIG_ARM
-/*
- * AArch32 does not provide these intrinsics natively because it does not
- * implement the underlying instructions. AArch32 only provides 64-bit
- * wide vtbl.8/vtbx.8 instruction, so use those instead.
- */
-static uint8x16_t vqtbl1q_u8(uint8x16_t a, uint8x16_t b)
-{
-	union {
-		uint8x16_t	val;
-		uint8x8x2_t	pair;
-	} __a = { a };
-
-	return vcombine_u8(vtbl2_u8(__a.pair, vget_low_u8(b)),
-			   vtbl2_u8(__a.pair, vget_high_u8(b)));
-}
-
-static uint8x16_t vqtbx1q_u8(uint8x16_t v, uint8x16_t a, uint8x16_t b)
-{
-	union {
-		uint8x16_t	val;
-		uint8x8x2_t	pair;
-	} __a = { a };
-
-	return vcombine_u8(vtbx2_u8(vget_low_u8(v), __a.pair, vget_low_u8(b)),
-			   vtbx2_u8(vget_high_u8(v), __a.pair, vget_high_u8(b)));
-}
-
-static int8_t vminvq_s8(int8x16_t v)
-{
-	int8x8_t s = vpmin_s8(vget_low_s8(v), vget_high_s8(v));
-
-	s = vpmin_s8(s, s);
-	s = vpmin_s8(s, s);
-	s = vpmin_s8(s, s);
-
-	return vget_lane_s8(s, 0);
-}
-#endif
-
-static const uint8_t permute[] __aligned(64) = {
-	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-	 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
-	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-};
-
-void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
-					unsigned int size)
-{
-	struct aegis128_state st = aegis128_load_state_neon(state);
-	const int short_input = size < AEGIS_BLOCK_SIZE;
-	uint8x16_t msg;
-
-	preload_sbox();
-
-	while (size >= AEGIS_BLOCK_SIZE) {
-		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
-
-		msg = vld1q_u8(src);
-		st = aegis128_update_neon(st, msg);
-		msg ^= s;
-		vst1q_u8(dst, msg);
-
-		size -= AEGIS_BLOCK_SIZE;
-		src += AEGIS_BLOCK_SIZE;
-		dst += AEGIS_BLOCK_SIZE;
-	}
-
-	if (size > 0) {
-		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
-		uint8_t buf[AEGIS_BLOCK_SIZE];
-		const void *in = src;
-		void *out = dst;
-		uint8x16_t m;
-
-		if (__builtin_expect(short_input, 0))
-			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
-
-		m = vqtbl1q_u8(vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
-			       vld1q_u8(permute + 32 - size));
-
-		st = aegis128_update_neon(st, m);
-
-		vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
-			 vqtbl1q_u8(m ^ s, vld1q_u8(permute + size)));
-
-		if (__builtin_expect(short_input, 0))
-			memcpy(dst, out, size);
-		else
-			vst1q_u8(out - AEGIS_BLOCK_SIZE, msg);
-	}
-
-	aegis128_save_state_neon(st, state);
-}
-
-void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
-					unsigned int size)
-{
-	struct aegis128_state st = aegis128_load_state_neon(state);
-	const int short_input = size < AEGIS_BLOCK_SIZE;
-	uint8x16_t msg;
-
-	preload_sbox();
-
-	while (size >= AEGIS_BLOCK_SIZE) {
-		msg = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
-		st = aegis128_update_neon(st, msg);
-		vst1q_u8(dst, msg);
-
-		size -= AEGIS_BLOCK_SIZE;
-		src += AEGIS_BLOCK_SIZE;
-		dst += AEGIS_BLOCK_SIZE;
-	}
-
-	if (size > 0) {
-		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
-		uint8_t buf[AEGIS_BLOCK_SIZE];
-		const void *in = src;
-		void *out = dst;
-		uint8x16_t m;
-
-		if (__builtin_expect(short_input, 0))
-			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
-
-		m = s ^ vqtbx1q_u8(s, vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
-				   vld1q_u8(permute + 32 - size));
-
-		st = aegis128_update_neon(st, m);
-
-		vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
-			 vqtbl1q_u8(m, vld1q_u8(permute + size)));
-
-		if (__builtin_expect(short_input, 0))
-			memcpy(dst, out, size);
-		else
-			vst1q_u8(out - AEGIS_BLOCK_SIZE, msg);
-	}
-
-	aegis128_save_state_neon(st, state);
-}
-
-int crypto_aegis128_final_neon(void *state, void *tag_xor,
-			       unsigned int assoclen,
-			       unsigned int cryptlen,
-			       unsigned int authsize)
-{
-	struct aegis128_state st = aegis128_load_state_neon(state);
-	uint8x16_t v;
-	int i;
-
-	preload_sbox();
-
-	v = st.v[3] ^ (uint8x16_t)vcombine_u64(vmov_n_u64(8ULL * assoclen),
-					       vmov_n_u64(8ULL * cryptlen));
-
-	for (i = 0; i < 7; i++)
-		st = aegis128_update_neon(st, v);
-
-	v = st.v[0] ^ st.v[1] ^ st.v[2] ^ st.v[3] ^ st.v[4];
-
-	if (authsize > 0) {
-		v = vqtbl1q_u8(~vceqq_u8(v, vld1q_u8(tag_xor)),
-			       vld1q_u8(permute + authsize));
-
-		return vminvq_s8((int8x16_t)v);
-	}
-
-	vst1q_u8(tag_xor, v);
-	return 0;
-}
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
deleted file mode 100644
index b41807e63bd3..000000000000
--- a/crypto/aegis128-neon.c
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2019 Linaro Ltd <ard.biesheuvel@linaro.org>
- */
-
-#include <asm/cpufeature.h>
-#include <asm/simd.h>
-
-#include "aegis.h"
-#include "aegis-neon.h"
-
-int aegis128_have_aes_insn __ro_after_init;
-
-bool crypto_aegis128_have_simd(void)
-{
-	if (cpu_have_feature(cpu_feature(AES))) {
-		aegis128_have_aes_insn = 1;
-		return true;
-	}
-	return IS_ENABLED(CONFIG_ARM64);
-}
-
-void crypto_aegis128_init_simd(struct aegis_state *state,
-			       const union aegis_block *key,
-			       const u8 *iv)
-{
-	scoped_ksimd()
-		crypto_aegis128_init_neon(state, key, iv);
-}
-
-void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg)
-{
-	scoped_ksimd()
-		crypto_aegis128_update_neon(state, msg);
-}
-
-void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size)
-{
-	scoped_ksimd()
-		crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
-}
-
-void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
-					const u8 *src, unsigned int size)
-{
-	scoped_ksimd()
-		crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
-}
-
-int crypto_aegis128_final_simd(struct aegis_state *state,
-			       union aegis_block *tag_xor,
-			       unsigned int assoclen,
-			       unsigned int cryptlen,
-			       unsigned int authsize)
-{
-	scoped_ksimd()
-		return crypto_aegis128_final_neon(state, tag_xor, assoclen,
-						  cryptlen, authsize);
-}
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e6834bdde9b9..7820fe01cd3a 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2138,13 +2138,6 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  speed_template_16_24_32);
 		break;
 
-	case 221:
-		test_aead_speed("aegis128", ENCRYPT, sec,
-				NULL, 0, 16, 8, speed_template_16);
-		test_aead_speed("aegis128", DECRYPT, sec,
-				NULL, 0, 16, 8, speed_template_16);
-		break;
-
 	case 222:
 		test_aead_speed("gcm(sm4)", ENCRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9419d61d0602..ce6f3171626c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4062,12 +4062,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha20_aes_tv_template)
 		},
-	}, {
-		.alg = "aegis128",
-		.test = alg_test_aead,
-		.suite = {
-			.aead = __VECS(aegis128_tv_template)
-		}
 	}, {
 		.alg = "authenc(hmac(md5),cbc(aes))",
 		.generic_driver = "authenc(hmac-md5-lib,cbc(aes-lib))",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 0ee15a8fae27..40aa7a2f044b 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -23311,450 +23311,6 @@ static const struct aead_testvec rfc7539esp_tv_template[] = {
 	},
 };
 
-/*
- * AEGIS-128 test vectors - generated via reference implementation from
- * SUPERCOP (https://bench.cr.yp.to/supercop.html):
- *
- *   https://bench.cr.yp.to/supercop/supercop-20170228.tar.xz
- *   (see crypto_aead/aegis128/)
- */
-static const struct aead_testvec aegis128_tv_template[] = {
-	{
-		.key	= "\x0f\xc9\x8e\x67\x44\x9e\xaa\x86"
-			  "\x20\x36\x2c\x24\xfe\xc9\x30\x81",
-		.klen	= 16,
-		.iv	= "\x1e\x92\x1c\xcf\x88\x3d\x54\x0d"
-			  "\x40\x6d\x59\x48\xfc\x92\x61\x03",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\x07\xa5\x11\xf2\x9d\x40\xb8\x6d"
-			  "\xda\xb8\x12\x34\x4c\x53\xd9\x72",
-		.clen	= 16,
-	}, {
-		.key	= "\x4b\xed\xc8\x07\x54\x1a\x52\xa2"
-			  "\xa1\x10\xde\xb5\xf8\xed\xf3\x87",
-		.klen	= 16,
-		.iv	= "\x5a\xb7\x56\x6e\x98\xb9\xfd\x29"
-			  "\xc1\x47\x0b\xda\xf6\xb6\x23\x09",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\x79",
-		.plen	= 1,
-		.ctext	= "\x9e\x78\x52\xae\xcb\x9e\xe4\xd3"
-			  "\x9a\xd7\x5d\xd7\xaa\x9a\xe9\x5a"
-			  "\xcc",
-		.clen	= 17,
-	}, {
-		.key	= "\x88\x12\x01\xa6\x64\x96\xfb\xbe"
-			  "\x22\xea\x90\x47\xf2\x11\xb5\x8e",
-		.klen	= 16,
-		.iv	= "\x97\xdb\x90\x0e\xa8\x35\xa5\x45"
-			  "\x42\x21\xbd\x6b\xf0\xda\xe6\x0f",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\xb5\x6e\xad\xdd\x30\x72\xfa\x53"
-			  "\x82\x8e\x16\xb4\xed\x6d\x47",
-		.plen	= 15,
-		.ctext	= "\xc3\x80\x83\x04\x5f\xaa\x61\xc7"
-			  "\xca\xdd\x6f\xac\x85\x08\xb5\x35"
-			  "\x2b\xc2\x3e\x0b\x1b\x39\x37\x2b"
-			  "\x7a\x21\x16\xb3\xe6\x67\x66",
-		.clen	= 31,
-	}, {
-		.key	= "\xc4\x37\x3b\x45\x74\x11\xa4\xda"
-			  "\xa2\xc5\x42\xd8\xec\x36\x78\x94",
-		.klen	= 16,
-		.iv	= "\xd3\x00\xc9\xad\xb8\xb0\x4e\x61"
-			  "\xc3\xfb\x6f\xfd\xea\xff\xa9\x15",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\xf2\x92\xe6\x7d\x40\xee\xa3\x6f"
-			  "\x03\x68\xc8\x45\xe7\x91\x0a\x18",
-		.plen	= 16,
-		.ctext	= "\x23\x25\x30\xe5\x6a\xb6\x36\x7d"
-			  "\x38\xfd\x3a\xd2\xc2\x58\xa9\x11"
-			  "\x1e\xa8\x30\x9c\x16\xa4\xdb\x65"
-			  "\x51\x10\x16\x27\x70\x9b\x64\x29",
-		.clen	= 32,
-	}, {
-		.key	= "\x01\x5c\x75\xe5\x84\x8d\x4d\xf6"
-			  "\x23\x9f\xf4\x6a\xe6\x5a\x3b\x9a",
-		.klen	= 16,
-		.iv	= "\x10\x25\x03\x4c\xc8\x2c\xf7\x7d"
-			  "\x44\xd5\x21\x8e\xe4\x23\x6b\x1c",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\x2e\xb7\x20\x1c\x50\x6a\x4b\x8b"
-			  "\x84\x42\x7a\xd7\xe1\xb5\xcd\x1f"
-			  "\xd3",
-		.plen	= 17,
-		.ctext	= "\x2a\x8d\x56\x91\xc6\xf3\x56\xa5"
-			  "\x1f\xf0\x89\x2e\x13\xad\xe6\xf6"
-			  "\x46\x80\xb1\x0e\x18\x30\x40\x97"
-			  "\x03\xdf\x64\x3c\xbe\x93\x9e\xc9"
-			  "\x3b",
-		.clen	= 33,
-	}, {
-		.key	= "\x3d\x80\xae\x84\x94\x09\xf6\x12"
-			  "\xa4\x79\xa6\xfb\xe0\x7f\xfd\xa0",
-		.klen	= 16,
-		.iv	= "\x4c\x49\x3d\xec\xd8\xa8\xa0\x98"
-			  "\xc5\xb0\xd3\x1f\xde\x48\x2e\x22",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\x6b\xdc\x5a\xbb\x60\xe5\xf4\xa6"
-			  "\x05\x1d\x2c\x68\xdb\xda\x8f\x25"
-			  "\xfe\x8d\x45\x19\x1e\xc0\x0b\x99"
-			  "\x88\x11\x39\x12\x1c\x3a\xbb",
-		.plen	= 31,
-		.ctext	= "\x4e\xf6\xfa\x13\xde\x43\x63\x4c"
-			  "\xe2\x04\x3e\xe4\x85\x14\xb6\x3f"
-			  "\xb1\x8f\x4c\xdb\x41\xa2\x14\x99"
-			  "\xf5\x53\x0f\x73\x86\x7e\x97\xa1"
-			  "\x4b\x56\x5b\x94\xce\xcd\x74\xcd"
-			  "\x75\xc4\x53\x01\x89\x45\x59",
-		.clen	= 47,
-	}, {
-		.key	= "\x7a\xa5\xe8\x23\xa4\x84\x9e\x2d"
-			  "\x25\x53\x58\x8c\xda\xa3\xc0\xa6",
-		.klen	= 16,
-		.iv	= "\x89\x6e\x77\x8b\xe8\x23\x49\xb4"
-			  "\x45\x8a\x85\xb1\xd8\x6c\xf1\x28",
-		.assoc	= "",
-		.alen	= 0,
-		.ptext	= "\xa7\x00\x93\x5b\x70\x61\x9d\xc2"
-			  "\x86\xf7\xde\xfa\xd5\xfe\x52\x2b"
-			  "\x28\x50\x51\x9d\x24\x60\x8d\xb3"
-			  "\x49\x3e\x17\xea\xf6\x99\x5a\xdd",
-		.plen	= 32,
-		.ctext	= "\xa4\x9a\xb7\xfd\xa0\xd4\xd6\x47"
-			  "\x95\xf4\x58\x38\x14\x83\x27\x01"
-			  "\x4c\xed\x32\x2c\xf7\xd6\x31\xf7"
-			  "\x38\x1b\x2c\xc9\xb6\x31\xce\xaa"
-			  "\xa5\x3c\x1a\x18\x5c\xce\xb9\xdf"
-			  "\x51\x52\x77\xf2\x5e\x85\x80\x41",
-		.clen	= 48,
-	}, {
-		.key	= "\xb6\xca\x22\xc3\xb4\x00\x47\x49"
-			  "\xa6\x2d\x0a\x1e\xd4\xc7\x83\xad",
-		.klen	= 16,
-		.iv	= "\xc5\x93\xb0\x2a\xf8\x9f\xf1\xd0"
-			  "\xc6\x64\x37\x42\xd2\x90\xb3\x2e",
-		.assoc	= "\xd5",
-		.alen	= 1,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\xfb\xd4\x83\x71\x9e\x63\xad\x60"
-			  "\xb9\xf9\xeb\x34\x52\x49\xcf\xb7",
-		.clen	= 16,
-	}, {
-		.key	= "\xf3\xee\x5c\x62\xc4\x7c\xf0\x65"
-			  "\x27\x08\xbd\xaf\xce\xec\x45\xb3",
-		.klen	= 16,
-		.iv	= "\x02\xb8\xea\xca\x09\x1b\x9a\xec"
-			  "\x47\x3e\xe9\xd4\xcc\xb5\x76\x34",
-		.assoc	= "\x11\x81\x78\x32\x4d\xb9\x44\x73"
-			  "\x68\x75\x16\xf8\xcb\x7e\xa7",
-		.alen	= 15,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\x0c\xaf\x2e\x96\xf6\x97\x08\x71"
-			  "\x7d\x3a\x84\xc4\x44\x57\x77\x7e",
-		.clen	= 16,
-	}, {
-		.key	= "\x2f\x13\x95\x01\xd5\xf7\x99\x81"
-			  "\xa8\xe2\x6f\x41\xc8\x10\x08\xb9",
-		.klen	= 16,
-		.iv	= "\x3f\xdc\x24\x69\x19\x96\x43\x08"
-			  "\xc8\x18\x9b\x65\xc6\xd9\x39\x3b",
-		.assoc	= "\x4e\xa5\xb2\xd1\x5d\x35\xed\x8f"
-			  "\xe8\x4f\xc8\x89\xc5\xa2\x69\xbc",
-		.alen	= 16,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\xc7\x87\x09\x3b\xc7\x19\x74\x22"
-			  "\x22\xa5\x67\x10\xb2\x36\xb3\x45",
-		.clen	= 16,
-	}, {
-		.key	= "\x6c\x38\xcf\xa1\xe5\x73\x41\x9d"
-			  "\x29\xbc\x21\xd2\xc2\x35\xcb\xbf",
-		.klen	= 16,
-		.iv	= "\x7b\x01\x5d\x08\x29\x12\xec\x24"
-			  "\x49\xf3\x4d\xf7\xc0\xfe\xfb\x41",
-		.assoc	= "\x8a\xca\xec\x70\x6d\xb1\x96\xab"
-			  "\x69\x29\x7a\x1b\xbf\xc7\x2c\xc2"
-			  "\x07",
-		.alen	= 17,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\x02\xc6\x3b\x46\x65\xb2\xef\x91"
-			  "\x31\xf0\x45\x48\x8a\x2a\xed\xe4",
-		.clen	= 16,
-	}, {
-		.key	= "\xa8\x5c\x09\x40\xf5\xef\xea\xb8"
-			  "\xaa\x96\xd3\x64\xbc\x59\x8d\xc6",
-		.klen	= 16,
-		.iv	= "\xb8\x26\x97\xa8\x39\x8e\x94\x3f"
-			  "\xca\xcd\xff\x88\xba\x22\xbe\x47",
-		.assoc	= "\xc7\xef\x26\x10\x7d\x2c\x3f\xc6"
-			  "\xea\x03\x2c\xac\xb9\xeb\xef\xc9"
-			  "\x31\x6b\x08\x12\xfc\xd8\x37\x2d"
-			  "\xe0\x17\x3a\x2e\x83\x5c\x8f",
-		.alen	= 31,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\x20\x85\xa8\xd0\x91\x48\x85\xf3"
-			  "\x5a\x16\xc0\x57\x68\x47\xdd\xcb",
-		.clen	= 16,
-	}, {
-		.key	= "\xe5\x81\x42\xdf\x05\x6a\x93\xd4"
-			  "\x2b\x70\x85\xf5\xb6\x7d\x50\xcc",
-		.klen	= 16,
-		.iv	= "\xf4\x4a\xd1\x47\x49\x09\x3d\x5b"
-			  "\x4b\xa7\xb1\x19\xb4\x46\x81\x4d",
-		.assoc	= "\x03\x14\x5f\xaf\x8d\xa8\xe7\xe2"
-			  "\x6b\xde\xde\x3e\xb3\x10\xb1\xcf"
-			  "\x5c\x2d\x14\x96\x01\x78\xb9\x47"
-			  "\xa1\x44\x19\x06\x5d\xbb\x2e\x2f",
-		.alen	= 32,
-		.ptext	= "",
-		.plen	= 0,
-		.ctext	= "\x6a\xf8\x8d\x9c\x42\x75\x35\x79"
-			  "\xc1\x96\xbd\x31\x6e\x69\x1b\x50",
-		.clen	= 16,
-	}, {
-		.key	= "\x22\xa6\x7c\x7f\x15\xe6\x3c\xf0"
-			  "\xac\x4b\x37\x86\xb0\xa2\x13\xd2",
-		.klen	= 16,
-		.iv	= "\x31\x6f\x0b\xe6\x59\x85\xe6\x77"
-			  "\xcc\x81\x63\xab\xae\x6b\x43\x54",
-		.assoc	= "\x40",
-		.alen	= 1,
-		.ptext	= "\x4f",
-		.plen	= 1,
-		.ctext	= "\x01\x24\xb1\xba\xf6\xd3\xdf\x83"
-			  "\x70\x45\xe3\x2a\x9d\x5c\x63\x98"
-			  "\x39",
-		.clen	= 17,
-	}, {
-		.key	= "\x5e\xcb\xb6\x1e\x25\x62\xe4\x0c"
-			  "\x2d\x25\xe9\x18\xaa\xc6\xd5\xd8",
-		.klen	= 16,
-		.iv	= "\x6d\x94\x44\x86\x69\x00\x8f\x93"
-			  "\x4d\x5b\x15\x3c\xa8\x8f\x06\x5a",
-		.assoc	= "\x7c\x5d\xd3\xee\xad\x9f\x39\x1a"
-			  "\x6d\x92\x42\x61\xa7\x58\x37",
-		.alen	= 15,
-		.ptext	= "\x8b\x26\x61\x55\xf1\x3e\xe3\xa1"
-			  "\x8d\xc8\x6e\x85\xa5\x21\x67",
-		.plen	= 15,
-		.ctext	= "\x18\x78\xc2\x6e\xe1\xf7\xe6\x8a"
-			  "\xca\x0e\x62\x00\xa8\x21\xb5\x21"
-			  "\x3d\x36\xdb\xf7\xcc\x31\x94\x9c"
-			  "\x98\xbd\x71\x7a\xef\xa4\xfa",
-		.clen	= 31,
-	}, {
-		.key	= "\x9b\xef\xf0\xbd\x35\xdd\x8d\x28"
-			  "\xad\xff\x9b\xa9\xa4\xeb\x98\xdf",
-		.klen	= 16,
-		.iv	= "\xaa\xb8\x7e\x25\x79\x7c\x37\xaf"
-			  "\xce\x36\xc7\xce\xa2\xb4\xc9\x60",
-		.assoc	= "\xb9\x82\x0c\x8d\xbd\x1b\xe2\x36"
-			  "\xee\x6c\xf4\xf2\xa1\x7d\xf9\xe2",
-		.alen	= 16,
-		.ptext	= "\xc8\x4b\x9b\xf5\x01\xba\x8c\xbd"
-			  "\x0e\xa3\x21\x16\x9f\x46\x2a\x63",
-		.plen	= 16,
-		.ctext	= "\xea\xd1\x81\x75\xb4\x13\x1d\x86"
-			  "\xd4\x17\x26\xe5\xd6\x89\x39\x04"
-			  "\xa9\x6c\xca\xac\x40\x73\xb2\x4c"
-			  "\x9c\xb9\x0e\x79\x4c\x40\x65\xc6",
-		.clen	= 32,
-	}, {
-		.key	= "\xd7\x14\x29\x5d\x45\x59\x36\x44"
-			  "\x2e\xd9\x4d\x3b\x9e\x0f\x5b\xe5",
-		.klen	= 16,
-		.iv	= "\xe6\xdd\xb8\xc4\x89\xf8\xe0\xca"
-			  "\x4f\x10\x7a\x5f\x9c\xd8\x8b\x66",
-		.assoc	= "\xf5\xa6\x46\x2c\xce\x97\x8a\x51"
-			  "\x6f\x46\xa6\x83\x9b\xa1\xbc\xe8"
-			  "\x05",
-		.alen	= 17,
-		.ptext	= "\x05\x70\xd5\x94\x12\x36\x35\xd8"
-			  "\x8f\x7d\xd3\xa8\x99\x6a\xed\x69"
-			  "\xd0",
-		.plen	= 17,
-		.ctext	= "\xf4\xb2\x84\xd1\x81\xfa\x98\x1c"
-			  "\x38\x2d\x69\x90\x1c\x71\x38\x98"
-			  "\x9f\xe1\x19\x3b\x63\x91\xaf\x6e"
-			  "\x4b\x07\x2c\xac\x53\xc5\xd5\xfe"
-			  "\x93",
-		.clen	= 33,
-	}, {
-		.key	= "\x14\x39\x63\xfc\x56\xd5\xdf\x5f"
-			  "\xaf\xb3\xff\xcc\x98\x33\x1d\xeb",
-		.klen	= 16,
-		.iv	= "\x23\x02\xf1\x64\x9a\x73\x89\xe6"
-			  "\xd0\xea\x2c\xf1\x96\xfc\x4e\x6d",
-		.assoc	= "\x32\xcb\x80\xcc\xde\x12\x33\x6d"
-			  "\xf0\x20\x58\x15\x95\xc6\x7f\xee"
-			  "\x2f\xf9\x4e\x2c\x1b\x98\x43\xc7"
-			  "\x68\x28\x73\x40\x9f\x96\x4a",
-		.alen	= 31,
-		.ptext	= "\x41\x94\x0e\x33\x22\xb1\xdd\xf4"
-			  "\x10\x57\x85\x39\x93\x8f\xaf\x70"
-			  "\xfa\xa9\xd0\x4d\x5c\x40\x23\xcd"
-			  "\x98\x34\xab\x37\x56\xae\x32",
-		.plen	= 31,
-		.ctext	= "\xa0\xe7\x0a\x60\xe7\xb8\x8a\xdb"
-			  "\x94\xd3\x93\xf2\x41\x86\x16\xdd"
-			  "\x4c\xe8\xe7\xe0\x62\x48\x89\x40"
-			  "\xc0\x49\x9b\x63\x32\xec\x8b\xdb"
-			  "\xdc\xa6\xea\x2c\xc2\x7f\xf5\x04"
-			  "\xcb\xe5\x47\xbb\xa7\xd1\x9d",
-		.clen	= 47,
-	}, {
-		.key	= "\x50\x5d\x9d\x9b\x66\x50\x88\x7b"
-			  "\x30\x8e\xb1\x5e\x92\x58\xe0\xf1",
-		.klen	= 16,
-		.iv	= "\x5f\x27\x2b\x03\xaa\xef\x32\x02"
-			  "\x50\xc4\xde\x82\x90\x21\x11\x73",
-		.assoc	= "\x6e\xf0\xba\x6b\xee\x8e\xdc\x89"
-			  "\x71\xfb\x0a\xa6\x8f\xea\x41\xf4"
-			  "\x5a\xbb\x59\xb0\x20\x38\xc5\xe0"
-			  "\x29\x56\x52\x19\x79\xf5\xe9\x37",
-		.alen	= 32,
-		.ptext	= "\x7e\xb9\x48\xd3\x32\x2d\x86\x10"
-			  "\x91\x31\x37\xcb\x8d\xb3\x72\x76"
-			  "\x24\x6b\xdc\xd1\x61\xe0\xa5\xe7"
-			  "\x5a\x61\x8a\x0f\x30\x0d\xd1\xec",
-		.plen	= 32,
-		.ctext	= "\x62\xdc\x2d\x68\x2d\x71\xbb\x33"
-			  "\x13\xdf\xc0\x46\xf6\x61\x94\xa7"
-			  "\x60\xd3\xd4\xca\xd9\xbe\x82\xf3"
-			  "\xf1\x5b\xa0\xfa\x15\xba\xda\xea"
-			  "\x87\x68\x47\x08\x5d\xdd\x83\xb0"
-			  "\x60\xf4\x93\x20\xdf\x34\x8f\xea",
-		.clen	= 48,
-	}, {
-		.key	= "\x8d\x82\xd6\x3b\x76\xcc\x30\x97"
-			  "\xb1\x68\x63\xef\x8c\x7c\xa3\xf7",
-		.klen	= 16,
-		.iv	= "\x9c\x4b\x65\xa2\xba\x6b\xdb\x1e"
-			  "\xd1\x9e\x90\x13\x8a\x45\xd3\x79",
-		.assoc	= "\xab\x14\xf3\x0a\xfe\x0a\x85\xa5"
-			  "\xf2\xd5\xbc\x38\x89\x0e\x04\xfb"
-			  "\x84\x7d\x65\x34\x25\xd8\x47\xfa"
-			  "\xeb\x83\x31\xf1\x54\x54\x89\x0d"
-			  "\x9d",
-		.alen	= 33,
-		.ptext	= "\xba\xde\x82\x72\x42\xa9\x2f\x2c"
-			  "\x12\x0b\xe9\x5c\x87\xd7\x35\x7c"
-			  "\x4f\x2e\xe8\x55\x66\x80\x27\x00"
-			  "\x1b\x8f\x68\xe7\x0a\x6c\x71\xc3"
-			  "\x21\x78\x55\x9d\x9c\x65\x7b\xcd"
-			  "\x0a\x34\x97\xff\x47\x37\xb0\x2a"
-			  "\x80\x0d\x19\x98\x33\xa9\x7a\xe3"
-			  "\x2e\x4c\xc6\xf3\x8c\x88\x42\x01"
-			  "\xbd",
-		.plen	= 65,
-		.ctext	= "\x84\xc5\x21\xab\xe1\xeb\xbb\x6d"
-			  "\xaa\x2a\xaf\xeb\x3b\x3b\x69\xe7"
-			  "\x2c\x47\xef\x9d\xb7\x53\x36\xb7"
-			  "\xb6\xf5\xe5\xa8\xc9\x9e\x02\xd7"
-			  "\x83\x88\xc2\xbd\x2f\xf9\x10\xc0"
-			  "\xf5\xa1\x6e\xd3\x97\x64\x82\xa3"
-			  "\xfb\xda\x2c\xb1\x94\xa1\x58\x32"
-			  "\xe8\xd4\x39\xfc\x9e\x26\xf9\xf1"
-			  "\x61\xe6\xae\x07\xf2\xe0\xa7\x44"
-			  "\x96\x28\x3b\xee\x6b\xc6\x16\x31"
-			  "\x3f",
-		.clen	= 81,
-	}, {
-		.key	= "\xc9\xa7\x10\xda\x86\x48\xd9\xb3"
-			  "\x32\x42\x15\x80\x85\xa1\x65\xfe",
-		.klen	= 16,
-		.iv	= "\xd8\x70\x9f\x42\xca\xe6\x83\x3a"
-			  "\x52\x79\x42\xa5\x84\x6a\x96\x7f",
-		.assoc	= "\xe8\x39\x2d\xaa\x0e\x85\x2d\xc1"
-			  "\x72\xaf\x6e\xc9\x82\x33\xc7\x01"
-			  "\xaf\x40\x70\xb8\x2a\x78\xc9\x14"
-			  "\xac\xb1\x10\xca\x2e\xb3\x28\xe4"
-			  "\xac\xfa\x58\x7f\xe5\x73\x09\x8c"
-			  "\x1d\x40\x87\x8c\xd9\x75\xc0\x55"
-			  "\xa2\xda\x07\xd1\xc2\xa9\xd1\xbb"
-			  "\x09\x4f\x77\x62\x88\x2d\xf2\x68"
-			  "\x54",
-		.alen	= 65,
-		.ptext	= "\xf7\x02\xbb\x11\x52\x24\xd8\x48"
-			  "\x93\xe6\x9b\xee\x81\xfc\xf7\x82"
-			  "\x79\xf0\xf3\xd9\x6c\x20\xa9\x1a"
-			  "\xdc\xbc\x47\xc0\xe4\xcb\x10\x99"
-			  "\x2f",
-		.plen	= 33,
-		.ctext	= "\x8f\x23\x47\xfb\xf2\xac\x23\x83"
-			  "\x77\x09\xac\x74\xef\xd2\x56\xae"
-			  "\x20\x7b\x7b\xca\x45\x8e\xc8\xc2"
-			  "\x50\xbd\xc7\x44\x1c\x54\x98\xd8"
-			  "\x1f\xd0\x9a\x79\xaa\xf9\xe1\xb3"
-			  "\xb4\x98\x5a\x9b\xe4\x4d\xbf\x4e"
-			  "\x39",
-		.clen	= 49,
-	}, {
-		.key	= "\x06\xcc\x4a\x79\x96\xc3\x82\xcf"
-			  "\xb3\x1c\xc7\x12\x7f\xc5\x28\x04",
-		.klen	= 16,
-		.iv	= "\x15\x95\xd8\xe1\xda\x62\x2c\x56"
-			  "\xd3\x53\xf4\x36\x7e\x8e\x59\x85",
-		.assoc	= "\x24\x5e\x67\x49\x1e\x01\xd6\xdd"
-			  "\xf3\x89\x20\x5b\x7c\x57\x89\x07",
-		.alen	= 16,
-		.ptext	= "\x33\x27\xf5\xb1\x62\xa0\x80\x63"
-			  "\x14\xc0\x4d\x7f\x7b\x20\xba\x89",
-		.plen	= 16,
-		.ctext	= "\x42\xc3\x58\xfb\x29\xe2\x4a\x56"
-			  "\xf1\xf5\xe1\x51\x55\x4b\x0a\x45"
-			  "\x46\xb5\x8d\xac\xb6\x34\xd8\x8b"
-			  "\xde\x20\x59\x77\xc1\x74\x90",
-		.clen	= 31,
-	}, {
-		.key	= "\x42\xf0\x84\x19\xa6\x3f\x2b\xea"
-			  "\x34\xf6\x79\xa3\x79\xe9\xeb\x0a",
-		.klen	= 16,
-		.iv	= "\x51\xb9\x12\x80\xea\xde\xd5\x71"
-			  "\x54\x2d\xa6\xc8\x78\xb2\x1b\x8c",
-		.assoc	= "\x61\x83\xa0\xe8\x2e\x7d\x7f\xf8"
-			  "\x74\x63\xd2\xec\x76\x7c\x4c\x0d",
-		.alen	= 16,
-		.ptext	= "\x70\x4c\x2f\x50\x72\x1c\x29\x7f"
-			  "\x95\x9a\xff\x10\x75\x45\x7d\x8f",
-		.plen	= 16,
-		.ctext	= "\xb2\xfb\xf6\x97\x69\x7a\xe9\xec"
-			  "\xe2\x94\xa1\x8b\xa0\x2b\x60\x72"
-			  "\x1d\x04\xdd\x6a\xef\x46\x8f\x68"
-			  "\xe9\xe0\x17\x45\x70\x12",
-		.clen	= 30,
-	}, {
-		.key	= "\x7f\x15\xbd\xb8\xb6\xba\xd3\x06"
-			  "\xb5\xd1\x2b\x35\x73\x0e\xad\x10",
-		.klen	= 16,
-		.iv	= "\x8e\xde\x4c\x20\xfa\x59\x7e\x8d"
-			  "\xd5\x07\x58\x59\x72\xd7\xde\x92",
-		.assoc	= "\x9d\xa7\xda\x88\x3e\xf8\x28\x14"
-			  "\xf5\x3e\x85\x7d\x70\xa0\x0f\x13",
-		.alen	= 16,
-		.ptext	= "\xac\x70\x69\xef\x82\x97\xd2\x9b"
-			  "\x15\x74\xb1\xa2\x6f\x69\x3f\x95",
-		.plen	= 16,
-		.ctext	= "\x47\xda\x54\x42\x51\x72\xc4\x8b"
-			  "\xf5\x57\x0f\x2f\x49\x0e\x11\x3b"
-			  "\x78\x93\xec\xfc\xf4\xff\xe1\x2d",
-		.clen	= 24,
-	},
-};
-
 static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
 	/*
 	 * Borrowed from the first applicable test vector from ACVP:
-- 
2.56.0.567.gdb80ae8cd5-goog

