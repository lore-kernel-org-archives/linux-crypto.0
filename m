Return-Path: <SRS0=Mcmw=PN=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42888 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfAEDkT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 22:40:19 -0500
Date: Sat, 5 Jan 2019 11:40:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 01/16] crypto: cfb - add missing 'chunksize' property
Message-ID: <20190105034016.tfn2gtl6uwyguv3s@gondor.apana.org.au>
References: <20190104041625.3259-2-ebiggers@kernel.org>
 <20190104210311.5AC542087F@mail.kernel.org>
 <20190105030747.GA661@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190105030747.GA661@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 04, 2019 at 07:07:48PM -0800, Eric Biggers wrote:
>
> Herbert, why was CFB accepted without any test vectors in the first place?

That was an oversight.  Longer term we should restructure how
the test vectors are stored by moving them in with the generic
implementation.  That should also ensure that we would never
add an algorithm without both a generic implementation as well
as test vectors.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
