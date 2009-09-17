From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Thu, 17 Sep 2009 13:16:22 -0700
Message-ID: <20090917201622.GA22003@gondor.apana.org.au>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au> <20090917124351.GA26276@hmsreliant.think-freely.org> <20090917153951.GB19535@gondor.apana.org.au> <20090917170824.GB26276@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jarod@redhat.com, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59868 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbZIQUQW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 16:16:22 -0400
Content-Disposition: inline
In-Reply-To: <20090917170824.GB26276@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 17, 2009 at 01:08:24PM -0400, Neil Horman wrote:
>
> Just so that I'm clear on what your suggesting, you're approach would be to
> register two algs in ansi_cprng, a 'raw' cprng, and a 'fips compliant cprng'
> underneath that used the raw cprng as a base, but implemented the continuity
> test underneath it?  If so, yeah, I can get behind that idea.  I'll spin a new
> set of patches shortly.

Yes, exactly like how we structure the raw CTR and RFC3686 which
is CTR tailored for IPsec.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
