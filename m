From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
Date: Thu, 24 Nov 2011 10:35:29 -0800
Message-ID: <4ECE8E71.1080606@xenotime.net>
References: <4ECD527E.8000506@xenotime.net> <20111124063741.17986.23462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-next@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111124063741.17986.23462.stgit@localhost6.localdomain6>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/23/2011 10:37 PM, Jussi Kivilinna wrote:
> Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
> CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  crypto/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 16e0c13..b8d1b10 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -770,6 +770,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
>  	tristate "Serpent cipher algorithm (x86_64/SSE2)"
>  	depends on X86 && 64BIT
>  	select CRYPTO_ALGAPI
> +	select CRYPTO_CRYPTD
>  	select CRYPTO_SERPENT
>  	help
>  	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
> @@ -787,6 +788,7 @@ config CRYPTO_SERPENT_SSE2_586
>  	tristate "Serpent cipher algorithm (i586/SSE2)"
>  	depends on X86 && !64BIT
>  	select CRYPTO_ALGAPI
> +	select CRYPTO_CRYPTD
>  	select CRYPTO_SERPENT
>  	help
>  	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
