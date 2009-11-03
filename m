From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX for .32] crypto, gcm, fix another complete call in
	complete fuction
Date: Tue, 3 Nov 2009 10:53:39 -0500
Message-ID: <20091103155339.GC9186@gondor.apana.org.au>
References: <1257216017.30470.1183.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59105 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751261AbZKCPxg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Nov 2009 10:53:36 -0500
Content-Disposition: inline
In-Reply-To: <1257216017.30470.1183.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 03, 2009 at 10:40:17AM +0800, Huang Ying wrote:
> The flow of the complete function (xxx_done) in gcm.c is as follow:
> 
> void complete(struct crypto_async_request *areq, int err)
> {
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

So why is async_next_step destroying areq? Can you give me a
concrete example?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
