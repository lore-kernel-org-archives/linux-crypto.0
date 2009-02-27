From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete function
Date: Fri, 27 Feb 2009 19:56:38 +0800
Message-ID: <20090227115638.GA24221@gondor.apana.org.au>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au> <49A7D3E5.5040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43241 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753736AbZB0L4p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 06:56:45 -0500
Content-Disposition: inline
In-Reply-To: <49A7D3E5.5040706@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2009 at 12:52:05PM +0100, Milan Broz wrote:
> Herbert Xu wrote:
> > On Fri, Feb 27, 2009 at 04:56:11PM +0800, Huang Ying wrote:
> >> @@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
> >>  		return;
> >>  	}
> >>  
> >> -	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
> >> +	mempool_free(dmreq->req, cc->req_pool);
> > 
> > Why do we need all this complexity? Can't just fix it by using
> > cc->req?
> 
> No. There can be parallel req allocated, also cc->req can be NULL.
> (seems that these structs are overcomplicated already:-)

Fair enough.  However we still shouldn't need to have dmreq->req
since

	dmreq->req == (char *)dmreq - sizeof(dmreq->req)

In fact just pass the request itself as data and derive dmreq
from that.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
