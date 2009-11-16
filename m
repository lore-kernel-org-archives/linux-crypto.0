From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX -v3 for .32] crypto, gcm, fix another complete call in
	complete fuction
Date: Mon, 16 Nov 2009 21:52:59 +0800
Message-ID: <20091116135258.GA4798@gondor.apana.org.au>
References: <1257838751.22519.2513.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49971 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbZKPNw4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Nov 2009 08:52:56 -0500
Content-Disposition: inline
In-Reply-To: <1257838751.22519.2513.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 10, 2009 at 03:39:11PM +0800, Huang Ying wrote:
> The flow of the complete function (xxx_done) in gcm.c is as follow:
> 
> void complete(struct crypto_async_request *areq, int err)
> {
> 	struct aead_request *req = areq->data;
> 
> 	if (!err) {
> 		err = async_next_step();
> 		if (err == -EINPROGRESS || err == -EBUSY)
> 			return;
> 	}
> 
> 	complete_for_next_step(areq, err);
> }
> 
> But *areq may be destroyed in async_next_step(), this makes
> complete_for_next_step() can not work properly. To fix this, one of
> following methods is used for each complete function.
> 
> - Add a __complete() for each complete(), which accept struct
>   aead_request *req instead of areq, so avoid using areq after it is
>   destroyed.
> 
> - Expand complete_for_next_step().
> 
> The fixing method is based on the idea of Herbert Xu.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Applied to crypto-2.6.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
