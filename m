From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] ARM: wire up HWCAP2 feature bits to the CPU modalias
Date: Sat, 29 Oct 2016 11:08:36 +0100
Message-ID: <CAKv+Gu_y7e=sJT+7FNj846NczgpNOdVx53SDC7dupmN-3ztNwA@mail.gmail.com>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org> <1476787939-21889-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve Capper <steve.capper@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:36299 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755237AbcJ2KIh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 Oct 2016 06:08:37 -0400
Received: by mail-it0-f46.google.com with SMTP id m138so14424806itm.1
        for <linux-crypto@vger.kernel.org>; Sat, 29 Oct 2016 03:08:37 -0700 (PDT)
In-Reply-To: <1476787939-21889-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 October 2016 at 11:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Wire up the generic support for exposing CPU feature bits via the
> modalias in /sys/device/system/cpu. This allows udev to automatically
> load modules for things like crypto algorithms that are implemented
> using optional instructions.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/Kconfig                  |  1 +
>  arch/arm/include/asm/cpufeature.h | 32 ++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>

Russell,

do you have any concerns regarding this patch? If not, I will drop it
into the patch system.

Herbert,

I will resend the followup patches in this series to linux-crypto@
once this prerequisite is in place

Thanks,
Ard.


> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b5d529fdffab..1a0c6a486a9c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -21,6 +21,7 @@ config ARM
>         select GENERIC_ALLOCATOR
>         select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
>         select GENERIC_CLOCKEVENTS_BROADCAST if SMP
> +       select GENERIC_CPU_AUTOPROBE
>         select GENERIC_EARLY_IOREMAP
>         select GENERIC_IDLE_POLL_SETUP
>         select GENERIC_IRQ_PROBE
> diff --git a/arch/arm/include/asm/cpufeature.h b/arch/arm/include/asm/cpufeature.h
> new file mode 100644
> index 000000000000..19c3dddd901a
> --- /dev/null
> +++ b/arch/arm/include/asm/cpufeature.h
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_CPUFEATURE_H
> +#define __ASM_CPUFEATURE_H
> +
> +#include <asm/hwcap.h>
> +
> +/*
> + * Due to the fact that ELF_HWCAP is a 32-bit type on ARM, and given the number
> + * of optional CPU features it defines, ARM's CPU capability bits have been
> + * divided across separate elf_hwcap and elf_hwcap2 variables, each of which
> + * covers a subset of the available CPU features.
> + *
> + * Currently, only a few of those are suitable for automatic module loading
> + * (which is the primary use case of this facility) and those happen to be all
> + * covered by HWCAP2. So let's only expose those via the CPU modalias for now.
> + */
> +#define MAX_CPU_FEATURES       (8 * sizeof(elf_hwcap2))
> +#define cpu_feature(x)         ilog2(HWCAP2_ ## x)
> +
> +static inline bool cpu_have_feature(unsigned int num)
> +{
> +       return elf_hwcap2 & (1UL << num);
> +}
> +
> +#endif
> --
> 2.7.4
>
