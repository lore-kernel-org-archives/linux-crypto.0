From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] [CRYPTO] hash: Add Async Hash Support
Date: Wed, 14 May 2008 20:44:28 +0800
Message-ID: <20080514124428.GA22964@gondor.apana.org.au>
References: <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6044D6442@SDCEXCHANGE01.ad.amcc.com> <20080422111635.GA19543@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6045B3153@SDCEXCHANGE01.ad.amcc.com> <20080507130047.GA26872@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D60472077B@SDCEXCHANGE01.ad.amcc.com> <20080514124039.GA22902@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57255 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757561AbYENMoa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 08:44:30 -0400
Content-Disposition: inline
In-Reply-To: <20080514124039.GA22902@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2008 at 08:40:39PM +0800, Herbert Xu wrote:
> 
> All ahash algorithms should provide a setkey function just like hash.
> Digest algorithms should never come down this way.  When we convert
> digest algorithms over to ahash we should add setkey functions.

Oh and for the vast majority of them we create create a common
default setkey function that they can put in their function tables.

The NULL setkey check in digest was there so that the existing
algorithms didn't have to be modified.  The ahash type does not
have this problem because there are no existing ahash algorithms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
