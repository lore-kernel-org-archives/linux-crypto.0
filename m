Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268E63A5E97;
	Mon,  4 May 2026 13:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777901308; cv=none; b=G492S0PJ0zs8+QepOtkgdvE3WyH0u2sXrbHw7cnZo9XiKGRKIo+A4Ni3uypydnYxWfLH0TXsg+a8vFPjiiwiEh/25CLEr9z82QJUzDJFtCnvg0aDorGhHbiw1CqBtLQaHms01lSYdFabcVRs+on5lIHe8ndPImFKEet4E8BxqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777901308; c=relaxed/simple;
	bh=AJYr4LOdEdvXR7hlsp4iQBqtZWTHBRDPXZ08TRm5g0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rGfzGpBAFfLlQ+GeSnyfH2GGw1U3gxxKWL76LHxPJso/hznoQXbZAalTE21WGCkypbd0tTHx5A+yIl0FlwCCX1OTq3rlPtvONAWCMQeURE9lJoUaqmifKWbCP5X4Mlu24LArZ8fItxpfaJ7MVhyhqFlPHeWR6w5MC79dn1h/Xgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TReQeoRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TReQeoRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA60C2BCF7;
	Mon,  4 May 2026 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777901307;
	bh=AJYr4LOdEdvXR7hlsp4iQBqtZWTHBRDPXZ08TRm5g0Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TReQeoRR7zCitHx+TxyBJlVnqmMwH6ndaA/4yFPDiPMYEmhV1bJhADqXHhjtr0KAL
	 Q8ZH1z4k2r1qkNttx/BWve5jaF0G4A9Pu3NmDDv2KMq9K+hN0o3A+kl/Y5eSu3NUzM
	 +FbxxuBRlF5Ule7vq7rnPTT9owUsaDFBJrpxr2UpZ1ZFDgzMNT6CFfKPSK0yl92AO/
	 VggHt2+aEsVW05FQ4eyIOZVHuDgxnxCJtFDvTLuj/N8GqBIDZrCwU6/9hqEd7aU9H/
	 Q1QgqXudm2IljMUVSaiZmFXGaU9F0rQE+yUyPot0p9dpZOP1yBcmZbneBDKVdNYehq
	 Bh757uDfhjM/Q==
Message-ID: <111ea924-fef5-441e-9849-83f938c913a7@kernel.org>
Date: Mon, 4 May 2026 15:28:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linuxppc-dev@lists.ozlabs.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260504041448.15820-1-ebiggers@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260504041448.15820-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Eric,

Le 04/05/2026 à 06:14, Eric Biggers a écrit :
> Earlier the decision was made to keep this code for a while, despite no
> other architectures having optimized MD5 code anymore, because of
> someone using it via AF_ALG via libkcapi-hasher
> (https://lore.kernel.org/r/f0d771d5-ed70-444c-957a-ad4c16f6c115@csgroup.eu/)
> 
> However, with AF_ALG itself now being on its way out due to its
> continuous stream of security vulnerabilities
> (https://lore.kernel.org/r/20260430011544.31823-1-ebiggers@kernel.org/),
> it's time to be a bit more forceful with nudging people towards
> userspace crypto code.  It's always been the better solution anyway, and
> it's much more efficient if properly optimized code is used.

Ok, why not, but what do you propose as an alternative ? Let me explain 
the situation.

We have two versions of boards:
- One with powerpc MPC885E, which embeds a SECURITY Engine called 
TALITOS for offloading crypto operations
- One with powerpc MPC866, which doesn't have the security engine.

To use the security engine, our software use the AF_ALG interface (via 
libkcapi).

Our software has to run on both boards, we can't afford two different 
versions of the software and the software shall have no dead code. 
Therefore we rely on the capability of the kernel to do the hash by 
itself when the TALITOS in not available.

The kernel has always been the place where we do board specific stuff, 
not the application. I can't see why the application would have to ask 
the kernel when the Talitos is there and have to do the hashing by 
itself when the Talitos is not there.

I'm really concerned with the optimised MD5 going away now, and I'm also 
wondering what will be the way to splice a file into the kernel and get 
it's MD-5 hash from the TALITOS if AF_ALG goes away in medium-term.

What is the way forward ? I'm open to any suggestion as I really can't 
see where to go for now.

But please don't remove powerpc MD5 before we find an alternative solution.

Thanks
Christophe

> 
> Thus, drop the PowerPC optimized MD5 code.  Note that this code contains
> no privileged instructions and could be run in userspace just fine.
> 
> MD5 is still supported, just with the generic code only.  I.e., this
> commit only changes performance; it isn't a hard break.
> 
> This also has no effect on implementations of md5sum that already just
> use userspace code (as they should), for example the coreutils one.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   lib/crypto/Kconfig           |   5 -
>   lib/crypto/Makefile          |   4 -
>   lib/crypto/md5.c             |  20 ++-
>   lib/crypto/powerpc/md5-asm.S | 235 -----------------------------------
>   lib/crypto/powerpc/md5.h     |  12 --
>   5 files changed, 7 insertions(+), 269 deletions(-)
>   delete mode 100644 lib/crypto/powerpc/md5-asm.S
>   delete mode 100644 lib/crypto/powerpc/md5.h
> 
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index d3904b72dae7..591c1c2a7fb3 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -129,15 +129,10 @@ config CRYPTO_LIB_MD5
>   	tristate
>   	help
>   	  The MD5 and HMAC-MD5 library functions.  Select this if your module
>   	  uses any of the functions from <crypto/md5.h>.
>   
> -config CRYPTO_LIB_MD5_ARCH
> -	bool
> -	depends on CRYPTO_LIB_MD5 && !UML
> -	default y if PPC
> -
>   config CRYPTO_LIB_MLDSA
>   	tristate
>   	select CRYPTO_LIB_SHA3
>   	help
>   	  The ML-DSA library functions.  Select this if your module uses any of
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 4ad91f390038..f1e9bf89785f 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -185,14 +185,10 @@ clean-files += powerpc/ghashp8-ppc.S
>   
>   ################################################################################
>   
>   obj-$(CONFIG_CRYPTO_LIB_MD5) += libmd5.o
>   libmd5-y := md5.o
> -ifeq ($(CONFIG_CRYPTO_LIB_MD5_ARCH),y)
> -CFLAGS_md5.o += -I$(src)/$(SRCARCH)
> -libmd5-$(CONFIG_PPC) += powerpc/md5-asm.o
> -endif # CONFIG_CRYPTO_LIB_MD5_ARCH
>   
>   ################################################################################
>   
>   obj-$(CONFIG_CRYPTO_LIB_MLDSA) += libmldsa.o
>   libmldsa-y := mldsa.o
> diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
> index c4af57db0ea8..6bf130cfbbf9 100644
> --- a/lib/crypto/md5.c
> +++ b/lib/crypto/md5.c
> @@ -1,11 +1,11 @@
>   // SPDX-License-Identifier: GPL-2.0-or-later
>   /*
>    * MD5 and HMAC-MD5 library functions
>    *
> - * md5_block_generic() is derived from cryptoapi implementation, originally
> - * based on the public domain implementation written by Colin Plumb in 1993.
> + * md5_block() is derived from cryptoapi implementation, originally based on the
> + * public domain implementation written by Colin Plumb in 1993.
>    *
>    * Copyright (c) Cryptoapi developers.
>    * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
>    * Copyright 2025 Google LLC
>    */
> @@ -29,12 +29,12 @@ static const struct md5_block_state md5_iv = {
>   #define F4(x, y, z) (y ^ (x | ~z))
>   
>   #define MD5STEP(f, w, x, y, z, in, s) \
>   	(w += f(x, y, z) + in, w = rol32(w, s) + x)
>   
> -static void md5_block_generic(struct md5_block_state *state,
> -			      const u8 data[MD5_BLOCK_SIZE])
> +static void md5_block(struct md5_block_state *state,
> +		      const u8 data[MD5_BLOCK_SIZE])
>   {
>   	u32 in[MD5_BLOCK_WORDS];
>   	u32 a, b, c, d;
>   
>   	memcpy(in, data, MD5_BLOCK_SIZE);
> @@ -117,25 +117,19 @@ static void md5_block_generic(struct md5_block_state *state,
>   	state->h[1] += b;
>   	state->h[2] += c;
>   	state->h[3] += d;
>   }
>   
> -static void __maybe_unused md5_blocks_generic(struct md5_block_state *state,
> -					      const u8 *data, size_t nblocks)
> +static void md5_blocks(struct md5_block_state *state,
> +		       const u8 *data, size_t nblocks)
>   {
>   	do {
> -		md5_block_generic(state, data);
> +		md5_block(state, data);
>   		data += MD5_BLOCK_SIZE;
>   	} while (--nblocks);
>   }
>   
> -#ifdef CONFIG_CRYPTO_LIB_MD5_ARCH
> -#include "md5.h" /* $(SRCARCH)/md5.h */
> -#else
> -#define md5_blocks md5_blocks_generic
> -#endif
> -
>   void md5_init(struct md5_ctx *ctx)
>   {
>   	ctx->state = md5_iv;
>   	ctx->bytecount = 0;
>   }
> diff --git a/lib/crypto/powerpc/md5-asm.S b/lib/crypto/powerpc/md5-asm.S
> deleted file mode 100644
> index fa6bc440cf4a..000000000000
> --- a/lib/crypto/powerpc/md5-asm.S
> +++ /dev/null
> @@ -1,235 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -/*
> - * Fast MD5 implementation for PPC
> - *
> - * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
> - */
> -#include <asm/ppc_asm.h>
> -#include <asm/asm-offsets.h>
> -#include <asm/asm-compat.h>
> -
> -#define rHP	r3
> -#define rWP	r4
> -
> -#define rH0	r0
> -#define rH1	r6
> -#define rH2	r7
> -#define rH3	r5
> -
> -#define rW00	r8
> -#define rW01	r9
> -#define rW02	r10
> -#define rW03	r11
> -#define rW04	r12
> -#define rW05	r14
> -#define rW06	r15
> -#define rW07	r16
> -#define rW08	r17
> -#define rW09	r18
> -#define rW10	r19
> -#define rW11	r20
> -#define rW12	r21
> -#define rW13	r22
> -#define rW14	r23
> -#define rW15	r24
> -
> -#define rT0	r25
> -#define rT1	r26
> -
> -#define INITIALIZE \
> -	PPC_STLU r1,-INT_FRAME_SIZE(r1); \
> -	SAVE_GPRS(14, 26, r1)		/* push registers onto stack	*/
> -
> -#define FINALIZE \
> -	REST_GPRS(14, 26, r1);		/* pop registers from stack	*/ \
> -	addi	r1,r1,INT_FRAME_SIZE
> -
> -#ifdef __BIG_ENDIAN__
> -#define LOAD_DATA(reg, off) \
> -	lwbrx		reg,0,rWP;	/* load data			*/
> -#define INC_PTR \
> -	addi		rWP,rWP,4;	/* increment per word		*/
> -#define NEXT_BLOCK			/* nothing to do		*/
> -#else
> -#define LOAD_DATA(reg, off) \
> -	lwz		reg,off(rWP);	/* load data			*/
> -#define INC_PTR				/* nothing to do		*/
> -#define NEXT_BLOCK \
> -	addi		rWP,rWP,64;	/* increment per block		*/
> -#endif
> -
> -#define R_00_15(a, b, c, d, w0, w1, p, q, off, k0h, k0l, k1h, k1l) \
> -	LOAD_DATA(w0, off)		/*    W				*/ \
> -	and		rT0,b,c;	/* 1: f = b and c		*/ \
> -	INC_PTR				/*    ptr++			*/ \
> -	andc		rT1,d,b;	/* 1: f' = ~b and d		*/ \
> -	LOAD_DATA(w1, off+4)		/*    W				*/ \
> -	or		rT0,rT0,rT1;	/* 1: f = f or f'		*/ \
> -	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
> -	add		a,a,rT0;	/* 1: a = a + f			*/ \
> -	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
> -	addis		w1,w1,k1h;	/* 2: wk = w + k		*/ \
> -	add		a,a,w0;		/* 1: a = a + wk		*/ \
> -	addi		w1,w1,k1l;	/* 2: wk = w + k'		*/ \
> -	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
> -	add		d,d,w1;		/* 2: a = a + wk		*/ \
> -	add		a,a,b;		/* 1: a = a + b			*/ \
> -	and		rT0,a,b;	/* 2: f = b and c		*/ \
> -	andc		rT1,c,a;	/* 2: f' = ~b and d		*/ \
> -	or		rT0,rT0,rT1;	/* 2: f = f or f'		*/ \
> -	add		d,d,rT0;	/* 2: a = a + f			*/ \
> -	INC_PTR				/*    ptr++			*/ \
> -	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
> -	add		d,d,a;		/* 2: a = a + b			*/
> -
> -#define R_16_31(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
> -	andc		rT0,c,d;	/* 1: f = c and ~d		*/ \
> -	and		rT1,b,d;	/* 1: f' = b and d		*/ \
> -	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
> -	or		rT0,rT0,rT1;	/* 1: f = f or f'		*/ \
> -	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
> -	add		a,a,rT0;	/* 1: a = a + f			*/ \
> -	addi		w1,w1,k1l;	/* 2: wk = w + k		*/ \
> -	add		a,a,w0;		/* 1: a = a + wk		*/ \
> -	addis		w1,w1,k1h;	/* 2: wk = w + k'		*/ \
> -	andc		rT0,b,c;	/* 2: f = c and ~d		*/ \
> -	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
> -	add		a,a,b;		/* 1: a = a + b			*/ \
> -	add		d,d,w1;		/* 2: a = a + wk		*/ \
> -	and		rT1,a,c;	/* 2: f' = b and d		*/ \
> -	or		rT0,rT0,rT1;	/* 2: f = f or f'		*/ \
> -	add		d,d,rT0;	/* 2: a = a + f			*/ \
> -	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
> -	add		d,d,a;		/* 2: a = a +b			*/
> -
> -#define R_32_47(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
> -	xor		rT0,b,c;	/* 1: f' = b xor c		*/ \
> -	addi		w0,w0,k0l;	/* 1: wk = w + k		*/ \
> -	xor		rT1,rT0,d;	/* 1: f = f xor f'		*/ \
> -	addis		w0,w0,k0h;	/* 1: wk = w + k'		*/ \
> -	add		a,a,rT1;	/* 1: a = a + f			*/ \
> -	addi		w1,w1,k1l;	/* 2: wk = w + k		*/ \
> -	add		a,a,w0;		/* 1: a = a + wk		*/ \
> -	addis		w1,w1,k1h;	/* 2: wk = w + k'		*/ \
> -	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
> -	add		d,d,w1;		/* 2: a = a + wk		*/ \
> -	add		a,a,b;		/* 1: a = a + b			*/ \
> -	xor		rT1,rT0,a;	/* 2: f = b xor f'		*/ \
> -	add		d,d,rT1;	/* 2: a = a + f			*/ \
> -	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
> -	add		d,d,a;		/* 2: a = a + b			*/
> -
> -#define R_48_63(a, b, c, d, w0, w1, p, q, k0h, k0l, k1h, k1l) \
> -	addi		w0,w0,k0l;	/* 1: w = w + k			*/ \
> -	orc		rT0,b,d;	/* 1: f = b or ~d		*/ \
> -	addis		w0,w0,k0h;	/* 1: w = w + k'		*/ \
> -	xor		rT0,rT0,c;	/* 1: f = f xor c		*/ \
> -	add		a,a,w0;		/* 1: a = a + wk		*/ \
> -	addi		w1,w1,k1l;	/* 2: w = w + k			*/ \
> -	add		a,a,rT0;	/* 1: a = a + f			*/ \
> -	addis		w1,w1,k1h;	/* 2: w = w + k'		*/ \
> -	rotrwi		a,a,p;		/* 1: a = a rotl x		*/ \
> -	add		a,a,b;		/* 1: a = a + b			*/ \
> -	orc		rT0,a,c;	/* 2: f = b or ~d		*/ \
> -	add		d,d,w1;		/* 2: a = a + wk		*/ \
> -	xor		rT0,rT0,b;	/* 2: f = f xor c		*/ \
> -	add		d,d,rT0;	/* 2: a = a + f			*/ \
> -	rotrwi		d,d,q;		/* 2: a = a rotl x		*/ \
> -	add		d,d,a;		/* 2: a = a + b			*/
> -
> -_GLOBAL(ppc_md5_transform)
> -	INITIALIZE
> -
> -	mtctr		r5
> -	lwz		rH0,0(rHP)
> -	lwz		rH1,4(rHP)
> -	lwz		rH2,8(rHP)
> -	lwz		rH3,12(rHP)
> -
> -ppc_md5_main:
> -	R_00_15(rH0, rH1, rH2, rH3, rW00, rW01, 25, 20, 0,
> -		0xd76b, -23432, 0xe8c8, -18602)
> -	R_00_15(rH2, rH3, rH0, rH1, rW02, rW03, 15, 10, 8,
> -		0x2420, 0x70db, 0xc1be, -12562)
> -	R_00_15(rH0, rH1, rH2, rH3, rW04, rW05, 25, 20, 16,
> -		0xf57c, 0x0faf, 0x4788, -14806)
> -	R_00_15(rH2, rH3, rH0, rH1, rW06, rW07, 15, 10, 24,
> -		0xa830, 0x4613, 0xfd47, -27391)
> -	R_00_15(rH0, rH1, rH2, rH3, rW08, rW09, 25, 20, 32,
> -		0x6981, -26408, 0x8b45,  -2129)
> -	R_00_15(rH2, rH3, rH0, rH1, rW10, rW11, 15, 10, 40,
> -		0xffff, 0x5bb1, 0x895d, -10306)
> -	R_00_15(rH0, rH1, rH2, rH3, rW12, rW13, 25, 20, 48,
> -		0x6b90, 0x1122, 0xfd98, 0x7193)
> -	R_00_15(rH2, rH3, rH0, rH1, rW14, rW15, 15, 10, 56,
> -		0xa679, 0x438e, 0x49b4, 0x0821)
> -
> -	R_16_31(rH0, rH1, rH2, rH3, rW01, rW06, 27, 23,
> -		0x0d56, 0x6e0c, 0x1810, 0x6d2d)
> -	R_16_31(rH2, rH3, rH0, rH1, rW11, rW00, 18, 12,
> -		0x9d02, -32109, 0x124c, 0x2332)
> -	R_16_31(rH0, rH1, rH2, rH3, rW05, rW10, 27, 23,
> -		0x8ea7, 0x4a33, 0x0245, -18270)
> -	R_16_31(rH2, rH3, rH0, rH1, rW15, rW04, 18, 12,
> -		0x8eee,  -8608, 0xf258,  -5095)
> -	R_16_31(rH0, rH1, rH2, rH3, rW09, rW14, 27, 23,
> -		0x969d, -10697, 0x1cbe, -15288)
> -	R_16_31(rH2, rH3, rH0, rH1, rW03, rW08, 18, 12,
> -		0x3317, 0x3e99, 0xdbd9, 0x7c15)
> -	R_16_31(rH0, rH1, rH2, rH3, rW13, rW02, 27, 23,
> -		0xac4b, 0x7772, 0xd8cf, 0x331d)
> -	R_16_31(rH2, rH3, rH0, rH1, rW07, rW12, 18, 12,
> -		0x6a28, 0x6dd8, 0x219a, 0x3b68)
> -
> -	R_32_47(rH0, rH1, rH2, rH3, rW05, rW08, 28, 21,
> -		0x29cb, 0x28e5, 0x4218,  -7788)
> -	R_32_47(rH2, rH3, rH0, rH1, rW11, rW14, 16,  9,
> -		0x473f, 0x06d1, 0x3aae, 0x3036)
> -	R_32_47(rH0, rH1, rH2, rH3, rW01, rW04, 28, 21,
> -		0xaea1, -15134, 0x640b, -11295)
> -	R_32_47(rH2, rH3, rH0, rH1, rW07, rW10, 16,  9,
> -		0x8f4c, 0x4887, 0xbc7c, -22499)
> -	R_32_47(rH0, rH1, rH2, rH3, rW13, rW00, 28, 21,
> -		0x7eb8, -27199, 0x00ea, 0x6050)
> -	R_32_47(rH2, rH3, rH0, rH1, rW03, rW06, 16,  9,
> -		0xe01a, 0x22fe, 0x4447, 0x69c5)
> -	R_32_47(rH0, rH1, rH2, rH3, rW09, rW12, 28, 21,
> -		0xb7f3, 0x0253, 0x59b1, 0x4d5b)
> -	R_32_47(rH2, rH3, rH0, rH1, rW15, rW02, 16,  9,
> -		0x4701, -27017, 0xc7bd, -19859)
> -
> -	R_48_63(rH0, rH1, rH2, rH3, rW00, rW07, 26, 22,
> -		0x0988,  -1462, 0x4c70, -19401)
> -	R_48_63(rH2, rH3, rH0, rH1, rW14, rW05, 17, 11,
> -		0xadaf,  -5221, 0xfc99, 0x66f7)
> -	R_48_63(rH0, rH1, rH2, rH3, rW12, rW03, 26, 22,
> -		0x7e80, -16418, 0xba1e, -25587)
> -	R_48_63(rH2, rH3, rH0, rH1, rW10, rW01, 17, 11,
> -		0x4130, 0x380d, 0xe0c5, 0x738d)
> -	lwz		rW00,0(rHP)
> -	R_48_63(rH0, rH1, rH2, rH3, rW08, rW15, 26, 22,
> -		0xe837, -30770, 0xde8a, 0x69e8)
> -	lwz		rW14,4(rHP)
> -	R_48_63(rH2, rH3, rH0, rH1, rW06, rW13, 17, 11,
> -		0x9e79, 0x260f, 0x256d, -27941)
> -	lwz		rW12,8(rHP)
> -	R_48_63(rH0, rH1, rH2, rH3, rW04, rW11, 26, 22,
> -		0xab75, -20775, 0x4f9e, -28397)
> -	lwz		rW10,12(rHP)
> -	R_48_63(rH2, rH3, rH0, rH1, rW02, rW09, 17, 11,
> -		0x662b, 0x7c56, 0x11b2, 0x0358)
> -
> -	add		rH0,rH0,rW00
> -	stw		rH0,0(rHP)
> -	add		rH1,rH1,rW14
> -	stw		rH1,4(rHP)
> -	add		rH2,rH2,rW12
> -	stw		rH2,8(rHP)
> -	add		rH3,rH3,rW10
> -	stw		rH3,12(rHP)
> -	NEXT_BLOCK
> -
> -	bdnz		ppc_md5_main
> -
> -	FINALIZE
> -	blr
> diff --git a/lib/crypto/powerpc/md5.h b/lib/crypto/powerpc/md5.h
> deleted file mode 100644
> index 540b08e34d1d..000000000000
> --- a/lib/crypto/powerpc/md5.h
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -/*
> - * MD5 optimized for PowerPC
> - */
> -
> -void ppc_md5_transform(u32 *state, const u8 *data, size_t nblocks);
> -
> -static void md5_blocks(struct md5_block_state *state,
> -		       const u8 *data, size_t nblocks)
> -{
> -	ppc_md5_transform(state->h, data, nblocks);
> -}
> 
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32

