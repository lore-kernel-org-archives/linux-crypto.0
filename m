From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Wed, 7 May 2008 21:15:58 +0800
Message-ID: <20080507131558.GA27156@gondor.apana.org.au>
References: <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6044D6442@SDCEXCHANGE01.ad.amcc.com> <20080422111635.GA19543@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6045B3153@SDCEXCHANGE01.ad.amcc.com> <20080507130047.GA26872@gondor.apana.org.au> <4821A9FA.3050307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Loc Ho <lho@amcc.com>, linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38677 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750707AbYEGNQD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:16:03 -0400
Content-Disposition: inline
In-Reply-To: <4821A9FA.3050307@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 07, 2008 at 03:09:14PM +0200, Patrick McHardy wrote:
> 
> Cool, I started adding hashing support to HIFN until I noticed
> the CrypoAPI doesn't support async hashing yet :)


The other really cool thing about Loc's new interafce is that
it'll let us have hash tfm objects that are reentrant.  So we
won't need to hold a spin lock around hash operations in IPsec
anymore.  Well, once we convert all the algorithms across that
is :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
