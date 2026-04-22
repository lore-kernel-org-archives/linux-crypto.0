Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EACC2E62B4
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878240; cv=none; b=qTXy6VYbbTDBPI/mXjicPFbWlo8oU2on8I+ep1FkFYK+ZSzg99zDaiI76vTzS4FApX7ApO4sg4GxbIGA5rhtPA1y8lwNXuHQg8jBz9qTruOEguDW3E8GswaFPegtlEdLE21lTLYTfochUxTnBV6K1HI03edI9Y5ej7lJljCQmZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878240; c=relaxed/simple;
	bh=d7B4uk59sJLFiJp148XsJHsOzksESJvDQl7EjYSP6jM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UNkphsV5+8sDwz5wbAU08aW2gK0eJUslHv//eVnplDWuy1+n+9epaJ9DeT/KqohKJq8qGDEIUo9aSOIgOSpcTDZYhdUh0+2O3QRTeQCbQD+dh7c00D46AByp7NW5lguNVBypOLytTA1vWZmCaPLUDq5ouAV3I2rc+C36X4A2u7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EOWvoFpC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EOWvoFpC"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d2cd2674so43916125e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878238; x=1777483038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=deqUl/0DmpTgTWRSS3T6H4sZGghf3sR2Je/I0n4Iar8=;
        b=EOWvoFpCUvrZKJciFQDvEQyFCq6FSsTFQPpFPQlIwWZhcI3d0+V1GHUrIkxSPV244e
         uAmTH3WyE4WObhfOaUqEbR4L7sylgGA4peKtBtHxlVRymogD5IF9UFC5toBTH0ZgvtqA
         V+/N5oTMP8JxGhad/Dx2feMvPgrDOj+Oqild/40DLVxEgvTB1IvTmzJdmWkJMBIFKPwV
         BtxQPzJmIddzSh2BXfhrG7zLvr5hlFWkMei50dH6wO3ftd75jaKEXCaA9qVePaEF5faE
         aqe4yYyHHHpMfCR8SkWmmKfBefGiLSQk7N5lqXlOSDZRKlzM8rjtJSrd7ETtB9hKQ/52
         IEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878238; x=1777483038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=deqUl/0DmpTgTWRSS3T6H4sZGghf3sR2Je/I0n4Iar8=;
        b=R7xCruRKqDrT5fdvSO6I4NqcqwM01odVmPzAaCBiI6gUpy980Cd9w5+MzjAmDPLNfM
         6tECwvZRPflfyTtku5eZLGxRIqLVsX7ZbXznotGG77wQ3lk3BiE6m0vPTKNIHEWExBJw
         oxTBy8uNvnTMjEqsUeS7eWazEIoyM79chufazbr78nXcixmbgyRR+uG6Vf5Hn/W5P3Cz
         ZMHtZQLcFKLV1l8NSz/Cxtlq7h5Jjb52i10lmeoaN8Bygnu2vIF84eMzIkPmdAvAu8Dx
         H8MFzxHq5oF/og47tO9PZ+dgBs8VN8zFqMRH8AwYL+Gbp8A6rJw3SAPer7Yj5bQJRkDE
         NysA==
X-Gm-Message-State: AOJu0YyoZ1QJTXSzZ4ewDg/l+hXiawucNj9Y39jN6KzvaFO0uHBN28ms
	EtXh0XFrhvvAEQyiLYIsF0klVIa4jsZjmlbQENXxTovT0fPGYLSJsyMyGw5B33QQOrt9uFBMxQ=
	=
X-Received: from wmer5.prod.google.com ([2002:a05:600c:4345:b0:48a:5970:2007])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8183:b0:488:ab26:8fe0
 with SMTP id 5b1f17b1804b1-488fb765b1dmr277032245e9.15.1776878237613; Wed, 22
 Apr 2026 10:17:17 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:16:57 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3447; i=ardb@kernel.org;
 h=from:subject; bh=zwZvU5669f7aDZao7jQAWD9kIr1c+dLuC0i1hvVVKpM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMlU1fb9UNFytb8/R6yr4vqjz276L+i5vzFZq2Wf/tWX
 9rcrejRUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbSE8/IsLv09KSzW4LMjrcF
 vT9w5UcO17XrYrsvqJgKT3Qy69N+wsXwT6MhqrhI3mZtitiK1Gsx4jVWPX92NrKk/To9cTZrxKU YLgA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-11-ardb+git@google.com>
Subject: [PATCH 1/8] ARM: Add a neon-intrinsics.h header like on arm64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Add a header asm/neon-intrinsics.h similar to the one that arm64 has.
This makes it possible for NEON intrinsics code to be shared seamlessly
between ARM and arm64.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/arch/arm/kernel_mode_neon.rst |  4 +-
 arch/arm/include/asm/neon-intrinsics.h      | 60 ++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/Documentation/arch/arm/kernel_mode_neon.rst b/Documentation/arch/arm/kernel_mode_neon.rst
index 9bfb71a2a9b9..1efb6d35b7bd 100644
--- a/Documentation/arch/arm/kernel_mode_neon.rst
+++ b/Documentation/arch/arm/kernel_mode_neon.rst
@@ -121,4 +121,6 @@ observe the following in addition to the rules above:
 * Compile the unit containing the NEON intrinsics with '-ffreestanding' so GCC
   uses its builtin version of <stdint.h> (this is a C99 header which the kernel
   does not supply);
-* Include <arm_neon.h> last, or at least after <linux/types.h>
+* Do not include <arm_neon.h> directly: instead, include <asm/neon-intrinsics.h>,
+  which tweaks some macro definitions so that system headers can be included
+  safely.
diff --git a/arch/arm/include/asm/neon-intrinsics.h b/arch/arm/include/asm/neon-intrinsics.h
new file mode 100644
index 000000000000..8b80c05ce1d7
--- /dev/null
+++ b/arch/arm/include/asm/neon-intrinsics.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_NEON_INTRINSICS_H
+#define __ASM_NEON_INTRINSICS_H
+
+#ifndef __ARM_NEON__
+#error You should compile this file with '-march=armv7-a -mfloat-abi=softfp -mfpu=neon'
+#endif
+
+#include <asm-generic/int-ll64.h>
+
+/*
+ * The C99 types uintXX_t that are usually defined in 'stdint.h' are not as
+ * unambiguous on ARM as you would expect. For the types below, there is a
+ * difference on ARM between GCC built for bare metal ARM, GCC built for glibc
+ * and the kernel itself, which results in build errors if you try to build
+ * with -ffreestanding and include 'stdint.h' (such as when you include
+ * 'arm_neon.h' in order to use NEON intrinsics)
+ *
+ * As the typedefs for these types in 'stdint.h' are based on builtin defines
+ * supplied by GCC, we can tweak these to align with the kernel's idea of those
+ * types, so 'linux/types.h' and 'stdint.h' can be safely included from the
+ * same source file (provided that -ffreestanding is used).
+ *
+ *                    int32_t     uint32_t          intptr_t     uintptr_t
+ * bare metal GCC     long        unsigned long     int          unsigned int
+ * glibc GCC          int         unsigned int      int          unsigned int
+ * kernel             int         unsigned int      long         unsigned long
+ */
+
+#ifdef __INT32_TYPE__
+#undef __INT32_TYPE__
+#define __INT32_TYPE__		int
+#endif
+
+#ifdef __UINT32_TYPE__
+#undef __UINT32_TYPE__
+#define __UINT32_TYPE__		unsigned int
+#endif
+
+#ifdef __INTPTR_TYPE__
+#undef __INTPTR_TYPE__
+#define __INTPTR_TYPE__		long
+#endif
+
+#ifdef __UINTPTR_TYPE__
+#undef __UINTPTR_TYPE__
+#define __UINTPTR_TYPE__	unsigned long
+#endif
+
+/*
+ * genksyms chokes on the ARM NEON instrinsics system header, but we
+ * don't export anything it defines anyway, so just disregard when
+ * genksyms execute.
+ */
+#ifndef __GENKSYMS__
+#include <arm_neon.h>
+#endif
+
+#endif /* __ASM_NEON_INTRINSICS_H */
-- 
2.54.0.rc1.555.g9c883467ad-goog

