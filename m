From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] Add RNG support to AF_ALG (v2)
Date: Fri, 21 Jan 2011 08:24:12 -0500
Message-ID: <20110121132412.GC30868@hmsreliant.think-freely.org>
References: <1292260317-2684-1-git-send-email-nhorman@tuxdriver.com>
 <1292275514-2488-1-git-send-email-nhorman@tuxdriver.com>
 <20110120233440.GA2451@localhost.localdomain>
 <20110121060005.GA9768@gondor.apana.org.au>
 <20110121120950.GB30868@hmsreliant.think-freely.org>
 <20110121123517.GA11677@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57604 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1AUNYX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Jan 2011 08:24:23 -0500
Content-Disposition: inline
In-Reply-To: <20110121123517.GA11677@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 21, 2011 at 11:35:17PM +1100, Herbert Xu wrote:
> On Fri, Jan 21, 2011 at 07:09:50AM -0500, Neil Horman wrote:
> >
> > I take your point, but I'm not certain I agree that we are duplicating an
> > existing user interface.  A cursory glance would say that we are, but
> > /dev/random and /dev/urandom really just provide access to the kernels entropy
> > pools, whereas the AF_ALG provides access to instances of any RNG the kernel has
> > to offer as well as the key management services that AF_ALG has, which I think
> > is adventageous, given that the CPRNG requires keying to work properly.
> 
> I'm not talking about /dev/random, I'm talking the hwrng interface
> in drivers/char/hwrng.
> 
Doh!  I'm sorry, that was stupid of me.  Yes that makes alot more sense.  I'll
try another pass, adding the cprng to that interface instead.

Thanks!
Neil

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
