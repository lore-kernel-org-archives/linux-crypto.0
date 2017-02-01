From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - Add mode to test specified algs
Date: Wed, 1 Feb 2017 22:03:48 +0800
Message-ID: <20170201140348.GA32415@gondor.apana.org.au>
References: <1484756700-10019-1-git-send-email-rabin.vincent@axis.com>
 <20170123141403.GC19957@gondor.apana.org.au>
 <20170123151304.GA20450@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53279 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751060AbdBAOEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 09:04:01 -0500
Content-Disposition: inline
In-Reply-To: <20170123151304.GA20450@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 23, 2017 at 04:13:04PM +0100, Rabin Vincent wrote:
> 
> That's what I thought so too, but that doesn't seem to be the case.  The
> mode=0 handling is this:
> 
> 	switch (m) {
> 	case 0:
> 		if (alg) {
> 			if (!crypto_has_alg(alg, type,
> 					    mask ?: CRYPTO_ALG_TYPE_MASK))
> 				ret = -ENOENT;
> 			break;
> 		}
> 
> 		for (i = 1; i < 200; i++)
> 			ret += do_test(NULL, 0, 0, i);
> 		break;
> 
> So, if alg= is specified, after first checking if the specified alg is
> present, it just goes ahead and runs all the tests.  I'm not sure what
> mode=0 alg=foo is meant to be used for.

You need to set the type and mask for it to work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
