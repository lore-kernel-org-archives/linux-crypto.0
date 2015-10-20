From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] Sparse related fixes
Date: Tue, 20 Oct 2015 22:21:17 +0800
Message-ID: <20151020142117.GF7625@gondor.apana.org.au>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <20151009104637.GA18798@n2100.arm.linux.org.uk>
 <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <20151018161649.GA6651@n2100.arm.linux.org.uk>
 <20151018173039.GA9737@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jason Cooper <jason@lakedaemon.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55288 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbbJTOV0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 10:21:26 -0400
Content-Disposition: inline
In-Reply-To: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 18, 2015 at 06:30:39PM +0100, Russell King - ARM Linux wrote:
> Continuing on from the previous set of 18 patches, I also fixed a
> number of sparse problems and other cleanups.  I don't deem these
> suitable for -rc merging, especially now that we're basically at
> -rc6.
> 
> The first patch switches the driver over to appropriately using
> the relaxed IO accessors - this avoids calling out to the heavy
> barrier on every read and write operation, but only calling out on
> those which really matter.
> 
> We switch to using dma_addr_t for DMA addresses which are not accessed
> by hardware, and using gfp_t for the get_free_page flags.  String-based
> MMIO accesses are used instead of plain memcpy()/memset() which prevents
> us potentially stumbling over GCC optimisations that it thinks it may
> make with these functions.
> 
> We convert as much of the hardware state to __le32 endian markings,
> and use cpu_to_le32() as appropriate.  A number of places are left
> unfixed, as we temporarily store CPU native endian values at these
> locations; these warnings should not be fixed (basically, only
> appropriate sparse warnings should be fixed without penalising code.)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
