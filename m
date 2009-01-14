From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
Date: Wed, 14 Jan 2009 17:53:59 +1100
Message-ID: <20090114065359.GA16044@gondor.apana.org.au>
References: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42245 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbZANGyE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 01:54:04 -0500
Content-Disposition: inline
In-Reply-To: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 14, 2009 at 02:44:08PM +0800, Huang Ying wrote:
> Because:
> 
> 1. if use %s, you can only request cryptd(<driver name>), not
>    cryptd(<alg name>), because generated new algorithm instance has
>    algorithm name: <alg name> and driver name cryptd(<driver name>).

This is intentional.  For the purposes we talked about we should
be requesting cryptd(<driver name>), as otherwise you may end up
with someone else's AES algorithm as the base.

> 2. Generated cryptd-ed algorithm will have the same algorithm name and
>    higher priority, but some user may not want to use cryptd-ed
>    version.

The priority shouldn't be an issue in our case since the AES-NI
algorithm should register itself as an ablkcipher with an even
higher priority.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
