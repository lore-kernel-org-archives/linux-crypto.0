From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Thu, 17 Sep 2009 13:23:02 -0700
Message-ID: <20090917202302.GA22127@gondor.apana.org.au>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au> <20090917124351.GA26276@hmsreliant.think-freely.org> <20090917153951.GB19535@gondor.apana.org.au> <20090917170824.GB26276@hmsreliant.think-freely.org> <20090917201622.GA22003@gondor.apana.org.au> <4AB29990.30303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59055 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbZIQUXG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 16:23:06 -0400
Content-Disposition: inline
In-Reply-To: <4AB29990.30303@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 17, 2009 at 04:18:24PM -0400, Jarod Wilson wrote:
>
> Yeah, I like that solution as well, does feel less dirty. So  
> essentially, in fips mode, we'd wind up using fips(ansi_cprng) or  
> similar, while the self-tests are done against raw ansi_cprng, correct?

Exactly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
