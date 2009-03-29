From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Accelerate GCM with PCLMULQDQ-NI
Date: Sun, 29 Mar 2009 15:43:26 +0800
Message-ID: <20090329074326.GB11735@gondor.apana.org.au>
References: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45466 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbZC2Hnb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2009 03:43:31 -0400
Content-Disposition: inline
In-Reply-To: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 18, 2009 at 04:52:12PM +0800, Huang Ying wrote:
>
> To accelerate GCM with it, I make the following design:
> 
> 1. Implement ghash as an ahash algorithm, Use ghash in gcm
> implementation.
> 2. Provide a new implementation of ghash with PCLMULQDQ-NI.
> 
> What do you think about that?

Sounds OK to me.  I presume the choice of ahash instead of shash
is due to the use of XMM registers, just like AES?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
