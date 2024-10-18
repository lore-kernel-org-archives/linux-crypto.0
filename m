Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFB18C33E
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 07:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238039; cv=none; b=BjSFSJlmYZYE8+V8M0GTWKdAuO5TZf+oKef5RCersl9Gd1dgaZuLPfGM3Ag6eQ3AxvmxHZrzetMBuIoHYgTSJNW5i6jNghHhG1BVQKoEAMVu/498dtql5iMKGhDQeWsc08KeYepcCIrNTG4LIIjtTzePAyWpKJ9yT8cLKBXCXpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238039; c=relaxed/simple;
	bh=oIlFT7Jxrt62NzF5vNKKgkbIj4vzF5UYXMHHr7146nM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q/Ek/HcWfa5IoQS0r9XX9XCLl6/d0abQkY53AjPBgV3gvQgz0Bj/yf3GhVtDl/u6KZOjBFjWrrh5h+Yv6TmgcFzU/uUbEwRszx2pqq3zjP7PdaNwdp2ky8NjzkJYMhnboTmH6HU9kt+QAmkgZgC8fajoymGWRlkJ5skGLCt2CEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tqnscNkx; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tqnscNkx"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e0082c1dd0so40850107b3.3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 00:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729238037; x=1729842837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kezPyuM4InCRolJl6LAlFN5HCzOB9cU6j7/gSS+7X54=;
        b=tqnscNkxoKI7pHEp+tN7HOUo9G6UP9ddAN4dJasXtG7wjAx+32H0chBZrmv9oVGmZg
         HxtMZjSEVmg6fIliOu1wGhg7aMFM6fxP8q1xsBs+Lp6apSXjiynOfzX9NuzF7zys6N1F
         CaRD+yAov6BNymHHKRIzz/Bax6Ov3Aq/wkb14CMtWWSH4DDQzrYLhBXLdCEVPr2RiT6T
         SLUDzcdC2tcsgOA2mgvOZFHxqHSZsbdzFwtd7OrBGabdbqnPJ0k3VekmOc2DdlT6qJBf
         YVKwEGo+x9HKzsyF0C3ZCU2QMmSJznG1ZBBs/nuaZBHAnQ9q/Pc3UDH9dYMC4nN6fzCq
         z9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729238037; x=1729842837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kezPyuM4InCRolJl6LAlFN5HCzOB9cU6j7/gSS+7X54=;
        b=pw75KNLXm3IQW4p17CgMUcFdk0/AjfPB+ygrVas5Q788QH0wmOk9QiMGKt5QDcuNoQ
         EzDY3MFeUNwuehR8UQv9wy0XjO9nNtZh/XP9aPZ870TryTtRofQ5kC41XI4gh9QTqT9Z
         JNpPKN7KV7HrZ+hm8yXo2zPsmdBX1vdOsxzQpFHxpOGZxd3txbYpg4S6G547Hyr0N+Ez
         Ac9ZX74qqDeRWrt0wnS83YByrdXLYkW3wRX+NrO/ml0EYTdXRaK39jgLzErgEuyRxABy
         B2xCjxmDWbyXKhn9moMuFWkJK0idAJIQgeOshtekJNJIrIjdoRMuUK6jHtsohiHcX9CI
         Pqew==
X-Forwarded-Encrypted: i=1; AJvYcCX08Myuv2rb/J7POLWwzHfTkryfZvMkp/eSZjqCugebs9oBPEvBsScnon8YtFYdjVFqUJFA5oJD2Dw2VRY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlEiFbz3trKWmpblCwg3LK+17sgn2Mp5aZbgWaMmGxbMu8+nXM
	d5s7b+N3lVP+g1P8ZBUCpECJGLq7Ur7BsI+wUMdLMwRUUGFrde8fXukUDWp80Ohc2sxfPA==
X-Google-Smtp-Source: AGHT+IEcEu05+Y+9rilOMhpbogGpXWKCrEoZFUDBzcsp9tfYjFlk5BqaMhJ/zAVq1ZWuCm5bsQ87jtBt
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:690c:4487:b0:6db:54ae:fd0f with SMTP id
 00721157ae682-6e5bfd8eba6mr49127b3.7.1729238036892; Fri, 18 Oct 2024 00:53:56
 -0700 (PDT)
Date: Fri, 18 Oct 2024 09:53:49 +0200
In-Reply-To: <20241018075347.2821102-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018075347.2821102-5-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3254; i=ardb@kernel.org;
 h=from:subject; bh=BrBF0xPC0fiK7oW+r+6zBvbfuoNaGmKqDl154e11vl8=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV1IhDeWv2XSDrWNN11YuBeoGyR84Pv0d3pduKiC3t01H
 vO3+i/vKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABOpE2dkWHy3ObZ23s28S9pc
 meZeV/awTZi+Ib5kkueRWYmVHxYv6mdkuJqRzbFtsfe7S+lvAvZPaGpmf238pj+Q9d71x0zL/20 4zg0A
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018075347.2821102-6-ardb+git@google.com>
Subject: [PATCH v4 1/3] arm64/lib: Handle CRC-32 alternative in C code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, will@kernel.org, catalin.marinas@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

In preparation for adding another code path for performing CRC-32, move
the alternative patching for ARM64_HAS_CRC32 into C code. The logic for
deciding whether to use this new code path will be implemented in C too.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/lib/Makefile     |  2 +-
 arch/arm64/lib/crc32-glue.c | 34 ++++++++++++++++++++
 arch/arm64/lib/crc32.S      | 22 ++++---------
 3 files changed, 41 insertions(+), 17 deletions(-)

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
index 8340dccff46f..22139691c7ae 100644
--- a/arch/arm64/lib/crc32.S
+++ b/arch/arm64/lib/crc32.S
@@ -6,7 +6,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/alternative.h>
 #include <asm/assembler.h>
 
 	.arch		armv8-a+crc
@@ -136,25 +135,16 @@ CPU_BE( rev16		\reg, \reg	)
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

