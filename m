From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] crypto: user - Fix size of netlink dump message
Date: Thu, 29 Mar 2012 07:53:30 +0200
Message-ID: <20120329055330.GB1021@secunet.com>
References: <20120326072729.GA16191@secunet.com>
 <20120326072827.GB16191@secunet.com>
 <20120329054504.GA1021@secunet.com>
 <20120329054626.GA16593@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33827 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab2C2Fxd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2012 01:53:33 -0400
Content-Disposition: inline
In-Reply-To: <20120329054626.GA16593@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 29, 2012 at 01:46:26PM +0800, Herbert Xu wrote:
> On Thu, Mar 29, 2012 at 07:45:04AM +0200, Steffen Klassert wrote:
> > On Mon, Mar 26, 2012 at 09:28:27AM +0200, Steffen Klassert wrote:
> > > +
> > >  		return netlink_dump_start(crypto_nlsk, skb, nlh,
> > > -					  link->dump, link->done, 0);
> > > +					  link->dump, link->done, dump_alloc);
> > 
> > I've just noticed that the interface to netlink_dump_start() changed in
> > the mainline (with commit 80d326fab534a5380e8f6e509a0b9076655a9670), so
> > this will cause a conflict. The crypto-2.6 tree is way behind the mainline
> > (v3.2 + some patches). Could you please update the crypto-2.6 tree so that
> > I can respin this patch?
> 
> 
> As long as your patch is against mainline it should be fine.  I will
> rebase cryptodev before applying any patches for the next release.
> 

Ok, so I'll respin this one to the mainline and resend.
Anyway, would be nice to see this fix in v3.4.
