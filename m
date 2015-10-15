From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: stm32 - Fix build with CONFIG_PM
Date: Thu, 15 Oct 2015 10:00:37 +0800
Message-ID: <20151015020037.GA22342@gondor.apana.org.au>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1444838695-7182-1-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@linaro.org,
	linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55346 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbJOCAr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 22:00:47 -0400
Content-Disposition: inline
In-Reply-To: <1444838695-7182-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 05:04:55PM +0100, Daniel Thompson wrote:
> Commit c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
> was inadequately tested (actually it was tested quite hard so
> incompetent would be a better description that inadequate) and does
> not compile on platforms with CONFIG_PM set.
> 
> Fix this.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
