From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Thu, 15 Oct 2015 13:59:44 +0100
Message-ID: <20151015125944.GB32532@n2100.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151013143312.GA7903@gondor.apana.org.au>
 <20151015093930.GA32532@n2100.arm.linux.org.uk>
 <20151015094147.GA2157@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Horia Geant? <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:37817 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbJONAE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 09:00:04 -0400
Content-Disposition: inline
In-Reply-To: <20151015094147.GA2157@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 05:41:47PM +0800, Herbert Xu wrote:
> On Thu, Oct 15, 2015 at 10:39:30AM +0100, Russell King - ARM Linux wrote:
> >
> > The CAAM driver is similarly buggy - it has export/import functions in
> > its ahash drivers, but zero statesize.
> > 
> > User exploitable kernel stack smashing... I'd suggest putting this patch
> > into stable kernels as high priority, as I'm pretty sure this could be
> 
> I agree.  It should already be on its way to stable as Linus has
> pulled it into his tree and it carries a stable cc.

Thanks.

I think the CAAM driver is pretty unfixable from a trivial point of
view.  This driver exports a huge amount of state - it contains both a
struct caam_hash_ctx and a struct caam_hash_state, which totals up to
1600 bytes.  This fails the:

	alg->halg.statesize > PAGE_SIZE / 8 

in ahash_prepare_alg() if we set .statesize.  For ARM, this places a
limit of 512 bytes on the state size.

The CAAM authors need to come up with a better solution (and quickly,
as caamhash is going to fail in all kernels soon), or we need to
support larger exported states.

BTW, I can't find a MAINTAINERS entry for CAAM, so I've just grabbed
a couple of addresses from recent git history in the hope they'll know
who's responsible.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
