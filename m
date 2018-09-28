From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 01/23] asm: simd context helper API
Date: Fri, 28 Sep 2018 10:49:47 +0200
Message-ID: <CAKv+Gu9kbLPZH4W0zKAfuv-b11mcDaZ05HUauvh9gMZVGVR0AQ@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-2-Jason@zx2c4.com>
 <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(+ Joe)

On 28 September 2018 at 10:28, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 25 September 2018 at 16:56, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> Sometimes it's useful to amortize calls to XSAVE/XRSTOR and the related
>> FPU/SIMD functions over a number of calls, because FPU restoration is
>> quite expensive. This adds a simple header for carrying out this pattern:
>>
>>     simd_context_t simd_context;
>>
>>     simd_get(&simd_context);
>>     while ((item = get_item_from_queue()) != NULL) {
>>         encrypt_item(item, simd_context);
>>         simd_relax(&simd_context);
>>     }
>>     simd_put(&simd_context);
>>
>> The relaxation step ensures that we don't trample over preemption, and
>> the get/put API should be a familiar paradigm in the kernel.
>>
>> On the other end, code that actually wants to use SIMD instructions can
>> accept this as a parameter and check it via:
>>
>>    void encrypt_item(struct item *item, simd_context_t *simd_context)
>>    {
>>        if (item->len > LARGE_FOR_SIMD && simd_use(simd_context))
>>            wild_simd_code(item);
>>        else
>>            boring_scalar_code(item);
>>    }
>>
>> The actual XSAVE happens during simd_use (and only on the first time),
>> so that if the context is never actually used, no performance penalty is
>> hit.
>>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Cc: Samuel Neves <sneves@dei.uc.pt>
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Greg KH <gregkh@linuxfoundation.org>
>> Cc: linux-arch@vger.kernel.org
>> ---
>>  arch/alpha/include/asm/Kbuild      |  5 ++-
>>  arch/arc/include/asm/Kbuild        |  1 +
>>  arch/arm/include/asm/simd.h        | 63 ++++++++++++++++++++++++++++++
>>  arch/arm64/include/asm/simd.h      | 51 +++++++++++++++++++++---
>>  arch/c6x/include/asm/Kbuild        |  3 +-
>>  arch/h8300/include/asm/Kbuild      |  3 +-
>>  arch/hexagon/include/asm/Kbuild    |  1 +
>>  arch/ia64/include/asm/Kbuild       |  1 +
>>  arch/m68k/include/asm/Kbuild       |  1 +
>>  arch/microblaze/include/asm/Kbuild |  1 +
>>  arch/mips/include/asm/Kbuild       |  1 +
>>  arch/nds32/include/asm/Kbuild      |  7 ++--
>>  arch/nios2/include/asm/Kbuild      |  1 +
>>  arch/openrisc/include/asm/Kbuild   |  7 ++--
>>  arch/parisc/include/asm/Kbuild     |  1 +
>>  arch/powerpc/include/asm/Kbuild    |  3 +-
>>  arch/riscv/include/asm/Kbuild      |  3 +-
>>  arch/s390/include/asm/Kbuild       |  3 +-
>>  arch/sh/include/asm/Kbuild         |  1 +
>>  arch/sparc/include/asm/Kbuild      |  1 +
>>  arch/um/include/asm/Kbuild         |  3 +-
>>  arch/unicore32/include/asm/Kbuild  |  1 +
>>  arch/x86/include/asm/simd.h        | 44 ++++++++++++++++++++-
>>  arch/xtensa/include/asm/Kbuild     |  1 +
>>  include/asm-generic/simd.h         | 20 ++++++++++
>>  include/linux/simd.h               | 28 +++++++++++++
>>  26 files changed, 234 insertions(+), 21 deletions(-)
>>  create mode 100644 arch/arm/include/asm/simd.h
>>  create mode 100644 include/linux/simd.h
>>
>> diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
>> index 0580cb8c84b2..07b2c1025d34 100644
>> --- a/arch/alpha/include/asm/Kbuild
>> +++ b/arch/alpha/include/asm/Kbuild
>> @@ -2,14 +2,15 @@
>>
>>
>>  generic-y += compat.h
>> +generic-y += current.h
>>  generic-y += exec.h
>>  generic-y += export.h
>>  generic-y += fb.h
>>  generic-y += irq_work.h
>> +generic-y += kprobes.h
>>  generic-y += mcs_spinlock.h
>>  generic-y += mm-arch-hooks.h
>>  generic-y += preempt.h
>>  generic-y += sections.h
>> +generic-y += simd.h
>>  generic-y += trace_clock.h
>> -generic-y += current.h
>> -generic-y += kprobes.h
>
> Given that this patch applies to all architectures at once, it is
> probably better to drop the unrelated reordering hunks to avoid
> conflicts.
>
>> diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
>> index feed50ce89fa..a7f4255f1649 100644
>> --- a/arch/arc/include/asm/Kbuild
>> +++ b/arch/arc/include/asm/Kbuild
>> @@ -22,6 +22,7 @@ generic-y += parport.h
>>  generic-y += pci.h
>>  generic-y += percpu.h
>>  generic-y += preempt.h
>> +generic-y += simd.h
>>  generic-y += topology.h
>>  generic-y += trace_clock.h
>>  generic-y += user.h
>> diff --git a/arch/arm/include/asm/simd.h b/arch/arm/include/asm/simd.h
>> new file mode 100644
>> index 000000000000..263950dd69cb
>> --- /dev/null
>> +++ b/arch/arm/include/asm/simd.h
>> @@ -0,0 +1,63 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>> + */
>> +
>> +#include <linux/simd.h>
>> +#ifndef _ASM_SIMD_H
>> +#define _ASM_SIMD_H
>> +
>> +#ifdef CONFIG_KERNEL_MODE_NEON
>> +#include <asm/neon.h>
>> +
>> +static __must_check inline bool may_use_simd(void)
>> +{
>> +       return !in_interrupt();
>> +}
>> +
>
> Remember this guy?
>
> https://marc.info/?l=linux-arch&m=149631094625176&w=2
>
> That was never merged, so let's get it right this time.
>
...
>> diff --git a/include/linux/simd.h b/include/linux/simd.h
>> new file mode 100644
>> index 000000000000..33bba21012ff
>> --- /dev/null
>> +++ b/include/linux/simd.h
>> @@ -0,0 +1,28 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>> + */
>> +
>> +#ifndef _SIMD_H
>> +#define _SIMD_H
>> +
>> +typedef enum {
>> +       HAVE_NO_SIMD = 1 << 0,
>> +       HAVE_FULL_SIMD = 1 << 1,
>> +       HAVE_SIMD_IN_USE = 1 << 31
>> +} simd_context_t;
>> +

Oh, and another thing (and I'm surprised checkpatch.pl didn't complain
about it): the use of typedef in new code is strongly discouraged.
This policy predates my involvement, so perhaps Joe can elaborate on
the rationale?


>> +#include <linux/sched.h>
>> +#include <asm/simd.h>
>> +
>> +static inline void simd_relax(simd_context_t *ctx)
>> +{
>> +#ifdef CONFIG_PREEMPT
>> +       if ((*ctx & HAVE_SIMD_IN_USE) && need_resched()) {
>> +               simd_put(ctx);
>> +               simd_get(ctx);
>> +       }
>> +#endif
>
> Could we return a bool here indicating whether we rescheduled or not?
> In some cases, we could pass that into the asm code as a 'reload'
> param, allowing repeated loads of key schedules, round constant tables
> or S-boxes to be elided.
>
>> +}
>> +
>> +#endif /* _SIMD_H */
>> --
>> 2.19.0
>>
