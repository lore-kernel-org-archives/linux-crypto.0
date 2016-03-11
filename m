From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 07/14] hw_random: exynos: use __maybe_unused to hide pm
 functions
Date: Fri, 11 Mar 2016 21:31:04 +0800
Message-ID: <20160311133104.GB24332@gondor.apana.org.au>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
 <1456934350-1389172-8-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456934350-1389172-8-git-send-email-arnd@arndb.de>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 02, 2016 at 04:58:59PM +0100, Arnd Bergmann wrote:
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

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
