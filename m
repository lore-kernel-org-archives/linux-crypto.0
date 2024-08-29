Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B201974EA;
	Thu, 29 Aug 2024 13:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937519; cv=none; b=DVLEwATBNRESzu0nxG0s9FBra5TgKOFLpMBoEDfaDchpWvRZzM1+x3y3359zYeCsYWYhtgtdsyATT5niMa5ryoWaRPDXuXeSU/QaJEjt3nzYxUH0a0so8n9U68QIBf7qURXspUNR5qFjOn1E7V5QosLozqY5foP1iorQtTaYD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937519; c=relaxed/simple;
	bh=xP7mLaBTQIVKu6v+SpT/VXgaUAjecAaatqPfgxOuI10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ooFxuJZD+OTyOhNvlBt1p5xpzLC1VMxNdhHvBwv/JfLJyxY9MZ7pao/xabVe7d5G3jPYS5e11iWaswn1yuIVSOaQO8yc7sIMCRyrcGitgMjsdBnNs6JvhjtTuPtx4QJ4HFUjRJNaTachhIRlulPBqR5HRkeh6asTObi8oqR0TVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sXgZs3d6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXgZs3d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC70BC4CEC3;
	Thu, 29 Aug 2024 13:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724937519;
	bh=xP7mLaBTQIVKu6v+SpT/VXgaUAjecAaatqPfgxOuI10=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sXgZs3d6HEWjtAs4U8B12CpfK6y6PU7NXOKhF/UVf53SHaFyY2Eoybe0Uj9xb6yIr
	 MVWos8+uOCp3/J92qoAPIEnflTIbFP3R3Ttz6Xwdz92nVd4BopM561bzNqS4Og2Ksv
	 EiE4W9YK0mq2d87TFafu16WJQ5bqWZJ5VVS5EwOHuMazCcTuKtHGbdby5YyVjwROjI
	 4GGKuU1+BPxn9G37nByaENJH2GLZflbM4fweU2EIG7umbQiEklGRpPiE46CQ2ilRhc
	 AYodP8Rq+Z13HlizlBf1sss2btlAyykCnALJ4zGGgqeU4w2mpMH2+pHOvapAezS5EY
	 01KF0yv3IAzyw==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5bed68129a7so908130a12.2;
        Thu, 29 Aug 2024 06:18:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUpw3xWkWk8+CNQcjw3/jPRZh81MGKjgHllBnMpEbN0GH6/dBKAbPdqp0GQNWWU3rxbkq8KckY5TLG9QUI=@vger.kernel.org, AJvYcCUrBjIA7cPiPXvp8Usy8m7tKICe8ZAhO0DjhyMcd+0DsHk4rEhKIMXPzbLxYQW9ON+8mlE3JgNIfZqEtACb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2JjaVxodGuZquLoDVAMz7G9/hsyvWnyrGb84wMg9PnS5fX5zE
	WdQADdAEwXLLXPuvd1crlt3Juz7CkrZdIxOuVbgkqSsurKVskfqYZ/G+e8j4W/xdsv30nmmzY1h
	rM0DFVYwr6RnJ3U7C37N40X9VsOA=
X-Google-Smtp-Source: AGHT+IHK656LsBHW+daI5TCjWU9J0pIHnhH9xybeCQ3hrNJk4OKwUbY+Gt8nIsaJK+igczUwFLMerGK+4yJYfym2s0U=
X-Received: by 2002:a05:6402:278c:b0:5c0:a8c0:3960 with SMTP id
 4fb4d7f45d1cf-5c21ed31e90mr2308421a12.4.1724937517348; Thu, 29 Aug 2024
 06:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829125656.19017-1-xry111@xry111.site>
In-Reply-To: <20240829125656.19017-1-xry111@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 29 Aug 2024 21:18:21 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
Message-ID: <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO implementation
To: Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>, linux-crypto@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jinyang He <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ruoyao,

On Thu, Aug 29, 2024 at 8:58=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> Hook up the generic vDSO implementation to the LoongArch vDSO data page
> by providing the required __arch_chacha20_blocks_nostack,
> __arch_get_k_vdso_rng_data, and getrandom_syscall implementations.
>
> Also enable the vDSO getrandom tests for LoongArch: create the symlink
> to the arch/loongarch/vdso directory, and correctly set the ARCH
> variable for LoongArch.
>
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>
> Cc: linux-crypto@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Cc: Jinyang He <hejinyang@loongson.cn>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>
> Passed vdso_test_getrandom and vdso_test_chacha tests.  Benchmark
> results:
>
> vdso_test_getrandom bench-single:
>
>        vdso: 25000000 times in 0.499490289 seconds
>        libc: 25000000 times in 6.963829873 seconds
>     syscall: 25000000 times in 6.983413486 seconds
>
> vdso_test_getrandom bench-multi:
>        vdso: 25000000 x 256 times in 28.703710823 seconds
>        libc: 25000000 x 256 times in 356.835801784 seconds
>        syscall: 25000000 x 256 times in 338.525837197 seconds
>
> [v4]->v5:
> - Rebase onto crng/random.git:
>   - Remove two selftest patches.
>   - Remove __arch_chacha20_blocks_nostack forward declaration.
> - Squash the remaining selftest patch into the vDSO getrandom
>   implementation patch.
> - Remove ifdef CONFIG_VDSO_GETRANDOM and $(CONFIG_VDSO_GETRANDOM) as
>   they are always true in arch/loongarch.
> - Remove asm-offsets.c change which has been already unneeded in v4.
> - Add comment about rematerializing the constant in the assembly code.
> - Add prototype for __vdso_getrandom to silence a -Wmissing-prototype
>   warning.
>
> [v3]->v4:
> - Remove LSX implementation, which isn't much faster than the generic
>   implementaion.
> - Rebase onto crng/random.git:
>   - Define __arch_get_k_vdso_rng_data instead of using inline asm to
>     provide the _vdso_rng_data symbol in a magic way.
>   - Remove memset.S.
>   - Use c-getrandom-y to easily include the generic C code.
>   - The benchmark results seem better than v3, maybe related to the TLS
>     refactoring in random.git.
> - Add patches for selftests.
>
> [v2]->v3:
> - Add a generic LoongArch implementation for which LSX isn't needed.
>
> v1->v2:
> - Properly send the series to the list.
>
> [v4]:https://lore.kernel.org/all/20240827132018.88854-1-xry111@xry111.sit=
e/
> [v3]:https://lore.kernel.org/all/20240816110717.10249-1-xry111@xry111.sit=
e/
> [v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.sit=
e/
>
>  arch/loongarch/Kconfig                      |   1 +
>  arch/loongarch/include/asm/vdso/getrandom.h |  44 ++++
>  arch/loongarch/include/asm/vdso/vdso.h      |   6 +
>  arch/loongarch/include/asm/vdso/vsyscall.h  |   8 +
>  arch/loongarch/kernel/asm-offsets.c         |   1 +
>  arch/loongarch/kernel/vdso.c                |   2 +
>  arch/loongarch/vdso/Makefile                |   7 +-
>  arch/loongarch/vdso/vdso.lds.S              |   1 +
>  arch/loongarch/vdso/vgetrandom-chacha.S     | 242 ++++++++++++++++++++
>  arch/loongarch/vdso/vgetrandom.c            |  15 ++
>  tools/arch/loongarch/vdso                   |   1 +
>  tools/testing/selftests/vDSO/Makefile       |   4 +-
>  12 files changed, 329 insertions(+), 3 deletions(-)
>  create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
>  create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
>  create mode 100644 arch/loongarch/vdso/vgetrandom.c
>  create mode 120000 tools/arch/loongarch/vdso
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 70f169210b52..14821c2aba5b 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -190,6 +190,7 @@ config LOONGARCH
>         select TRACE_IRQFLAGS_SUPPORT
>         select USE_PERCPU_NUMA_NODE_ID
>         select USER_STACKTRACE_SUPPORT
> +       select VDSO_GETRANDOM
>         select ZONE_DMA32
>
>  config 32BIT
> diff --git a/arch/loongarch/include/asm/vdso/getrandom.h b/arch/loongarch=
/include/asm/vdso/getrandom.h
> new file mode 100644
> index 000000000000..04c991f6921d
> --- /dev/null
> +++ b/arch/loongarch/include/asm/vdso/getrandom.h
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserve=
d.
> + */
> +#ifndef __ASM_VDSO_GETRANDOM_H
> +#define __ASM_VDSO_GETRANDOM_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <asm/unistd.h>
> +#include <asm/vdso/vdso.h>
> +
> +static __always_inline ssize_t getrandom_syscall(void *_buffer,
> +                                                size_t _len,
> +                                                unsigned int _flags)
> +{
> +       register long ret asm("a0");
> +       register long nr asm("a7") =3D __NR_getrandom;
> +       register void *buffer asm("a0") =3D _buffer;
> +       register size_t len asm("a1") =3D _len;
> +       register unsigned int flags asm("a2") =3D _flags;
> +
> +       asm volatile(
> +       "      syscall 0\n"
> +       : "+r" (ret)
> +       : "r" (nr), "r" (buffer), "r" (len), "r" (flags)
> +       : "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8",
> +         "memory");
> +
> +       return ret;
> +}
> +
> +static __always_inline const struct vdso_rng_data *__arch_get_vdso_rng_d=
ata(
> +       void)
As I said before, no line break needed, because there is no 80
characters limit now.

> +{
> +       return (const struct vdso_rng_data *)(
> +               get_vdso_data() +
> +               VVAR_LOONGARCH_PAGES_START * PAGE_SIZE +
> +               offsetof(struct loongarch_vdso_data, rng_data));
> +}
The same, we don't need so many lines.

> +
> +#endif /* !__ASSEMBLY__ */
> +
> +#endif /* __ASM_VDSO_GETRANDOM_H */
> diff --git a/arch/loongarch/include/asm/vdso/vdso.h b/arch/loongarch/incl=
ude/asm/vdso/vdso.h
> index 5a12309d9fb5..e31ac7474513 100644
> --- a/arch/loongarch/include/asm/vdso/vdso.h
> +++ b/arch/loongarch/include/asm/vdso/vdso.h
> @@ -4,6 +4,9 @@
>   * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
>   */
>
> +#ifndef _ASM_VDSO_VDSO_H
> +#define _ASM_VDSO_VDSO_H
> +
>  #ifndef __ASSEMBLY__
>
>  #include <asm/asm.h>
> @@ -16,6 +19,7 @@ struct vdso_pcpu_data {
>
>  struct loongarch_vdso_data {
>         struct vdso_pcpu_data pdata[NR_CPUS];
> +       struct vdso_rng_data rng_data;
>  };
>
>  /*
> @@ -63,3 +67,5 @@ static inline unsigned long get_vdso_data(void)
>  }
>
>  #endif /* __ASSEMBLY__ */
> +
> +#endif
> diff --git a/arch/loongarch/include/asm/vdso/vsyscall.h b/arch/loongarch/=
include/asm/vdso/vsyscall.h
> index 5de615383a22..b1273ce6f140 100644
> --- a/arch/loongarch/include/asm/vdso/vsyscall.h
> +++ b/arch/loongarch/include/asm/vdso/vsyscall.h
> @@ -8,6 +8,7 @@
>  #include <vdso/datapage.h>
>
>  extern struct vdso_data *vdso_data;
> +extern struct vdso_rng_data *vdso_rng_data;
>
>  /*
>   * Update the vDSO data page to keep in sync with kernel timekeeping.
> @@ -19,6 +20,13 @@ struct vdso_data *__loongarch_get_k_vdso_data(void)
>  }
>  #define __arch_get_k_vdso_data __loongarch_get_k_vdso_data
>
> +static __always_inline
> +struct vdso_rng_data *__loongarch_get_k_vdso_rng_data(void)
> +{
> +       return vdso_rng_data;
> +}
> +#define __arch_get_k_vdso_rng_data __loongarch_get_k_vdso_rng_data
> +
>  /* The asm-generic header needs to be included after the definitions abo=
ve */
>  #include <asm-generic/vdso/vsyscall.h>
>
> diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/=
asm-offsets.c
> index bee9f7a3108f..ab258878d551 100644
> --- a/arch/loongarch/kernel/asm-offsets.c
> +++ b/arch/loongarch/kernel/asm-offsets.c
> @@ -14,6 +14,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/processor.h>
>  #include <asm/ftrace.h>
> +#include <asm/vdso/vdso.h>
>
>  static void __used output_ptreg_defines(void)
>  {
> diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
> index 90dfccb41c14..2af05ba5f121 100644
> --- a/arch/loongarch/kernel/vdso.c
> +++ b/arch/loongarch/kernel/vdso.c
> @@ -22,6 +22,7 @@
>  #include <vdso/helpers.h>
>  #include <vdso/vsyscall.h>
>  #include <vdso/datapage.h>
> +#include <generated/asm-offsets.h>
>  #include <generated/vdso-offsets.h>
>
>  extern char vdso_start[], vdso_end[];
> @@ -37,6 +38,7 @@ static union {
>  static struct page *vdso_pages[] =3D { NULL };
>  struct vdso_data *vdso_data =3D generic_vdso_data.data;
>  struct vdso_pcpu_data *vdso_pdata =3D loongarch_vdso_data.vdata.pdata;
> +struct vdso_rng_data *vdso_rng_data =3D &loongarch_vdso_data.vdata.rng_d=
ata;
>
>  static int vdso_mremap(const struct vm_special_mapping *sm, struct vm_ar=
ea_struct *new_vma)
>  {
> diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
> index d724d46b07c8..19249d4b3542 100644
> --- a/arch/loongarch/vdso/Makefile
> +++ b/arch/loongarch/vdso/Makefile
> @@ -4,7 +4,8 @@
>  # Include the generic Makefile to check the built vdso.
>  include $(srctree)/lib/vdso/Makefile
>
> -obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o
> +obj-vdso-y :=3D elf.o vgetcpu.o vgettimeofday.o sigreturn.o vgetrandom.o=
 \
> +              vgetrandom-chacha.o
>
>  # Common compiler flags between ABIs.
>  ccflags-vdso :=3D \
> @@ -29,6 +30,10 @@ ifneq ($(c-gettimeofday-y),)
>    CFLAGS_vgettimeofday.o +=3D -include $(c-gettimeofday-y)
>  endif
>
> +ifneq ($(c-getrandom-y),)
> +  CFLAGS_vgetrandom.o +=3D -include $(c-getrandom-y)
> +endif
> +
>  # VDSO linker flags.
>  ldflags-y :=3D -Bsymbolic --no-undefined -soname=3Dlinux-vdso.so.1 \
>         $(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared \
> diff --git a/arch/loongarch/vdso/vdso.lds.S b/arch/loongarch/vdso/vdso.ld=
s.S
> index 56ad855896de..2c965a597d9e 100644
> --- a/arch/loongarch/vdso/vdso.lds.S
> +++ b/arch/loongarch/vdso/vdso.lds.S
> @@ -63,6 +63,7 @@ VERSION
>                 __vdso_clock_gettime;
>                 __vdso_gettimeofday;
>                 __vdso_rt_sigreturn;
> +               __vdso_getrandom;
I also said before that keep  __vdso_rt_sigreturn be the last one.

>         local: *;
>         };
>  }
> diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vds=
o/vgetrandom-chacha.S
> new file mode 100644
> index 000000000000..7e86a50f6e85
> --- /dev/null
> +++ b/arch/loongarch/vdso/vgetrandom-chacha.S
> @@ -0,0 +1,242 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserve=
d.
> + */
> +
> +#include <asm/asm.h>
> +#include <asm/regdef.h>
> +#include <linux/linkage.h>
> +
> +.text
> +
> +/* Salsa20 quarter-round */
> +.macro QR      a b c d
> +       add.w           \a, \a, \b
> +       xor             \d, \d, \a
> +       rotri.w         \d, \d, 16
> +
> +       add.w           \c, \c, \d
> +       xor             \b, \b, \c
> +       rotri.w         \b, \b, 20
> +
> +       add.w           \a, \a, \b
> +       xor             \d, \d, \a
> +       rotri.w         \d, \d, 24
> +
> +       add.w           \c, \c, \d
> +       xor             \b, \b, \c
> +       rotri.w         \b, \b, 25
> +.endm
> +
> +/*
> + * Very basic LoongArch implementation of ChaCha20. Produces a given pos=
itive
> + * number of blocks of output with a nonce of 0, taking an input key and
> + * 8-byte counter. Importantly does not spill to the stack. Its argument=
s
> + * are:
> + *
> + *     a0: output bytes
> + *     a1: 32-byte key input
> + *     a2: 8-byte counter input/output
> + *     a3: number of 64-byte blocks to write to output
> + */
> +SYM_FUNC_START(__arch_chacha20_blocks_nostack)
> +
> +/* We don't need a frame pointer */
> +#define s9             fp
> +
> +#define output         a0
> +#define key            a1
> +#define counter                a2
> +#define nblocks                a3
> +#define i              a4
> +#define state0         s0
> +#define state1         s1
> +#define state2         s2
> +#define state3         s3
> +#define state4         s4
> +#define state5         s5
> +#define state6         s6
> +#define state7         s7
> +#define state8         s8
> +#define state9         s9
> +#define state10                a5
> +#define state11                a6
> +#define state12                a7
> +#define state13                t0
> +#define state14                t1
> +#define state15                t2
> +#define cnt_lo         t3
> +#define cnt_hi         t4
> +#define copy0          t5
> +#define copy1          t6
> +#define copy2          t7
> +
> +/* Reuse i as copy3 */
> +#define copy3          i
> +
> +       /*
> +        * The ABI requires s0-s9 saved, and sp aligned to 16-byte.
> +        * This does not violate the stack-less requirement: no sensitive=
 data
> +        * is spilled onto the stack.
> +        */
> +       PTR_ADDI        sp, sp, (-SZREG * 10) & STACK_ALIGN
> +       REG_S           s0, sp, 0
> +       REG_S           s1, sp, SZREG
> +       REG_S           s2, sp, SZREG * 2
> +       REG_S           s3, sp, SZREG * 3
> +       REG_S           s4, sp, SZREG * 4
> +       REG_S           s5, sp, SZREG * 5
> +       REG_S           s6, sp, SZREG * 6
> +       REG_S           s7, sp, SZREG * 7
> +       REG_S           s8, sp, SZREG * 8
> +       REG_S           s9, sp, SZREG * 9
> +
> +       li.w            copy0, 0x61707865
> +       li.w            copy1, 0x3320646e
> +       li.w            copy2, 0x79622d32
> +
> +       ld.w            cnt_lo, counter, 0
> +       ld.w            cnt_hi, counter, 4
> +
> +.Lblock:
> +       /* state[0,1,2,3] =3D "expand 32-byte k" */
> +       move            state0, copy0
> +       move            state1, copy1
> +       move            state2, copy2
> +       li.w            state3, 0x6b206574
> +
> +       /* state[4,5,..,11] =3D key */
> +       ld.w            state4, key, 0
> +       ld.w            state5, key, 4
> +       ld.w            state6, key, 8
> +       ld.w            state7, key, 12
> +       ld.w            state8, key, 16
> +       ld.w            state9, key, 20
> +       ld.w            state10, key, 24
> +       ld.w            state11, key, 28
> +
> +       /* state[12,13] =3D counter */
> +       move            state12, cnt_lo
> +       move            state13, cnt_hi
> +
> +       /* state[14,15] =3D 0 */
> +       move            state14, zero
> +       move            state15, zero
> +
> +       li.w            i, 10
> +.Lpermute:
> +       /* odd round */
> +       QR              state0, state4, state8, state12
> +       QR              state1, state5, state9, state13
> +       QR              state2, state6, state10, state14
> +       QR              state3, state7, state11, state15
> +
> +       /* even round */
> +       QR              state0, state5, state10, state15
> +       QR              state1, state6, state11, state12
> +       QR              state2, state7, state8, state13
> +       QR              state3, state4, state9, state14
> +
> +       addi.w          i, i, -1
> +       bnez            i, .Lpermute
> +
> +       /*
> +        * copy[3] =3D "expa", materialize it here because copy[3] shares=
 the
> +        * same register with i which just became dead.
> +        */
> +       li.w            copy3, 0x6b206574
> +
> +       /* output[0,1,2,3] =3D copy[0,1,2,3] + state[0,1,2,3] */
> +       add.w           state0, state0, copy0
> +       add.w           state1, state1, copy1
> +       add.w           state2, state2, copy2
> +       add.w           state3, state3, copy3
> +       st.w            state0, output, 0
> +       st.w            state1, output, 4
> +       st.w            state2, output, 8
> +       st.w            state3, output, 12
> +
> +       /* from now on state[0,1,2,3] are scratch registers  */
> +
> +       /* state[0,1,2,3] =3D lo32(key) */
> +       ld.w            state0, key, 0
> +       ld.w            state1, key, 4
> +       ld.w            state2, key, 8
> +       ld.w            state3, key, 12
> +
> +       /* output[4,5,6,7] =3D state[0,1,2,3] + state[4,5,6,7] */
> +       add.w           state4, state4, state0
> +       add.w           state5, state5, state1
> +       add.w           state6, state6, state2
> +       add.w           state7, state7, state3
> +       st.w            state4, output, 16
> +       st.w            state5, output, 20
> +       st.w            state6, output, 24
> +       st.w            state7, output, 28
> +
> +       /* state[0,1,2,3] =3D hi32(key) */
> +       ld.w            state0, key, 16
> +       ld.w            state1, key, 20
> +       ld.w            state2, key, 24
> +       ld.w            state3, key, 28
> +
> +       /* output[8,9,10,11] =3D state[0,1,2,3] + state[8,9,10,11] */
> +       add.w           state8, state8, state0
> +       add.w           state9, state9, state1
> +       add.w           state10, state10, state2
> +       add.w           state11, state11, state3
> +       st.w            state8, output, 32
> +       st.w            state9, output, 36
> +       st.w            state10, output, 40
> +       st.w            state11, output, 44
> +
> +       /* output[12,13,14,15] =3D state[12,13,14,15] + [cnt_lo, cnt_hi, =
0, 0] */
> +       add.w           state12, state12, cnt_lo
> +       add.w           state13, state13, cnt_hi
> +       st.w            state12, output, 48
> +       st.w            state13, output, 52
> +       st.w            state14, output, 56
> +       st.w            state15, output, 60
> +
> +       /* ++counter  */
> +       addi.w          cnt_lo, cnt_lo, 1
> +       sltui           state0, cnt_lo, 1
> +       add.w           cnt_hi, cnt_hi, state0
> +
> +       /* output +=3D 64 */
> +       PTR_ADDI        output, output, 64
> +       /* --nblocks */
> +       PTR_ADDI        nblocks, nblocks, -1
> +       bnez            nblocks, .Lblock
> +
> +       /* counter =3D [cnt_lo, cnt_hi] */
> +       st.w            cnt_lo, counter, 0
> +       st.w            cnt_hi, counter, 4
> +
> +       /*
> +        * Zero out the potentially sensitive regs, in case nothing uses =
these
> +        * again. As at now copy[0,1,2,3] just contains "expand 32-byte k=
" and
> +        * state[0,...,9] are s0-s9 those we'll restore in the epilogue, =
so we
> +        * only need to zero state[11,...,15].
> +        */
> +       move            state10, zero
> +       move            state11, zero
> +       move            state12, zero
> +       move            state13, zero
> +       move            state14, zero
> +       move            state15, zero
> +
> +       REG_L           s0, sp, 0
> +       REG_L           s1, sp, SZREG
> +       REG_L           s2, sp, SZREG * 2
> +       REG_L           s3, sp, SZREG * 3
> +       REG_L           s4, sp, SZREG * 4
> +       REG_L           s5, sp, SZREG * 5
> +       REG_L           s6, sp, SZREG * 6
> +       REG_L           s7, sp, SZREG * 7
> +       REG_L           s8, sp, SZREG * 8
> +       REG_L           s9, sp, SZREG * 9
> +       PTR_ADDI        sp, sp, -((-SZREG * 10) & STACK_ALIGN)
> +
> +       jr              ra
> +SYM_FUNC_END(__arch_chacha20_blocks_nostack)
> diff --git a/arch/loongarch/vdso/vgetrandom.c b/arch/loongarch/vdso/vgetr=
andom.c
> new file mode 100644
> index 000000000000..68e44b3f1d49
> --- /dev/null
> +++ b/arch/loongarch/vdso/vgetrandom.c
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024 Xi Ruoyao <xry111@xry111.site>. All Rights Reserve=
d.
> + */
> +#include <linux/types.h>
> +
> +ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags,
> +                        void *opaque_state, size_t opaque_len);
Please see commit 42874e4eb35bdfc54f8514685e50434098ba4f6, it is
better to avoid such hacks.

> +
> +ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags,
> +                        void *opaque_state, size_t opaque_len)
> +{
> +       return __cvdso_getrandom(buffer, len, flags, opaque_state,
> +                                opaque_len);
Again, no line breaks needed.


Huacai

> +}
> diff --git a/tools/arch/loongarch/vdso b/tools/arch/loongarch/vdso
> new file mode 120000
> index 000000000000..ebda43a82db7
> --- /dev/null
> +++ b/tools/arch/loongarch/vdso
> @@ -0,0 +1 @@
> +../../../arch/loongarch/vdso
> \ No newline at end of file
> diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selfte=
sts/vDSO/Makefile
> index e21e78aae24d..606ce5f5c2a4 100644
> --- a/tools/testing/selftests/vDSO/Makefile
> +++ b/tools/testing/selftests/vDSO/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  uname_M :=3D $(shell uname -m 2>/dev/null || echo not)
> -ARCH ?=3D $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
> +ARCH ?=3D $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/ =
-e /loongarch/s/[0-9]//g)
>
>  TEST_GEN_PROGS :=3D vdso_test_gettimeofday
>  TEST_GEN_PROGS +=3D vdso_test_getcpu
> @@ -10,7 +10,7 @@ ifeq ($(ARCH),$(filter $(ARCH),x86 x86_64))
>  TEST_GEN_PROGS +=3D vdso_standalone_test_x86
>  endif
>  TEST_GEN_PROGS +=3D vdso_test_correctness
> -ifeq ($(uname_M),x86_64)
> +ifeq ($(uname_M),$(filter $(uname_M),x86_64 loongarch64))
>  TEST_GEN_PROGS +=3D vdso_test_getrandom
>  TEST_GEN_PROGS +=3D vdso_test_chacha
>  endif
>
> base-commit: ec309dd126280ca4ef4087e02246a6f61f36c8d1
> --
> 2.46.0
>
