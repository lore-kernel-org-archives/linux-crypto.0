From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: dm-crypt IV generation (summary)
Date: Fri, 7 Apr 2017 14:12:26 +0800
Message-ID: <20170407061226.GA2282@gondor.apana.org.au>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
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
Received: from orcrist.hmeau.com ([104.223.48.154]:41912 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbdDGGNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Apr 2017 02:13:12 -0400
Content-Disposition: inline
In-Reply-To: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 10, 2017 at 02:44:26PM +0100, Ondrej Mosnacek wrote:
>
>     ISSUES:
>         a) The 'keycount' parameter.
>             In order to support multi-key modes from Loop-AES,
> dm-crypt accepts a keycount parameter which, if it != 1, causes
> consecutive sectors to be encrypted with a different key. This
> parameter can be specified with any of the cipher modes, which makes
> porting the whole scale of modes supported by dm-crypt to crypto API
> rather messy, since a lot of dm-crypt specific stuff needs to be moved
> into the crypto drivers.

Actually I think this one can probably easily handled in the crypto
layer.  All we need is to add a multikey template that sits on top
of an underlying IV generator.  The multikey instance can then accept
a key length that is a multiple of the underlying key length.

>         b) New AEAD functionality; random IV generator.
>             The soon-to-be-added AEAD functionality in dm-crypt
> introduces a new IV generator that generates IVs randomly and stores
> them as sector metadata. This means IV generation cannot be handled
> solely in the driver. Also, additional AEAD implementation of IV
> generators would be eventually needed.

Again I don't see the problem here.  IV generators are supposed
to return the IV to the caller so that it can be transmitted.

For example, the IV generated in IPsec is explicitly transmitted.
Here we just need to store the IV.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
