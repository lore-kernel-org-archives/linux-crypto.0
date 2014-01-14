From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Tue, 14 Jan 2014 18:34:54 +0100
Message-ID: <201401141834.54942.marex@denx.de>
References: <1386703583-8386-1-git-send-email-marex@denx.de> <201401051633.21894.marex@denx.de> <20140105232926.GA29518@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49830 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaANRez (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 12:34:55 -0500
In-Reply-To: <20140105232926.GA29518@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, January 06, 2014 at 12:29:27 AM, Herbert Xu wrote:
> On Sun, Jan 05, 2014 at 04:33:21PM +0100, Marek Vasut wrote:
> > On Sunday, January 05, 2014 at 02:05:29 PM, Herbert Xu wrote:
> > > On Tue, Dec 10, 2013 at 08:26:19PM +0100, Marek Vasut wrote:
> > > > When finishing the ahash request, the ahash_op_unaligned_done() will
> > > > call complete() on the request. Yet, this will not call the correct
> > > > complete callback. The correct complete callback was previously
> > > > stored in the requests' private data, as seen in
> > > > ahash_op_unaligned(). This patch restores the correct complete
> > > > callback and .data field of the request before calling complete() on
> > > > it.
> > > > 
> > > > Signed-off-by: Marek Vasut <marex@denx.de>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Cc: David S. Miller <davem@davemloft.net>
> > > > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > > Cc: linux-crypto@vger.kernel.org
> > > 
> > > All patches applied.  Thanks!
> > 
> > Uh, I think this was not intended to happen! We still discuss this patch
> > will need rework, do we not?
> 
> Please send your new fixes as incremental patches on top of this.

I sent a new set of patches and added a bit of documentation too. I am still 
working on a better piece of documentation for writing crypto drivers now.

Best regards,
Marek Vasut
