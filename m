From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Tue, 13 Jan 2009 13:53:41 +1100
Message-ID: <20090113025341.GA14718@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231743310.5937.107.camel@yhuang-dev.sh.intel.com> <20090112104335.GA4942@gondor.apana.org.au> <1231814053.5937.120.camel@yhuang-dev.sh.intel.com> <20090113023937.GA14460@gondor.apana.org.au> <1231814947.5937.124.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50661 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbZAMCxq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 21:53:46 -0500
Content-Disposition: inline
In-Reply-To: <1231814947.5937.124.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 13, 2009 at 10:49:07AM +0800, Huang Ying wrote:
>
> I can set req->data in xx_encrypt() to my original request to solve this
> issue. Except that, does this solution work?

Yes it would work provided that you save the original data somewhere
in your context (and then restore it of course).

But it'd be much simpler if you just nested the request structures
(they aren't that big too start with) which means that you wouldn't
need this extra completion handler at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
