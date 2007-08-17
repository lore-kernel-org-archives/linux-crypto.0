From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 01/10] t add cast to regain ablkcipher_request from private ctx
Date: Fri, 17 Aug 2007 16:55:07 +0800
Message-ID: <20070817085507.GA17210@gondor.apana.org.au>
References: <20070816200105.735608000@ml.breakpoint.cc> <20070816200134.680838000@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cbe-oss-dev@ozlabs.org, arnd@arndb.de, jk@ozlabs.org,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4272 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764284AbXHQIzT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Aug 2007 04:55:19 -0400
Content-Disposition: inline
In-Reply-To: <20070816200134.680838000@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 16, 2007 at 10:01:06PM +0200, Sebastian Siewior wrote:
> This cast allows to regain the struct ablkcipher_request for a request 
> from private data.

Hi Sebastian:

I think this function would make more sense as a private
function in your driver.  That way you can give it an
explicit type rather than having it take a void *.

We want to avoid unnecessary casting like this where
possible as it's error-prone.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
