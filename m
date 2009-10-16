From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH v0 1/2] DMA: fsldma: Disable DMA_INTERRUPT when
 Async_tx enabled
Date: Fri, 16 Oct 2009 08:33:34 -0700
Message-ID: <20091016153334.GA27401@ovro.caltech.edu>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
 <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vishnu Suresh <Vishnu@freescale.com>, herbert@gondor.apana.org.au,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	Timur Tabi <timur@freescale.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760455AbZJPPeN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 15, 2009 at 06:25:14PM -0700, Dan Williams wrote:
> [ added Leo and Timur to the Cc ]
>=20
> On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh <Vishnu@freescale.com=
> wrote:
> > This patch disables the use of DMA_INTERRUPT capability with Async_=
tx
> >
> > The fsldma produces a null transfer with DMA_INTERRUPT
> > capability when used with Async_tx. When RAID devices queue
> > a transaction via Async_tx, this =A0results in a hang.
> >
> > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > ---
> > =A0drivers/dma/fsldma.c | =A0 =A06 ++++++
> > =A01 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> > index 296f9e7..66d9b39 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -1200,7 +1200,13 @@ static int __devinit of_fsl_dma_probe(struct=
 of_device *dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0- fdev->reg.start + 1);
> >
> > =A0 =A0 =A0 =A0dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > +#ifndef CONFIG_ASYNC_CORE
> > + =A0 =A0 =A0 /*
> > + =A0 =A0 =A0 =A0* The DMA_INTERRUPT async_tx is a NULL transfer, w=
hich will
> > + =A0 =A0 =A0 =A0* triger a PE interrupt.
> > + =A0 =A0 =A0 =A0*/
> > =A0 =A0 =A0 =A0dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> > +#endif
> > =A0 =A0 =A0 =A0dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
> > =A0 =A0 =A0 =A0fdev->common.device_alloc_chan_resources =3D fsl_dma=
_alloc_chan_resources;
> > =A0 =A0 =A0 =A0fdev->common.device_free_chan_resources =3D fsl_dma_=
free_chan_resources;
>=20
> You are basically saying that fsl_dma_prep_interrupt() is buggy.  Can
> that routine be fixed rather than this piecemeal solution?  If it
> cannot be fixed (i.e. hardware issue) then fsl_dma_prep_interrupt()
> should just be disabled/deleted altogether.
>=20

=46or what it's worth, I've used the following code in the recent past,
without any issues. This was on an 83xx, within the last few kernel
releases. I haven't tried it on the latest -rc.

Using device_prep_dma_memcpy() can trigger a callback as well, so the
interrupt feature isn't strictly needed. Just attach the callback to th=
e
last memcpy operation.

static dma_cookie_t dma_async_interrupt(struct dma_chan *chan,
                                        dma_async_tx_callback callback,
                                        void *data)
{
        struct dma_device *dev =3D chan->device;
        struct dma_async_tx_descriptor *tx;=20

        /* Set up the DMA */
        tx =3D dev->device_prep_dma_interrupt(chan, DMA_PREP_INTERRUPT)=
;
        if (!tx)
                return -ENOMEM;

        tx->callback =3D callback;
        tx->callback_param =3D data;

        return tx->tx_submit(tx);
}

Ira
