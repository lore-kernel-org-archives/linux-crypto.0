From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Fix DMA API misuse
Date: Wed, 10 Jan 2018 17:23:20 +0100
Message-ID: <20180110172320.5ab39e43@bbrezillon>
References: <55d3177407b00dd4a9d51fe4f8e2bf2282fe8e3d.1515596541.git.robin.murphy@arm.com>
        <20180110162522.580089a5@bbrezillon>
        <20180110154817.GA18707@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Robin Murphy <robin.murphy@arm.com>, arno@natisbad.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110154817.GA18707@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Christoph,

On Wed, 10 Jan 2018 16:48:17 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jan 10, 2018 at 04:25:22PM +0100, Boris Brezillon wrote:
> > On Wed, 10 Jan 2018 15:15:43 +0000
> > Robin Murphy <robin.murphy@arm.com> wrote:
> >   
> > > phys_to_dma() is an internal helper for certain DMA API implementations,
> > > and is not appropriate for drivers to use. It appears that what the CESA
> > > driver really wants to be using is dma_map_resource() - admittedly that
> > > didn't exist when the offending code was first merged, but it does now.
> > > 
> > > Signed-off-by: Robin Murphy <robin.murphy@arm.com>  
> > 
> > Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>  
> 
> Thanks.  Robin, Boris: do you want me to pick this up in the
> dma-mapping tree and move it before the dma-direct.h introduction?

You should probably sync with Herbert, I'm just the maintainer of this
driver, not the crypto subsystem.

Regards,

Boris
