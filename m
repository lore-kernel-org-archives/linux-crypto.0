From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: stm32: fix maybe uninitialized variable warning
Date: Tue, 31 May 2016 18:18:00 +0800
Message-ID: <20160531101800.GI15376@gondor.apana.org.au>
References: <1464255297-21090-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51197 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcEaKSO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:18:14 -0400
Content-Disposition: inline
In-Reply-To: <1464255297-21090-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 26, 2016 at 11:34:57AM +0200, Maxime Coquelin wrote:
> This patch fixes the following warning:
> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
>                                         uninitialized in this function
> 
> Reported-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
