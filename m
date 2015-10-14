From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Wed, 14 Oct 2015 22:28:22 +0800
Message-ID: <20151014142822.GF17455@gondor.apana.org.au>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@linaro.org,
	linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32977 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbJNO2g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:28:36 -0400
Content-Disposition: inline
In-Reply-To: <1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2015 at 09:21:27AM +0100, Daniel Thompson wrote:
> This patchset introduces a driver for the STM32 hardware random number
> generator.
> 
> v2:
> 
>  * Moved binding docs from .../hwrng/ to .../rng/ and renamed to match
>    convention in new directory (Rob Herring).
>  * Adopted runtime PM and auto-suspend instead of managing the clocks
>    from the read function (Linus Walleij). Increased bandwidth by ~30%.
>  * Simplified error detection in main read loop (Linus Walleij, Maxime
>    Coquelin).
>  * Only WARN_ONCE() when hardware failure mechanisms trigger (Maxime
>    Coquelin).
>  * Simplify end of probe function after cocci warning (Fengguang Wu).
>  * Switch to devm_hwrng_register.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
