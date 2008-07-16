From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 21:38:59 +0800
Message-ID: <20080716133859.GA16473@gondor.apana.org.au>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com> <20080716124533.GA16103@gondor.apana.org.au> <20080716132539.GB24291@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32998 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756697AbYGPNjD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 09:39:03 -0400
Content-Disposition: inline
In-Reply-To: <20080716132539.GB24291@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 09:25:40AM -0400, Neil Horman wrote:
>
> I think I have an irc log somewhere where I thought we discussed this, and
> decided that counter mode allowed us a larger period in the random number
> stream, but you're correct, simple AES mode is called for in the specification.
> I suppose its better to do whats written down there rather than do what makes
> intuitive sense, I'll change that.

Yes since this is primarily for the purposes of fulfilling the
specifications this would be the best course to take.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
