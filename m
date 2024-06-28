Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85F317999;
	Fri, 28 Jun 2024 01:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539577; cv=none; b=lg8fYis7mprRQ7g3CvJob9OFiLExr9Jw0AuaDRAQd5niOealHvupqwLDMqnd9aXjNpKSjUjfyXtrB32Wuxm9JtlL0M5CoeTRgQmEdAGSAQ3D3pA+J41DXA7JRtfjiU49rvHTMR8PNyw9zHqboRTcWgJVfVZH30ANKPPBjmPQvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539577; c=relaxed/simple;
	bh=5twr3EC9mAFVmaahUeAwYJleDq6wd1YX3NVu2AphDw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpduH8YhsaNRHF60arOKh5reJWi/MXtDdy2QuNxW+0Zr86fJeLw8UYop1MDwItxa9I8E1q7RIeThXbdAsfGM7m7O5LQS3d0RcwAuK37ZkvAEvndNE35uLLYD9NOcDT3YXqp8KUDF9oaUw080dI3ccVRq2LVzaygOm8SwNI3hgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN0mi-004GFr-1k;
	Fri, 28 Jun 2024 11:52:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:52:21 +1000
Date: Fri, 28 Jun 2024 11:52:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	Anand Moon <linux.amoon@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] hwrng: exynos: Add support for Exynos850
Message-ID: <Zn4XVQRm5mt8+ynw@gondor.apana.org.au>
References: <20240620231339.1574-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620231339.1574-1-semen.protsenko@linaro.org>

On Thu, Jun 20, 2024 at 06:13:33PM -0500, Sam Protsenko wrote:
> Exynos850 has True Random Number Generator (TRNG) block which is very
> similar to Exynos5250 for which the driver already exists
> (exynos-trng.c). There are two differences though:
>   1. Additional SSS PCLK clock has to be enabled to make TRNG registers
>      accessible.
>   2. All SSS registers (including TRNG area) are protected with
>      TrustZone and can only be accessed from EL3 monitor. So the
>      corresponding SMC calls have to be used instead to interact with
>      TRNG block.
> 
> This patch series enables TRNG support on Exynos850 SoC. It was tested
> on the E850-96 board running Debian rootfs like this:
> 
>     8<-------------------------------------------------------------->8
>     # cat /sys/devices/virtual/misc/hw_random/rng_current
>     12081400.rng
> 
>     # dd if=/dev/hwrng bs=100000 count=1 > /dev/null
>     ...
>     122KB/s
> 
>     # apt install rng-tools5
>     # rngtest -c 1000 < /dev/hwrng
>     ...
>     rngtest: starting FIPS tests...
>     rngtest: bits received from input: 20000032
>     rngtest: FIPS 140-2 successes: 1000
>     rngtest: FIPS 140-2 failures: 0
>     rngtest: FIPS 140-2(2001-10-10) Monobit: 0
>     rngtest: FIPS 140-2(2001-10-10) Poker: 0
>     rngtest: FIPS 140-2(2001-10-10) Runs: 0
>     rngtest: FIPS 140-2(2001-10-10) Long run: 0
>     rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
>     rngtest: input channel speed: (min=941.855; avg=965.515;
>              max=968.236)Kibits/s
>     rngtest: FIPS tests speed: (min=49.542; avg=52.886;
>              max=53.577)Mibits/s
>     rngtest: Program run time: 20590194 microseconds
>     8<-------------------------------------------------------------->8
> 
> SMC commands added in this series require LDFW (Loadable Firmware) to be
> loaded by the bootloader. In case of E850-96 board, at the moment only
> the LittleKernel based bootloader [1] is able to load LDFW. It is
> expected to be added into U-Boot port soon as well. See [2] for more
> details.
> 
> [1] https://gitlab.com/Linaro/96boards/e850-96/lk
> [2] https://docs.u-boot.org/en/latest/board/samsung/e850-96.html
> 
> Changes in v3:
>   - Rebased on top of the most recent linux-next
>   - Removed dts patch (7/7) from the series, as suggested by Krzysztof
>   - Addressed all review comments for v2 series
> 
> Changes in v2:
>   - Removed the patch for renaming the dt-bindings doc file
>   - Added the patch for using devm_clk_get_enabled() to get the clock
>   - Addressed all review comments for v1 series
> 
> Sam Protsenko (6):
>   dt-bindings: rng: Add Exynos850 support to exynos-trng
>   hwrng: exynos: Improve coding style
>   hwrng: exynos: Use devm_clk_get_enabled() to get the clock
>   hwrng: exynos: Implement bus clock control
>   hwrng: exynos: Add SMC based TRNG operation
>   hwrng: exynos: Enable Exynos850 support
> 
>  .../bindings/rng/samsung,exynos5250-trng.yaml |  40 +++-
>  drivers/char/hw_random/exynos-trng.c          | 225 +++++++++++++-----
>  2 files changed, 206 insertions(+), 59 deletions(-)
> 
> -- 
> 2.39.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
