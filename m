From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: dm-crypt IV generation (summary)
Date: Fri, 23 Jun 2017 16:49:36 +0800
Message-ID: <20170623084936.GA30510@gondor.apana.org.au>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
 <20170407061226.GA2282@gondor.apana.org.au>
 <CAFqZXNvp0qgEMUqi8o3o8ZVhMwYngkdV5WePx+KRq+rAMEu2kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36030 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753847AbdFWIt6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 04:49:58 -0400
Content-Disposition: inline
In-Reply-To: <CAFqZXNvp0qgEMUqi8o3o8ZVhMwYngkdV5WePx+KRq+rAMEu2kg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 18, 2017 at 01:40:38PM +0200, Ondrej Mosnacek wrote:
>
> > Actually I think this one can probably easily handled in the crypto
> > layer.  All we need is to add a multikey template that sits on top
> > of an underlying IV generator.  The multikey instance can then accept
> > a key length that is a multiple of the underlying key length.
> 
> I thought of that, too, but unfortunately with TCW the key structure is:
> 
> | KEY 1 | KEY 2 | ... | KEY n | IV SEED (size = IV size) | WHITENING
> (size = 16 bytes) |
> 
> So part of the key needs to be processed before it is split into multiple keys.
> 
> Also with the LMK mode, there is a similar optional key appendix,
> which is of the same size as the other subkeys.

The format of the key isn't an issue.  Because we're writing this
from scratch.  We can change the format in any way we want, e.g.,
we could include the value n if we wanted in the key stream.

Yes dm-crypt would need to massage the key before passing it over
to the crypto layer, but that should be pretty easy.

> My point is that it doesn't make much sense to have a crypto API alg
> that calls get_random_bytes() as part of its implementation. IMHO,
> that might tempt HW drivers to replace it with some crappy
> alternatives, which wouldn't be good... Also, how would we test such
> alg with testmgr?

You are right.  There is no way we can judge the quality of a
hardware IV generator, just as there is no way to judge the quality
of hardware RNG without looking at its internal structure.

But that doesn't mean that we shouldn't support them if they exist.

In any case, this scenario already exists today with IPsec where
we have multiple hardware implementations that generate the IV.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
