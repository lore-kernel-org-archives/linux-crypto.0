Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C8B1E3DF7;
	Tue, 11 Feb 2025 07:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739259616; cv=none; b=M1Oc5h0ZPz82FN4ZPuu8jAarTz958u6m286MgOEPLLgWlOP6RB+3EGfOg5vDp+M/5A7ZfHEPuGe5QH1BuUz4FvTyRKwU1j8V6VchR0LOis7BHyT8hYSKdbZjGrVGviTJOO8iq9Tsy3RR1Gntr8FdQU0Kba+Q1Jqiu0uufuiL0Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739259616; c=relaxed/simple;
	bh=beJJmS5KhmQpKqkqoSD5HJLmQz/rWVlme+hJ0TKjkbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZV92+vVFDhzgRpIbLIx1pCtsDQdymdYKwbZRyD9DK6VjyCGsKKm2l42wMrvfbh19tW2JuBr4LcggjsKPCNzw53znmZ3j5Wx3r6HPMABpxVipdqFeL9M9LVKdwGHOm/Lf3AqKkCP5gw/Iv0bbEG36xQpZeYnYBACZyRnF6fPeFFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from mail-ej1-f41.google.com (unknown [209.85.218.41])
	by APP-03 (Coremail) with SMTP id rQCowADnzTAw_apnJpFeDA--.31350S2;
	Tue, 11 Feb 2025 15:33:05 +0800 (CST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab78bcb4b19so687060366b.2;
        Mon, 10 Feb 2025 23:33:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVZiU4mMNrddg1iSVuPTfzKde/lf8ufY7q0BjQTo68SHgohobMMKWOshw4luZdpxsESggXIcst70wPxKECP@vger.kernel.org, AJvYcCW8eGYEtHdQjZOm1YTE5zgm2xyBNXmQpr9V+2rAFlbdNjViAjvUifNRakuzVcBhwrOM3D+c1u/b0LLyc9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU2zrEfhYpfVqzJ8TX4LvwU3hvAGA/gwwLk/Q0S6x5pOXFm+FR
	xOtpW9k/3H6gnCJwds2M5iPocQns2EnMBURtww5yWXO3cpypBJ+V2SIt9Efzw/V5/EQLdWxYA6u
	9c5iRTlbMCs+8kT2JswXM+nxFlBY=
X-Google-Smtp-Source: AGHT+IHAwCNj07u8aeVQ4vMQiCfg+P4MVm57iVQx3ohWOvjItM6I9wWFswl6UR1flM66NCYqiGOpCSMe1tRHdiN6gMc=
X-Received: by 2002:a17:907:9806:b0:ab7:46cd:4803 with SMTP id
 a640c23a62f3a-ab789ade88fmr1591185966b.18.1739259184101; Mon, 10 Feb 2025
 23:33:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211071101.181652-1-zhihang.shao.iscas@gmail.com>
In-Reply-To: <20250211071101.181652-1-zhihang.shao.iscas@gmail.com>
Reply-To: zhangchunyan@iscas.ac.cn
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Date: Tue, 11 Feb 2025 15:32:27 +0800
X-Gmail-Original-Message-ID: <CAOsKWHA9XHygkz1pedRYftmnK9XZ5sENDk1pvf7UEXsjBubepA@mail.gmail.com>
X-Gm-Features: AWEUYZlXBBviCHia7xS16GpqqRCUdV3l5h6e5wQ7ZTpwghOFSFroDhhIYbxdu_Y
Message-ID: <CAOsKWHA9XHygkz1pedRYftmnK9XZ5sENDk1pvf7UEXsjBubepA@mail.gmail.com>
Subject: Re: [PATCH v4] riscv: Optimize crct10dif with zbc extension
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: ebiggers@kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	ardb@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-CM-TRANSID:rQCowADnzTAw_apnJpFeDA--.31350S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr4UCF1fJFy5ZFyUuFW3KFg_yoW7ZFWDpF
	Wvkrs3tFWUWay7GrWxZ347WFn8Cw4vgw4agry7GFy5JF1DZrW8ZFZ5Kas29rs7JF1kJrWI
	kF95ur98CrWDJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
	vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF
	0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr
	0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxG
	rwCY02Avz4vEIxC_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
	IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
	6r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
	IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv
	67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf
	9x07jI0PfUUUUU=
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwwKB2eq7yQwAAAAsw

On Tue, 11 Feb 2025 at 15:11, Zhihang Shao <zhihang.shao.iscas@gmail.com> wrote:
>
> The current CRC-T10DIF algorithm on RISC-V platform is based on
> table-lookup optimization.
> Given the previous work on optimizing crc32 calculations with zbc
> extension, it is believed that this will be equally effective for
> accelerating crc-t10dif.
>
> Therefore this patch offers an implementation of crc-t10dif using zbc
> extension. This can detect whether the current runtime environment
> supports zbc feature and, if so, uses it to accelerate crc-t10dif
> calculations.
>
> This patch is updated due to the patchset of updating kernel's
> CRC-T10DIF library in 6.14, which is finished by Eric Biggers.
> Also, I used crc_kunit.c to test the performance of crc-t10dif
> optimized by crc extension.
>
> Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>

You should add Eric's Acked-by and Tested-by, apart from that, feel free to add,

Reviewed-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

Thanks,
Chunyan


>
> ---
> v4:
> - Use proper data types and remove #defines according
> to Eric's comments. (Eric)
> ---
> v3:
> - Rebase for Eric's crc tree. (Eric)
> ---
> v2:
> - Use crypto self-tests instead. (Eric)
> - Fix some format errors in arch/riscv/crypto/Kconfig. (Chunyan)
> ---
>  arch/riscv/Kconfig                |   1 +
>  arch/riscv/lib/Makefile           |   1 +
>  arch/riscv/lib/crc-t10dif-riscv.c | 120 ++++++++++++++++++++++++++++++
>  3 files changed, 122 insertions(+)
>  create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 7612c52e9b1e..db1cf9666dfd 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -25,6 +25,7 @@ config RISCV
>         select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>         select ARCH_HAS_BINFMT_FLAT
>         select ARCH_HAS_CRC32 if RISCV_ISA_ZBC
> +       select ARCH_HAS_CRC_T10DIF if RISCV_ISA_ZBC
>         select ARCH_HAS_CURRENT_STACK_POINTER
>         select ARCH_HAS_DEBUG_VIRTUAL if MMU
>         select ARCH_HAS_DEBUG_VM_PGTABLE
> diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
> index 79368a895fee..689895b271bd 100644
> --- a/arch/riscv/lib/Makefile
> +++ b/arch/riscv/lib/Makefile
> @@ -16,6 +16,7 @@ lib-$(CONFIG_MMU)     += uaccess.o
>  lib-$(CONFIG_64BIT)    += tishift.o
>  lib-$(CONFIG_RISCV_ISA_ZICBOZ) += clear_page.o
>  obj-$(CONFIG_CRC32_ARCH)       += crc32-riscv.o
> +obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-riscv.o
>  obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
>  lib-$(CONFIG_RISCV_ISA_V)      += xor.o
>  lib-$(CONFIG_RISCV_ISA_V)      += riscv_v_helpers.o
> diff --git a/arch/riscv/lib/crc-t10dif-riscv.c b/arch/riscv/lib/crc-t10dif-riscv.c
> new file mode 100644
> index 000000000000..da90e2900ca7
> --- /dev/null
> +++ b/arch/riscv/lib/crc-t10dif-riscv.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerated CRC-T10DIF implementation with RISC-V Zbc extension.
> + *
> + * Copyright (C) 2024 Institute of Software, CAS.
> + */
> +
> +#include <asm/alternative-macros.h>
> +#include <asm/byteorder.h>
> +#include <asm/hwcap.h>
> +
> +#include <linux/byteorder/generic.h>
> +#include <linux/crc-t10dif.h>
> +#include <linux/minmax.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +
> +#define CRCT10DIF_POLY 0x8bb7
> +
> +#if __riscv_xlen == 64
> +#define CRCT10DIF_POLY_QT_BE 0xf65a57f81d33a48a
> +
> +static inline u64 crct10dif_prep(u16 crc, const __be64 *ptr)
> +{
> +       return ((u64)crc << 48) ^ __be64_to_cpu(*ptr);
> +}
> +
> +#elif __riscv_xlen == 32
> +#define CRCT10DIF_POLY_QT_BE 0xf65a57f8
> +
> +static inline u32 crct10dif_prep(u16 crc, const __be32 *ptr)
> +{
> +       return ((u32)crc << 16) ^ __be32_to_cpu(*ptr);
> +}
> +
> +#else
> +#error "Unexpected __riscv_xlen"
> +#endif
> +
> +static inline u16 crct10dif_zbc(unsigned long s)
> +{
> +       u16 crc;
> +
> +       asm volatile   (".option push\n"
> +                       ".option arch,+zbc\n"
> +                       "clmulh %0, %1, %2\n"
> +                       "xor    %0, %0, %1\n"
> +                       "clmul  %0, %0, %3\n"
> +                       ".option pop\n"
> +                       : "=&r" (crc)
> +                       : "r"(s),
> +                         "r"(CRCT10DIF_POLY_QT_BE),
> +                         "r"(CRCT10DIF_POLY)
> +                       :);
> +
> +       return crc;
> +}
> +
> +static inline u16 crct10dif_unaligned(u16 crc, const u8 *p, size_t len)
> +{
> +       size_t bits = len * 8;
> +       unsigned long s = 0;
> +       u16 crc_low = 0;
> +
> +       for (int i = 0; i < len; i++)
> +               s = *p++ | (s << 8);
> +
> +       if (len < sizeof(u16)) {
> +               s ^= crc >> (16 - bits);
> +               crc_low = crc << bits;
> +       } else {
> +               s ^= (unsigned long)crc << (bits - 16);
> +       }
> +
> +       crc = crct10dif_zbc(s);
> +       crc ^= crc_low;
> +
> +       return crc;
> +}
> +
> +u16 crc_t10dif_arch(u16 crc, const u8 *p, size_t len)
> +{
> +       size_t offset, head_len, tail_len;
> +       const __be64 *p_ul;
> +       unsigned long s;
> +
> +       asm goto(ALTERNATIVE("j %l[legacy]", "nop", 0,
> +                            RISCV_ISA_EXT_ZBC, 1)
> +                : : : : legacy);
> +
> +       offset = (unsigned long)p & (sizeof(unsigned long) - 1);
> +       if (offset && len) {
> +               head_len = min(sizeof(unsigned long) - offset, len);
> +               crc = crct10dif_unaligned(crc, p, head_len);
> +               p += head_len;
> +               len -= head_len;
> +       }
> +
> +       tail_len = len & (sizeof(unsigned long) - 1);
> +       len = len >> ilog2(sizeof(unsigned long));
> +       p_ul = (const __be64 *)p;
> +
> +       for (int i = 0; i < len; i++) {
> +               s = crct10dif_prep(crc, p_ul);
> +               crc = crct10dif_zbc(s);
> +               p_ul++;
> +       }
> +
> +       p = (const u8 *)p_ul;
> +       if (tail_len)
> +               crc = crct10dif_unaligned(crc, p, tail_len);
> +
> +       return crc;
> +legacy:
> +       return crc_t10dif_generic(crc, p, len);
> +}
> +EXPORT_SYMBOL(crc_t10dif_arch);
> +
> +MODULE_DESCRIPTION("CRC-T10DIF using RISC-V ZBC Extension");
> +MODULE_LICENSE("GPL");
> --
> 2.47.0
>
>

