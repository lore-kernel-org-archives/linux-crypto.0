From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Thu, 27 Jan 2011 09:33:15 +1000
Message-ID: <20110126233315.GB26664@gondor.apana.org.au>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com> <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com> <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com> <20110126070939.GA18150@gondor.apana.org.au> <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40651 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1AZXdR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 18:33:17 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 26, 2011 at 11:20:22AM +0330, Hamid Nassiby wrote:
>
> Do you mean that different IP packets fit into one single Block Cipher tfm?
> Would you please explain expansively?

We allocate one tfm per SA.  So as long as ordering is guaranteed
per SA then it's guaranteed per SA which is all that's needed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
