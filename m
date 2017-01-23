From: Rabin Vincent <rabin.vincent@axis.com>
Subject: Re: [PATCH] crypto: tcrypt - Add mode to test specified algs
Date: Mon, 23 Jan 2017 16:13:04 +0100
Message-ID: <20170123151304.GA20450@axis.com>
References: <1484756700-10019-1-git-send-email-rabin.vincent@axis.com>
 <20170123141403.GC19957@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:44010 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWPNH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 10:13:07 -0500
Content-Disposition: inline
In-Reply-To: <20170123141403.GC19957@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 23, 2017 at 10:14:03PM +0800, Herbert Xu wrote:
> On Wed, Jan 18, 2017 at 05:25:00PM +0100, Rabin Vincent wrote:
> > From: Rabin Vincent <rabinv@axis.com>
> > tcrypt offers a bunch of mode= values to test various (groups of)
> > algorithms, but there is no way provided to test a subset of the
> > algorithms.  This adds a new mode=2000 which interprets alg= as a
> > colon-separated list of algorithms to test with alg_test().  Colon is
> > used since the names may contain commas.
> > 
> > This is useful during driver development and also for regression testing
> > to avoid the errors that are otherwise generated when attempting to test
> > non-enabled algorithms.
> > 
> >  # insmod tcrypt.ko dyndbg mode=2000 alg="cbc(aes):ecb(aes):hmac(sha256):sha256:xts(aes)"
> >  [  649.418569] tcrypt: testing cbc(aes)
> >  [  649.420809] tcrypt: testing ecb(aes)
> >  [  649.422627] tcrypt: testing hmac(sha256)
> >  [  649.424861] tcrypt: testing sha256
> >  [  649.426368] tcrypt: testing xts(aes)
> >  [  649.430014] tcrypt: all tests passed
> > 
> > Signed-off-by: Rabin Vincent <rabinv@axis.com>
> 
> You can already do this with the existing mode=0 setting, no?

That's what I thought so too, but that doesn't seem to be the case.  The
mode=0 handling is this:

	switch (m) {
	case 0:
		if (alg) {
			if (!crypto_has_alg(alg, type,
					    mask ?: CRYPTO_ALG_TYPE_MASK))
				ret = -ENOENT;
			break;
		}

		for (i = 1; i < 200; i++)
			ret += do_test(NULL, 0, 0, i);
		break;

So, if alg= is specified, after first checking if the specified alg is
present, it just goes ahead and runs all the tests.  I'm not sure what
mode=0 alg=foo is meant to be used for.
