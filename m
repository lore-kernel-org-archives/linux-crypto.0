From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH] crypto: move ablk_helper out of arch/x86
Date: Mon, 16 Sep 2013 09:53:22 +0300
Message-ID: <5236AAE2.9030104@iki.fi>
References: <1379154250-14803-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-arch@vger.kernel.org, herbert@gondor.apana.org.au,
	mingo@redhat.com, arnd@arndb.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33758 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3IPGx2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Sep 2013 02:53:28 -0400
In-Reply-To: <1379154250-14803-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14.09.2013 13:24, Ard Biesheuvel wrote:
> Move the ablk_helper code out of arch/x86 so it can be reused
> by other architectures. The only x86 specific dependency is
> a call to irq_fpu_usable(), in the generic case we use
> !in_interrupt() instead.
> 
> Cc: jussi.kivilinna@iki.fi
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> 
> Any need to split this up between generic/crypto and x86?
> 
> 
>  arch/x86/crypto/Makefile                   |   1 -
>  arch/x86/crypto/ablk_helper.c              | 149 ----------------------------
>  arch/x86/crypto/aesni-intel_glue.c         |   2 +-
>  arch/x86/crypto/camellia_aesni_avx2_glue.c |   2 +-
>  arch/x86/crypto/camellia_aesni_avx_glue.c  |   2 +-
>  arch/x86/crypto/cast5_avx_glue.c           |   2 +-
>  arch/x86/crypto/cast6_avx_glue.c           |   2 +-
>  arch/x86/crypto/serpent_avx2_glue.c        |   2 +-
>  arch/x86/crypto/serpent_avx_glue.c         |   2 +-
>  arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
>  arch/x86/crypto/twofish_avx_glue.c         |   2 +-
>  arch/x86/include/asm/crypto/ablk_helper.h  |  38 ++------
>  crypto/Kconfig                             |  23 +++--
>  crypto/Makefile                            |   1 +
>  crypto/ablk_helper.c                       | 150 +++++++++++++++++++++++++++++
>  include/asm-generic/crypto/ablk_helper.h   |  13 +++
>  include/crypto/ablk_helper.h               |  31 ++++++
>  17 files changed, 224 insertions(+), 200 deletions(-)
>  delete mode 100644 arch/x86/crypto/ablk_helper.c
>  create mode 100644 crypto/ablk_helper.c
>  create mode 100644 include/asm-generic/crypto/ablk_helper.h
>  create mode 100644 include/crypto/ablk_helper.h
> 
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index 7d6ba9d..18fda50 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -4,7 +4,6 @@
>  
>  avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
>  
> -obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
>  obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o

This part does not apply cleanly to cryptodev tree (git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git).

> 
[snip]
> diff --git a/include/asm-generic/crypto/ablk_helper.h b/include/asm-generic/crypto/ablk_helper.h
> new file mode 100644
> index 0000000..ede807f
> --- /dev/null
> +++ b/include/asm-generic/crypto/ablk_helper.h
> @@ -0,0 +1,13 @@
> +
> +#include <linux/hardirq.h>
> +
> +/*
> + * ablk_can_run_sync - used by crypto/ablk_helper to decide whether a request
> + * can be handled synchronously or needs to be queued up.
> + * 
> + * Choose in_interrupt() as a reasonable default
> + */

Trailing whitespace in above comment block.

ERROR: trailing whitespace
#702: FILE: include/asm-generic/crypto/ablk_helper.h:7:
+ * $

Otherwise,
Acked-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
