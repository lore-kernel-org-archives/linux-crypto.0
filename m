Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281840;
	b=zxi45WIxdNniXFcJ2/CHRN0A4CwjgMINqEaK3qjiDu9LIE2PYAT6gZobcO/UXM02rALC
	 hMEYK0etTm6PFpXqCay0G0MsgK73XFml8V/IrlEI/gHPfdjW5RYulMKU/z0FSKBIxCakd
	 /xX6C0yoz0hl92CTWT1HGCdaMY/ctSWJcVlX7i46NH8TS71A0K2V3Zair6q21hdiOf7b9
	 /ARSSDxeBP5CdugyMkLnsuGja5tUrnwmJYo+Iui/Ae5jlGc9KxtqBvjLdTbEkJ7PZ7H4u
	 WOrnzd32E+zelDMpd6+zbOKZj6p6thsG0M1pDNJVMo+xzxcQVeZ01BBJ5YVV2PicLxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=rHmC9nnHSs/HBIYFqAJimZ70eQd4OJw7JCv9j7P9OZ4=;
	b=kfs/YL0fUtacFnbdq9js9BhRUTXmA4EVK8OAj3otuTONd6UjOvh60s7a/tqIC+SRFZGJ
	 Kv13RlWz0Bofmg+ygop3zb2DHzDfK7fIBYoKIZau/vWoirkzHn0WUaVkov2sVGD1mEXu8
	 EWrg6o41cY04kJWeRaTtV68qF4KWFcFPl8Ka7S0GYamxoWsSntdY3kbAf60d1KmgjPOD4
	 yazny+JFPcRGomY6eWtj6HSS0sa04pWjCaoSo/roEX29R8vn5ePBIWC3azEvE+u6LOKy4
	 nQ32bUGYlGvJNlNLPLypCvnOQvnin4nlfkI01nObmmTuKoIuWV2okcSoFccHMgbq8ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pye7StVF;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C460A2619
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 13:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C5C460A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pye7StVF
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1d1f26a63so18910055e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 06:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281839; x=1793886639; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rHmC9nnHSs/HBIYFqAJimZ70eQd4OJw7JCv9j7P9OZ4=;
        b=pye7StVFKtRSkDKooVu6T0zv1CXbTCcB1Ru2v0/T9uZ52RN6jiqnXmmJHFdxoMUjDW
         bk6Zvfhf9r11Y6V3eWWClkLZ8WG3TEZLu/DF0/lUnkvASEiyXZeulv8C86il9/yNaJeG
         LNl/+7fS6JKbKDOEgWCA8F7oD0YNdQY8KX0jqPP4G5QlzwDnuFHfqaxTmWDUZ340yLI5
         3Ea2CUUO9syqqfS0z/p3BDwiDuPybOrZlIYQfIksS5jloXtUPwm04ChpE1b5j9JKAESD
         xNAYB0pYKdGugETh9GXghEq37MzZhFGEMWdvH/cCN5iBFGheiXiwbB/zLvYZZlUoVBBs
         XJjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281839; x=1793886639;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rHmC9nnHSs/HBIYFqAJimZ70eQd4OJw7JCv9j7P9OZ4=;
        b=nG+N0kDx59hH9rM8tN78jV3yXbSZ+kSvLYCwVbLYEkPD5KLz3EWN0eg5uz/nM5Hhi3
         RCsMyDk88Zj4yVhysvGgXKeqatnxQwRJjmdS3WAEggOdBAWQWQZDXA1eQvyKKiaO1vi0
         NGRZ924AWOmyKqTN5UjjIdCtt2vrUGuOUxudWZu/Bdc4zF6oh9Eo/TIDtTcZeQmYXUFh
         KFkVGubLr+DtAbu+rzM+dd3LkK/e4an+824o8seijfK9dmTc66U00KntSOMRWf3S/ygD
         F0wvmkanJ2AlBFC9/tmb4G+7XsQ88H5ay6fD5iRBofvvIitSGMB7pWPw+zZVwXsyMPTK
         EyUA==
X-Forwarded-Encrypted: i=1; AKwUvByasO28N9jomAnaLI3E/bROhGUoy2sbIlvstzASWF/k8xqurdb+Kisu89GdAVVtKg88RLMJynMKVKrbGes=@vger.kernel.org
X-Gm-Message-State: AFq9FYJCr+uLpydm4HH6S4OYTJReSW8eP1Qc7X6YOSVS4yJVz1EzUwxf
	eHy6NYC0IGj8NPwFdnlwjqcnc0LvaRV5xY8pSd4Tv2xJZPmAtOhkjd85oIj8Kn9dp3wDi4d2BQ=
	=
X-Received: from wmbdx18.prod.google.com ([2002:a05:600c:63d2:b0:4a7:a5bc:d876])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8183:b0:4a4:fc8c:cfd9
 with SMTP id 5b1f17b1804b1-4a96710c712mr106879715e9.25.1793281838064; Thu, 29
 Oct 2026 06:50:38 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:50:23 +0100
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029135020.272082-9-ardb+git@google.com>
Subject: [PATCH 3/4] arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

None of the users of NEON intrinsics include <linux/types.h> anymore,
and so there is no longer a need to override __INT64_TYPE__ and
__UINT64_TYPE__ in order to make the definitions of int64_t and uint64_t
provided by the compiler's freestanding <stdint.h> compatible with the
kernel's. So drop the overrides.

This also means that uint64_t now matches the type that Clang uses for
64-bit quantities in the prototypes of its NEON builtins, and so the
-Wincompatible-pointer-types warnings that are currently being disabled
for all NEON intrinsics code will no longer occur. So drop the pragma
that disables them as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/neon-intrinsics.h | 24 ++++----------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/neon-intrinsics.h b/arch/arm64/include/asm/neon-intrinsics.h
index 5f13505d39fc..43cdf4d16170 100644
--- a/arch/arm64/include/asm/neon-intrinsics.h
+++ b/arch/arm64/include/asm/neon-intrinsics.h
@@ -6,23 +6,13 @@
 #ifndef __ASM_NEON_INTRINSICS_H
 #define __ASM_NEON_INTRINSICS_H
 
-#include <asm-generic/int-ll64.h>
-
 /*
- * In the kernel, u64/s64 are [un]signed long long, not [un]signed long.
- * So by redefining these macros to the former, we can force gcc-stdint.h
- * to define uint64_t / in64_t in a compatible manner.
+ * <arm_neon.h> includes <stdint.h>, which defines some C99 types differently
+ * from <linux/types.h>, so the latter must not be included into code that uses
+ * NEON intrinsics. The kernel's u8/u16/u32/u64 types can be used alongside the
+ * C99 ones, so provide those instead.
  */
-
-#ifdef __INT64_TYPE__
-#undef __INT64_TYPE__
-#define __INT64_TYPE__		long long
-#endif
-
-#ifdef __UINT64_TYPE__
-#undef __UINT64_TYPE__
-#define __UINT64_TYPE__		unsigned long long
-#endif
+#include <asm-generic/int-ll64.h>
 
 /*
  * genksyms chokes on the ARM NEON instrinsics system header, but we
@@ -33,8 +23,4 @@
 #include <arm_neon.h>
 #endif
 
-#ifdef CONFIG_CC_IS_CLANG
-#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
-#endif
-
 #endif /* __ASM_NEON_INTRINSICS_H */
-- 
2.56.0.313.g2479322e68-goog

