From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 15/39] crypto: ux500/cryp - Prepare clock before
 enabling it
Date: Thu, 16 May 2013 15:01:44 +0800
Message-ID: <20130516070144.GB6721@gondor.apana.org.au>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-16-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	vinod.koul@intel.com, arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com,
	Andreas Westin <andreas.westin@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58606 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754957Ab3EPHBu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 03:01:50 -0400
Content-Disposition: inline
In-Reply-To: <1368611522-9984-16-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 10:51:38AM +0100, Lee Jones wrote:
> If we fail to prepare the ux500-cryp clock before enabling it the
> platform will fail to boot. Here we insure this happens.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
