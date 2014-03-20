From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v5 1/1] crypto: SHA1 transform x86_64 AVX2
Date: Thu, 20 Mar 2014 18:57:25 +0100
Message-ID: <201403201857.25744.marex@denx.de>
References: <1395337517.2367.50.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ilya Albrekht <ilya.albrekht@intel.com>,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	Ronen Zohar <ronen.zohar@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: chandramouli narayanan <mouli@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:50621 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbaCTR5a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 13:57:30 -0400
In-Reply-To: <1395337517.2367.50.camel@pegasus.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, March 20, 2014 at 06:45:17 PM, chandramouli narayanan wrote:
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
> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> ---
>  arch/x86/crypto/Makefile               |   3 +
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S | 702
> +++++++++++++++++++++++++++++++++ arch/x86/crypto/sha1_ssse3_glue.c      |
>  50 ++-
>  crypto/Kconfig                         |   4 +-
>  4 files changed, 750 insertions(+), 9 deletions(-)
>  create mode 100644 arch/x86/crypto/sha1_avx2_x86_64_asm.S

The changelog is missing completely now ;-)
[...]

> +#include <linux/linkage.h>
> +
> +#define CTX	%rdi	/* arg1 */
> +#define BUF	%rsi	/* arg2 */
> +#define CNT	%rdx	/* arg3 */
> +
> +#define REG_A	%ecx
> +#define REG_B	%esi
> +#define REG_C	%edi
> +#define REG_D	%eax
> +#define REG_E	%edx
> +#define REG_TB  %ebx
> +#define REG_TA  %r12d
> +#define REG_RA  %rcx
> +#define REG_RB  %rsi
> +#define REG_RC  %rdi
> +#define REG_RD  %rax
> +#define REG_RE  %rdx
> +#define REG_RTA %r12
> +#define REG_RTB %rbx
> +#define REG_T1  %ebp

You're still mixing spaces and tabs here ...

[...]

> +	/* Align stack */
> +        mov     %rsp, %rbx
> +        and     $(0x1000-1), %rbx
> +        sub     $(8+32), %rbx
> +        sub     %rbx, %rsp
> +        push    %rbx
> +        sub     $RESERVE_STACK, %rsp
> +
> +        avx2_zeroupper
> +
> +	lea	K_XMM_AR(%rip), K_BASE

The indent here is really flying all around ;-)

Why don't you just check for "^ \+" and replace them with tabs ? That'd solve 
your indent problem rather quickly. Moreover, you can just use:

[TAB]<insn>[TAB]arg1, arg2...

This would solve the problem where your instruction arguments are not well 
indented.

Uh guys, Peter or Herbert, please stop me if I'm pushing too much.

[...]
