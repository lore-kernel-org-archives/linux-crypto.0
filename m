From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Wed, 16 Sep 2009 22:37:29 -0500
Message-ID: <20090917033729.GA13826@gondor.apana.org.au>
References: <20090916160456.GC11163@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jarod@redhat.com, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33471 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758284AbZIQDhb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 23:37:31 -0400
Content-Disposition: inline
In-Reply-To: <20090916160456.GC11163@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 16, 2009 at 12:04:56PM -0400, Neil Horman wrote:
>
> 	So the question is, how do I make this RNG fips compliant without
> breaking some subset of users out there that rely on the predictability of the
> CPRNG?  The solution I've come up with is a dynamic flag.  This patch series

What user apart from the test vector relies on the predictability?
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
