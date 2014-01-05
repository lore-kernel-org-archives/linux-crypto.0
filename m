From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Mon, 6 Jan 2014 07:29:27 +0800
Message-ID: <20140105232926.GA29518@gondor.apana.org.au>
References: <1386703583-8386-1-git-send-email-marex@denx.de>
 <20140105130529.GA26358@gondor.apana.org.au>
 <201401051633.21894.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55171 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAEXaS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Jan 2014 18:30:18 -0500
Content-Disposition: inline
In-Reply-To: <201401051633.21894.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 05, 2014 at 04:33:21PM +0100, Marek Vasut wrote:
> On Sunday, January 05, 2014 at 02:05:29 PM, Herbert Xu wrote:
> > On Tue, Dec 10, 2013 at 08:26:19PM +0100, Marek Vasut wrote:
> > > When finishing the ahash request, the ahash_op_unaligned_done() will
> > > call complete() on the request. Yet, this will not call the correct
> > > complete callback. The correct complete callback was previously stored
> > > in the requests' private data, as seen in ahash_op_unaligned(). This
> > > patch restores the correct complete callback and .data field of the
> > > request before calling complete() on it.
> > > 
> > > Signed-off-by: Marek Vasut <marex@denx.de>
> > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > Cc: David S. Miller <davem@davemloft.net>
> > > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > Cc: linux-crypto@vger.kernel.org
> > 
> > All patches applied.  Thanks!
> 
> Uh, I think this was not intended to happen! We still discuss this patch will 
> need rework, do we not?

Please send your new fixes as incremental patches on top of this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
