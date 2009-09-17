From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Thu, 17 Sep 2009 08:43:51 -0400
Message-ID: <20090917124351.GA26276@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jarod@redhat.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37756 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZIQMnv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 08:43:51 -0400
Content-Disposition: inline
In-Reply-To: <20090917033729.GA13826@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 16, 2009 at 10:37:29PM -0500, Herbert Xu wrote:
> On Wed, Sep 16, 2009 at 12:04:56PM -0400, Neil Horman wrote:
> >
> > 	So the question is, how do I make this RNG fips compliant without
> > breaking some subset of users out there that rely on the predictability of the
> > CPRNG?  The solution I've come up with is a dynamic flag.  This patch series
> 
> What user apart from the test vector relies on the predictability?
As Jarod mentioned, currently only the NIST certification vectors and, as a
result our testmgr vectors require disabling of the internal continuity test,
but to generalize from that, I would imagine that any set of certification
vectors that exist in the wild, may or may not assume the presence of the oth
iteration consumption, and this patch gives us the flexability to make use of
those.  I was thinking that this api extension could also be used for various
debugging purposes (additional flags could be created to enable internal
debugging, etc).

Neil

> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
