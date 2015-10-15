From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Thu, 15 Oct 2015 10:39:30 +0100
Message-ID: <20151015093930.GA32532@n2100.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151013143312.GA7903@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37336 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbJOJjp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 05:39:45 -0400
Content-Disposition: inline
In-Reply-To: <20151013143312.GA7903@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 10:33:12PM +0800, Herbert Xu wrote:
> On Fri, Oct 09, 2015 at 08:43:33PM +0100, Russell King wrote:
> > If the algorithm passed a zero statesize, do not pass a valid pointer
> > into the export/import functions.  Passing a valid pointer covers up
> > bugs in driver code which then go on to smash the kernel stack.
> > Instead, pass NULL, which will cause any attempt to write to the
> > pointer to fail.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Patch applied without the shash hunk.  I also replaced your commit
> message as it no longer makes any sense:
> 
>     crypto: ahash - ensure statesize is non-zero
> 
>     Unlike shash algorithms, ahash drivers must implement export
>     and import as their descriptors may contain hardware state and
>     cannot be exported as is.  Unfortunately some ahash drivers did
>     not provide them and end up causing crashes with algif_hash.
> 
>     This patch adds a check to prevent these drivers from registering
>     ahash algorithms until they are fixed.
> 
> Thanks,

There will be fallout from this.

The CAAM driver is similarly buggy - it has export/import functions in
its ahash drivers, but zero statesize.

User exploitable kernel stack smashing... I'd suggest putting this patch
into stable kernels as high priority, as I'm pretty sure this could be
used to gain privileges via carefully crafted md5 hashes.  I've not
proven it, but given that the md5 hash and state data get copied over
the kernel stack, it's highly likely that it _is_ exploitable from any
user that can create an AF_ALG socket.

Yes, it means regressions in the form of various hw crypto no longer
being loadable, but I think that's preferable to the security hole here.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
