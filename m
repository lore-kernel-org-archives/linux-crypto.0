From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v4 1/1] crypto: SHA1 transform x86_64 AVX2
Date: Thu, 20 Mar 2014 01:16:41 +0100
Message-ID: <201403200116.42104.marex@denx.de>
References: <1395264105.2367.42.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, hpa@zytor.com,
	ilya.albrekht@intel.com, maxim.locktyukhin@intel.com,
	ronen.zohar@intel.com, wajdi.k.feghali@intel.com,
	tim.c.chen@linux.intel.com,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34464 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaCTAQv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 20:16:51 -0400
In-Reply-To: <1395264105.2367.42.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, March 19, 2014 at 10:21:45 PM, chandramouli narayanan wrote:
> From 8948c828aa929a3e2531ca88e3f05fbeb1ff53db Mon Sep 17 00:00:00 2001
> From: Chandramouli Narayanan <mouli@linux.intel.com>
> Date: Wed, 19 Mar 2014 09:30:12 -0700
> Subject: [PATCH v4 1/1] crypto: SHA1 transform x86_64 AVX2

I guess this header was somehow duplicated. But yep, this patch is much nicer :)

> This git patch adds x86_64 AVX2 optimization of SHA1
> transform to crypto support. The patch has been tested with 3.14.0-rc1
> kernel.
> 
> On a Haswell desktop, with turbo disabled and all cpus running
> at maximum frequency, tcrypt shows AVX2 performance improvement
> from 3% for 256 bytes update to 16% for 1024 bytes update over
> AVX implementation.
> 
> This patch adds sha1_avx2_transform(), the glue, build and
> configuration changes needed for AVX2 optimization of
> SHA1 transform to crypto support.
> 
> sha1-ssse3 is one module which adds the necessary optimization
> support (SSSE3/AVX/AVX2) for the low-level SHA1 transform function. With
> better optimization support, transform function is overridden as the case
> may be. In the case of AVX2, due to performance reasons across datablock
> sizes, the AVX or AVX2 transform function is used at run-time as it suits
> best. The Makefile change therefore appends the necessary objects to the
> linkage. Due to this, the patch merely appends AVX2 transform to the
> existing build mix and Kconfig support and leaves the configuration build
> support as is.
> 
> Changes noted from the initial version of this patch are based on the
> feedback from the community:
> a) check for BMI2 in addition to AVX2 support since
> __sha1_transform_avx2() uses rorx
> b) Since the module build has dependency on 64bit, it is
> redundant to check it in the code here.
> c) coding style cleanup
> d) simplification of the assembly code where macros are repetitively used.

This goes ...

> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> ---
>  arch/x86/crypto/Makefile               |   3 +
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S | 706
> +++++++++++++++++++++++++++++++++ arch/x86/crypto/sha1_ssse3_glue.c      |
>  50 ++-
>  crypto/Kconfig                         |   4 +-
>  4 files changed, 754 insertions(+), 9 deletions(-)
>  create mode 100644 arch/x86/crypto/sha1_avx2_x86_64_asm.S

... here. You don't want the changelog to be part of the patch.

> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index 6ba54d6..61d6e28 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -79,6 +79,9 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
> fpu.o aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o
>  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o
> ghash-clmulni-intel_glue.o sha1-ssse3-y := sha1_ssse3_asm.o
> sha1_ssse3_glue.o
> +ifeq ($(avx2_supported),yes)
> +sha1-ssse3-y += sha1_avx2_x86_64_asm.o
> +endif
>  crc32c-intel-y := crc32c-intel_glue.o
>  crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
>  crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
> diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
> b/arch/x86/crypto/sha1_avx2_x86_64_asm.S new file mode 100644
> index 0000000..559eb6c
> --- /dev/null
> +++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S

[...]

> +.align 128
> +K_XMM_AR:
> +    .long K1, K1, K1, K1
> +    .long K1, K1, K1, K1
> +    .long K2, K2, K2, K2
> +    .long K2, K2, K2, K2
> +    .long K3, K3, K3, K3
> +    .long K3, K3, K3, K3
> +    .long K4, K4, K4, K4
> +    .long K4, K4, K4, K4

This (and a couple of other parts) are indented with spaces, yet, another 
portions of this file are indented with tabs. Can you make this consistent 
please ?

> +BSWAP_SHUFB_CTL:
> +    .long 0x00010203
> +    .long 0x04050607
> +    .long 0x08090a0b
> +    .long 0x0c0d0e0f
> +    .long 0x00010203
> +    .long 0x04050607
> +    .long 0x08090a0b
> +    .long 0x0c0d0e0f
> +
> +/*
> + */
> +.text

This comment looks like some unwanted remnant.

> +SHA1_VECTOR_ASM     sha1_transform_avx2
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c
> b/arch/x86/crypto/sha1_ssse3_glue.c index 4a11a9d..bdd6295 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c

[...]

>  #ifdef CONFIG_AS_AVX
>  	/* allow AVX to override SSSE3, it's a little faster */
> -	if (avx_usable())
> -		sha1_transform_asm = sha1_transform_avx;
> +	if (avx_usable()) {
> +		if (cpu_has_avx) {
> +			sha1_transform_asm = sha1_transform_avx;
> +			algo_name = "AVX";
> +		}
> +#ifdef CONFIG_AS_AVX2
> +		if (cpu_has_avx2 && boot_cpu_has(X86_FEATURE_BMI2)) {
> +			/* allow AVX2 to override AVX, it's a little faster */
> +			sha1_transform_asm = __sha1_transform_avx2;

I find this __sha1_transform_avx2() name a bit unhappy. Can you not name the 
function without those two leading underscores ? If I'm not mistaken, two 
leading underscores are special functions (and stuff reserved for compiler), 
which this one isn't .
[...]
