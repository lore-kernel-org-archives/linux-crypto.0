From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH v3 7/7] crypto: omap_sham: Remove usage of private DMA
 API
Date: Wed, 14 Nov 2012 09:47:55 -0700
Message-ID: <20121114164755.GA16925@animalcreek.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
 <1352257033-32495-8-git-send-email-mgreer@animalcreek.com>
 <CALLzPKY9fRSwgSTw-t9-wRbCHVbKPA=m+RsTWW4=CaxtDCczcQ@mail.gmail.com>
 <20121109171745.GB13898@animalcreek.com>
 <CALLzPKZ0qC-mm4tLsywzGi7jtnK8aSQcbW5sGxr2Z1g6hyBpsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:59077 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161249Ab2KNQr4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Nov 2012 11:47:56 -0500
Content-Disposition: inline
In-Reply-To: <CALLzPKZ0qC-mm4tLsywzGi7jtnK8aSQcbW5sGxr2Z1g6hyBpsA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2012 at 11:47:57PM -0800, Kasatkin, Dmitry wrote:
> On Fri, Nov 9, 2012 at 9:17 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> > On Fri, Nov 09, 2012 at 06:28:16PM +0200, Kasatkin, Dmitry wrote:
> >> On Wed, Nov 7, 2012 at 4:57 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> >> > From: "Mark A. Greer" <mgreer@animalcreek.com>
> >> >
> >> > Remove usage of the private OMAP DMA API.
> >> > The dmaengine API will be used instead.
> >> >
> >> > CC: Russell King <rmk+kernel@arm.linux.org.uk>
> >> > CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> >> > Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> >> > ---
> >> >  drivers/crypto/omap-sham.c | 117 ---------------------------------------------
> >> >  1 file changed, 117 deletions(-)
> >> >
> >> > diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> >> > index b57277c..ebb5255 100644
> >> > --- a/drivers/crypto/omap-sham.c
> >> > +++ b/drivers/crypto/omap-sham.c
> >
> >> > @@ -807,18 +762,6 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
> >> >         if (err)
> >> >                 goto err1;
> >> >
> >> > -#ifdef OMAP_SHAM_DMA_PRIVATE
> >> > -       omap_set_dma_dest_params(dd->dma_lch, 0,
> >> > -                       OMAP_DMA_AMODE_CONSTANT,
> >> > -                       dd->phys_base + SHA_REG_DIN(0), 0, 16);
> >> > -
> >> > -       omap_set_dma_dest_burst_mode(dd->dma_lch,
> >> > -                       OMAP_DMA_DATA_BURST_16);
> >> > -
> >> > -       omap_set_dma_src_burst_mode(dd->dma_lch,
> >> > -                       OMAP_DMA_DATA_BURST_4);
> >>
> >> Burst mode significantly improves performance.
> >> How do you configure burst mode with new API?
> >
> > This is (or should be) taken care of by the dmaengine infrastructure.
> > I've noted that there's an issue and there is a discussion about it
> > here:
> >
> >         http://www.spinics.net/lists/linux-omap/msg79855.html
> >
> > We probably need to extend the dmaengine API to allow API-users to
> > request specific tweaks/optimizations/whatever but that's MHO.
> >
> 
> Hello,
> 
> I am in favor of new APIs.
> The only my concern is that it performs worse..
> 
> Is it possible to keep burst mode setting there?

I'm going to respin the patch the I posted in the email thread above
to only set bursting for non-cyclic DMAs.

Mark
--
