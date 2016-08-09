From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/11] Further iMX CAAM updates
Date: Tue, 9 Aug 2016 19:02:41 +0800
Message-ID: <20160809110241.GF7099@gondor.apana.org.au>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47855 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcHILDB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 07:03:01 -0400
Content-Disposition: inline
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 08, 2016 at 06:04:01PM +0100, Russell King - ARM Linux wrote:
> This is a re-post (with hopefully bugs fixed from December's review).
> Untested, because AF_ALG appears to be broken in 4.8-rc1.  Maybe
> someone can provide some hints how to test using tcrypt please?
> 
> Here are further imx-caam updates that I've had since before the
> previous merge window.  Please review and (I guess) if Freescale
> folk can provide acks etc that would be nice.  Thanks.
> 
>  drivers/crypto/caam/caamhash.c | 540 ++++++++++++++++++++++-------------------
>  drivers/crypto/caam/intern.h   |   1 -
>  drivers/crypto/caam/jr.c       |  25 +-
>  3 files changed, 305 insertions(+), 261 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
