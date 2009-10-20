From: "Suresh Vishnu-B05022" <Vishnu@freescale.com>
Subject: RE: [PATCH v0 1/2] DMA: fsldma: Disable DMA_INTERRUPT when Async_tx
	enabled
Date: Tue, 20 Oct 2009 18:39:53 +0530
Message-ID: <76952DF81420A349876E087D089DF03438B8C1@zin33exm21.fsl.freescale.net>
References: <1255588866-4133-1-git-send-email-Vishnu@freescale.com>
	<e9c3a7c20910151825o67cd2712id91aead70f84987c@mail.gmail.com>
	<20091016153334.GA27401@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org,
	linux-crypto@vger.kernel.org, Tabi Timur-B04825 <timur@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>,
	"Dan Williams" <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091016153334.GA27401@ovro.caltech.edu>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu] =

> Sent: Friday, October 16, 2009 9:04 PM
> To: Dan Williams
> Cc: Suresh Vishnu-B05022; herbert@gondor.apana.org.au; =

> linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org; =

> linuxppc-dev@ozlabs.org; linux-crypto@vger.kernel.org; Tabi =

> Timur-B04825
> Subject: Re: [PATCH v0 1/2] DMA: fsldma: Disable =

> DMA_INTERRUPT when Async_tx enabled
> =

> On Thu, Oct 15, 2009 at 06:25:14PM -0700, Dan Williams wrote:
> > [ added Leo and Timur to the Cc ]
> > =

> > On Wed, Oct 14, 2009 at 11:41 PM, Vishnu Suresh =

> <Vishnu@freescale.com> wrote:
> > > This patch disables the use of DMA_INTERRUPT capability with =

> > > Async_tx
> > >
> > > The fsldma produces a null transfer with DMA_INTERRUPT capability =

> > > when used with Async_tx. When RAID devices queue a =

> transaction via =

> > > Async_tx, this =A0results in a hang.
> > >
> > > Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> > > ---
> > > =A0drivers/dma/fsldma.c | =A0 =A06 ++++++
> > > =A01 files changed, 6 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index =

> > > 296f9e7..66d9b39 100644
> > > --- a/drivers/dma/fsldma.c
> > > +++ b/drivers/dma/fsldma.c
> > > @@ -1200,7 +1200,13 @@ static int __devinit =

> of_fsl_dma_probe(struct =

> > > of_device *dev,
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- =

> fdev->reg.start + =

> > > 1);
> > >
> > > =A0 =A0 =A0 =A0dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
> > > +#ifndef CONFIG_ASYNC_CORE
> > > + =A0 =A0 =A0 /*
> > > + =A0 =A0 =A0 =A0* The DMA_INTERRUPT async_tx is a NULL transfer, =

> which will
> > > + =A0 =A0 =A0 =A0* triger a PE interrupt.
> > > + =A0 =A0 =A0 =A0*/
> > > =A0 =A0 =A0 =A0dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
> > > +#endif
> > > =A0 =A0 =A0 =A0dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
> > > =A0 =A0 =A0 =A0fdev->common.device_alloc_chan_resources =3D =

> > > fsl_dma_alloc_chan_resources;
> > > =A0 =A0 =A0 =A0fdev->common.device_free_chan_resources =3D =

> > > fsl_dma_free_chan_resources;
> > =

> > You are basically saying that fsl_dma_prep_interrupt() is =

> buggy.  Can =

> > that routine be fixed rather than this piecemeal solution?  If it =

> > cannot be fixed (i.e. hardware issue) then fsl_dma_prep_interrupt() =

> > should just be disabled/deleted altogether.
We are working to fix this issue.
> > =

> =

> For what it's worth, I've used the following code in the =

> recent past, without any issues. This was on an 83xx, within =

> the last few kernel releases. I haven't tried it on the latest -rc.
This works fine as long as only DMA_MEMCPY is being used.
The async_tx_channel_switch does not occur and the =

device_prep_dma_interrupt is not called. =

However, when a DMA_XOR capable device is exposed, =

which is differnet from the DMA_MEMCPY/INTERRUPT device, this path is hit.

Is it proper to schedule a dma_interrupt from the channel switch call, =

even when the depend_tx and tx channels correspond to different devices?

> =

> Using device_prep_dma_memcpy() can trigger a callback as =

> well, so the interrupt feature isn't strictly needed. Just =

> attach the callback to the last memcpy operation.
> =

> static dma_cookie_t dma_async_interrupt(struct dma_chan *chan,
>                                         dma_async_tx_callback =

> callback,
>                                         void *data) {
>         struct dma_device *dev =3D chan->device;
>         struct dma_async_tx_descriptor *tx; =

> =

>         /* Set up the DMA */
>         tx =3D dev->device_prep_dma_interrupt(chan, DMA_PREP_INTERRUPT);
>         if (!tx)
>                 return -ENOMEM;
> =

>         tx->callback =3D callback;
>         tx->callback_param =3D data;
> =

>         return tx->tx_submit(tx);
> }
> =

> Ira
> =

> =
