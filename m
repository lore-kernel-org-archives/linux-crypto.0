From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: omap3-rom-rng: convert timer to delayed work
Date: Tue, 17 Nov 2015 21:36:33 +0800
Message-ID: <20151117133633.GC8032@gondor.apana.org.au>
References: <1446761724-5191-1-git-send-email-aaro.koskinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	Sebastian Reichel <sre@kernel.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	linux-omap@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60895 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbKQNgn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 08:36:43 -0500
Content-Disposition: inline
In-Reply-To: <1446761724-5191-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 06, 2015 at 12:15:24AM +0200, Aaro Koskinen wrote:
> We cannot put the HW RNG to idle using a timer because we cannot disable
> clocks from atomic context. Use a delayed work instead.
> 
> Fixes a warning with CONFIG_DEBUG_MUTEXES on Nokia N900 during boot.
> 
> Reported-by: Sebastian Reichel <sre@kernel.org>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks for the patch.  Can you please remove timer.h and include
workqueue.h instead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
