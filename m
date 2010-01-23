From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Async Crypto API
Date: Sat, 23 Jan 2010 16:20:39 +1300
Message-ID: <20100123032039.GA5551@gondor.apana.org.au>
References: <4B5965AE.9060202@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59145 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752754Ab0AWDUy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2010 22:20:54 -0500
Content-Disposition: inline
In-Reply-To: <4B5965AE.9060202@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> Hello,
> 
> I have one question about async api.
> 
> I work on AHASH driver and wonder about one thing.
> 
> while calculating hash, client might call many times
> 
> ahash_request_set_crypt(req, &sg, sha1, len);
> crypto_ahash_update(req);
> ..
> ..
> ahash_request_set_crypt(req, &sg, sha1, len);
> crypto_ahash_finup(req);
> 
> right?
> 
> But because it is async and driver does not wait_for_completion,
> previous request may not be completed before client will call next update.
> 
> But what should be the behavior of the driver?

If any async operation returns EINPROGRESS, the client must not
proceed until that operation has completed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
