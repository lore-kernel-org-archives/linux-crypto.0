Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58940C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBPF6J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPF6I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:58:08 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0CC305D3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:58:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSXHO-00BreG-R6; Thu, 16 Feb 2023 13:58:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 13:58:02 +0800
Date:   Thu, 16 Feb 2023 13:58:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/10] crypto: aead - Count error stats differently
Message-ID: <Y+3F6vmmSsy+NLZR@gondor.apana.org.au>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2H-00BVkZ-8X@formenos.hmeau.com>
 <Y+3AmZaoNJBO4xU0@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+3AmZaoNJBO4xU0@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 09:35:21PM -0800, Eric Biggers wrote:
> On Wed, Feb 15, 2023 at 05:25:09PM +0800, Herbert Xu wrote:
> >  int crypto_aead_encrypt(struct aead_request *req)
> >  {
> >  	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> > -	struct crypto_alg *alg = aead->base.__crt_alg;
> > +	struct aead_alg *alg = crypto_aead_alg(aead);
> >  	unsigned int cryptlen = req->cryptlen;
> 
> The cryptlen local variable is no longer needed.  Just use req->cryptlen below.

Thanks, I'll remove it.

> This could just check whether istat is NULL:

Yes but that would introduce an unnecessary branch when STATS
are enabled.  I agree that it makes no difference if you don't
enable STATS though.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
