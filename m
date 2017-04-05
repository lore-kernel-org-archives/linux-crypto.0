From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG: handle 0 lengths in af_alg_make_sg
Date: Wed, 5 Apr 2017 20:50:12 +0800
Message-ID: <20170405125012.GA26558@gondor.apana.org.au>
References: <2380853.MJYDG7HQLD@positron.chronox.de>
 <2164576.cSnkze5bYl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37318 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932130AbdDEMwG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 08:52:06 -0400
Content-Disposition: inline
In-Reply-To: <2164576.cSnkze5bYl@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 01, 2017 at 07:46:39PM +0200, Stephan Müller wrote:
> Am Samstag, 1. April 2017, 17:04:28 CEST schrieb Stephan Müller:
> 
> Hi Herbert,
> 
> > Hi Herbert,
> > 
> > If you concur with the patch, I think it should go to 4.11 as well as
> > to stable.
> 
> After checking this issue again, I see that it is not triggerable in the 
> current code as the different af_alg users make sure that this function is not 
> called with 0.
> 
> I only triggered this issue during experimenting with the algif_skcipher and 
> algif_aead revamp as requested by you. During those experiments, I invoked 
> af_alg_make_sg with a len = 0.
> 
> Thus, this patch is not applicable for stable and 4.11.
> 
> Yet, I would suggest to consider this patch as a safeguard for any potential 
> programming errors.

So this is only possible with patches that have not been applied
yet? In that case please fold this into whichever patch series
that needs it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
