Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A2E1DD55F;
	Thu, 17 Oct 2024 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170693; cv=none; b=GohLIrM9eRFHs8LhZD8uh0pY2ggn5D/1h/5aOMA9F/btSA18wCPazpdcdTm+L03ZPcOldSsE6gAcMQPCrYrfn/NhgV5C/aE5zGTyiujF/w1f9SZFfDOxpsLl4sC6/5qgk6Bh7nyDYNee7ZDmSQ1sFAsILorCnJTrFwd6EsbiNEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170693; c=relaxed/simple;
	bh=+wZxc5RHbItq3Om/97Yf/bxIJpCua9j0x2F4k1spuoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWsNJHSqG4GA1UBUX2FxqgPw9g8mUop6X2p/u+sC3RdwmY5Di3Cm5IRLn0puZsXINCI6Nca9Ipgk2YCdb9EfbizlfIzQENDr+ZD5qZ+/dxhQXXOj69larArzziy9axzDReoi/Fs2QkW72hm5z4GTHvq2+KeibPjas5FBR30u6bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=LMgYX+On; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="LMgYX+On"
Received: from francesco-nb (31-10-206-125.static.upc.ch [31.10.206.125])
	by mail11.truemail.it (Postfix) with ESMTPA id 0AFA41FC42;
	Thu, 17 Oct 2024 15:11:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1729170677;
	bh=zUQMYtIBgZDMICEqQVq0exrUsPCv8RdUk/uxkBPVgi0=; h=From:To:Subject;
	b=LMgYX+OnGnrp5oHDXiHbgph/QCRhrm+oAR97nLOS+MSWkkoCYFHCeOPlotH7t6XL6
	 Au7MKhYaNYccRCwFIsX8CRmsRNDe7YqRPtPFtpTGhWJ1YtO72MNt2cLOV09wfm8mcu
	 XGZvKeaVyHKQ6YmtyrnujJ790N/UP66UsgCvJhN4atibydcXy9YB07LEPArAH5m03U
	 jSM8nuSo2mtSsIffdINea/MAPVlh7EfMJvSSJO2acN44oqz/mTjvuXyeRfOyYdjc8o
	 GCytORySQl6IvTHWINGidv7EoBEgo5MrwwC97uYvTgjmFuBIbeK5LoZruoTpmzWQm1
	 JYD3/YbhpIzYA==
Date: Thu, 17 Oct 2024 15:11:12 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: Re: [PATCH 2/2] hwrng: add support for Airoha EN7581 TRNG
Message-ID: <20241017131112.GA28955@francesco-nb>
References: <20241016151845.23712-1-ansuelsmth@gmail.com>
 <20241016151845.23712-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016151845.23712-2-ansuelsmth@gmail.com>

On Wed, Oct 16, 2024 at 05:18:42PM +0200, Christian Marangi wrote:
> Add support for Airoha TRNG. The Airoha SoC provide a True RNG module
> that can output 4 bytes of raw data at times.
> 
> The module makes use of various noise source to provide True Random
> Number Generation.
> 
> On probe the module is reset to operate Health Test and verify correct
> execution of it.
> 
> The module can also provide DRBG function but the execution mode is
> mutually exclusive, running as TRNG doesn't permit to also run it as
> DRBG.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/char/hw_random/Kconfig       |  13 ++
>  drivers/char/hw_random/Makefile      |   1 +
>  drivers/char/hw_random/airoha-trng.c | 243 +++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+)
>  create mode 100644 drivers/char/hw_random/airoha-trng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 5912c2dd6398..bda283f290bc 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -62,6 +62,19 @@ config HW_RANDOM_AMD
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_AIROHA
> +	tristate "Airoha True HW Random Number Generator support"
> +	depends on ARCH_AIROHA || COMPILE_TEST

> +	default HW_RANDOM
This should not be always enabled when HW_RANDOM is enabled. Enabling
driver should be a opt-in.

Francesco


