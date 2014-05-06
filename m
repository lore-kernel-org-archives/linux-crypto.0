From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH resend 01/15] asm-generic: allow generic unaligned access
 if the arch supports it
Date: Tue, 6 May 2014 15:31:20 +0100
Message-ID: <20140506143120.GD23957@arm.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25636 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754661AbaEFOb6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2014 10:31:58 -0400
Content-Disposition: inline
In-Reply-To: <1398959381-8126-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 01, 2014 at 04:49:33PM +0100, Ard Biesheuvel wrote:
> Switch the default unaligned access method to 'hardware implemented'
> if HAVE_EFFICIENT_UNALIGNED_ACCESS is set.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/unaligned.h | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

I'm happy to take this patch via the arm64 tree. But arm is affected as
well, so it would be good to know if Russell has any objections (cc'ed).

Patch below for reference. Thanks.

Catalin

> diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
> index 03cf5936bad6..1ac097279db1 100644
> --- a/include/asm-generic/unaligned.h
> +++ b/include/asm-generic/unaligned.h
> @@ -4,22 +4,27 @@
>  /*
>   * This is the most generic implementation of unaligned accesses
>   * and should work almost anywhere.
> - *
> - * If an architecture can handle unaligned accesses in hardware,
> - * it may want to use the linux/unaligned/access_ok.h implementation
> - * instead.
>   */
>  #include <asm/byteorder.h>
>  
> +/* Set by the arch if it can handle unaligned accesses in hardware. */
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +# include <linux/unaligned/access_ok.h>
> +#endif
> +
>  #if defined(__LITTLE_ENDIAN)
> -# include <linux/unaligned/le_struct.h>
> -# include <linux/unaligned/be_byteshift.h>
> +# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +#  include <linux/unaligned/le_struct.h>
> +#  include <linux/unaligned/be_byteshift.h>
> +# endif
>  # include <linux/unaligned/generic.h>
>  # define get_unaligned	__get_unaligned_le
>  # define put_unaligned	__put_unaligned_le
>  #elif defined(__BIG_ENDIAN)
> -# include <linux/unaligned/be_struct.h>
> -# include <linux/unaligned/le_byteshift.h>
> +# ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +#  include <linux/unaligned/be_struct.h>
> +#  include <linux/unaligned/le_byteshift.h>
> +# endif
>  # include <linux/unaligned/generic.h>
>  # define get_unaligned	__get_unaligned_be
>  # define put_unaligned	__put_unaligned_be
> -- 
> 1.8.3.2
