From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] crypto: s5p-sss: fix multiplatform build
Date: Mon, 12 May 2014 11:31:05 +0900
Message-ID: <000701cf6d8a$399b0990$acd11cb0$%han@samsung.com>
References: <4525493.CM3akEXMYf@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Naveen Krishna Chatradhi' <ch.naveen@samsung.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	'Vladimir Zapolskiy' <vz@mleia.com>,
	'Jingoo Han' <jg1.han@samsung.com>
To: 'Arnd Bergmann' <arnd@arndb.de>,
	'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <4525493.CM3akEXMYf@wuerfel>
Content-language: ko
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday, May 09, 2014 8:36 PM, Arnd Bergmann wrote:
> 
> As we are preparing to enable multiplatform support on EXYNOS,
> we can no longer include mach/*.h or plat/*.h headers from device
> drivers.
> 
> The s5p-sss driver was just enabled for EXYNOS when it used to
> be used only on s5pv210, and it includes two samsung platform
> specific header files for historic reasons. Fortunately, it no
> longer actually needs them, so we can remove the #includes and
> avoid the problem
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: <linux-samsung-soc@vger.kernel.org>
> Cc: Vladimir Zapolskiy <vz@mleia.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

I checked that these machine specific headers are
unnecessary. Thanks!

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> Please apply on top of the other s5p-sss patches
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 47c568e..4197ad9 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -30,9 +30,6 @@
>  #include <crypto/aes.h>
>  #include <crypto/ctr.h>
> 
> -#include <plat/cpu.h>
> -#include <mach/dma.h>
> -
>  #define _SBF(s, v)                      ((v) << (s))
>  #define _BIT(b)                         _SBF(b, 1)
> 
> 
> --
