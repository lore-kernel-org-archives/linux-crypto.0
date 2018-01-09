From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: clear htmldocs build warnings for crypto/hash
Date: Tue, 9 Jan 2018 18:41:33 +1100
Message-ID: <20180109074133.GA10094@gondor.apana.org.au>
References: <CGME20180106230157epcas2p2a3dc70ac85fbd7861ddf916fde5dd2be@epcas2p2.samsung.com>
 <1515279703-14070-1-git-send-email-me@tobin.cc>
 <724b85c9-f3df-15b2-7aa2-4089f232c155@partner.samsung.com>
 <20180108155619.GA5350@gondor.apana.org.au>
 <2b4fa5b0-dadb-47fe-2bbd-b051ad343bc4@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Tobin C. Harding" <me@tobin.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:53888 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbeAIHlw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Jan 2018 02:41:52 -0500
Content-Disposition: inline
In-Reply-To: <2b4fa5b0-dadb-47fe-2bbd-b051ad343bc4@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 08, 2018 at 05:43:18PM +0100, Kamil Konieczny wrote:

> Is it mandatory for both async hash and shash ?
> 
> in crypto/ahash.c in function
> 
> static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
> 
> there is:
> 
> 	hash->export = ahash_no_export;
> 	hash->import = ahash_no_import;
> 
> and later in the same function:
> 
> 	if (alg->export)
> 		hash->export = alg->export;
> 	if (alg->import)
> 		hash->import = alg->import;

That's just a leftover from the old days before we started requiring
them.  These should be removed so that the registration fails if
they're not provided.

The requirement has been in place for a while now and we have been
failing any algorithms with a zero statesize which is only used by
import/export.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
