From: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2 2/2] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Wed, 4 Oct 2017 17:36:00 +0200
Message-ID: <20171004153600.GB31821@linux-mips.org>
References: <1507114133-9129-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1507114133-9129-3-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:60602 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752471AbdJDPgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2017 11:36:12 -0400
Received: from localhost.localdomain ([127.0.0.1]:40434 "EHLO linux-mips.org"
        rhost-flags-OK-OK-OK-FAIL) by eddie.linux-mips.org with ESMTP
        id S23990499AbdJDPgKHVMm2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2017 17:36:10 +0200
Content-Disposition: inline
In-Reply-To: <1507114133-9129-3-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 04, 2017 at 12:48:53PM +0200, Marcin Nowakowski wrote:

>  arch/mips/Kconfig             |   4 +
>  arch/mips/Makefile            |   3 +
>  arch/mips/crypto/Makefile     |   5 +
>  arch/mips/crypto/crc32-mips.c | 364 ++++++++++++++++++++++++++++++++++++++++++
>  crypto/Kconfig                |   9 ++
>  5 files changed, 385 insertions(+)
>  create mode 100644 arch/mips/crypto/Makefile
>  create mode 100644 arch/mips/crypto/crc32-mips.c
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index cb7fcc4..0f96812 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2036,6 +2036,7 @@ config CPU_MIPSR6
>  	select CPU_HAS_RIXI
>  	select HAVE_ARCH_BITREVERSE
>  	select MIPS_ASID_BITS_VARIABLE
> +	select MIPS_CRC_SUPPORT
>  	select MIPS_SPRAM
>  
>  config EVA
> @@ -2503,6 +2504,9 @@ config MIPS_ASID_BITS
>  config MIPS_ASID_BITS_VARIABLE
>  	bool
>  
> +config MIPS_CRC_SUPPORT
> +	bool
> +
>  #
>  # - Highmem only makes sense for the 32-bit kernel.
>  # - The current highmem code will only work properly on physically indexed
> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
> index a96d97a..aa77536 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -216,6 +216,8 @@ cflags-$(toolchain-msa)			+= -DTOOLCHAIN_SUPPORTS_MSA
>  endif
>  toolchain-virt				:= $(call cc-option-yn,$(mips-cflags) -mvirt)
>  cflags-$(toolchain-virt)		+= -DTOOLCHAIN_SUPPORTS_VIRT
> +toolchain-crc				:= $(call cc-option-yn,$(mips-cflags) -Wa$(comma)-mcrc)
> +cflags-$(toolchain-crc)			+= -DTOOLCHAIN_SUPPORTS_CRC
>  
>  #
>  # Firmware support
> @@ -324,6 +326,7 @@ libs-y			+= arch/mips/math-emu/
>  # See arch/mips/Kbuild for content of core part of the kernel
>  core-y += arch/mips/
>  
> +drivers-$(CONFIG_MIPS_CRC_SUPPORT) += arch/mips/crypto/
>  drivers-$(CONFIG_OPROFILE)	+= arch/mips/oprofile/
>  
>  # suspend and hibernation support
> diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
> new file mode 100644
> index 0000000..665c725
> --- /dev/null
> +++ b/arch/mips/crypto/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for MIPS crypto files..
> +#
> +
> +obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
> diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
> new file mode 100644
> index 0000000..f2f5db0
> --- /dev/null
> +++ b/arch/mips/crypto/crc32-mips.c
> @@ -0,0 +1,364 @@
> +/*
> + * crc32-mips.c - CRC32 and CRC32C using optional MIPSr6 instructions
> + *
> + * Module based on arm64/crypto/crc32-arm.c
> + *
> + * Copyright (C) 2014 Linaro Ltd <yazen.ghannam@linaro.org>
> + * Copyright (C) 2017 Imagination Technologies, Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/unaligned/access_ok.h>
> +#include <linux/cpufeature.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <asm/mipsregs.h>
> +
> +#include <crypto/internal/hash.h>
> +
> +enum crc_op_size {
> +	b, h, w, d,
> +};
> +
> +enum crc_type {
> +	crc32,
> +	crc32c,
> +};
> +
> +#ifdef TOOLCHAIN_SUPPORTS_CRC
> +
> +#define _CRC32(crc, value, size, type)		\
> +do {						\
> +	__asm__ __volatile__(			\
> +	".set	push\n\t"			\
> +	".set	crc\n\t"			\
> +	#type #size "	%0, %1, %0\n\t"		\
> +	".set	pop"			\
> +	: "+r" (crc)				\
> +	: "r" (value)				\
> +);						\
> +} while(0)
> +
> +#define CRC_REGISTER
> +
> +#else	/* TOOLCHAIN_SUPPORTS_CRC */
> +/*
> + * Crc argument is currently ignored and the assembly below assumes
> + * the crc is stored in $2. As the register number is encoded in the
> + * instruction we can't let the compiler chose the register it wants.
> + * An alternative is to change the code to do
> + * move $2, %0
> + * crc32
> + * move %0, $2
> + * but that adds unnecessary operations that the crc32 operation is
> + * designed to avoid. This issue can go away once the assembler
> + * is extended to support this operation and the compiler can make
> + * the right register choice automatically
> + */
> +
> +#define _CRC32(crc, value, size, type)						\
> +do {										\
> +	__asm__ __volatile__(							\
> +	".set	push\n\t"							\
> +	".set	noat\n\t"							\
> +	"move	$at, %1\n\t"							\
> +	"# " #type #size "	%0, $at, %0\n\t"				\
> +	_ASM_INSN_IF_MIPS(0x7c00000f | (2 << 16) | (1 << 21) | (%2 << 6) | (%3 << 8))	\
> +	_ASM_INSN32_IF_MM(0x00000030 | (1 << 16) | (2 << 21) | (%2 << 14) | (%3 << 3))	\
> +	".set	pop"							\
> +	: "+r" (crc)								\
> +	: "r" (value), "i" (size), "i" (type)					\
> +);										\
> +} while(0)
> +
> +#define CRC_REGISTER __asm__("$2")
> +#endif	/* !TOOLCHAIN_SUPPORTS_CRC */

Over there years we've added so many inlines for instructions not yet
supported by gas and the simply approach always requires extra move
instructions.  So I finally cooked up something better which only relies
on things that are in gas for as long as I can remember.  This illustrates
it:

	.macro	parse var r
	.ifc	\r, $0
\var	=	0
	.endif
	.ifc	\r, $1
\var	=	1
	.endif
	.ifc	\r, $2
\var	=	2
	.endif
	.ifc	\r, $3
\var	=	3
	.endif
	.endm

	.macro	definsn opcode r1 r2 r3
	parse	__definsn_r1 \r1
	parse	__definsn_r2 \r2
	parse	__definsn_r3 \r3
	.word	\opcode | (__definsn_r1 << 16) | (__definsn_r2 << 20) | (__definsn_r3 << 24)
	.endm

	.macro	foo r1, r2, r3
	definsn	42, \r1, \r2, \r3
	.endm

	foo	$1, $2, $3
	foo	$3, $0, $1

The advantages are obvious, the hypothetical instruction foo can be used
just like it was actually supported by gas and no bloat by move
instructions to shuffle operands in and results out.  Which for some
very convoluted cases may also save you from an ICE.

Above skeleton still needs a little polish, either by extending the
parsing of register numbers to all 32 registers or by implementing that
using another loop which probably would be implemented using a recursive
gas macro.

> +
> +#define CRC32(crc, value, size) \
> +	_CRC32(crc, value, size, crc32)
> +
> +#define CRC32C(crc, value, size) \
> +	_CRC32(crc, value, size, crc32c)
> +
> +static u32 crc32_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
> +{
> +	register u32 crc CRC_REGISTER = crc_;
> +
> +#ifdef CONFIG_64BIT
> +	while (len >= sizeof(u64)) {
> +		register u64 value = get_unaligned_le64(p);

Nice try but gcc will happily ignore the register keyword.  It only
honors register when explicitly assigning a value to a register, something
like register int foo asm("$42");.  Same for the other instances of
register below.

Cheers,

  Ralf
