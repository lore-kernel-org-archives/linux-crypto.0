From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v5 2/6] fsl-dma: remove attribute DMA_INTERRUPT of
 dmaengine
Date: Thu, 2 Aug 2012 04:52:23 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70CFD5F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1343810948-25343-1-git-send-email-qiang.liu@freescale.com>
 <20120801163553.GC11359@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 Vinod Koul <vinod.koul@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "davem@davemloft.net" <davem@davemloft.net>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20120801163553.GC11359@ovro.caltech.edu>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: Thursday, August 02, 2012 12:36 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; dan.j.williams@gmail.com; Vinod Koul;
> herbert@gondor.hengli.com.au; Dan Williams; davem@davemloft.net
> Subject: Re: [PATCH v5 2/6] fsl-dma: remove attribute DMA_INTERRUPT of
> dmaengine
> 
> On Wed, Aug 01, 2012 at 04:49:08PM +0800, qiang.liu@freescale.com wrote:
> > From: Qiang Liu <qiang.liu@freescale.com>
> >
> > Delete attribute DMA_INTERRUPT because fsl-dma doesn't support this
> > function, exception will be thrown if talitos is used to offload xor at
> the same time.
> >
> 
> I have no problem with this patch.
> 
> However, it ***WILL BREAK*** both drivers in drivers/misc/carma. Please
> add my patch 7/7 titled "[PATCH 7/7] carma: remove unnecessary
> DMA_INTERRUPT capability" to your series. I suggest placing it
> immediately after this patch in your series.
> 
> The carma drivers use the fsldma driver exclusively.
Fine, thanks.

> 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Li Yang <leoli@freescale.com>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
> > ---
> >  drivers/dma/fsldma.c |   31 -------------------------------
> >  1 files changed, 0 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index
> > 8f84761..4f2f212 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -543,35 +543,6 @@ static void fsl_dma_free_chan_resources(struct
> > dma_chan *dchan)  }
> >
> >  static struct dma_async_tx_descriptor *
> > -fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
> > -{
> > -	struct fsldma_chan *chan;
> > -	struct fsl_desc_sw *new;
> > -
> > -	if (!dchan)
> > -		return NULL;
> > -
> > -	chan = to_fsl_chan(dchan);
> > -
> > -	new = fsl_dma_alloc_descriptor(chan);
> > -	if (!new) {
> > -		chan_err(chan, "%s\n", msg_ld_oom);
> > -		return NULL;
> > -	}
> > -
> > -	new->async_tx.cookie = -EBUSY;
> > -	new->async_tx.flags = flags;
> > -
> > -	/* Insert the link descriptor to the LD ring */
> > -	list_add_tail(&new->node, &new->tx_list);
> > -
> > -	/* Set End-of-link to the last link descriptor of new list */
> > -	set_ld_eol(chan, new);
> > -
> > -	return &new->async_tx;
> > -}
> > -
> > -static struct dma_async_tx_descriptor *  fsl_dma_prep_memcpy(struct
> > dma_chan *dchan,
> >  	dma_addr_t dma_dst, dma_addr_t dma_src,
> >  	size_t len, unsigned long flags)
> > @@ -1352,12 +1323,10 @@ static int __devinit fsldma_of_probe(struct
> platform_device *op)
> >  	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
> >
> >  	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > -	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> >  	dma_cap_set(DMA_SG, fdev->common.cap_mask);
> >  	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
> >  	fdev->common.device_alloc_chan_resources =
> fsl_dma_alloc_chan_resources;
> >  	fdev->common.device_free_chan_resources =
> fsl_dma_free_chan_resources;
> > -	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
> >  	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
> >  	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
> >  	fdev->common.device_tx_status = fsl_tx_status;
> > --
> > 1.7.5.1
> >
> >
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev
