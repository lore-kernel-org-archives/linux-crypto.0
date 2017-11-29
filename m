From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Fix NULL pointer deref. on no default_rng
Date: Wed, 29 Nov 2017 17:34:30 +1100
Message-ID: <20171129063430.GD21575@gondor.apana.org.au>
References: <20171112142432.20186-1-pinaraf@pinaraf.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Pierre Ducroquet <pinaraf@pinaraf.info>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40634 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdK2Gen (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:34:43 -0500
Content-Disposition: inline
In-Reply-To: <20171112142432.20186-1-pinaraf@pinaraf.info>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 12, 2017 at 03:24:32PM +0100, Pierre Ducroquet wrote:
> If crypto_get_default_rng returns an error, the
> function ecc_gen_privkey should return an error.
> Instead, it currently tries to use the default_rng
> nevertheless, thus creating a kernel panic with a
> NULL pointer dereference.
> Returning the error directly, as was supposedly
> intended when looking at the code, fixes this.
> 
> Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
