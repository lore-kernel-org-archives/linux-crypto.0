Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBC33CCFAE
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 07:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943400; cv=none; b=H1pye953VI3sAbi9pwmLy4CASTENkNV5WBfvsikFOL0LGtryuGCG+/0pI+zGt9/sX0kTcWuRN8vuO240eEmUWb5ab68f/RTHAYG6jL35CIZYZzjHamkOoutcsFD/88ijNYnvKgeGDy1FCsTOuUHdTRvhj6u5rQTWu5gM4uQnSZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943400; c=relaxed/simple;
	bh=rj4UKghhjQpwTZ9RZN5rC9h3OTBmSb/5ClEuXyJVrM8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cY/A5raCje5gsee4Toal/RCjk6cdEn1oEWZxAKTKSFEP15yMv3PtHdp0jj0XCPmsuTv/xOYyNXAmIxSE3cGGRxx0j0NZdb4+pF5jvPe6agThs4ogWnCWtQ+1ElWmzpSe5l2sgjJK1XE5VuiLp0BpKmHBbzGfXpZ5EHXTWhFzb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L62ybRsA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L62ybRsA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso47746835e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943397; x=1775548197; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xX1RLQfuL8f01fbs5w+AQoYx0sqR/fYyxSbc44uk88k=;
        b=L62ybRsAUNHjQV/yz5uD6aj8zpiYrfvvPDEe8Luyuhs1CyXcoSXh6uZ1rEgpo6X6Gd
         2j17m6RR2l7GAFa3ja+bX7QKsT2uwkYTo340xOGjwx5sDZrAboBXnOCx6b/wxEj9zzUx
         PQa1/XDomgn/Zl5P54wu82CtN/kTEImzy/bKjChlrQm4zcOzZA/VborXwlJf5fs8pCqS
         hbkXODw5QXCTpVLDQiVPULT4m4IbHcT8sD0GSe3tNx4pVE8y/hlWCcmwYoDwPyoWlQdj
         RUDqxIEIXTomQe5bN/DIPPidHslO0yo+68UTpP+FPB3/yK+TXIu0Xuysuf7hapQWY29N
         sGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943397; x=1775548197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xX1RLQfuL8f01fbs5w+AQoYx0sqR/fYyxSbc44uk88k=;
        b=myUsEJzfUnDOTUm6DprOodJk8W2es9VwdRBxe/TMUzjPHusnGbE//5ODwRiYO54j6h
         NBvTw8CcdMlc5QEEGeKZhh3LcilTGRndlNaFLKcA8YJWDgKMuitDkJAUqnGJ5hABYrUA
         v60rtxthsZ6wVDhw/Twu351yJmBn48fqDKs5evPGVAgYwyOOVC2geawGrcd/U9rLDWby
         EeTLsFxCwoLGKEzSp1eyYYgrm9hi3EGatA49yh1x1kZTjtGhty6MGN//hiy1fDlnJb9f
         NlGo/0bNPgAeqEuQgtp+sfZrBSyJ+aErg3EVA7qWxswdCrAuj0QmKLAWXn4jUteoW7Mx
         IF3w==
X-Forwarded-Encrypted: i=1; AJvYcCVuNP/YD+a3ksdr2pq3r1GXZZtmocWxxXdLsbXWsFfD3WqX/vsgamq20YhYuYdD80cwD13iFJ0vTZDAruw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvavoXIkNHTWH+m2dSVw9GOGmgQovgxdgqI4vFcS5L89juXJeb
	6558ysO6tLMtYbc1Do5lMm7p6DayP2zLUTgm84JziLX4UYC9vrlRIe+BD1S+TLPwzvSeSRjXTg=
	=
X-Received: from wmpj25.prod.google.com ([2002:a05:600c:4899:b0:487:304a:7fdd])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d1e:b0:486:fe46:b647
 with SMTP id 5b1f17b1804b1-48727f00d8fmr253676295e9.10.1774943397259; Tue, 31
 Mar 2026 00:49:57 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:45 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2392; i=ardb@kernel.org;
 h=from:subject; bh=VgvFV6e24K1jLyX3BtgZs5h4ZlG8hjrR1x9Qg5yrHgw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zewnU1Knqs9ZfFllycHU259cjd9YXt3kKnk/t+ngk
 tWSv+WPd5SyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJcL9mZPiwTss4cunvH3Gf
 vjaonFg6Tc90zSWeizr3zCck/7CukX/F8FdIympv5PfjRw96CfklM/irxpx5NF9v3aXCuOdG05K XbeACAA==
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-12-ardb+git@google.com>
Subject: [PATCH v2 5/5] ARM: Remove hacked-up asm/types.h header
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

ARM has a special version of asm/types.h which contains overrides for
certain #define's related to the C types used to back C99 types such as
uint32_t and uintptr_t.

This is only needed when pulling in system headers such as stdint.h
during the build, and this only happens when using NEON intrinsics,
for which there is now a dedicated header file.

So drop this header entirely, and revert to the asm-generic one.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/uapi/asm/types.h | 41 --------------------
 1 file changed, 41 deletions(-)

diff --git a/arch/arm/include/uapi/asm/types.h b/arch/arm/include/uapi/asm/types.h
deleted file mode 100644
index 1a667bc26510..000000000000
--- a/arch/arm/include/uapi/asm/types.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _UAPI_ASM_TYPES_H
-#define _UAPI_ASM_TYPES_H
-
-#include <asm-generic/int-ll64.h>
-
-/*
- * The C99 types uintXX_t that are usually defined in 'stdint.h' are not as
- * unambiguous on ARM as you would expect. For the types below, there is a
- * difference on ARM between GCC built for bare metal ARM, GCC built for glibc
- * and the kernel itself, which results in build errors if you try to build with
- * -ffreestanding and include 'stdint.h' (such as when you include 'arm_neon.h'
- * in order to use NEON intrinsics)
- *
- * As the typedefs for these types in 'stdint.h' are based on builtin defines
- * supplied by GCC, we can tweak these to align with the kernel's idea of those
- * types, so 'linux/types.h' and 'stdint.h' can be safely included from the same
- * source file (provided that -ffreestanding is used).
- *
- *                    int32_t         uint32_t               uintptr_t
- * bare metal GCC     long            unsigned long          unsigned int
- * glibc GCC          int             unsigned int           unsigned int
- * kernel             int             unsigned int           unsigned long
- */
-
-#ifdef __INT32_TYPE__
-#undef __INT32_TYPE__
-#define __INT32_TYPE__		int
-#endif
-
-#ifdef __UINT32_TYPE__
-#undef __UINT32_TYPE__
-#define __UINT32_TYPE__	unsigned int
-#endif
-
-#ifdef __UINTPTR_TYPE__
-#undef __UINTPTR_TYPE__
-#define __UINTPTR_TYPE__	unsigned long
-#endif
-
-#endif /* _UAPI_ASM_TYPES_H */
-- 
2.53.0.1018.g2bb0e51243-goog

