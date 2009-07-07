From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Tue, 7 Jul 2009 14:00:03 +0800
Message-ID: <20090707060003.GA28886@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com> <20090707034548.GA28075@gondor.apana.org.au> <20090707040232.GA28257@gondor.apana.org.au> <20090707040341.GA28303@gondor.apana.org.au> <20090707060015.GA20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34064 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbZGGGAE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 02:00:04 -0400
Content-Disposition: inline
In-Reply-To: <20090707060015.GA20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2009 at 08:00:15AM +0200, Steffen Klassert wrote:
>
> Just FYI, I have a ahash version of hmac. Actually I'm about to convert
> the hmac users. I have not posted it so far because not all hmac users
> are converted, but I can do so if you are interested.

Sure, maybe I could take some of your code as is.  My plan for
hmac is to first convert it to shash, then convert the users to
ahash, and finally convert hmac itself to ahash.

This way we don't have to convert all the users and hmac in one
go.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
