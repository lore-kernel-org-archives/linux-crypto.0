From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 9 Feb 2010 20:02:19 +1100
Message-ID: <20100209090219.GA18239@gondor.apana.org.au>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B7120AB.8010201@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46333 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752081Ab0BIJCW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 04:02:22 -0500
Content-Disposition: inline
In-Reply-To: <4B7120AB.8010201@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2010 at 10:45:31AM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> Ok...
> 
> But normally kernel client code uses sync API as shash.
> 
> And I provide async hw driver via async ahash API.
> That is simply will not be used at all.
> 
> Client must be changed to use async ahash API in order to benefit from
> HW crypto.
> 
> Right?

Yes we will convert hash users over to ahash where appropriate,
starting with authenc which covers IPsec.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
