From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/18] crypto: further fixes for Marvell CESA hash
Date: Tue, 20 Oct 2015 22:20:44 +0800
Message-ID: <20151020142044.GE7625@gondor.apana.org.au>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <20151009104637.GA18798@n2100.arm.linux.org.uk>
 <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <20151018161649.GA6651@n2100.arm.linux.org.uk>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:43811 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbJTOU7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 10:20:59 -0400
Content-Disposition: inline
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 18, 2015 at 05:16:49PM +0100, Russell King - ARM Linux wrote:
> Following on from the previous series, this series addresses further
> problems with the Marvell CESA hash driver found while testing it my
> openssl/ssh scenarios.
> 
> The first patch improves one from the previous series: we can get the
> transform more directly using req->base.tfm rather than going round
> the houses.
> 
> The next few patches rework the algorithm endianness conversions.
> There are two things which depend on the algorithm endianness - the
> format of the result, and the format of the bit length in the last
> block.  We introduce a flag to convey this information, and keep
> the creq->state format in CPU endian mode for consistency.
> 
> Some of the inconsistent hash results are down to the template
> operation not being properly initialised - so we zero initialise all
> template operations.
> 
> The following patches (from "factor out first fragment decisions to
> helper") rework the digest handling to ensure that we always provide
> the hardware with a complete block of data to hash, otherwise it can
> be left mid-calculation, which then causes state to leak to
> subsequent operations.  This requires a re-structure of the way we
> put together the DMA entries, so it's done in relatively small steps.
> 
> This results in the CESA driver passing all tests I can throw at it
> via the AF_ALG openssl plugin with the exception of asking for the
> hash of /dev/null.  This returns an all zero result, rather than the
> correct hash value.  This bug is pending further diagnosis, but it
> is believed not to be a driver specific bug as iMX6 CAAM also behaves
> the same.
> 
> Unfortunately, this is a large series, but the driver unfortunately
> needs this level of bug fixing to work properly.

All applied.  Thanks Russell!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
