From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 4.2
Date: Wed, 24 Jun 2015 21:29:37 +0800
Message-ID: <20150624132937.GA32020@gondor.apana.org.au>
References: <20140123115319.GA20602@gondor.apana.org.au>
 <20140401100001.GA12386@gondor.apana.org.au>
 <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <CA+55aFyQW-Em8weHOBDVYw08H=-RfbeXJg61Zv6T-35rTdXB+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53689 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbbFXN3s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 09:29:48 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyQW-Em8weHOBDVYw08H=-RfbeXJg61Zv6T-35rTdXB+g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2015 at 07:11:19PM -0700, Linus Torvalds wrote:
> On Mon, Jun 22, 2015 at 1:44 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Here is the crypto update for 4.2:
> 
> Hmm. I noticed a new annoyance:
> 
> I get this at bootup:
> 
>   [  +0.001504] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)

This is indeed bogus and I'll make sure it disappears.

>   [  +0.002233] alg: aead: setkey failed on test 1 for
> rfc4106-gcm-aesni: flags=0

This however is a real bug.  It looks like aesni is somehow broken
and is failing on setkey.  I'll look into it.

> in general, I'm not at all convinced that the crypto tests make sense.
> I absolutely destest that horrid "testmgr.h" file that is 32
> _thousand_ lines of noise. And now it's apparently complaining about a
> missing test, so that nasty mess will presumably grow.
> 
> Could you not make the test infrastructure be something that gets run
> in user space?

I too think the current testmgr model has reached its limit.
However, it has been quite useful in catching bugs like the
one you saw which may otherwise result in hard-to-track-down
bugs in other subsystems such as IPsec or disk encryption.

What I was planning to do is to instead bundle the test vectors
with the algorithms themselves.  So for each algorithm we would
have the test vectors in the canonical C implementation which then
would be used to test every other implmenetation of that algorithm.

The test code could similarly be distributed out to the individual
types, e.g., RNG tests would go into rng.c, hash tests into ahash.c,
etc.

When this is done there would be no central repository of testing
information anymore.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
