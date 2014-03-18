From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC PATCH 03/22] staging: crypto: skein: allow building
 statically
Date: Tue, 18 Mar 2014 08:58:49 -0400
Message-ID: <20140318125849.GQ15608@titan.lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
 <e3d822cba2ff9e9bbb57fc613039bd0983186c05.1394570067.git.jason@lakedaemon.net>
 <20140317215252.GA24150@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54497 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912AbaCRM6x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Mar 2014 08:58:53 -0400
Content-Disposition: inline
In-Reply-To: <20140317215252.GA24150@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 17, 2014 at 02:52:52PM -0700, Greg KH wrote:
> On Tue, Mar 11, 2014 at 09:32:35PM +0000, Jason Cooper wrote:
> > These are the minimum changes required to get the code to build
> > statically in the kernel.  It's necessary to do this first so that we
> > can empirically determine that future cleanup patches aren't changing
> > the generated object code.
> > 
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> 
> This doesn't apply to my latest tree :(

Ah, ok.  I'll rebase this series on the staging tree.

> > --- a/drivers/staging/Makefile
> > +++ b/drivers/staging/Makefile
> > @@ -65,3 +65,4 @@ obj-$(CONFIG_XILLYBUS)		+= xillybus/
> >  obj-$(CONFIG_DGNC)			+= dgnc/
> >  obj-$(CONFIG_DGAP)			+= dgap/
> >  obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
> > +obj-$(CONFIG_CRYPTO_SKEIN) += skein/
> 
> Care to align these up with the way this file is formatted?

Of course, not sure what happened there (well, other than the obvious
:-P)

> And I have no objection to taking the drivers/staging/ patches, the
> script looks useful, but I can't take it through the staging tree,
> sorry.

Ok, I'll pull that out as a separate branch.  Do you mind taking a
series that depends on a topic branch from another tree?  We do it a lot
in arm-soc, but I'm not sure how popular that is elsewhere.

It's purely an audit/testing dependency, but it would be nice to have it
available in the history if someone wants to audit the changes.

I have one change I'd like to do to the objdiff script.  I'd like it to
assume 'HEAD^ HEAD' when the user executes './scripts/objdiff diff'.

I'll respin both and submit a v1.

Thanks for the review.

thx,

Jason.
