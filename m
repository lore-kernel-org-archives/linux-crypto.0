From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: marvell/cesa - Fix DMA API misuse
Date: Thu, 18 Jan 2018 23:03:14 +1100
Message-ID: <20180118120314.GG20717@gondor.apana.org.au>
References: <55d3177407b00dd4a9d51fe4f8e2bf2282fe8e3d.1515596541.git.robin.murphy@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boris.brezillon@free-electrons.com, arno@natisbad.org,
        davem@davemloft.net, hch@lst.de, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55d3177407b00dd4a9d51fe4f8e2bf2282fe8e3d.1515596541.git.robin.murphy@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 10, 2018 at 03:15:43PM +0000, Robin Murphy wrote:
> phys_to_dma() is an internal helper for certain DMA API implementations,
> and is not appropriate for drivers to use. It appears that what the CESA
> driver really wants to be using is dma_map_resource() - admittedly that
> didn't exist when the offending code was first merged, but it does now.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
