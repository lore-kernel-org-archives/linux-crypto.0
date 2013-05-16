From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 18/39] crypto: ux500/[cryp|hash] - Show successful
 start-up in the bootlog
Date: Thu, 16 May 2013 15:02:17 +0800
Message-ID: <20130516070217.GD6721@gondor.apana.org.au>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-19-git-send-email-lee.jones@linaro.org>
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
Received: from ringil.hengli.com.au ([178.18.16.133]:56253 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754957Ab3EPHCZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 03:02:25 -0400
Content-Disposition: inline
In-Reply-To: <1368611522-9984-19-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 10:51:41AM +0100, Lee Jones wrote:
> The Cryp driver is currently silent and the Hash driver prints the
> name of its probe function unnecessarily. Let's just put a nice
> descriptive one-liner there instead.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
