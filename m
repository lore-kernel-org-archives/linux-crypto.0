Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5594035D5
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773963099; cv=none; b=c7lsQmxuLjBdcCqh1xUFVy2vcNCebdrQ2Vmjd12ERVDz4DNLubYj2H5hegRjwanGb+bmf5lh7rmq8q5sJUEW6WHcFAWbinu4JVDEbfR1rzrZm+JIaJRbCC8ep4o7DFxgdaLiK7i7M9S08en7LllciiADc9cKBmDN12Ld7ftPkVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773963099; c=relaxed/simple;
	bh=qZY7IPEpKQHZP+0wQyFn5BMkUw6hrtYGUHt8mRRlGn4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lxs1MTDhP/4Rnb19Bdn/fJmY7PCTeOLbH4ROEZddV8FH+HZ/cjHiSCA4BCEFmhi46G4pWFWZQXNiEz2xzRprBOQLX6+KiMSVjjUxZElZGeJyFmRAS/ebWjlNkXkSrH4yUKUEsniFst/RLUcDGQGcRXuAv2QmSCIwveMLea6u0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lH5LHeLX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lH5LHeLX"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso9178385e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 16:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773963096; x=1774567896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKi0wuTPJMqhmhYRR+cZkwrRHJTsFrhSyCr65EK1waU=;
        b=lH5LHeLXalVH8QTKBL/Qkm06iLe3+Er5xc+Qrpw/TvodFF44ngsBV3FhYa3jJPHsCX
         7lt5YiG/PdsLnBC5tVBFF9OLnbRzrOiq7hRyrAJHPdAol8EbblMx1Ggf0++KY6FxhnCH
         1IVQLBosDXVQbJUxg6TYUz8EkNzcV7+fQC8TQlg0auRK18VQ1LfCCJzfh2LQP22I+EG3
         6hhbl2GStA7XQ87nLyi4lKzKPsVCo/tUpfBiHSZajErjQGrbg5PIOSCefTwcwI2aPJNH
         c37b7IqghbnqHO8PRz6dEQ5EbxCXk6GWrI6DM/a7xRNCEfoAy7Y/mDkODyW8RM+5x2ip
         hZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963096; x=1774567896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aKi0wuTPJMqhmhYRR+cZkwrRHJTsFrhSyCr65EK1waU=;
        b=JS0GdJ/C8rkRXN6RTZ6gb8JJH4TgVyQyrz8+JdnbPUZn+JcPgZa1qKdNvY9TSBEa49
         PHIvz2+HgRs5Zp08zyka4juIepyLcWsjpvPKyxKhyH6bZjkB0uA33/q7YsmYNQbuNG7G
         AWUCDU0yrrt001BlJ5p7ilMfTYCa74jMNxZq6ATt+ymrmxkZkfu8dfbWga0r5utyVcq1
         9iHvXYtj8ymMFmrFjM4FtIgJy177FccfQ3/gpOmddVAyJSVNUZUSlsiEYtyd6otfoCjx
         FxKyC5m3HRI4WgwiOCGABKrffkA3Io6mLzS3we8oAE7IgS+P+nubg+ULJr6JbAoefB6C
         8j3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYjsGSPKMHWATVFpWpnDtDYS0fE/ofwmE/KKuqktDzETTiZh99qD27sjOvPiYtsQgDriNWJCGK+/HO+e8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+tyw7CG19aSfzCXWkdFdvw+Ih6w+4Qs/lE992ii8QSkgzXdaT
	XMR9q5sxAxYEtQ6Xt+oBAD/YuWwuR0KERUacWPhktuNQIy9gJ7FyHS5P
X-Gm-Gg: ATEYQzxjjLDQuFSfGZ5L6xdvV7Jf29g6/flTW7J1aQJ+dMs+HS0uj0cP4NDfchyOjoP
	8SHZ+MmyHJVN8RFBdi+iW5Fge+LEl1bKxowksGJHeEn1zlfzcgsJkzVqCqjwb4dIYO5CZB9NJk9
	KafpvjQoq3WRQBcZq2cVxUV5QnqVi5YST/8b1pMSIuRmluKold0e0zPEmDDfypzj19LQqG8hid+
	x/Mj6sPf+XDcE+l6X0FN8E0r2AzmYi7Ush8dkIW91tRVrWvtWhzPFZAOOopPk33WfcuLKYgaTTr
	6qSQm7/wkyStoFGld6ofPM7Lox05QlCrIKXRARcC1Fxa4YAORdsHJixBB6FERzmNU82qgXVmtqH
	iD6hr+eAEtelmyHWNUB46KL01/BaJIqi1p9pJ9nnA6sa9QSkCBFI+9O/LRRBtBZlNuIS2MC5G7O
	03MxxiEjx7P2M1hpr1E56PXBnVLRb36z1TQKn3A3fbBK2U2jXCUgtw53AJs15PPqLyn87RnFY8v
	XE=
X-Received: by 2002:a05:600c:8710:b0:486:d76c:fa21 with SMTP id 5b1f17b1804b1-486fee051a3mr14018675e9.12.1773963096430;
        Thu, 19 Mar 2026 16:31:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe8367d8sm23947715e9.14.2026.03.19.16.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 16:31:36 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:31:34 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Demian Shulhan <demyansh@gmail.com>
Cc: ebiggers@kernel.org, ardb@kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260319233134.58fb994c@pumpkin>
In-Reply-To: <20260317065425.2684093-1-demyansh@gmail.com>
References: <20260317065425.2684093-1-demyansh@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Mar 2026 06:54:25 +0000
Demian Shulhan <demyansh@gmail.com> wrote:

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
> ---
>  lib/crc/Kconfig                  |  1 +
>  lib/crc/Makefile                 |  4 ++
>  lib/crc/arm64/crc64-neon-inner.c | 82 ++++++++++++++++++++++++++++++++
>  lib/crc/arm64/crc64.h            | 35 ++++++++++++++
>  4 files changed, 122 insertions(+)
>  create mode 100644 lib/crc/arm64/crc64-neon-inner.c
>  create mode 100644 lib/crc/arm64/crc64.h
> 
> diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
> index 70e7a6016de3..6b6c7d9f5ea5 100644
> --- a/lib/crc/Kconfig
> +++ b/lib/crc/Kconfig
> @@ -82,6 +82,7 @@ config CRC64
>  config CRC64_ARCH
>  	bool
>  	depends on CRC64 && CRC_OPTIMIZATIONS
> +	default y if ARM64 && KERNEL_MODE_NEON
>  	default y if RISCV && RISCV_ISA_ZBC && 64BIT
>  	default y if X86_64
>  
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
> +#ifdef CONFIG_ARM64
> +#include <asm/neon-intrinsics.h>
> +#else
> +#include <arm_neon.h>
> +#endif
> +
> +#define GET_P64_0(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 0))
> +#define GET_P64_1(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 1))
> +
> +static const u64 fold_consts_val[2] = {0xeadc41fd2ba3d420ULL, 0x21e9761e252621acULL};
> +static const u64 bconsts_val[2] = {0x27ecfa329aef9f77ULL, 0x34d926535897936aULL};
> +
> +u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
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
> +			v1 = vreinterpretq_p64_u8(vld1q_u8(p));
> +
> +			poly128_t v2 = vmull_high_p64(fold_consts, v0);
> +			poly128_t v0_128 = vmull_p64(GET_P64_0(fold_consts), GET_P64_0(v0));

If the cpu can execute two PMULL at the same time it should be possible
to speed things up.
With the correct constant the PMULL output can be xor'ed onto the p[32-63]
instead of p[16-47] (which is where I think it ends up) so you can execute
two in parallel - just needs some very careful register use.

> +
> +			uint8x16_t x0 = veorq_u8(vreinterpretq_u8_p128(v0_128),
> +						 vreinterpretq_u8_p128(v2));
> +
> +			x0 = veorq_u8(x0, vreinterpretq_u8_p64(v1));
> +			v0 = vreinterpretq_p64_u8(x0);
> +
> +			p += 16;
> +			len -= 16;
> +		}

I can't help feeling the part below really needs a few comments.
I think I know what it has to be doing - reducing 128 bits to 64
(or possibly 256 to 64 depending on the width of the multiply).
Although you only need to do it at the end of the outer loop.
Between the 4k blocks I think you can just save the output in 64bit
registers.

I'm also not entirely certain, but I think the code is equivalent to
calling crc64_nvme_generic() for 8 bytes (which could be xor'ed with
the last 8 bytes of the buffer).
(Or that might need a different constant and the code is actually
running the crc backwards on 8 bytes 'beyond the crc'.)


> +
> +		poly64x2_t v7 = vreinterpretq_p64_u64((uint64x2_t){0, 0});
> +
> +		poly128_t v1_128 = vmull_p64(GET_P64_1(fold_consts), GET_P64_0(v0));
> +
> +		uint8x16_t ext_v0 = vextq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p64(v7), 8);
> +		uint8x16_t x0 = veorq_u8(ext_v0, vreinterpretq_u8_p128(v1_128));
> +
> +		v0 = vreinterpretq_p64_u8(x0);
> +
> +		poly64x2_t bconsts = vreinterpretq_p64_u64(vld1q_u64(bconsts_val));
> +
> +		v1_128 = vmull_p64(GET_P64_0(bconsts), GET_P64_0(v0));
> +
> +		poly64x2_t v1_64 = vreinterpretq_p64_u8(vreinterpretq_u8_p128(v1_128));
> +		poly128_t v3_128 = vmull_p64(GET_P64_1(bconsts), GET_P64_0(v1_64));
> +
> +		x0 = veorq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p128(v3_128));
> +
> +		uint8x16_t ext_v2 = vextq_u8(vreinterpretq_u8_p64(v7),
> +					     vreinterpretq_u8_p128(v1_128), 8);
> +
> +		x0 = veorq_u8(x0, ext_v2);
> +
> +		v0 = vreinterpretq_p64_u8(x0);
> +		crc = vgetq_lane_u64(vreinterpretq_u64_p64(v0), 1);
> +	}
> +
> +	return crc;
> +}
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
> +
> +#include <asm/cpufeature.h>
> +#include <asm/simd.h>
> +#include <linux/minmax.h>
> +#include <linux/sizes.h>
> +
> +u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
> +
> +#define crc64_be_arch crc64_be_generic
> +
> +static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
> +{
> +	if (!IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) && len >= 128 &&
> +	    cpu_have_named_feature(PMULL) && likely(may_use_simd())) {
> +		while (len >= 128) {
> +			size_t chunk = min_t(size_t, len & ~15, SZ_4K);

That shouldn't need to be min_t().

	David

> +
> +			scoped_ksimd() {
> +				crc = crc64_nvme_arm64_c(crc, p, chunk);
> +			}
> +			p += chunk;
> +			len -= chunk;
> +		}
> +	}
> +	return crc64_nvme_generic(crc, p, len);
> +}
> +
> +#endif /* _ARM64_CRC64_H */
> +

