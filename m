From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: New Crypto Hardware
Date: Thu, 17 Jan 2008 22:23:14 +1100
Message-ID: <20080117112314.GC9020@gondor.apana.org.au>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42985 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbYAQLXQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jan 2008 06:23:16 -0500
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 16, 2008 at 10:19:04AM -0800, Loc Ho wrote:
> Hi,
> 
> For hashing, there are HMAC key if HMAC and digest size. As digest size
> is part of the algorithm, there is only HMAC key. Are you referring to
> moving the HMAC key from transformation into the request structure? As I
> am modeled after ablkcipher_request structure, there will be a context
> point 'void *__ctx[] CRYPTO_MINALIGN_ATTR;' for the request operation.

No I meant the context that has to be stored between calls to
crypto_hash_update and crypto_hash_final.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
