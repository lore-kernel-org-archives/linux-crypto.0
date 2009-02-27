From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete
	function
Date: Fri, 27 Feb 2009 19:41:03 +0800
Message-ID: <20090227114103.GB24024@gondor.apana.org.au>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39585 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754458AbZB0LlJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 06:41:09 -0500
Content-Disposition: inline
In-Reply-To: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2009 at 04:56:11PM +0800, Huang Ying wrote:
>
> @@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
>  		return;
>  	}
>  
> -	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
> +	mempool_free(dmreq->req, cc->req_pool);

Why do we need all this complexity? Can't just fix it by using
cc->req?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
