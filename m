From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/2] omap-aes: Use pm_runtime_put instead of
 pm_runtime_put_sync in tasklet
Date: Sun, 10 Mar 2013 18:15:31 +0800
Message-ID: <20130310101530.GE10910@gondor.apana.org.au>
References: <1361894672-10431-1-git-send-email-agnel.joel@gmail.com>
 <1361894672-10431-2-git-send-email-agnel.joel@gmail.com>
 <20130226230636.GD13338@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: agnel.joel@gmail.com, linux-crypto@vger.kernel.org,
	Joel A Fernandes <joelagnel@ti.com>,
	"David S. Miller" <davem@davemloft.net>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:56617 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732Ab3CJKPj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 06:15:39 -0400
Content-Disposition: inline
In-Reply-To: <20130226230636.GD13338@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 26, 2013 at 04:06:36PM -0700, Mark A. Greer wrote:
> On Tue, Feb 26, 2013 at 10:04:32AM -0600, agnel.joel@gmail.com wrote:
> > From: Joel A Fernandes <joelagnel@ti.com>
> > 
> > After DMA is complete, the omap_aes_finish_req function is called as
> > a part of the done_task tasklet. During this its atomic and any calls
> > to pm functions should not assume they wont sleep.
> > 
> > The patch replaces a call to pm_runtime_put_sync (which can sleep) with
> > pm_runtime_put thus fixing a kernel panic observed on AM33xx SoC during
> > AES operation.
> > 
> > Tested on an AM33xx SoC device (beaglebone board).
> > To reproduce the problem, I used the tcrypt kernel module as:
> > modprobe tcrypt sec=2 mode=500
> > 
> > Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Mark A. Greer <mgreer@animalcreek.com>
> > ---
> >  drivers/crypto/omap-aes.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> > index cf57866..8450bfd2 100644
> > --- a/drivers/crypto/omap-aes.c
> > +++ b/drivers/crypto/omap-aes.c
> > @@ -636,7 +636,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
> >  
> >  	pr_debug("err: %d\n", err);
> >  
> > -	pm_runtime_put_sync(dd->dev);
> > +	pm_runtime_put(dd->dev);
> >  	dd->flags &= ~FLAGS_BUSY;
> >  
> >  	req->base.complete(&req->base, err);
> 
> Acked-by: Mark A. Greer <mgreer@animalcreek.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
