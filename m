From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: update help description for omap-rng
Date: Wed, 15 Feb 2017 13:34:41 +0800
Message-ID: <20170215053441.GG14043@gondor.apana.org.au>
References: <E1cdFMW-0004yZ-OB@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Perier <romain.perier@free-electrons.com>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35447 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbdBOFfA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:35:00 -0500
Content-Disposition: inline
In-Reply-To: <E1cdFMW-0004yZ-OB@rmk-PC.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 13, 2017 at 12:04:08PM +0000, Russell King wrote:
> omap-rng also supports Marvell Armada 7k/8k SoCs, but no mention of this
> is made in the help text, despite the dependency being added. Explicitly
> mention these SoCs in the help description so people know that it covers
> more than just TI SoCs.
> 
> Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
