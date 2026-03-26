Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D0734A3D8;
	Thu, 26 Mar 2026 20:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774557232; cv=none; b=POHqgABDa/LSDX/5c4t1qyFssCSvlI5fli7SZiieJdTRUZOQLOmCFl9IXp7bNACw+RIG/a6n5Esj9T42sMZjF3V4n6mkA+L78jcZl8T0OXb+g4Di0AsX5R4qkT4AzlDgU+2rdtX8ZmzCo6tl9iTua5CBhQE/kblPtprW5X8JAtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774557232; c=relaxed/simple;
	bh=Pr5ogmVS/nQaXDB7AZFHq8parU19obu368R2tSsYo1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s8yG/YcEWqlqUNBTz+DZC1ByUj9ibg6j++w3xFGw3ut/FMl1Trcyr7W1AwxamMQ9wZkoJLg43YzEb92bf9u4W2a0xc0x0Lg4StYuXp2HaAWkGw6x+zj3I5xa46vbyGuWHFT/DXYXMObJUW3yXPRZu8gJaxo8aWOraaSoDNIFSog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VY/ezY9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VY/ezY9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D82CC116C6;
	Thu, 26 Mar 2026 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774557231;
	bh=Pr5ogmVS/nQaXDB7AZFHq8parU19obu368R2tSsYo1k=;
	h=From:To:Cc:Subject:Date:From;
	b=VY/ezY9BYdwxMO3cq4H5E9Tag29nOyiFKNKTw7aMN2xdoJGPDP3uTCC+UvpND9Sg6
	 q86Ee64Ajp5OVVYk9MsfDkt5IS86HawELnqVPBs0CyBKy6BBXxDKZzK5yeEh4YeHXC
	 QENDMKGsazeVdH+S4ejV9dGup6HH0ujVhbTKd/PXmhuCJif4kElVr3DOjz1zbntLRX
	 WdDxZT4MCLJmCqd2ccXYvtfD9vhG7mdrtQ7zgjkjsMtJQrksM6B7iAWvK23by8RfnR
	 a09dOO7feT1blTjcN5SOVq+WA3CrdkHZqw4GpVLnRdc8IHz9BAAE6aTvw+IP4BNWZ6
	 BTGyRgak9V1Zw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: sparc: Drop optimized MD5 code
Date: Thu, 26 Mar 2026 13:33:41 -0700
Message-ID: <20260326203341.60393-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MD5 is obsolete.  Continuing to maintain architecture-optimized
implementations of MD5 is unnecessary and risky.  It diverts resources
from the modern algorithms that are actually important.

While there was demand for continuing to maintain the PowerPC optimized
MD5 code to accommodate userspace programs that are misusing AF_ALG
(https://lore.kernel.org/linux-crypto/c4191597-341d-4fd7-bc3d-13daf7666c41@csgroup.eu/),
no such demand has been seen for the SPARC optimized MD5 code.

Thus, let's drop it and focus effort on the more modern SHA algorithms,
which already have optimized code for SPARC.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/Kconfig         |  1 -
 lib/crypto/Makefile        |  1 -
 lib/crypto/sparc/md5.h     | 48 --------------------------
 lib/crypto/sparc/md5_asm.S | 70 --------------------------------------
 4 files changed, 120 deletions(-)
 delete mode 100644 lib/crypto/sparc/md5.h
 delete mode 100644 lib/crypto/sparc/md5_asm.S

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4b6f593dc72f..a5246171a000 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -134,11 +134,10 @@ config CRYPTO_LIB_MD5
 config CRYPTO_LIB_MD5_ARCH
 	bool
 	depends on CRYPTO_LIB_MD5 && !UML
 	default y if MIPS && CPU_CAVIUM_OCTEON
 	default y if PPC
-	default y if SPARC64
 
 config CRYPTO_LIB_MLDSA
 	tristate
 	select CRYPTO_LIB_SHA3
 	help
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index ec1747f51d07..4b47a2e5c67c 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -186,11 +186,10 @@ clean-files += powerpc/ghashp8-ppc.S
 obj-$(CONFIG_CRYPTO_LIB_MD5) += libmd5.o
 libmd5-y := md5.o
 ifeq ($(CONFIG_CRYPTO_LIB_MD5_ARCH),y)
 CFLAGS_md5.o += -I$(src)/$(SRCARCH)
 libmd5-$(CONFIG_PPC) += powerpc/md5-asm.o
-libmd5-$(CONFIG_SPARC) += sparc/md5_asm.o
 endif # CONFIG_CRYPTO_LIB_MD5_ARCH
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_MLDSA) += libmldsa.o
diff --git a/lib/crypto/sparc/md5.h b/lib/crypto/sparc/md5.h
deleted file mode 100644
index 3995f3e075eb..000000000000
--- a/lib/crypto/sparc/md5.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * MD5 accelerated using the sparc64 crypto opcodes
- *
- * Copyright (c) Alan Smithee.
- * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
- * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
- * Copyright (c) Mathias Krause <minipli@googlemail.com>
- * Copyright (c) Cryptoapi developers.
- * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- */
-
-#include <asm/elf.h>
-#include <asm/opcodes.h>
-#include <asm/pstate.h>
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_md5_opcodes);
-
-asmlinkage void md5_sparc64_transform(struct md5_block_state *state,
-				      const u8 *data, size_t nblocks);
-
-static void md5_blocks(struct md5_block_state *state,
-		       const u8 *data, size_t nblocks)
-{
-	if (static_branch_likely(&have_md5_opcodes)) {
-		cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
-		md5_sparc64_transform(state, data, nblocks);
-		le32_to_cpu_array(state->h, ARRAY_SIZE(state->h));
-	} else {
-		md5_blocks_generic(state, data, nblocks);
-	}
-}
-
-#define md5_mod_init_arch md5_mod_init_arch
-static void md5_mod_init_arch(void)
-{
-	unsigned long cfr;
-
-	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
-		return;
-
-	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
-	if (!(cfr & CFR_MD5))
-		return;
-
-	static_branch_enable(&have_md5_opcodes);
-	pr_info("Using sparc64 md5 opcode optimized MD5 implementation\n");
-}
diff --git a/lib/crypto/sparc/md5_asm.S b/lib/crypto/sparc/md5_asm.S
deleted file mode 100644
index 60b544e4d205..000000000000
--- a/lib/crypto/sparc/md5_asm.S
+++ /dev/null
@@ -1,70 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#include <linux/linkage.h>
-#include <asm/opcodes.h>
-#include <asm/visasm.h>
-
-ENTRY(md5_sparc64_transform)
-	/* %o0 = digest, %o1 = data, %o2 = rounds */
-	VISEntryHalf
-	ld	[%o0 + 0x00], %f0
-	ld	[%o0 + 0x04], %f1
-	andcc	%o1, 0x7, %g0
-	ld	[%o0 + 0x08], %f2
-	bne,pn	%xcc, 10f
-	 ld	[%o0 + 0x0c], %f3
-
-1:
-	ldd	[%o1 + 0x00], %f8
-	ldd	[%o1 + 0x08], %f10
-	ldd	[%o1 + 0x10], %f12
-	ldd	[%o1 + 0x18], %f14
-	ldd	[%o1 + 0x20], %f16
-	ldd	[%o1 + 0x28], %f18
-	ldd	[%o1 + 0x30], %f20
-	ldd	[%o1 + 0x38], %f22
-
-	MD5
-
-	subcc	%o2, 1, %o2
-	bne,pt	%xcc, 1b
-	 add	%o1, 0x40, %o1
-
-5:
-	st	%f0, [%o0 + 0x00]
-	st	%f1, [%o0 + 0x04]
-	st	%f2, [%o0 + 0x08]
-	st	%f3, [%o0 + 0x0c]
-	retl
-	 VISExitHalf
-10:
-	alignaddr %o1, %g0, %o1
-
-	ldd	[%o1 + 0x00], %f10
-1:
-	ldd	[%o1 + 0x08], %f12
-	ldd	[%o1 + 0x10], %f14
-	ldd	[%o1 + 0x18], %f16
-	ldd	[%o1 + 0x20], %f18
-	ldd	[%o1 + 0x28], %f20
-	ldd	[%o1 + 0x30], %f22
-	ldd	[%o1 + 0x38], %f24
-	ldd	[%o1 + 0x40], %f26
-
-	faligndata %f10, %f12, %f8
-	faligndata %f12, %f14, %f10
-	faligndata %f14, %f16, %f12
-	faligndata %f16, %f18, %f14
-	faligndata %f18, %f20, %f16
-	faligndata %f20, %f22, %f18
-	faligndata %f22, %f24, %f20
-	faligndata %f24, %f26, %f22
-
-	MD5
-
-	subcc	%o2, 1, %o2
-	fsrc2	%f26, %f10
-	bne,pt	%xcc, 1b
-	 add	%o1, 0x40, %o1
-
-	ba,a,pt	%xcc, 5b
-ENDPROC(md5_sparc64_transform)

base-commit: 7ac21b4032e5b9b8a6a312b6f1d54f4ba24d1c16
-- 
2.53.0

