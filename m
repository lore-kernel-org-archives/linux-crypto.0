From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Wed, 6 Aug 2008 19:22:49 +0800
Message-ID: <20080806112249.GA32234@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain> <20080806094226.GA23685@atrey.karlin.mff.cuni.cz> <1218020727.29030.16.camel@localhost.localdomain> <20080806111724.GA32129@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@suse.cz>, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60776 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758426AbYHFLXE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 07:23:04 -0400
Content-Disposition: inline
In-Reply-To: <20080806111724.GA32129@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 06, 2008 at 07:17:24PM +0800, Herbert Xu wrote:
> On Wed, Aug 06, 2008 at 07:05:27AM -0400, Austin Zhang wrote:
> >
> > > > +		return -1;
> > > 
> > > That's supposed to be errno, right?
> > Are you suggest "ENODEV"? It's a feature from the device but the device is exact here. 
> 
> Yes I think this should be ENODEV to be consistent with the
> existing drivers such as padlock-aes.c.
> 
> I'll make that change in cryptodev.

In fact I'm going to kill that printk altogether since the fact
that this feature doesn't exist isn't an error.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
