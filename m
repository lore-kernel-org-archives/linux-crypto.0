From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Thu, 17 Sep 2009 08:39:51 -0700
Message-ID: <20090917153951.GB19535@gondor.apana.org.au>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au> <20090917124351.GA26276@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jarod@redhat.com, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44175 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbZIQPjv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 11:39:51 -0400
Content-Disposition: inline
In-Reply-To: <20090917124351.GA26276@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 17, 2009 at 08:43:51AM -0400, Neil Horman wrote:
>
> As Jarod mentioned, currently only the NIST certification vectors and, as a
> result our testmgr vectors require disabling of the internal continuity test,
> but to generalize from that, I would imagine that any set of certification
> vectors that exist in the wild, may or may not assume the presence of the oth
> iteration consumption, and this patch gives us the flexability to make use of
> those.  I was thinking that this api extension could also be used for various
> debugging purposes (additional flags could be created to enable internal
> debugging, etc).

My gut feeling would be to just get rid of the test vectors.

But if you really want to keep them, please do it like CTR and
RFC3686.  That is, have the raw RNG tested with the current vectors,
and implement the FIPS version as a wrapper on top of it to remove
the required bits.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
