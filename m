From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Fri, 28 Sep 2018 17:47:33 +0200
Message-ID: <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-5-Jason@zx2c4.com>
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
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180925145622.29959-5-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25 September 2018 at 16:56, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This provides SSSE3, AVX-2, AVX-512F, and AVX-512VL implementations for
> ChaCha20. The AVX-512F implementation is disabled on Skylake, due to
> throttling, and the VL ymm implementation is used instead. These come
> from Andy Polyakov's implementation, with the following modifications
> from Samuel Neves:
>
>   - Some cosmetic changes, like renaming labels to .Lname, constants,
>     and other Linux conventions.
>
>   - CPU feature checking is done in C by the glue code, so that has been
>     removed from the assembly.
>
>   - Eliminate translating certain instructions, such as pshufb, palignr,
>     vprotd, etc, to .byte directives. This is meant for compatibility
>     with ancient toolchains, but presumably it is unnecessary here,
>     since the build system already does checks on what GNU as can
>     assemble.
>
>   - When aligning the stack, the original code was saving %rsp to %r9.
>     To keep objtool happy, we use instead the DRAP idiom to save %rsp
>     to %r10:
>
>       leaq    8(%rsp),%r10
>       ... code here ...
>       leaq    -8(%r10),%rsp
>
>   - The original code assumes the stack comes aligned to 16 bytes. This
>     is not necessarily the case, and to avoid crashes,
>     `andq $-alignment, %rsp` was added in the prolog of a few functions.
>
>   - The original hardcodes returns as .byte 0xf3,0xc3, aka "rep ret".
>     We replace this by "ret". "rep ret" was meant to help with AMD K8
>     chips, cf. http://repzret.org/p/repzret. It makes no sense to
>     continue to use this kludge for code that won't even run on ancient
>     AMD chips.
>
> While this is CRYPTOGAMS code, the originating code for this happens to
> be the same as OpenSSL's commit cded951378069a478391843f5f8653c1eb5128da
>

I'd still prefer the kernel side changes to be presented as a separate
followup patch (preferably based on the .pl but I understand that is
more difficult with x86 than with ARM code)

> Cycle counts on a Core i7 6700HQ using the AVX-2 codepath:
>
> size    old     new
> ----    ----    ----
> 0       62      52
> 16      414     376
> 32      410     400
> 48      414     422
> 64      362     356
> 80      714     666
> 96      714     700
> 112     712     718
> 128     692     646
> 144     1042    674
> 160     1042    694
> 176     1042    726
> 192     1018    650
> 208     1366    686
> 224     1366    696
> 240     1366    722
> 256     640     656
> 272     988     1246
> 288     988     1276
> 304     992     1296
> 320     972     1222
> 336     1318    1256
> 352     1318    1276
> 368     1316    1294
> 384     1294    1218
> 400     1642    1258
> 416     1642    1282
> 432     1642    1302
> 448     1628    1224
> 464     1970    1258
> 480     1970    1280
> 496     1970    1300
> 512     656     676
> 528     1010    1290
> 544     1010    1306
> 560     1010    1332
> 576     986     1254
> 592     1340    1284
> 608     1334    1310
> 624     1340    1334
> 640     1314    1254
> 656     1664    1282
> 672     1674    1306
> 688     1662    1336
> 704     1638    1250
> 720     1992    1292
> 736     1994    1308
> 752     1988    1334
> 768     1252    1254
> 784     1596    1290
> 800     1596    1314
> 816     1596    1330
> 832     1576    1256
> 848     1922    1286
> 864     1922    1314
> 880     1926    1338
> 896     1898    1258
> 912     2248    1288
> 928     2248    1320
> 944     2248    1338
> 960     2226    1268
> 976     2574    1288
> 992     2576    1312
> 1008    2574    1340
>
> Cycle counts on a Xeon Gold 5120 using the AVX-512 codepath:
>
> size    old     new
> ----    ----    ----
> 0       64      54
> 16      386     372
> 32      388     396
> 48      388     420
> 64      366     350
> 80      708     666
> 96      708     692
> 112     706     736
> 128     692     648
> 144     1036    682
> 160     1036    708
> 176     1036    730
> 192     1016    658
> 208     1360    684
> 224     1362    708
> 240     1360    732
> 256     644     500
> 272     990     526
> 288     988     556
> 304     988     576
> 320     972     500
> 336     1314    532
> 352     1316    558
> 368     1318    578
> 384     1308    506
> 400     1644    532
> 416     1644    556
> 432     1644    594
> 448     1624    508
> 464     1970    534
> 480     1970    556
> 496     1968    582
> 512     660     624
> 528     1016    682
> 544     1016    702
> 560     1018    728
> 576     998     654
> 592     1344    680
> 608     1344    708
> 624     1344    730
> 640     1326    654
> 656     1670    686
> 672     1670    708
> 688     1670    732
> 704     1652    658
> 720     1998    682
> 736     1998    710
> 752     1996    734
> 768     1256    662
> 784     1606    688
> 800     1606    714
> 816     1606    736
> 832     1584    660
> 848     1948    688
> 864     1950    714
> 880     1948    736
> 896     1912    688
> 912     2258    718
> 928     2258    744
> 944     2256    768
> 960     2238    692
> 976     2584    718
> 992     2584    744
> 1008    2584    770
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>

Please drop this SOB line: SOB is not about (co-)authorship but about
who handled the patch on its way into mainline. You are sending the
patch so your SOB should come last.

> Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
> Based-on-code-from: Andy Polyakov <appro@openssl.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: Andy Polyakov <appro@openssl.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> ---
>  lib/zinc/Makefile                        |    1 +
>  lib/zinc/chacha20/chacha20-x86_64-glue.h |  105 +
>  lib/zinc/chacha20/chacha20-x86_64.S      | 2632 ++++++++++++++++++++++
>  lib/zinc/chacha20/chacha20.c             |    4 +-
>  4 files changed, 2741 insertions(+), 1 deletion(-)
>  create mode 100644 lib/zinc/chacha20/chacha20-x86_64-glue.h
>  create mode 100644 lib/zinc/chacha20/chacha20-x86_64.S
>
> diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
> index 3d80144d55a6..223a0816c918 100644
> --- a/lib/zinc/Makefile
> +++ b/lib/zinc/Makefile
> @@ -3,4 +3,5 @@ ccflags-y += -D'pr_fmt(fmt)="zinc: " fmt'
>  ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
>
>  zinc_chacha20-y := chacha20/chacha20.o
> +zinc_chacha20-$(CONFIG_ZINC_ARCH_X86_64) += chacha20/chacha20-x86_64.o
>  obj-$(CONFIG_ZINC_CHACHA20) += zinc_chacha20.o
> diff --git a/lib/zinc/chacha20/chacha20-x86_64-glue.h b/lib/zinc/chacha20/chacha20-x86_64-glue.h
> new file mode 100644
> index 000000000000..9b47001661a6
> --- /dev/null
> +++ b/lib/zinc/chacha20/chacha20-x86_64-glue.h
> @@ -0,0 +1,105 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <asm/fpu/api.h>
> +#include <asm/cpufeature.h>
> +#include <asm/processor.h>
> +#include <asm/intel-family.h>
> +
> +#ifdef CONFIG_AS_SSSE3
> +asmlinkage void hchacha20_ssse3(u32 *derived_key, const u8 *nonce,
> +                               const u8 *key);
> +asmlinkage void chacha20_ssse3(u8 *out, const u8 *in, const size_t len,
> +                              const u32 key[8], const u32 counter[4]);
> +#endif
> +#ifdef CONFIG_AS_AVX2
> +asmlinkage void chacha20_avx2(u8 *out, const u8 *in, const size_t len,
> +                             const u32 key[8], const u32 counter[4]);
> +#endif
> +#ifdef CONFIG_AS_AVX512
> +asmlinkage void chacha20_avx512(u8 *out, const u8 *in, const size_t len,
> +                               const u32 key[8], const u32 counter[4]);
> +asmlinkage void chacha20_avx512vl(u8 *out, const u8 *in, const size_t len,
> +                                 const u32 key[8], const u32 counter[4]);
> +#endif
> +

You can drop the #ifdefs above ...

> +static bool chacha20_use_ssse3 __ro_after_init;
> +static bool chacha20_use_avx2 __ro_after_init;
> +static bool chacha20_use_avx512 __ro_after_init;
> +static bool chacha20_use_avx512vl __ro_after_init;
> +
> +static void __init chacha20_fpu_init(void)
> +{
> +       chacha20_use_ssse3 = boot_cpu_has(X86_FEATURE_SSSE3);
> +       chacha20_use_avx2 =
> +               boot_cpu_has(X86_FEATURE_AVX) &&
> +               boot_cpu_has(X86_FEATURE_AVX2) &&
> +               cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
> +       chacha20_use_avx512 =
> +               boot_cpu_has(X86_FEATURE_AVX) &&
> +               boot_cpu_has(X86_FEATURE_AVX2) &&
> +               boot_cpu_has(X86_FEATURE_AVX512F) &&
> +               cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
> +                                 XFEATURE_MASK_AVX512, NULL) &&
> +               /* Skylake downclocks unacceptably much when using zmm. */
> +               boot_cpu_data.x86_model != INTEL_FAM6_SKYLAKE_X;
> +       chacha20_use_avx512vl =
> +               boot_cpu_has(X86_FEATURE_AVX) &&
> +               boot_cpu_has(X86_FEATURE_AVX2) &&
> +               boot_cpu_has(X86_FEATURE_AVX512F) &&
> +               boot_cpu_has(X86_FEATURE_AVX512VL) &&
> +               cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
> +                                 XFEATURE_MASK_AVX512, NULL);
> +}
> +
> +static inline bool chacha20_arch(struct chacha20_ctx *state, u8 *dst,
> +                                const u8 *src, const size_t len,
> +                                simd_context_t *simd_context)
> +{
> +       if (!chacha20_use_ssse3 || len <= CHACHA20_BLOCK_SIZE ||
> +           !simd_use(simd_context))
> +               return false;
> +
> +#ifdef CONFIG_AS_AVX512

... and use IS_ENABLED(CONFIG_AS_AVX512) here inside the if().

> +       if (chacha20_use_avx512 && len >= CHACHA20_BLOCK_SIZE * 8) {
> +               chacha20_avx512(dst, src, len, state->key, state->counter);
> +               goto success;
> +       }
> +       if (chacha20_use_avx512vl && len >= CHACHA20_BLOCK_SIZE * 4) {
> +               chacha20_avx512vl(dst, src, len, state->key, state->counter);
> +               goto success;
> +       }
> +#endif
> +#ifdef CONFIG_AS_AVX2
> +       if (chacha20_use_avx2 && len >= CHACHA20_BLOCK_SIZE * 4) {
> +               chacha20_avx2(dst, src, len, state->key, state->counter);
> +               goto success;
> +       }
> +#endif
> +#ifdef CONFIG_AS_SSSE3
> +       if (chacha20_use_ssse3) {
> +               chacha20_ssse3(dst, src, len, state->key, state->counter);
> +               goto success;
> +       }
> +#endif
> +       return false;
> +success:
> +       state->counter[0] += (len + 63) / 64;
> +       return true;
> +}
> +
> +static inline bool hchacha20_arch(u32 derived_key[CHACHA20_KEY_WORDS],
> +                                 const u8 nonce[HCHACHA20_NONCE_SIZE],
> +                                 const u8 key[HCHACHA20_KEY_SIZE],
> +                                 simd_context_t *simd_context)
> +{
> +#if defined(CONFIG_AS_SSSE3)
> +       if (chacha20_use_ssse3 && simd_use(simd_context)) {
> +               hchacha20_ssse3(derived_key, nonce, key);
> +               return true;
> +       }
> +#endif
> +       return false;
> +}
...
> diff --git a/lib/zinc/chacha20/chacha20.c b/lib/zinc/chacha20/chacha20.c
> index c82d9fc71f21..4354b874a6a5 100644
> --- a/lib/zinc/chacha20/chacha20.c
> +++ b/lib/zinc/chacha20/chacha20.c
> @@ -14,7 +14,9 @@
>  #include <linux/init.h>
>  #include <crypto/algapi.h>
>
> -#ifndef HAVE_CHACHA20_ARCH_IMPLEMENTATION

As I mentioned in reply to the previous patch, please get rid of this
CPP symbol ^^^

> +#if defined(CONFIG_ZINC_ARCH_X86_64)
> +#include "chacha20-x86_64-glue.h"
> +#else
>  void __init chacha20_fpu_init(void)
>  {
>  }
> --
> 2.19.0
>
