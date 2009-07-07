From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Tue, 7 Jul 2009 11:45:48 +0800
Message-ID: <20090707034548.GA28075@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au> <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60192 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754856AbZGGDpr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2009 23:45:47 -0400
Content-Disposition: inline
In-Reply-To: <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2009 at 11:31:52AM +0800, Huang Ying wrote:
>
> What's your plan to convert everything to shash? For 2.6.32? How about
> the progress? What can I do to help?

I've been busy with networking :)

I'll try to get onto hmac today or tomorrow.  But if you could
spend some time on the remaining DIGEST algorithms that would
very much be appreciated.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
