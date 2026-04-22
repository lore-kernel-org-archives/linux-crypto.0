Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125873803DF
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878247; cv=none; b=Cw7FbTTlcRdb+sg3AuZVfbl/9GPeNJYjHl//17d4RtWIQnODsTaPCrgzynHJi2Zh3oVsfQ24aj8lL6s8i7NcYs5DJhsgYWl1PKZid/WwnIy0YhyBXI6mytdMOTuI97i+cNphiBoJT6syrTI5Pk+kalJe2mzGVdIz9z1iDiu7r5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878247; c=relaxed/simple;
	bh=PZFLd5rvqF35s/dAbltJY7JKK52t/+savyDJAyIJNmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rq37wQsFIGfSrM0Ngx3D9+Z818SsksawEa4xV5yCcY6DYltvD0qtsh8F2AfHAhFu3aftPqddsVOVZeRTy+w3GAvEG8wSVEXnRlzBnvzkaLkSST17ld7QW8I+GNxqeBZV3Vg9ect98DAPobt6a0vYXviGnu0HyEBW2nQAJb/lfzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eXej9QCd; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eXej9QCd"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d121c4271so4082199f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878244; x=1777483044; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1KAxfG6BFXtsRWghQ1pcNf8ys+JfrNCOwRGJsq7foU=;
        b=eXej9QCdibVndbAGlsO3951JdgifK/V38IDeTy0s88SPIPaaIVBjas6lSZaT2Ph3Tx
         VHeSL6m1LhMmwKEfCi5F1BhzTBjilYc4+1GJV3EllgNLMOJghOW4rMj8YFBrqvFEUGIb
         kdsm/P2XUTd1qgq/c7lDCKdaAAbKBLXs8QeRALr1cw6Nn4uhmgE3CU1SYhxjswXOq9ND
         20oimLnmulclslanAuTjT2mpxJXfvwNKCOQKqG6dX8hnooz524A/Txu9oI484Ia50qWF
         X16jqqhb7C8TCpEWLjX86DwVbHsq7xZPhkaGUM+aZIgWq9rXDG5effJDmj2WguiVhqsp
         Dr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878244; x=1777483044;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w1KAxfG6BFXtsRWghQ1pcNf8ys+JfrNCOwRGJsq7foU=;
        b=FM9J8FOpXPHAXjpGw202I1m57HaH5t95SYUxaZRuezzcqLy41BmAXeWZePrKxxlHnt
         WtNyJ3ihfD4EpstrVIpGliZcD9zJBe8SV92bS7PwCHp5G2iK8iENemGpPIOCx8OA0SNj
         Py1wCbI3WVUmgMZL9UrYGQ+Vooh3NUs84Fk42TXs9VS7QhGGjsOJjgI/LHCC2B7xABLG
         2b7hy/jCd5G20UGvF1LjVt7x+aDZGRZc4pHxOFIZqkZK5cHSuF2mY+N7DzZKnBmXVSX1
         jsZthB1bjwfMQq7bwfGzLm7TTV0YcYtOPejKyzxGpy3QTJBAf0nh2rCvLzzbcdB0O8Ek
         TJOg==
X-Gm-Message-State: AOJu0Yx7LVPF6Rob0qQZsZ7/pgvXUslYC15SA1ew8AoKRzSIn2tRKMV1
	U31+CO3W16cirQTFx6VHrnv8yKhP+M/nwqkbWNE30UTW+1IZcrtqUgfd4SpEKDbuEKQqn5s3cQ=
	=
X-Received: from wrmy2.prod.google.com ([2002:adf:e6c2:0:b0:43d:780a:6fbd])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1785:b0:43c:fc5c:a9fe
 with SMTP id ffacd0b85a97d-43fe3dbf4e7mr36040481f8f.20.1776878244159; Wed, 22
 Apr 2026 10:17:24 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:17:04 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2395; i=ardb@kernel.org;
 h=from:subject; bh=koeyEC8RTAmtOu/HBUQeDz+lw7UQyz/6JF7WLaYxDho=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMl0xQzr0KxmdZfvl+P5DSYP6tiwby57XVLbdaKvFJYd
 TqAx5i7o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwk6Ssjwx2t741yoiGzA79V
 zeB3urdbxE9y8gYlxXWrAoTv+nRN5mRkeGwV3VUkElTDfrf232l2DlXJ7kYRmd57Vp+fq1xdz/a DBwA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-18-ardb+git@google.com>
Subject: [PATCH 8/8] ARM: Remove hacked-up asm/types.h header
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
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
2.54.0.rc1.555.g9c883467ad-goog

