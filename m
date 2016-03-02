From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 07/14] hw_random: exynos: use __maybe_unused to hide pm
 functions
Date: Thu, 03 Mar 2016 08:43:54 +0900
Message-ID: <56D77ABA.1040505@samsung.com>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
 <1456934350-1389172-8-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1456934350-1389172-8-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03.03.2016 00:58, Arnd Bergmann wrote:
> The exynos random driver uses #ifdef to check for CONFIG_PM, but
> then uses SIMPLE_DEV_PM_OPS, which leaves the references out when
> CONFIG_PM_SLEEP is not defined, so we get a warning with
> PM=y && PM_SLEEP=n:
> 
> drivers/char/hw_random/exynos-rng.c:166:12: error: 'exynos_rng_suspend' defined but not used [-Werror=unused-function]
> drivers/char/hw_random/exynos-rng.c:171:12: error: 'exynos_rng_resume' defined but not used [-Werror=unused-function]
> 
> This removes the incorrect #ifdef and instead uses a __maybe_unused
> annotation to let the compiler know it can silently drop
> the function definition.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/char/hw_random/exynos-rng.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
