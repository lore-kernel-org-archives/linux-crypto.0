Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D9B327C18
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882007; cv=none; b=eFoXjz5YMmNtGRGWQ/oHRCIOw8i0HNKGxEm4BBBBclREli1D51nZNQP6Rjvl7F22eI68RC6LrepIIVma3L2B3476MdVh6wqN8E8ejZcsF+aVHm+jJO/S1hoylN90X/KQMWsaO5i4PVyLWssQFdnj1v/2wHrX0CGtA89Wc4BhN7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882007; c=relaxed/simple;
	bh=IgBoKSALuAo6iW9gXWXETgLj0vEk1rAPv2EwB03g89w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doJlY67Vl/jD2LaatvZDB/mclciC//n+zTwwBrDW84aUZ9ALxPotvvpjq8owlDwT1YNyFZbvRIUsN3noDAYAgSzqcnjdZLjDQJYm6EXXMkYBeIEj0KxHmoI9+v3EszoC5y9c5FPHNVlbBdxX/nLnFSFOlTC5ndlsuqe3z4ppAGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpsndG0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpsndG0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA329C19423;
	Mon, 30 Mar 2026 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882007;
	bh=IgBoKSALuAo6iW9gXWXETgLj0vEk1rAPv2EwB03g89w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpsndG0rAidpFh5a02zMA4rxDw1dwwz3BhGt0znGMgQ2cpvzvcfmWf1pW/yl4GvXG
	 Ugn2X61oGQwh883xYhQ+3SnsXzaDMYoUVZsNPALHwsqUMQs0qxr3wYZHaJ1yrdwdc/
	 Nq23ffPr3jH0dGftnYdh5/824d0LaFrRoqX5Q99RdHpBw/PZKb7Q8Yu7tqkgJT1qk/
	 Yigc8VD6HO+6KLhNPM1nZtq7MHqPNIATSqSgq+KLrn+vy0ZAqxGnGz4OUdzYyKB4Ce
	 cUnna6IDnVbe1CINyrv8MElqDmWkn7xGePTQOThYsksqySBUM9TIGskX1Mzi+XfMrT
	 knuxOQNX1Gr1A==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/5] ARM: Add a neon-intrinsics.h header like on arm64
Date: Mon, 30 Mar 2026 16:46:34 +0200
Message-ID: <20260330144630.33026-10-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330144630.33026-7-ardb@kernel.org>
References: <20260330144630.33026-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3550; i=ardb@kernel.org; h=from:subject; bh=IgBoKSALuAo6iW9gXWXETgLj0vEk1rAPv2EwB03g89w=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDJP9RwXUtzy7ll+28aPjy+d+fGTx0d248zlL7cLhV5ff fvtqRM3T3ZMZWEQ5mSQFVNk2amc0/3aRfSdvkJlDswcViaQIQxcnAIwEWYfxoZlvQrNznbcQfPK Dq2dUyrz51nqjNUfrjoGyu3V2Pa/+XTkiV/BfJOj6tW6+sUPn/Hn4GBsOPunaIfA0U6HUG67Zu6 asyKZ99dzrGKclTXxz79Zj3dKhTyU+Dfj4sZVcnqpLa+mpcQUAgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

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

