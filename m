Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4363D3CFF
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 07:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943397; cv=none; b=YzUSDvvapVYh6avbQb8OZAqAZ916vvQ7s841UuLV/jO3mKlqGFgJCj8+CVLysYQDph+1tGeK015rFnhyddCqKPmk6zw6Vaf+QfYLKYPk5J/l1oWF3lPVlRYtXMo0JMt3QfsA5HvewEGmlM68uyBSJ9tIR2o2tTAMW/zMLKdHu5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943397; c=relaxed/simple;
	bh=vr6mNH90vWzgPd1b4aznKnOMMMOUkJhLMQG5LrjWL8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KDvZEG7zRnzZ+6wpTjPeUCQ4vJiLn+rscfvTumtPuO2HqFkx2HfcZ/LD3B1OD1W+YmYIcR6g0Zv+6PntJX0o9wvBlQ3eAJar87HxMa1wRm9lrzqtEm9CjgsvLzY+1bJ8uBJGx5Bd4OTq1QrqE4oSZotEzjQWV0nj+J30Wnv9a7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=egti3BdU; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="egti3BdU"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b941d4b7f2cso682440366b.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943392; x=1775548192; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nwY78gYNpf388OFjzzX16QE/Cco/4CSsRPLh29K8HMo=;
        b=egti3BdUWShWsmA2VP//zNkzTq5gsRlRQHc487L+N+UBw6DcDf6gRWQP2nytmORYDq
         P4hhH22Kp0a7Pgi8Y/WpAxzxplFYVi0Bo48B9cpepxg0yT3G0XMFr+0m7SBiqIR9d99Z
         aJh1o0WhzeH+Rzr4F1yI0PQNODGFePXcgGbEcw+JuigyxRMBNkJZtZaL13mW78UNNlyW
         26LoCKNLdYVqgxpct7XK+uilfidBQDoZaEqB1HeKUcZiSsOy1/dsAvriCJj+C1336XBD
         VmDIyv2zQqCBG2E55uUbfA2ttJJLK/dmlx8Efm52J+g0/SveB9z57mXaZAfMHQT6in0/
         8+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943392; x=1775548192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nwY78gYNpf388OFjzzX16QE/Cco/4CSsRPLh29K8HMo=;
        b=QWj7E4NDWQS15SUTnAY3sIacveL+8AlyoDtQ580La5vExhT0hhnW/7eId4/tk8fHfl
         9QNPNBoUhH7xkYgGUVst6mkjvc/y6CzWLjjyyX8kTlAJzmNQVu+8AKVafREu0tIW5G1S
         9/aBXysR5DMgv39KCawkhynx8HxBgu4+D/xE3OkVDaR15g0UwDbQ1F2k0pTIFziQdEAd
         +c60jnz5ugbRVgafFjqsnFocYsOu2CUGn7kkJ67cWhAswyJA838wQNuHcQ3z+fL4Rj42
         5TdOqn+ZiWCDvR42YOvHptPxeXfCZNL/6X24C0d6a933sL1En7NU/iQq7tIeBqwbvqAA
         SsJw==
X-Forwarded-Encrypted: i=1; AJvYcCViC6jz153UPtmZGZbSSGu2DytFqUwqVgMpIrbj96l4VXdoEfwCNnsvjicAqWa1OmUwy/bFrnY23pSyor0=@vger.kernel.org
X-Gm-Message-State: AOJu0YynKw6tBN0FnlZtPTRaJOdtBjUcGo8vLIY3qLzS4qsxltiPot35
	ZUsq+byBJggT92KIZ4So6QWBZ3u+eZD8C0gh1hiHnXnhHpPT7VbAoQ146azl0O/0mZ6FsOf/uw=
	=
X-Received: from ejcho13.prod.google.com ([2002:a17:907:e8d:b0:b97:a2a0:2673])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9c07:b0:b9b:308f:d9ad
 with SMTP id a640c23a62f3a-b9b502e30edmr912242166b.19.1774943392226; Tue, 31
 Mar 2026 00:49:52 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:41 +0200
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260331074940.55502-7-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3550; i=ardb@kernel.org;
 h=from:subject; bh=IgBoKSALuAo6iW9gXWXETgLj0vEk1rAPv2EwB03g89w=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zTQhxS3vnuW3bfz4+NKZHz95fGQ3zlz+crtQ6PXVt
 9+eOnHzZEcpC4MYF4OsmCKLwOy/73aenihV6zxLFmYOKxPIEAYuTgGYiIMfI8ODrReceheJnAvO
 SOe+VX/iwLpP8r7uF9f+me/wOETkTegXRobW5Ztc5//K2x7vPv1kZjNfnP52id8/mmcxtHIWv89 MmcYEAA==
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-8-ardb+git@google.com>
Subject: [PATCH v2 1/5] ARM: Add a neon-intrinsics.h header like on arm64
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
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
 arch/arm/include/asm/neon-intrinsics.h      | 64 ++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

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
index 000000000000..3fe0b5ab9659
--- /dev/null
+++ b/arch/arm/include/asm/neon-intrinsics.h
@@ -0,0 +1,64 @@
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
+#ifdef CONFIG_CC_IS_CLANG
+#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
+#endif
+
+#endif /* __ASM_NEON_INTRINSICS_H */
-- 
2.53.0.1018.g2bb0e51243-goog

