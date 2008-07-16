From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 09:25:40 -0400
Message-ID: <20080716132539.GB24291@hmsreliant.think-freely.org>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com> <20080716124533.GA16103@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4957 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYGPNZv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 09:25:51 -0400
Content-Disposition: inline
In-Reply-To: <20080716124533.GA16103@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 08:45:33PM +0800, Herbert Xu wrote:
> On Thu, Jul 03, 2008 at 04:21:02PM -0400, Neil Horman wrote:
> >
> > + * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
> > + * for implementation details
> 
> BTW, any reason why counter mode is used? This document specifies
> simple AES only, with no modes of operations.
> 
I think I have an irc log somewhere where I thought we discussed this, and
decided that counter mode allowed us a larger period in the random number
stream, but you're correct, simple AES mode is called for in the specification.
I suppose its better to do whats written down there rather than do what makes
intuitive sense, I'll change that.

Regards
Neil

> Thanks,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
