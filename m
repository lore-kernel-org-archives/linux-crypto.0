Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E89E243367;
	Wed,  6 May 2026 03:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778036503; cv=none; b=OQ6olRoAOjXc7itM7UjkyIyJgevVm7HFKJ+mGSuQsJzYS9LdYBl7+iiw80TPOcgY1MhimGdP+pIVuDNMsf81np1GKFt7xrWEmlwh5ie+OdCa+RCW0MX/qPwcuGadekdle86BX9uEFvROxf9z34Y7uAetCC26HxaXpFzPyBBuk8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778036503; c=relaxed/simple;
	bh=dZylXfP4eJOp2CvHm4RP4wLgE+8Qid57tk+EFUtgRLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sKeX0lELQLLH8b/6ivW3yHRZHSdFmgR7C2KPOlRZ58DT3VJBrdl4y75JDjSYH3RgGyWn1ruQfOtwXR1E++SrSQR43bhTcIWBryxwPQ37BnYmN2K7Ra4c1vTqyyNe4gP7/zHbw67QRZSeNZk/b/nAU6u6QpwlrC3moLygHmIvnO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyDsrlW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyDsrlW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48520C2BCB4;
	Wed,  6 May 2026 03:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778036502;
	bh=dZylXfP4eJOp2CvHm4RP4wLgE+8Qid57tk+EFUtgRLE=;
	h=From:To:Cc:Subject:Date:From;
	b=TyDsrlW7sctY1kPM4suS8f9wXmYYgJdelP+VEIYJ70nL//CUaLpougzdMZLxsHoZf
	 YACkOUseBd5vCVB/1+dL+4K8GX8TxQD8o3/mE0r2nnOjDotgK8gKX0QZ5vhyWa2jXt
	 I88HLK2TSp1DFFRtCu/z3iyzGEBN5FppG0+3LCc0xYN+9EHTPxetQ0z8e/Fon53OvU
	 IjIPVTa6PrOUbX+xYfCi5HEVvDmm2m2Q/dyu4Sdpie8a9q9vVWgtnB4boMs4hZYwOr
	 vG6+KAkQn1cd5IEteFphd6Ye+/ftWBM3eO3+WR4coBwVmpVgX4s2c1m7I3L/ehFOma
	 vgRUxG1Y8dHeA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
Date: Tue,  5 May 2026 20:00:05 -0700
Message-ID: <20260506030005.9698-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MD5 is obsolete, is vulnerable to collision attacks, and is being
replaced by SHA-256 in new systems.  It doesn't make sense to continue
to maintain architecture-optimized implementations of MD5.  Effort
should be spent on modern algorithms.

Indeed, architecture-optimized MD5 code remains only for powerpc.  It
was already removed from mips and sparc, and it never existed for any
other architecture (e.g. x86, arm, or arm64) in the first place.
Earlier the decision was made to keep the powerpc MD5 code for a while
anyway because of someone using it via AF_ALG via libkcapi-hasher
(https://lore.kernel.org/r/f0d771d5-ed70-444c-957a-ad4c16f6c115@csgroup.eu/)

However, with AF_ALG itself now being on its way out due to its
continuous stream of security vulnerabilities
(https://lore.kernel.org/r/20260430011544.31823-1-ebiggers@kernel.org/),
it's also time to be a bit more forceful with nudging people towards
userspace crypto code.  It's always been the better solution anyway, and
it's much more efficient if properly optimized code is used.

Note that the md5-asm.S file contains no privileged instructions and
could be run in userspace just fine.

Thus, we now have two factors going against keeping the powerpc MD5
code.  Different people might weigh these two factors differently, but I
think the two of them together make the removal the clear choice.

Let's remove it.

Acked-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to be taken via libcrypto-next

v2: reworked commit message

 lib/crypto/Kconfig           |   5 -
 lib/crypto/Makefile          |   4 -
 lib/crypto/md5.c             |  20 ++-
 lib/crypto/powerpc/md5-asm.S | 235 -----------------------------------
 lib/crypto/powerpc/md5.h     |  12 --
 5 files changed, 7 insertions(+), 269 deletions(-)
 delete mode 100644 lib/crypto/powerpc/md5-asm.S
 delete mode 100644 lib/crypto/powerpc/md5.h

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index d3904b72dae7..591c1c2a7fb3 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -129,15 +129,10 @@ config CRYPTO_LIB_MD5
 	tristate
 	help
 	  The MD5 and HMAC-MD5 library functions.  Select this if your module
 	  uses any of the functions from <crypto/md5.h>.
 
-config CRYPTO_LIB_MD5_ARCH
-	bool
-	depends on CRYPTO_LIB_MD5 && !UML
-	default y if PPC
-
 config CRYPTO_LIB_MLDSA
 	tristate
 	select CRYPTO_LIB_SHA3
 	help
 	  The ML-DSA library functions.  Select this if your module uses any of
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 4ad91f390038..f1e9bf89785f 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -185,14 +185,10 @@ clean-files += powerpc/ghashp8-ppc.S
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_MD5) += libmd5.o
 libmd5-y := md5.o
-ifeq ($(CONFIG_CRYPTO_LIB_MD5_ARCH),y)
-CFLAGS_md5.o += -I$(src)/$(SRCARCH)
-libmd5-$(CONFIG_PPC) += powerpc/md5-asm.o
-endif # CONFIG_CRYPTO_LIB_MD5_ARCH
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_MLDSA) += libmldsa.o
 libmldsa-y := mldsa.o
diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index c4af57db0ea8..6bf130cfbbf9 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * MD5 and HMAC-MD5 library functions
  *
- * md5_block_generic() is derived from cryptoapi implementation, originally
- * based on the public domain implementation written by Colin Plumb in 1993.
+ * md5_block() is derived from cryptoapi implementation, originally based on the
+ * public domain implementation written by Colin Plumb in 1993.
  *
  * Copyright (c) Cryptoapi developers.
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright 2025 Google LLC
  */
@@ -29,12 +29,12 @@ static const struct md5_block_state md5_iv = {
 #define F4(x, y, z) (y ^ (x | ~z))
 
 #define MD5STEP(f, w, x, y, z, in, s) \
 	(w += f(x, y, z) + in, w = rol32(w, s) + x)
 
-static void md5_block_generic(struct md5_block_state *state,
-			      const u8 data[MD5_BLOCK_SIZE])
+static void md5_block(struct md5_block_state *state,
+		      const u8 data[MD5_BLOCK_SIZE])
 {
 	u32 in[MD5_BLOCK_WORDS];
 	u32 a, b, c, d;
 
 	memcpy(in, data, MD5_BLOCK_SIZE);
@@ -117,25 +117,19 @@ static void md5_block_generic(struct md5_block_state *state,
 	state->h[1] += b;
 	state->h[2] += c;
 	state->h[3] += d;
 }
 
-static void __maybe_unused md5_blocks_generic(struct md5_block_state *state,
-					      const u8 *data, size_t nblocks)
+static void md5_blocks(struct md5_block_state *state,
+		       const u8 *data, size_t nblocks)
 {
 	do {
-		md5_block_generic(state, data);
+		md5_block(state, data);
 		data += MD5_BLOCK_SIZE;
 	} while (--nblocks);
 }
 
-#ifdef CONFIG_CRYPTO_LIB_MD5_ARCH
-#include "md5.h" /* $(SRCARCH)/md5.h */
-#else
-#define md5_blocks md5_blocks_generic
-#endif
-
 void md5_init(struct md5_ctx *ctx)
 {
 	ctx->state = md5_iv;
 	ctx->bytecount = 0;
 }
diff --git a/lib/crypto/powerpc/md5-asm.S b/lib/crypto/powerpc/md5-asm.S
deleted file mode 100644
index fa6bc440cf4a..000000000000
--- a/lib/crypto/powerpc/md5-asm.S
+++ /dev/null
@@ -1,235 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Fast MD5 implementation for PPC
- *
- * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
- */
-#include <asm/ppc_asm.h>
-#include <asm/asm-offsets.h>
-#include <asm/asm-compat.h>
-
-#define rHP	r3
-#define rWP	r4
-
-#define rH0	r0
-#define rH1	r6
-#define rH2	r7
-#define rH3	r5
-
-#define rW00	r8
-#define rW01	r9
-#define rW02	r10
-#define rW03	r11
-#define rW04	r12
-#define rW05	r14
-#define rW06	r15
-#define rW07	r16
-#define rW08	r17
-#define rW09	r18
-#define rW10	r19
-#define rW11	r20
-#define rW12	r21
-#define rW13	r22
-#define rW14	r23
-#define rW15	r24
-
-#define rT0	r25
-#define rT1	r26
-
-#define INITIALIZE \
-	PPC_STLU r1,-INT_FRAME_SIZE(r1); \
-	SAVE_GPRS(14, 26, r1)		/* push registers onto stack	*/
-
-#define FINALIZE \
-	REST_GPRS(14, 26, r1);		/* pop registers from stack	*/ \
-	addi	r1,r1,INT_FRAME_SIZE
-
-#ifdef __BIG_ENDIAN__
-#define LOAD_DATA(reg, off) \
-	lwbrx		reg,0,rWP;	/* load data			*/
-#define INC_PTR \
-	addi		rWP,rWP,4;	/* increment per word		*/
-#define NEXT_BLOCK			/* nothing to do		*/
-#else
-#define LOAD_DATA(reg, off) \
-	lwz		reg,off(rWP);	/* load data			*/
-#define INC_PTR				/* nothing to do		*/
-#define NEXT_BLOCK \
-	addi		rWP,rWP,64;	/* increment per block		*/
-#endif
-
-#define R_00_15(a, b, c, d, w0, w1, p, q, off, k0h, k0l, k1h, k1l) \
-	LOAD_DATA(w0, off)		/*    W				*/ \
-	and		rT0,b,c;	/* 1: f = b and c		*/ \
-	INC_PTR				/*    ptr++			*/ \
-	andc		rT1,d,b;	/* 1: f' = ~b and d		*/ \
-	LOAD_DATA(w1, off+4)		/*    W				*/ \
-	or		rT0,rT0,rT1;	/* 1: f = f or f'		*/ \
-	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
-	add		a,a,rT0;	/* 1: a = a + f			*/ \
-	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
-	addis		w1,w1,k1h;	/* 2: wk = w + k		*/ \
-	add		a,a,w0;		/* 1: a = a + wk		*/ \
-	addi		w1,w1,k1l;	/* 2: wk = w + k'		*/ \
-	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
-	add		d,d,w1;		/* 2: a = a + wk		*/ \
-	add		a,a,b;		/* 1: a = a + b			*/ \
-	and		rT0,a,b;	/* 2: f = b and c		*/ \
-	andc		rT1,c,a;	/* 2: f' = ~b and d		*/ \
-	or		rT0,rT0,rT1;	/* 2: f = f or f'		*/ \
-	add		d,d,rT0;	/* 2: a = a + f			*/ \
-	INC_PTR				/*    ptr++			*/ \
-	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
-	add		d,d,a;		/* 2: a = a + b			*/
-
-#define R_16_31(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
-	andc		rT0,c,d;	/* 1: f = c and ~d		*/ \
-	and		rT1,b,d;	/* 1: f' = b and d		*/ \
-	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
-	or		rT0,rT0,rT1;	/* 1: f = f or f'		*/ \
-	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
-	add		a,a,rT0;	/* 1: a = a + f			*/ \
-	addi		w1,w1,k1l;	/* 2: wk = w + k		*/ \
-	add		a,a,w0;		/* 1: a = a + wk		*/ \
-	addis		w1,w1,k1h;	/* 2: wk = w + k'		*/ \
-	andc		rT0,b,c;	/* 2: f = c and ~d		*/ \
-	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
-	add		a,a,b;		/* 1: a = a + b			*/ \
-	add		d,d,w1;		/* 2: a = a + wk		*/ \
-	and		rT1,a,c;	/* 2: f' = b and d		*/ \
-	or		rT0,rT0,rT1;	/* 2: f = f or f'		*/ \
-	add		d,d,rT0;	/* 2: a = a + f			*/ \
-	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
-	add		d,d,a;		/* 2: a = a +b			*/
-
-#define R_32_47(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
-	xor		rT0,b,c;	/* 1: f' = b xor c		*/ \
-	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
-	xor		rT1,rT0,d;	/* 1: f = f xor f'		*/ \
-	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
-	add		a,a,rT1;	/* 1: a = a + f			*/ \
-	addi		w1,w1,k1l;	/* 2: wk = w + k		*/ \
-	add		a,a,w0;		/* 1: a = a + wk		*/ \
-	addis		w1,w1,k1h;	/* 2: wk = w + k'		*/ \
-	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
-	add		d,d,w1;		/* 2: a = a + wk		*/ \
-	add		a,a,b;		/* 1: a = a + b			*/ \
-	xor		rT1,rT0,a;	/* 2: f = b xor f'		*/ \
-	add		d,d,rT1;	/* 2: a = a + f			*/ \
-	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
-	add		d,d,a;		/* 2: a = a + b			*/
-
-#define R_48_63(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
-	addi		w0,w0,k0l;	/* 1: w = w + k			*/ \
-	orc		rT0,b,d;	/* 1: f = b or ~d		*/ \
-	addis		w0,w0,k0h;	/* 1: w = w + k'		*/ \
-	xor		rT0,rT0,c;	/* 1: f = f xor c		*/ \
-	add		a,a,w0;		/* 1: a = a + wk		*/ \
-	addi		w1,w1,k1l;	/* 2: w = w + k			*/ \
-	add		a,a,rT0;	/* 1: a = a + f			*/ \
-	addis		w1,w1,k1h;	/* 2: w = w + k'		*/ \
-	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
-	add		a,a,b;		/* 1: a = a + b			*/ \
-	orc		rT0,a,c;	/* 2: f = b or ~d		*/ \
-	add		d,d,w1;		/* 2: a = a + wk		*/ \
-	xor		rT0,rT0,b;	/* 2: f = f xor c		*/ \
-	add		d,d,rT0;	/* 2: a = a + f			*/ \
-	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
-	add		d,d,a;		/* 2: a = a + b			*/
-
-_GLOBAL(ppc_md5_transform)
-	INITIALIZE
-
-	mtctr		r5
-	lwz		rH0,0(rHP)
-	lwz		rH1,4(rHP)
-	lwz		rH2,8(rHP)
-	lwz		rH3,12(rHP)
-
-ppc_md5_main:
-	R_00_15(rH0, rH1, rH2, rH3, rW00, rW01, 25, 20, 0,
-		0xd76b, -23432, 0xe8c8, -18602)
-	R_00_15(rH2, rH3, rH0, rH1, rW02, rW03, 15, 10, 8,
-		0x2420, 0x70db, 0xc1be, -12562)
-	R_00_15(rH0, rH1, rH2, rH3, rW04, rW05, 25, 20, 16,
-		0xf57c, 0x0faf, 0x4788, -14806)
-	R_00_15(rH2, rH3, rH0, rH1, rW06, rW07, 15, 10, 24,
-		0xa830, 0x4613, 0xfd47, -27391)
-	R_00_15(rH0, rH1, rH2, rH3, rW08, rW09, 25, 20, 32,
-		0x6981, -26408, 0x8b45,  -2129)
-	R_00_15(rH2, rH3, rH0, rH1, rW10, rW11, 15, 10, 40,
-		0xffff, 0x5bb1, 0x895d, -10306)
-	R_00_15(rH0, rH1, rH2, rH3, rW12, rW13, 25, 20, 48,
-		0x6b90, 0x1122, 0xfd98, 0x7193)
-	R_00_15(rH2, rH3, rH0, rH1, rW14, rW15, 15, 10, 56,
-		0xa679, 0x438e, 0x49b4, 0x0821)
-
-	R_16_31(rH0, rH1, rH2, rH3, rW01, rW06, 27, 23,
-		0x0d56, 0x6e0c, 0x1810, 0x6d2d)
-	R_16_31(rH2, rH3, rH0, rH1, rW11, rW00, 18, 12,
-		0x9d02, -32109, 0x124c, 0x2332)
-	R_16_31(rH0, rH1, rH2, rH3, rW05, rW10, 27, 23,
-		0x8ea7, 0x4a33, 0x0245, -18270)
-	R_16_31(rH2, rH3, rH0, rH1, rW15, rW04, 18, 12,
-		0x8eee,  -8608, 0xf258,  -5095)
-	R_16_31(rH0, rH1, rH2, rH3, rW09, rW14, 27, 23,
-		0x969d, -10697, 0x1cbe, -15288)
-	R_16_31(rH2, rH3, rH0, rH1, rW03, rW08, 18, 12,
-		0x3317, 0x3e99, 0xdbd9, 0x7c15)
-	R_16_31(rH0, rH1, rH2, rH3, rW13, rW02, 27, 23,
-		0xac4b, 0x7772, 0xd8cf, 0x331d)
-	R_16_31(rH2, rH3, rH0, rH1, rW07, rW12, 18, 12,
-		0x6a28, 0x6dd8, 0x219a, 0x3b68)
-
-	R_32_47(rH0, rH1, rH2, rH3, rW05, rW08, 28, 21,
-		0x29cb, 0x28e5, 0x4218,  -7788)
-	R_32_47(rH2, rH3, rH0, rH1, rW11, rW14, 16,  9,
-		0x473f, 0x06d1, 0x3aae, 0x3036)
-	R_32_47(rH0, rH1, rH2, rH3, rW01, rW04, 28, 21,
-		0xaea1, -15134, 0x640b, -11295)
-	R_32_47(rH2, rH3, rH0, rH1, rW07, rW10, 16,  9,
-		0x8f4c, 0x4887, 0xbc7c, -22499)
-	R_32_47(rH0, rH1, rH2, rH3, rW13, rW00, 28, 21,
-		0x7eb8, -27199, 0x00ea, 0x6050)
-	R_32_47(rH2, rH3, rH0, rH1, rW03, rW06, 16,  9,
-		0xe01a, 0x22fe, 0x4447, 0x69c5)
-	R_32_47(rH0, rH1, rH2, rH3, rW09, rW12, 28, 21,
-		0xb7f3, 0x0253, 0x59b1, 0x4d5b)
-	R_32_47(rH2, rH3, rH0, rH1, rW15, rW02, 16,  9,
-		0x4701, -27017, 0xc7bd, -19859)
-
-	R_48_63(rH0, rH1, rH2, rH3, rW00, rW07, 26, 22,
-		0x0988,  -1462, 0x4c70, -19401)
-	R_48_63(rH2, rH3, rH0, rH1, rW14, rW05, 17, 11,
-		0xadaf,  -5221, 0xfc99, 0x66f7)
-	R_48_63(rH0, rH1, rH2, rH3, rW12, rW03, 26, 22,
-		0x7e80, -16418, 0xba1e, -25587)
-	R_48_63(rH2, rH3, rH0, rH1, rW10, rW01, 17, 11,
-		0x4130, 0x380d, 0xe0c5, 0x738d)
-	lwz		rW00,0(rHP)
-	R_48_63(rH0, rH1, rH2, rH3, rW08, rW15, 26, 22,
-		0xe837, -30770, 0xde8a, 0x69e8)
-	lwz		rW14,4(rHP)
-	R_48_63(rH2, rH3, rH0, rH1, rW06, rW13, 17, 11,
-		0x9e79, 0x260f, 0x256d, -27941)
-	lwz		rW12,8(rHP)
-	R_48_63(rH0, rH1, rH2, rH3, rW04, rW11, 26, 22,
-		0xab75, -20775, 0x4f9e, -28397)
-	lwz		rW10,12(rHP)
-	R_48_63(rH2, rH3, rH0, rH1, rW02, rW09, 17, 11,
-		0x662b, 0x7c56, 0x11b2, 0x0358)
-
-	add		rH0,rH0,rW00
-	stw		rH0,0(rHP)
-	add		rH1,rH1,rW14
-	stw		rH1,4(rHP)
-	add		rH2,rH2,rW12
-	stw		rH2,8(rHP)
-	add		rH3,rH3,rW10
-	stw		rH3,12(rHP)
-	NEXT_BLOCK
-
-	bdnz		ppc_md5_main
-
-	FINALIZE
-	blr
diff --git a/lib/crypto/powerpc/md5.h b/lib/crypto/powerpc/md5.h
deleted file mode 100644
index 540b08e34d1d..000000000000
--- a/lib/crypto/powerpc/md5.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * MD5 optimized for PowerPC
- */
-
-void ppc_md5_transform(u32 *state, const u8 *data, size_t nblocks);
-
-static void md5_blocks(struct md5_block_state *state,
-		       const u8 *data, size_t nblocks)
-{
-	ppc_md5_transform(state->h, data, nblocks);
-}

base-commit: 74fe02ce122a6103f207d29fafc8b3a53de6abaf
-- 
2.54.0

