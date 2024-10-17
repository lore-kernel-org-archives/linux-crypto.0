Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47E1D9587
	for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2024 09:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158104; cv=none; b=bhqCXZnvoetE5wjKVvZG3ORAu2ymnapGcsfAH8KGuSE3a+WB2pUyOti93D5SDW2+8B7ujNybTmpdGWLT9U/zencGtOfl0Hwez4U7mtRlanJbeoi8oSTdYpyXNv/N/GIS47+/0bmPsTX4P3mJaB294o2f6MAa28YBCLpicv6oRrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158104; c=relaxed/simple;
	bh=oIlFT7Jxrt62NzF5vNKKgkbIj4vzF5UYXMHHr7146nM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k0HStpRRpj4ySZ49cjej+2eWs3F9Of0L8cuscV7n38rxpCz40I7opO4DtKA8I/0UgfiDjatez1oCPA+2u81vN72pjnXgJtZC2u2gDI28DbsDetiR/HDIcXSEaOGGR98KFFra6qU/dV267RkHI4kbyqR2EHQGfoBlZJwfLeCrD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M0tyGkJA; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M0tyGkJA"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-37d458087c0so1006910f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2024 02:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729158101; x=1729762901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kezPyuM4InCRolJl6LAlFN5HCzOB9cU6j7/gSS+7X54=;
        b=M0tyGkJARkygIpiQN19EtNHa3g34evf76RxBv3ofPltSgL9MuL4m6vDB6C3DnestY/
         yKbnlI0cZYexy6GRMYb6J6uEqPfIbhDEu5od1n6PiFMmp2F9x0PEQVWN0A6fnMUIstih
         jLjXAU9C8cmHrdOERyUOFQI0h+nZTXbBuzCS8IAJeWXqVtVYb4Fqzk1saZEqEy0ZRYkS
         lxCdfb3LYSxLY3FK3E7vfMo4/eJB7NpzjuzkSq9AeiW1OLZLF/j5dmb8r9cKqfgFxktp
         /Mwsd7doREMx3CA36clmvPZkfQhsMm1ignX/H0gr4KJas927sAqUSj2ZTJXvgb3jCttC
         3I7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729158101; x=1729762901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kezPyuM4InCRolJl6LAlFN5HCzOB9cU6j7/gSS+7X54=;
        b=kaD474xrrNV+c7ler65VgcBUjPuIolRBEXrgYSgaFJyWHXB/4rVR59YHRvGe8Po2K3
         CeC+N6WuV/0CTphQpsh2wfNKd1e41GljVttBooJB+qHsECQhsUuNJJV0dzXbGUB3+zGa
         Qg1MA9JPnHTyEtUv5VXr3R4+//+pleFhc7Fiy0j7C41aDACerZSjgrkGrC1uGnQMTBeN
         VB1SqIfGYCHWrQp3eyWw7duFbN0S0D9opG5/64GqFjZA95CQr8PCV648bP8kfEbpcVFp
         W2fC9pMVtHWr9RO0E7cTOHXjxETooq05uC55IrXtNfVrSNQyfbXp7h/Wmq+XiCmO8pU2
         k9CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt8QRMcm2Xz1/qq8iezjK0jP6BXBh21GpVbrGb0iFJxW5ifo4jDGAA/KuGkti5JNLDGVusTiJskYXUIi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZmhRZlGmZCGsoeLFxkFiOM+5soHD8wbZ/mG1PNEpd2hSl/wrn
	iQ6qPhUmyX2qaZu1QWd+X4tA6uvrfSNmbB67UXsUTauXMAlETt/+0svPE8B9dZdlmXK4Kw==
X-Google-Smtp-Source: AGHT+IFtrefZwulQCp/DMukJY8gdjmqiJAlfQp80ffHtAb5a7zr+SDM3yt7r1lb8TZ0V24OYrICWPe6U
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:adf:a349:0:b0:37d:32f2:eb27 with SMTP id
 ffacd0b85a97d-37d93e1ba24mr1702f8f.4.1729158100933; Thu, 17 Oct 2024 02:41:40
 -0700 (PDT)
Date: Thu, 17 Oct 2024 11:41:34 +0200
In-Reply-To: <20241017094132.2482168-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241017094132.2482168-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3254; i=ardb@kernel.org;
 h=from:subject; bh=BrBF0xPC0fiK7oW+r+6zBvbfuoNaGmKqDl154e11vl8=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3g9rlY/pZJO9Q23nRh4V6gbpDwge/T3+l14aIKenfXe
 Mzf6r+8o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEwk0JThv++e5d/EtlQuSmB7
 yvHvch2D+pv59tyH6hfz1oUExM3P4mf4K7FFWzx59/uJvYe+7jo9PYbJ/pEyV4Oe7PE5siuVfxz nZwUA
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241017094132.2482168-5-ardb+git@google.com>
Subject: [PATCH v3 1/2] arm64/lib: Handle CRC-32 alternative in C code
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

