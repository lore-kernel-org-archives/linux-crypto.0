Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DAC2144D3
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729106811; cv=none; b=N52itPO9D3/JpoorDLgzgzbFefo/nOAHQTBSjO/2BacrbB1ad1Vfr0akrdiNWjhip2flZbabxfe6QsEzhjjJ1nMjw3AMBENOyvoD4QUYpFoKOu2MRsH+p+EIuQaChJn4SP0qg9d3D2jFAEWuWvSkR2uppQYa9yILJczDarZgnR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729106811; c=relaxed/simple;
	bh=kEqsGqMnenIrGLULLkXDJmc0xqN2YM+PDFTCKGEnApw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b/HvSPH7ALsOTwtpryMgqm9BGXrhqR5Fn1mt2gRyD4AzcvRgkAnMYy7NiZpzZZLRVHJ3fCWUAzOLl2ypdTxDkJ4sfqs0Bbc0xxJabpmVt5QBG51KYHTRDHNSgQplCMCYxmll/AuW4tpnGnIwYVLGAfCSQ3NhwY4GBRtWvw/UjWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y067a+aq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y067a+aq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43117b2a901so1917525e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 12:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729106809; x=1729711609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdyYwjyFS7cKng3xrhrvuZYheW62euvO0qiJZmOhRNg=;
        b=y067a+aquSVuK1erh5I7eXgV+jhw3lXbAVlD7o6Tfw9sIENvO6Grw77Dh+2WN+UGmy
         Lacfk939ypB8CLJmUCxRs7n5zeWpDSad/A0BwTE1zgQt/Mtfk7n7YbXXdEGpQUivFFCt
         R4Hu/MSZNXhKpSc+mmBdboaKl2BNvqrnEFS0PRYAbFAMmBt6uSCQRNXlkDVgeVuUgFL5
         2c8N9XKw6TzySWjLsGfCWwDmVkrM0fSBNhYVO3RUwqbDvfodhahwA/1EEKZdL32VgciA
         V58iBU46xtaSOOqo2dQRrImNuQfHNT2sLSiR1fSf9vZ3vkU08/Cm7yu7VD8Nn/bH8qXe
         5U5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729106809; x=1729711609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sdyYwjyFS7cKng3xrhrvuZYheW62euvO0qiJZmOhRNg=;
        b=k1I+zqfRQv044HyFFHUDx5AwRBy9QjMxTzXrkxV5Pi7E//N5C3OZYP5GK6DR2YpkX9
         FZK3XhkHupFTN2D1oGx7Ji1IyXX3fLWHc3FPaIgjeJvtmKWrtKwSfuk2S5piMzUqe8xd
         9CPTxWFdFS3HtfjxSFiXibSU8UhGZm147ko8/Fvt34yqrbZAl4P40eEo/7213iDUX/Pp
         vLHsvFrPMt3I3yuYv8sdzt/lMUUQ3+boLm1O4iKNKZ9lmYVLrKskitfWgiL2Dc7tPHnb
         aGHTDu/KfShgR8PpTH3C/GMCa66mWljQQYIR9kPz9/2p1DBvvzg24nk4QZLe4sdlAviU
         tSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrMzcSLxq8Yw0FNIhnerafeIml/HEAjlMBLo/War+hRy0hRF5hmkhpHr4NlrU/hBcH1HIhfrYz6Ux2Vic=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmA2UhI0IfCqHbZPhAzWP9yPTAZm+uPdykv4ThuCh3jUMvPHk5
	NxakNzMNLmCY5zbMVkd9VAevWlexrBcrKRKbtV1Rm1tzjQ0quTUBJNY3dPxvCn4Mw5sYEg==
X-Google-Smtp-Source: AGHT+IFNPVTQq4FU+tjLci7Y7yj+a7X37dCzskRm3spU5YpifCPnZ7HlXxkkLmtwz8D5/uebxM7mm2Tn
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:26c4:b0:430:4e1e:9b93 with SMTP id
 5b1f17b1804b1-4314a28b66cmr30515e9.1.1729106808491; Wed, 16 Oct 2024 12:26:48
 -0700 (PDT)
Date: Wed, 16 Oct 2024 21:26:42 +0200
In-Reply-To: <20241016192640.406255-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241016192640.406255-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3064; i=ardb@kernel.org;
 h=from:subject; bh=t1qGgmVoGyL6ETZIh2nQx2YqAZcU/0d9D3ED8tzRuT0=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV1AuMiwY47kzKTnOvHTz5cHyx+V3/hUy0hdUl9PnOFb6
 8rdL1d0lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIk0PGZk+KujsWGZZ170Z2++
 nBPTvL8z1itsrk/N4YsOvri0PiR9CiNDg6Tb4YwWkdx+wVleHHJdOa1u1cUTDGdO350W33rAcSE bAA==
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241016192640.406255-5-ardb+git@google.com>
Subject: [PATCH v2 1/2] arm64/lib: Handle CRC-32 alternative in C code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, will@kernel.org, catalin.marinas@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

In preparation for adding another code path for performing CRC-32, move
the alternative patching for ARM64_HAS_CRC32 into C code. The logic for
deciding whether to use this new code path will be implemented in C too.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/lib/Makefile     |  2 +-
 arch/arm64/lib/crc32-glue.c | 34 ++++++++++++++++++++
 arch/arm64/lib/crc32.S      | 21 ++++--------
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 13e6a2829116..8e882f479d98 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -13,7 +13,7 @@ endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
-obj-$(CONFIG_CRC32) += crc32.o
+obj-$(CONFIG_CRC32) += crc32.o crc32-glue.o
 
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
diff --git a/arch/arm64/lib/crc32-glue.c b/arch/arm64/lib/crc32-glue.c
new file mode 100644
index 000000000000..0b51761d4b75
--- /dev/null
+++ b/arch/arm64/lib/crc32-glue.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/crc32.h>
+#include <linux/linkage.h>
+
+#include <asm/alternative.h>
+
+asmlinkage u32 crc32_le_arm64(u32 crc, unsigned char const *p, size_t len);
+asmlinkage u32 crc32c_le_arm64(u32 crc, unsigned char const *p, size_t len);
+asmlinkage u32 crc32_be_arm64(u32 crc, unsigned char const *p, size_t len);
+
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
+{
+	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
+		return crc32_le_base(crc, p, len);
+
+	return crc32_le_arm64(crc, p, len);
+}
+
+u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
+{
+	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
+		return __crc32c_le_base(crc, p, len);
+
+	return crc32c_le_arm64(crc, p, len);
+}
+
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
+{
+	if (!alternative_has_cap_likely(ARM64_HAS_CRC32))
+		return crc32_be_base(crc, p, len);
+
+	return crc32_be_arm64(crc, p, len);
+}
diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
index 8340dccff46f..5dac63da4247 100644
--- a/arch/arm64/lib/crc32.S
+++ b/arch/arm64/lib/crc32.S
@@ -136,25 +136,16 @@ CPU_BE( rev16		\reg, \reg	)
 	.endm
 
 	.align		5
-SYM_FUNC_START(crc32_le)
-alternative_if_not ARM64_HAS_CRC32
-	b		crc32_le_base
-alternative_else_nop_endif
+SYM_FUNC_START(crc32_le_arm64)
 	__crc32
-SYM_FUNC_END(crc32_le)
+SYM_FUNC_END(crc32_le_arm64)
 
 	.align		5
-SYM_FUNC_START(__crc32c_le)
-alternative_if_not ARM64_HAS_CRC32
-	b		__crc32c_le_base
-alternative_else_nop_endif
+SYM_FUNC_START(crc32c_le_arm64)
 	__crc32		c
-SYM_FUNC_END(__crc32c_le)
+SYM_FUNC_END(crc32c_le_arm64)
 
 	.align		5
-SYM_FUNC_START(crc32_be)
-alternative_if_not ARM64_HAS_CRC32
-	b		crc32_be_base
-alternative_else_nop_endif
+SYM_FUNC_START(crc32_be_arm64)
 	__crc32		be=1
-SYM_FUNC_END(crc32_be)
+SYM_FUNC_END(crc32_be_arm64)
-- 
2.47.0.rc1.288.g06298d1525-goog

