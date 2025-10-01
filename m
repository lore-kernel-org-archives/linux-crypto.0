Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC42730BF73
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352636; cv=none; b=odRtARzndwkxq6Uxr0V8WkQWhAo32xKn5DLZAsyYcGxTvJKdsR+gfUifnCY+w7kDcxGY/aXl9Jw7/NeCUmphqP/rJ/8ZcY1yL2tyn5oW/j6yfEtO0Eiu99NwGVfpFu8ve9h3yh4FNpYjleH8JBuIR+y5lubSvNyvrCaTDF9dUxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352636; c=relaxed/simple;
	bh=TaDdrCr4EA15LrvASYKCxfIrPDw/VW9LUU5yJ++wxko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FC741VIteda9N54xGP8bIsEX+e21XQtYn8TvjBSdl1IeytwrEDwYdYd3pDtmfqEmeoA9gIe/7NTK2c8VUM8XD6DpZi+XH4pM9W7CEclRdWM2M6fm9otMFVvBuSDzkT+BTS0kgxPPB8GWxQOG6cyn6Yx1G8AyYu+jHMbOo9h15Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVKp2pHl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVKp2pHl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so1294755e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352632; x=1759957432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yv4MPsa7zu8trmjDFhojytb8BQb2fz3TAffp8KKlObQ=;
        b=vVKp2pHl6ta5RDTqtN3Yq40h2I9t40cDOI/2pYOHsE3XfnCgd0wQaPfdfydNcZ2JiR
         K1IzJrk0U9AK5mB2eVDM7HyKprvDgKb17NrRYdyzriQdcaV6lFIJIvj7Hh32bfaOHwwe
         hvQVByjUMjfXI0GNN2qVU3wvN+cPtlBnrrmqdBafyPnVmZ9LAIbMfX4NNdevwaP5ZcmY
         MIQ87D2jrzBs8jFi2c6tmVvl9c+UOVKYGhimdD8n4l+bkIK0e55WscIeRZd7gc6xgxOz
         wf7EwDqWMSukn5mPbpoIv5TujVm53HL1Gj/24J2afeP1QHXxedO0WVj8hw/q79XlS9mN
         orlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352632; x=1759957432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yv4MPsa7zu8trmjDFhojytb8BQb2fz3TAffp8KKlObQ=;
        b=OUMxqjEWjN5D0r2MLnrfRhqmg6/JC/4zyPRI+V2GE29lxgN5vFcgmflrYHuBeFTdxy
         dl3BcAPQxTxrbuahURpy4lAU0CtG5qPHaE/2pb8/hS2x6Jacngzk+tWR27Dc5ghK3s10
         UBlrlxpZbI1kDblRil9hfDkXf+YGaPYcOcTzFxfGQPfJDNtifDzmrPSFkKOCt+vUV9z7
         AfJQMQvq8FJq/35MHeiFgIZ4tDeWqG49zKwG40S0Lqaqj+H80WXyidydxU+Ecu9oH/NS
         KvOvBputncvd8fu9FkK1TsAVAPKu4BtzMUDrs1JpYxGsk7yu26gejbwZ0v4YaFptErGZ
         px5g==
X-Gm-Message-State: AOJu0YwliLLg7tYzxmB2UrfaY1dxYx4+sZLNpcch5VSXd+Hv87hQIqUl
	G6ZX55dh5BwGSXu5l8qpKQd34FmKUWz+XnB4IH48lo59/bk77qAHUf0jHYAw12jkE9YGOKEaAA=
	=
X-Google-Smtp-Source: AGHT+IEwfMr+9GH23CoDtyxHMgiZV15eJsCtIOXalrQTUCN9ExcDshQ1x2ZZkxN+VVOM8u52+gt+ZxW9
X-Received: from wmbh5.prod.google.com ([2002:a05:600c:a105:b0:46e:1ae9:749a])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:18:b0:46e:45d3:82fd
 with SMTP id 5b1f17b1804b1-46e61285dbamr33313365e9.31.1759352632472; Wed, 01
 Oct 2025 14:03:52 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:03 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5902; i=ardb@kernel.org;
 h=from:subject; bh=Gm8Jj53sW6sJUiVR2FBV0YZV5f74EFJ+TCyGKzfcUfk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePutPMZpVErpLgli+4+e5Y8tWK+SIAO00XutE9MOx2av
 X89zbrQUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYy5yMjw3MuvfD1cQwyggdO
 PNXa/nrzxaLfjyNWNjy+GbZ3lp7X878M/920D9z+/e98p4s9c8G78K/ijhvMvDoV117q+ZdjEVD nyQ0A
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-23-ardb+git@google.com>
Subject: [PATCH v2 01/20] arm64: Revert support for generic kernel mode FPU
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On arm64, generic kernel mode FPU support, as used by the AMD GPU
driver, involves dropping the -mgeneral-regs-only compiler flag, as that
flag makes the use of double and float C types impossible.

However, dropping that flag allows the compiler to use FPU and SIMD
registers in other ways too, and for this reason, arm64 only permits
doing so in strictly controlled contexts, i.e., isolated compilation
units that get called from inside a kernel_neon_begin() and
kernel_neon_end() pair.

The users of the generic kernel mode FPU API lack such strict checks,
and this may result in userland FP/SIMD state to get corrupted, given
that touching FP/SIMD registers outside of a kernel_neon_begin/end pair
does not fault, but silently operates on the userland state without
preserving it.

So disable this feature for the time being.  This reverts commits

  71883ae35278 arm64: implement ARCH_HAS_KERNEL_FPU_SUPPORT
  7177089525d9 arm64: crypto: use CC_FLAGS_FPU for NEON CFLAGS
  4be073931cd8 lib/raid6: use CC_FLAGS_FPU for NEON CFLAGS

Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/Kconfig           |  1 -
 arch/arm64/Makefile          |  9 +-----
 arch/arm64/include/asm/fpu.h | 15 ---------
 arch/arm64/lib/Makefile      |  6 ++--
 lib/raid6/Makefile           | 33 ++++++++++++++------
 5 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b81ab5fbde57..abf70929f675 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -32,7 +32,6 @@ config ARM64
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
-	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 73a10f65ce8b..82209cc52a5a 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -33,14 +33,7 @@ ifeq ($(CONFIG_BROKEN_GAS_INST),y)
 $(warning Detected assembler with broken .inst; disassembly will be unreliable)
 endif
 
-# The GCC option -ffreestanding is required in order to compile code containing
-# ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
-CC_FLAGS_FPU	:= -ffreestanding
-# Enable <arm_neon.h>
-CC_FLAGS_FPU	+= -isystem $(shell $(CC) -print-file-name=include)
-CC_FLAGS_NO_FPU	:= -mgeneral-regs-only
-
-KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU) \
+KBUILD_CFLAGS	+= -mgeneral-regs-only	\
 		   $(compat_vdso) $(cc_has_k_constraint)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(compat_vdso)
diff --git a/arch/arm64/include/asm/fpu.h b/arch/arm64/include/asm/fpu.h
deleted file mode 100644
index 2ae50bdce59b..000000000000
--- a/arch/arm64/include/asm/fpu.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2023 SiFive
- */
-
-#ifndef __ASM_FPU_H
-#define __ASM_FPU_H
-
-#include <asm/neon.h>
-
-#define kernel_fpu_available()	cpu_has_neon()
-#define kernel_fpu_begin()	kernel_neon_begin()
-#define kernel_fpu_end()	kernel_neon_end()
-
-#endif /* ! __ASM_FPU_H */
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 633e5223d944..291b616ab511 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -7,8 +7,10 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
 
 ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
 obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
-CFLAGS_xor-neon.o		+= $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_xor-neon.o	+= $(CC_FLAGS_NO_FPU)
+CFLAGS_REMOVE_xor-neon.o	+= -mgeneral-regs-only
+CFLAGS_xor-neon.o		+= -ffreestanding
+# Enable <arm_neon.h>
+CFLAGS_xor-neon.o		+= -isystem $(shell $(CC) -print-file-name=include)
 endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 5be0a4e60ab1..903e287c50c8 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -34,6 +34,25 @@ CFLAGS_REMOVE_vpermxor8.o += -msoft-float
 endif
 endif
 
+# The GCC option -ffreestanding is required in order to compile code containing
+# ARM/NEON intrinsics in a non C99-compliant environment (such as the kernel)
+ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
+NEON_FLAGS := -ffreestanding
+# Enable <arm_neon.h>
+NEON_FLAGS += -isystem $(shell $(CC) -print-file-name=include)
+ifeq ($(ARCH),arm)
+NEON_FLAGS += -march=armv7-a -mfloat-abi=softfp -mfpu=neon
+endif
+CFLAGS_recov_neon_inner.o += $(NEON_FLAGS)
+ifeq ($(ARCH),arm64)
+CFLAGS_REMOVE_recov_neon_inner.o += -mgeneral-regs-only
+CFLAGS_REMOVE_neon1.o += -mgeneral-regs-only
+CFLAGS_REMOVE_neon2.o += -mgeneral-regs-only
+CFLAGS_REMOVE_neon4.o += -mgeneral-regs-only
+CFLAGS_REMOVE_neon8.o += -mgeneral-regs-only
+endif
+endif
+
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(AWK) -v N=$* -f $(src)/unroll.awk < $< > $@
 
@@ -57,16 +76,10 @@ targets += vpermxor1.c vpermxor2.c vpermxor4.c vpermxor8.c
 $(obj)/vpermxor%.c: $(src)/vpermxor.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
-CFLAGS_neon1.o += $(CC_FLAGS_FPU)
-CFLAGS_neon2.o += $(CC_FLAGS_FPU)
-CFLAGS_neon4.o += $(CC_FLAGS_FPU)
-CFLAGS_neon8.o += $(CC_FLAGS_FPU)
-CFLAGS_recov_neon_inner.o += $(CC_FLAGS_FPU)
-CFLAGS_REMOVE_neon1.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon2.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon4.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_neon8.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_REMOVE_recov_neon_inner.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_neon1.o += $(NEON_FLAGS)
+CFLAGS_neon2.o += $(NEON_FLAGS)
+CFLAGS_neon4.o += $(NEON_FLAGS)
+CFLAGS_neon8.o += $(NEON_FLAGS)
 targets += neon1.c neon2.c neon4.c neon8.c
 $(obj)/neon%.c: $(src)/neon.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
-- 
2.51.0.618.g983fd99d29-goog

