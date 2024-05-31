Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CC178C8C;
	Fri, 31 May 2024 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717133840; cv=none; b=dQLS2FA6HIf1nDuY0eS3jOAcXhLJETbqEMxOKB2s4bdEOggf4gzgaKsXnA3/LVpzMVMYIh8x390ZgiQBg4BpNu+ONjE4HoFVpTSv2eCzt6ZiwcTmW6RjY5AMEIA3vaEXCeWdmvAC4XpyirvhRiwYYVU1dFcD1fQu6OEoT6oAOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717133840; c=relaxed/simple;
	bh=jTk+PbPG5/BiWaxqKTp/AOmZzIKehTQQqrAJvbDBINI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSrG8C1qRo1iXtyfDuOHDDh+PeWdErfnjL7zRuowRZ2nZi6ua1A8y6ax6ZPr1t/CIenQXVfzGBmyeNwDN6n8WOYC9zBWT++uDMtSNU3K9LoTSwv4A84+6Qd0sxMfzDRBrCfLFRZxna5vZ4ZdwtU2rokLxm7T26fddloCusIcq3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oT9v4H8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oT9v4H8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CFCC116B1;
	Fri, 31 May 2024 05:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717133839;
	bh=jTk+PbPG5/BiWaxqKTp/AOmZzIKehTQQqrAJvbDBINI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oT9v4H8AMIH5plMJixaSOXe7S0fMyHl6baWUn/0GTqpVx625j/zPTyDU7gfEUtz1c
	 gsaUiZ+E/ONBlyPXVjFVI3b9xCJK3qd2A30VZDOy3OT8kEC8QyCVfFGTUvXmWBESp4
	 6A1g9dQo7R/NwGn2P0xtQQL5Gwx7N06/HHRzTwWsK0hmvt/LsNcl6PiZIZXWvYQAeS
	 a3r1vvV19vbs8LsuSmUADXSExJlkN+9Vn9cj+XukEiHyWNjQzTcAaNkROq/gD5XjR2
	 cDwNJzGDAc6nXPSSg11rbkjcw25o95L8Rq58DOYtBAq1R5FV93LQlRJUKXAzvs/YXA
	 3B4E/3YmeK9uQ==
Date: Thu, 30 May 2024 22:37:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, ardb@kernel.org, x86@kernel.org,
	bernie.keany@intel.com
Subject: Re: [PATCH v9a 14/14] crypto: x86/aes-kl - Implement the AES-XTS
 algorithm
Message-ID: <20240531053718.GF6505@sol.localdomain>
References: <20240329015346.635933-15-chang.seok.bae@intel.com>
 <20240522184235.16766-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522184235.16766-1-chang.seok.bae@intel.com>

On Wed, May 22, 2024 at 11:42:35AM -0700, Chang S. Bae wrote:
> I've reworked this patch based on feedback,
>     https://lore.kernel.org/lkml/20240408014806.GA965@quark.localdomain/
> and rebased to upstream v6.10 Linus merge tree on May 13th: commit
> 84c7d76b5ab6 ("Merge tag 'v6.10-p1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6")
> 
> According to the dm-crypt benchmark, using VEX-encoded instructions for
> tweak processing enhances performance by approximately 2-3%. The
> PCLMULDQD instruction did not yield a measurable impact, so I dropped it
> to simplify the implementation.
> 
> In contrast to other AES instructions, AES-KL does not permit tweak
> processing between rounds. In XTS mode, a single instruction covers all
> rounds of 8 blocks without interleaving instructions. Maybe this is one
> of the reasons for the limited performance gain.
> 
> Moving forward, I would like to address any further feedback on this
> AES-KL driver code first before the next revision of the whole series.
> 
> Changes from v9:
> * Duplicate the new XTS glue code, instead of sharing (Eric).
> * Use VEX-coded instructions for non-AES parts of the code (Eric).
> * Adjust ASM code to stylistically follow the new VAES support (Eric).
> * Export and reference the high-level AES-NI XTS functions (Eric). Then,
>   support a module build, along with rearranging build dependencies.
> * Reorganize the glue code and improve ASM code readability.
> * Revoke the review tag due to major changes.
> ---

Thanks for the updated patch!

> diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
> index 59aedf32c4ea..89e326c9dbfe 100644
> --- a/arch/x86/Kconfig.assembler
> +++ b/arch/x86/Kconfig.assembler
> @@ -35,6 +35,11 @@ config AS_VPCLMULQDQ
>  	help
>  	  Supported by binutils >= 2.30 and LLVM integrated assembler
>  
> +config AS_HAS_KEYLOCKER
> +	def_bool $(as-instr,encodekey256 %eax$(comma)%eax)
> +	help
> +	  Supported by binutils >= 2.36 and LLVM integrated assembler >= V12

Adding AS_HAS_KEYLOCKER should be its own patch.

> diff --git a/arch/x86/crypto/aeskl-xts-x86_64.S b/arch/x86/crypto/aeskl-xts-x86_64.S
> new file mode 100644
> index 000000000000..6ff8b5feebfc
> --- /dev/null
> +++ b/arch/x86/crypto/aeskl-xts-x86_64.S
> @@ -0,0 +1,358 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Implement AES algorithm using AES Key Locker instructions.
> + *
> + * Most code is primarily derived from aesni-intel_asm.S and
> + * stylistically aligned with aes-xts-avx-x86_64.S.
> + */
> +
> +#include <linux/linkage.h>
> +#include <linux/cfi_types.h>
> +#include <asm/errno.h>
> +#include <asm/inst.h>
> +#include <asm/frame.h>
> +
> +/* Constant values shared between AES implementations: */
> +
> +.section .rodata
> +.p2align 4
> +.Lgf_poly:
> +	/*
> +	 * Represents the polynomial x^7 + x^2 + x + 1, where the low 64
> +	 * bits are XOR'd into the tweak's low 64 bits when a carry
> +	 * occurs from the high 64 bits.
> +	 */
> +	.quad	0x87, 1
> +
> +	/*
> +	 * Table of constants for variable byte shifts and blending
> +	 * during ciphertext stealing operations.
> +	 */
> +.Lcts_permute_table:
> +	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +	.byte	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
> +	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
> +	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
> +
> +.text
> +
> +.set	V0,		%xmm0
> +.set	V1,		%xmm1
> +.set	V2,		%xmm2
> +.set	V3,		%xmm3
> +.set	V4,		%xmm4
> +.set	V5,		%xmm5
> +.set	V6,		%xmm6
> +.set	V7,		%xmm7
> +.set	V8,		%xmm8
> +.set	V9,		%xmm9
> +.set	V10,		%xmm10
> +.set	V11,		%xmm11
> +.set	V12,		%xmm12
> +.set	V13,		%xmm13
> +.set	V14,		%xmm14
> +.set	V15,		%xmm15

The point of the V[0-15] aliases in aes-xts-avx-x86_64.S are to support both ymm
and zmm registers.  Here all registers are xmm, so there's no need for the layer
of indirection and you should just use xmm[0-15] directly.

> +.set	TWEAK_XMM1,	V8
> +.set	TWEAK_XMM2,	V9
> +.set	TWEAK_XMM3,	V10
> +.set	TWEAK_XMM4,	V11
> +.set	TWEAK_XMM5,	V12
> +.set	TWEAK_XMM6,	V13
> +.set	TWEAK_XMM7,	V14
> +.set	GF_POLY_XMM,	V15
> +.set	TWEAK_TMP,	TWEAK_XMM1
> +.set	TWEAK_XMM,	TWEAK_XMM2
> +.set	TMP,		%r10

Similarly, the _XMM suffixes are not really helpful since ymm and zmm registers
are not in play here.

> +/* Function parameters */
> +.set	HANDLEP,	%rdi	/* Pointer to struct aeskl_ctx */
> +.set	DST,		%rsi	/* Pointer to next destination data */
> +.set	UKEYP,		DST	/* Pointer to the original key */
> +.set	KLEN,		%r9d	/* AES key length in bytes */
> +.set	SRC,		%rdx	/* Pointer to next source data */
> +.set	LEN,		%rcx	/* Remaining length in bytes */
> +.set	TWEAK,		%r8	/* Pointer to next tweak */

Please don't put parameters for different functions in the same list like this.
There should be a separate list at the beginning of each function.  (Yes, it
doesn't work perfectly because '.set' is global and doesn't go out of scope once
the function ends.  But at least this would make it clear what the intent is.)

Also LEN needs to be %ecx, not %rcx, because it is unsigned int.

> +SYM_FUNC_START(__aeskl_setkey)
> +	FRAME_BEGIN
> +	movl		%edx, 480(HANDLEP)
> +	vmovdqu		(UKEYP), V0
> +	mov		$1, %eax
> +	cmp		$16, %dl
> +	je		.Lsetkey_128
> +
> +	vmovdqu		0x10(UKEYP), V1
> +	encodekey256	%eax, %eax
> +	vmovdqu		V3, 0x30(HANDLEP)
> +	jmp		.Lsetkey_end
> +.Lsetkey_128:
> +	encodekey128	%eax, %eax
> +
> +.Lsetkey_end:
> +	vmovdqu		V0, 0x00(HANDLEP)
> +	vmovdqu		V1, 0x10(HANDLEP)
> +	vmovdqu		V2, 0x20(HANDLEP)
> +
> +	FRAME_END
> +	RET
> +SYM_FUNC_END(__aeskl_setkey)

These are all leaf functions, so they don't need FRAME_BEGIN and FRAME_END.

> +.macro _aeskl		width, operation
> +	cmp		$16, KLEN
> +	je		.Laeskl128\@
> +.ifc \width, wide
> + .ifc \operation, dec
> +	aesdecwide256kl	(HANDLEP)
> + .else
> +	aesencwide256kl	(HANDLEP)
> + .endif
> +.else
> + .ifc \operation, dec
> +	aesdec256kl	(HANDLEP), V0
> + .else
> +	aesenc256kl	(HANDLEP), V0
> + .endif
> +.endif
> +	jmp		.Laesklend\@
> +.Laeskl128\@:
> +.ifc \width, wide
> + .ifc \operation, dec
> +	aesdecwide128kl	(HANDLEP)
> + .else
> +	aesencwide128kl	(HANDLEP)
> + .endif
> +.else
> + .ifc \operation, dec
> +	aesdec128kl	(HANDLEP), V0
> + .else
> +	aesenc128kl	(HANDLEP), V0
> + .endif
> +.endif
> +.Laesklend\@:
> +.endm

I think it would be easier to read if this was split into two macros, one for
1-block and one for 8-block.

> +/* int __aeskl_enc(const void *handlep, u8 *dst, const u8 *src) */
> +SYM_FUNC_START(__aeskl_enc)
> +	FRAME_BEGIN
> +	vmovdqu		(SRC), V0
> +	movl		480(HANDLEP), KLEN
> +
> +	_aeskl		oneblock, enc
> +	jz		.Lerror
> +	xor		%rax, %rax
> +	vmovdqu		V0, (DST)
> +	FRAME_END
> +	RET
> +.Lerror:
> +	mov		$(-EINVAL), %rax

For returning an int, %eax should be used, not %rax.

(Note that instructions that operate on %eax also tend to be slightly shorter.)

> +/*
> + * int __aeskl_xts_encrypt(const struct aeskl_ctx *handlep, u8 *dst,
> + *			   const u8 *src, unsigned int klen, le128 *tweak)
> + */
> +SYM_FUNC_START(__aeskl_xts_encrypt)
> +	_aeskl_xts_crypt	enc
> +SYM_FUNC_END(__aeskl_xts_encrypt)
> +
> +/*
> + * int __aeskl_xts_decrypt(const struct crypto_aes_ctx *handlep, u8 *dst,
> + *			   const u8 *src, unsigned int klen, le128 *twek)
> + */

Please make sure the function prototypes, including the parameter names, match
the ones used in the .c file and also the lists of register aliases.

> diff --git a/arch/x86/crypto/aeskl_glue.c b/arch/x86/crypto/aeskl_glue.c
> new file mode 100644
> index 000000000000..6dc4d380be54
> --- /dev/null
> +++ b/arch/x86/crypto/aeskl_glue.c
> @@ -0,0 +1,376 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Support for AES Key Locker instructions. This file contains glue
> + * code and the real AES implementation is in aeskl-intel_asm.S.
> + *
> + * Most code is based on aesni-intel_glue.c
> + */
> +
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <crypto/algapi.h>
> +#include <crypto/aes.h>
> +#include <crypto/xts.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/internal/simd.h>
> +#include <asm/simd.h>
> +#include <asm/cpu_device_id.h>
> +#include <asm/fpu/api.h>
> +#include <asm/keylocker.h>
> +#include "aesni-xts.h"
> +
> +#define AESKL_ALIGN		16
> +#define AESKL_ALIGN_ATTR	__attribute__ ((__aligned__(AESKL_ALIGN)))
> +#define AESKL_ALIGN_EXTRA	((AESKL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
> +
> +#define AESKL_AAD_SIZE		16
> +#define AESKL_TAG_SIZE		16
> +#define AESKL_CIPHERTEXT_MAX	AES_KEYSIZE_256
> +
> +/* The Key Locker handle is an encoded form of the AES key. */
> +struct aeskl_handle {
> +	u8 additional_authdata[AESKL_AAD_SIZE];
> +	u8 integrity_tag[AESKL_TAG_SIZE];
> +	u8 ciphre_text[AESKL_CIPHERTEXT_MAX];
> +};

ciphre_text => ciphertext

> +/*
> + * Key Locker does not support 192-bit key size. The driver needs to
> + * retrieve the key size in the first place. The offset of the
> + * 'key_length' field here should be compatible with struct

should => must

> + * crypto_aes_ctx.
> + */
> +#define AESKL_CTX_RESERVED (sizeof(struct crypto_aes_ctx) - sizeof(struct aeskl_handle) \
> +			    - sizeof(u32))
> +
> +struct aeskl_ctx {
> +	struct aeskl_handle handle;
> +	u8 reserved[AESKL_CTX_RESERVED];
> +	u32 key_length;
> +};
> +
> +struct aeskl_xts_ctx {
> +	struct aeskl_ctx tweak_ctx AESKL_ALIGN_ATTR;
> +	struct aeskl_ctx crypt_ctx AESKL_ALIGN_ATTR;
> +};

So there's a union between aeskl_ctx and crypto_aes_ctx going on here, but it's
not made explicit through a C union.  How about doing that?

Also, there should be a BUILD_BUG_ON() that enforces that the key_length is
really at the same offset in both.

> +/*
> + * The glue code in xts_crypt() and xts_crypt_slowpath() follows
> + * aesni-intel_glue.c. While this code is shareable, the key
> + * material format difference can cause more destructive code changes in
> + * the AES-NI side.
> + */
> +
> +typedef int (*xts_encrypt_iv_func)(const struct aeskl_ctx *tweak_key,
> +				   u8 iv[AES_BLOCK_SIZE]);
> +typedef int (*xts_crypt_func)(const struct aeskl_ctx *key,
> +			      const u8 *src, u8 *dst, unsigned int len,
> +			      u8 tweak[AES_BLOCK_SIZE]);

Since there are so few functions in play here (one xts_encrypt_iv_func and two
xts_crypt_func) I think you should just use direct calls instead of function
pointers.  A simple parameter 'bool enc' would take care of selecting the
encryption function vs. the decryption one.

One of the issues with indirect calls, even when inlined with the intention that
they be optimized out, is that there's no guarantee that the compiler will
actually optimize them out.  That has the consequence that CFI stubs are still
needed in the assembly.

Direct calls avoid this issue.

(BTW, in my AES-GCM patchset I'm using direct calls:
https://lore.kernel.org/linux-crypto/20240527075626.142576-1-ebiggers@kernel.org/.
I'm thinking I should have used that approach with AES-XTS too.)

> +static struct skcipher_alg aeskl_skciphers[] = {
> +	{
> +		.base = {
> +			.cra_name		= "__xts(aes)",
> +			.cra_driver_name	= "__xts-aes-aeskl",
> +			.cra_priority		= 200,

Maybe add a comment here that explains that this is intentionally made lower
priority than xts-aes-aesni.

> +static int __init aeskl_init(void)
> +{
> +	u32 eax, ebx, ecx, edx;
> +
> +	if (!valid_keylocker())
> +		return -ENODEV;
> +
> +	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
> +	if (!(ebx & KEYLOCKER_CPUID_EBX_WIDE))
> +		return -ENODEV;
> +
> +	/*
> +	 * AES-KL itself does not rely on AES-NI. But, AES-KL does not
> +	 * support 192-bit keys. To ensure AES compliance, AES-KL falls
> +	 * back to AES-NI.
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_AES))
> +		return -ENODEV;

Everywhere else in arch/x86/crypto/ uses boot_cpu_has(), not
cpu_feature_enabled().

> +
> +	/* The tweak processing is optimized using AVX instructions. */
> +	if (!cpu_feature_enabled(X86_FEATURE_AVX))
> +		return -ENODEV;

The whole implementation uses VEX-coded instructions now, not just the tweak
processing.  So either fix or delete the above comment.

- Eric
