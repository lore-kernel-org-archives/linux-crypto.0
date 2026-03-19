Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B335C1B4;
	Thu, 19 Mar 2026 19:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773947353; cv=none; b=gUoyeE09iqvm6PYJcl+QzdExBR6xwj6Bq3aBAnvMlWyBEoT/h3Gews2AB0juiwCce1HXuK0ChBtyLQQtnUUpVYUdj1jFfqxDQNoo+Np7AOYO8FzGPSos2Gbwm9lKjpffSs29DgtXmHNb9F5iqtq+2lm+328Ogs5OqblT5u5o8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773947353; c=relaxed/simple;
	bh=LN9pKIEm8CVhPvn+kJ0ya0tyrc4TCbDobALCWmgaZ70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6po77+YctiPX1nSeM5VXL2sBUuAlwffl6aDHMu73VJYEjHHdCt2IWGertnxZOY25VE5NOKiEkQlL4i+HNng53QwPaM0euGcu3Vej4Xla/2pAB4oOD/cVXPLotMQwThHldMMpr/sO6LafRC+OWVCcwc8zWVztDhN9z8/6+LboHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WURVGIXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WURVGIXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D8EC19424;
	Thu, 19 Mar 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773947353;
	bh=LN9pKIEm8CVhPvn+kJ0ya0tyrc4TCbDobALCWmgaZ70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WURVGIXtHaxXgZj883lLZ76xRRo+5LgvswfrpIOQ0SpLEafoM4GQXKD11OboRtAEf
	 eY2GdYng1D60KTkaez1cix3pbdMEbghcfIE7Zz+z1DwehZTmy8fqMsXzhkmZWTuM9I
	 ucM/sVEflEcFeGvlEPLHkVF3hBWk1Ex8KHWVTsZSdJIGKYFE9tQ8Y0ykjlq6RDLlGq
	 5lTa5PloqA23tz38UQUes2KsG2amAw/dO5tncskkSn4+GHAX0A0+xsSqUfkNEkJ/Id
	 ahA5Mj3DkBQ+xW+oi963yfHYdE+imWo5ODPRh3aoboWssyN412Fo4G8vkX2V0zMS9D
	 GoQ9LUH3hBOIA==
Date: Thu, 19 Mar 2026 12:09:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demian Shulhan <demyansh@gmail.com>
Cc: ardb@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260319190908.GB10208@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317065425.2684093-1-demyansh@gmail.com>

On Tue, Mar 17, 2026 at 06:54:25AM +0000, Demian Shulhan wrote:
> Implement an optimized CRC64 (NVMe) algorithm for ARM64 using NEON
> Polynomial Multiply Long (PMULL) instructions. The generic shift-and-XOR
> software implementation is slow, which creates a bottleneck in NVMe and
> other storage subsystems.
> 
> The acceleration is implemented using C intrinsics (<arm_neon.h>) rather
> than raw assembly for better readability and maintainability.
> 
> Key highlights of this implementation:
> - Uses 4KB chunking inside scoped_ksimd() to avoid preemption latency
>   spikes on large buffers.
> - Pre-calculates and loads fold constants via vld1q_u64() to minimize
>   register spilling.
> - Benchmarks show the break-even point against the generic implementation
>   is around 128 bytes. The PMULL path is enabled only for len >= 128.
> - Safely falls back to the generic implementation on Big-Endian systems.
> 
> Performance results (kunit crc_benchmark on Cortex-A72):
> - Generic (len=4096): ~268 MB/s
> - PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)
> 
> Signed-off-by: Demian Shulhan <demyansh@gmail.com>

Thanks!  I'm planning to accept this once the relatively minor comments
later on in this email are addressed.

But just FYI, having separate code for each CRC variant isn't very
sustainable.  CRC-T10DIF, CRC64-NVME, and CRC64-BE should all have
similar PMULL based implementations.  x86 and riscv solve this using a
"template" that supports all CRC variants.  I'd like to eventually bring
a similar solution to arm64 (and arm) as well.

So while this code is fine for now, later I'd like to replace it with
something more general, like x86 and riscv have now.  Then we can
optimize CRC-T10DIF, CRC64-NVME, and CRC64-BE together.

E.g., consider that the CRC64-NVME code added by patch folds across at
most 1 vector.  That's much less optimized than the existing CRC-T10DIF
code in lib/crc/arm64/crc-t10dif-core.S, which folds across 8.  If we
used a unified approach, we could optimize these CRC variants together.

As for intristics vs. assembly: the kernel usually uses assembly.
However, I'm supportive of starting to use intrinsics more, and this a
good start.  But we'll need to keep an eye out for any compiler issues.

Various fairly minor comments below:

> diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
> index 70e7a6016de3..6b6c7d9f5ea5 100644
> --- a/lib/crc/Kconfig
> +++ b/lib/crc/Kconfig
> @@ -82,6 +82,7 @@ config CRC64
>  config CRC64_ARCH
>  	bool
>  	depends on CRC64 && CRC_OPTIMIZATIONS
> +	default y if ARM64 && KERNEL_MODE_NEON

Just "default y if ARM64".  KERNEL_MODE_NEON is always enabled on ARM64.
Changes have already been submitted to remove the existing checks of
KERNEL_MODE_NEON in ARM64-specific code in lib/crc/ and lib/crypto/.

> diff --git a/lib/crc/Makefile b/lib/crc/Makefile
> index 7543ad295ab6..552760f28003 100644
> --- a/lib/crc/Makefile
> +++ b/lib/crc/Makefile
> @@ -38,6 +38,10 @@ obj-$(CONFIG_CRC64) += crc64.o
>  crc64-y := crc64-main.o
>  ifeq ($(CONFIG_CRC64_ARCH),y)
>  CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
> +CFLAGS_REMOVE_arm64/crc64-neon-inner.o += -mgeneral-regs-only
> +CFLAGS_arm64/crc64-neon-inner.o += -ffreestanding -march=armv8-a+crypto
> +CFLAGS_arm64/crc64-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
> +crc64-$(CONFIG_ARM64) += arm64/crc64-neon-inner.o
>  crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
>  crc64-$(CONFIG_X86) += x86/crc64-pclmul.o
>  endif

To make this a bit easier to read, add newlines before and after the
arm64-specific parts, and change 'endif' to 'endif # CONFIG_CRC64_ARCH'

> diff --git a/lib/crc/arm64/crc64-neon-inner.c b/lib/crc/arm64/crc64-neon-inner.c
> new file mode 100644
> index 000000000000..beefdec5456b
> --- /dev/null
> +++ b/lib/crc/arm64/crc64-neon-inner.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerated CRC64 (NVMe) using ARM NEON C intrinsics
> + */
> +
> +#include <linux/types.h>
> +#include <linux/crc64.h>

No need for <linux/crc64.h> here

> +#ifdef CONFIG_ARM64
> +#include <asm/neon-intrinsics.h>
> +#else
> +#include <arm_neon.h>
> +#endif

This is arm64-specific code, so all that's needed above is the part
under CONFIG_ARM64.

> static const u64 fold_consts_val[2] = {0xeadc41fd2ba3d420ULL, 0x21e9761e252621acULL};
> static const u64 bconsts_val[2] = {0x27ecfa329aef9f77ULL, 0x34d926535897936aULL};

Add comments that document what these constants are.  As per
lib/crc/x86/crc-pclmul-consts.h which has the same constants, these are:
x^191 mod G, x^127 mod G, floor(x^127 / G), and (G - x^64) / x.

> +u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)

Declare this function first earlier in the file, otherwise a
-Wmissing-prototypes warning is generated.

> +{
> +	if (len == 0)
> +		return crc;
> +
> +	uint64x2_t v0_u64 = {crc, 0};
> +	poly64x2_t v0 = vreinterpretq_p64_u64(v0_u64);
> +
> +	poly64x2_t fold_consts = vreinterpretq_p64_u64(vld1q_u64(fold_consts_val));
> +
> +	if (len >= 16) {

> +		poly64x2_t v1 = vreinterpretq_p64_u8(vld1q_u8(p));
> +
> +		v0 = vreinterpretq_p64_u8(veorq_u8(vreinterpretq_u8_p64(v0),
> +						   vreinterpretq_u8_p64(v1)));
> +		p += 16;
> +		len -= 16;
> +
> +		while (len >= 16) {

Since this function is called only when len >= 128, and it exists
specifically for that caller and isn't available for wider use, it
doesn't need to handle other cases.  So the 'if (len == 0)' block should
be removed, 'len >= 16' should be made unconditional, 'while (len >=
16)' should be replaced with 'do ... while (len >= 16)'.

> diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
> new file mode 100644
> index 000000000000..12b1a8bd518a
> --- /dev/null
> +++ b/lib/crc/arm64/crc64.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CRC64 using ARM64 PMULL instructions
> + */
> +#ifndef _ARM64_CRC64_H
> +#define _ARM64_CRC64_H

We haven't been using include guards in the headers
lib/{crc,crypto}/${ARCH}/${ALGORITHM}.h, as they are intended only for
inclusion in a specific C file -- lib/crc/crc64-main.c in this case.
Probably best to stay with the existing convention of omitting these.

> +static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
> +{
> +	if (!IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) && len >= 128 &&

No need to check !IS_ENABLED(CONFIG_CPU_BIG_ENDIAN), since arm64 kernels
are little-endian-only these days.

>               while (len >= 128)

Replace with a do-while loop, as this is already conditional on
'len >= 128'.

> +			scoped_ksimd() {
> +				crc = crc64_nvme_arm64_c(crc, p, chunk);
> +			}

Remove the braces above, as the contents of the block are a single
statement.

Finally, this patch also has many overly-long lines.  I recommend
running 'git clang-format'.  It's not perfect, but it's easier and often
produces better results than manual formatting.

- Eric
