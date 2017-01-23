From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt - Add mode to test specified algs
Date: Mon, 23 Jan 2017 22:14:03 +0800
Message-ID: <20170123141403.GC19957@gondor.apana.org.au>
References: <1484756700-10019-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41439 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751083AbdAWPAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 10:00:06 -0500
Content-Disposition: inline
In-Reply-To: <1484756700-10019-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2017 at 05:25:00PM +0100, Rabin Vincent wrote:
> From: Rabin Vincent <rabinv@axis.com>
> 
> tcrypt offers a bunch of mode= values to test various (groups of)
> algorithms, but there is no way provided to test a subset of the
> algorithms.  This adds a new mode=2000 which interprets alg= as a
> colon-separated list of algorithms to test with alg_test().  Colon is
> used since the names may contain commas.
> 
> This is useful during driver development and also for regression testing
> to avoid the errors that are otherwise generated when attempting to test
> non-enabled algorithms.
> 
>  # insmod tcrypt.ko dyndbg mode=2000 alg="cbc(aes):ecb(aes):hmac(sha256):sha256:xts(aes)"
>  [  649.418569] tcrypt: testing cbc(aes)
>  [  649.420809] tcrypt: testing ecb(aes)
>  [  649.422627] tcrypt: testing hmac(sha256)
>  [  649.424861] tcrypt: testing sha256
>  [  649.426368] tcrypt: testing xts(aes)
>  [  649.430014] tcrypt: all tests passed
> 
> Signed-off-by: Rabin Vincent <rabinv@axis.com>

You can already do this with the existing mode=0 setting, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
