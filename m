From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/6] Fix CAAM hash driver
Date: Tue, 20 Oct 2015 22:23:46 +0800
Message-ID: <20151020142346.GG7625@gondor.apana.org.au>
References: <20151017185055.GQ32532@n2100.arm.linux.org.uk>
 <20151018165046.GA7997@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56750 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbbJTOXz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 10:23:55 -0400
Content-Disposition: inline
In-Reply-To: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 18, 2015 at 05:50:47PM +0100, Russell King - ARM Linux wrote:
> The following series fixes the CAAM hash driver, allowing it to work
> with the previously merged "crypto: ahash - ensure statesize is non-
> zero" patch.
> 
> This is non-trivial, because CAAM exports a huge 1600 bytes of data,
> which, if we set .statesize to this, still results in the core code
> rejecting the driver.  So, we need to shrink the amount of state
> exported.
> 
> The first, most obvious one to get rid of is the export of the
> caam_hash_ctx structure, which is shared between the socket being
> exported from and imported to - copying it away and back again was
> a complete no-op.
> 
> The second is that we don't need to export both pending-bytes buffers.
> Only one will be in use at any time.
> 
> A problem was encountered while testing, where the size of the pending
> bytes buffer was not added to the scatterlist with the correct length.
> This is also fixed in this series, by patch 3.  This bug was introduced
> by a prior commit trying to fix a tcrypt error.  However, the change is
> wrong, but I have to question whether the test was correct or not - the
> backtrace contains a function "test_ahash_pnum" which doesn't seem to
> exist in mainline, nor does it seem to exist in any previous mainline
> kernel.
> 
> Version 2 of this series addresses a mismerge in patch 5 of the
> original series, and adds further information to patch 3.
> 
> Further testing with tcrypt showed up a problem identified by the
> DMA API debugging (different to the original one referred to in
> patch 3) where we leak DMA mappings.

Patches 1-5 applied.  Patch 6 failed to apply because the cryptodev
tree already has a patch that converts caam to use dma_map_sg instead
of the caam-specific dma_map_sg_chained.  If your patch is still
needed could you please rebase it on top of cryptodev?

commit 13fb8fd7a81923f7a64b4e688fe0bdaf1ea26adf
Author: LABBE Corentin <clabbe.montjoie@gmail.com>
Date:   Wed Sep 23 13:55:27 2015 +0200

    crypto: caam - dma_map_sg can handle chained SG

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
