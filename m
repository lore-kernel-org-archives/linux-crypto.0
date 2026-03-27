Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E7334DCF9
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 11:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611082; cv=none; b=oLdM5Gyuo8pXbZe3rQQZx+k8hxn4atULxtcsbwVL5rqcCO1wqPq77bdob9XFV66Jr9lz5KeFxYvgdAZwI6N3EICzBL5Z0k6bDkNA8tVBAKRcKtj//DQ0NQ0UPWC9e6U++DPS7LE2X6ZGvTKvujM/N9pd9GbWtgHyiIP2N2A2Ykg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611082; c=relaxed/simple;
	bh=wgFhcPPvgd+DVdfDF+mljNJJQJ9Z93cZdYcVSI/QJNg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mAxugO2qZBLveRNV9kzwNPs+hjOhQvvQA/jZJHJdm5kwYUK12Qp913UaDZWc5YkepJj7iSBqjO8nvrpm2HWOQLxH5Ss8kUQ8D1zHCYs2m7b/aa8R4kQFr8BiwY32n4XU2mOmQDW6F+DROkydcjKK9oFiK8/nQNsitC47Csa4YZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hv5+dGBR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hv5+dGBR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fe36cf73so18037045e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 04:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611078; x=1775215878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmZT00Ychy/3NTwgfmTOB1a8Ndd9LgN+eWkq4LgHQdg=;
        b=hv5+dGBRoPylO9im2VdxZhYgHitipH4Ljov0JYDHg7dsueBveyXULMYSl6Cazy4mNo
         D3Lncr6CfJfyZL8rDbtWl8mC74nxWhEezyM9++23ef8rIMUJ4r7evaxhb5fIj3YJpv/r
         xNs0EOd7jJJtkZUvZZMgwBCnpCsO4nhH++K0Ij+y39oIQSTfh/N4P8eqXJs4W7+eTAYM
         8aWkDNI/41ZEvDWdW17xUewTtgt/APeHQBG1+0P5SSLsBgGha1eXsR81D9v0fUp4YJX0
         clOI5SZNUGJcepVbu4gIm3tA25RGH5Jp2Kn54UwIdsD6yBL7sSqz+MARdEZEZnt4qmwe
         jqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611078; x=1775215878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmZT00Ychy/3NTwgfmTOB1a8Ndd9LgN+eWkq4LgHQdg=;
        b=f0ldKarAFx+5mdTr9YHISKya/nLHOprwKPr8Ki8RbjnvxqqTzNgsPtpsvuXSd0fjQm
         NdFZVG6op2X4JYGJtQ0PbND5m2fkyQTALMJ1ehNOLLAiyq8dDy1egL88lpRea7Kk1yUx
         015mQGCkFspuywGkMc+w0xHlY3lgZ3R1VOqYOJ/HGGZiDsESW/zQaD96K51xarwT6SJV
         jaS7rax25cS7dzQoi7+qFfVATMm/5K0nWt/R3+G00X9lkBI9dNWy7VCAf6b/SXH0YG8y
         iwCLUi+puH43XetMU4FNnw17LDxMTmgRxB/p/gQMiLOlGMQr0C5dXjVD+Z0zpAuAwBkm
         LYbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWbrhMRCINd2SPeALI87T0tH52pkrob3CGrS5rFd5a0iYU/fcB5ZKdp4RcjkZJijIDMrutzHtTSRQFDYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaBYsmAFfNirgoAFczevY/XJRXoIS8x4pd98K5NT9Rz6ivLx0Q
	JiGrnBPaTndDH9fEym7yq5UWIi6KoC6CmHdNIgBY9XCPXnYi2R2sDRxJTXc09AfnzijZdh5xYw=
	=
X-Received: from wrjp8.prod.google.com ([2002:adf:cc88:0:b0:43b:4e32:c2a8])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a108:b0:485:4388:348b
 with SMTP id 5b1f17b1804b1-48727c81d77mr30248765e9.0.1774611077786; Fri, 27
 Mar 2026 04:31:17 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:53 +0100
In-Reply-To: <20260327113047.4043492-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260327113047.4043492-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2411; i=ardb@kernel.org;
 h=from:subject; bh=CP6n0AwzEy3EVDh+0vOJC9hg0Vq3wbja3Fi94y7uAGs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNYVp60psKV4x+/8rY9vl6vut9UO6DV4ekjDTXNHplb2
 38HXLrcUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZifpKRYe0yydXrfL+ebZwj
 p9zl8TZXTMp/jVXaBxGZ2P3TPZzbHzIyXPq8N3jfz9+bZ19Z8J/z1T2nTYI1hWs09DaH520IK9a cyQYA
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-12-ardb+git@google.com>
Subject: [PATCH 5/5] ARM: Remove hacked-up asm/types.h header
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
during the build, and this only happens when using NEON intrinsics, now
that the compiler vectorized version of XOR has been replaced.

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

