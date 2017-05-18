From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: dm-crypt IV generation (summary)
Date: Thu, 18 May 2017 13:40:38 +0200
Message-ID: <CAFqZXNvp0qgEMUqi8o3o8ZVhMwYngkdV5WePx+KRq+rAMEu2kg@mail.gmail.com>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
 <20170407061226.GA2282@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35774 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbdERLkt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 07:40:49 -0400
Received: by mail-oi0-f41.google.com with SMTP id l18so50155641oig.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 May 2017 04:40:39 -0700 (PDT)
In-Reply-To: <20170407061226.GA2282@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-04-07 8:12 GMT+02:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Fri, Mar 10, 2017 at 02:44:26PM +0100, Ondrej Mosnacek wrote:
>>
>>     ISSUES:
>>         a) The 'keycount' parameter.
>>             In order to support multi-key modes from Loop-AES,
>> dm-crypt accepts a keycount parameter which, if it != 1, causes
>> consecutive sectors to be encrypted with a different key. This
>> parameter can be specified with any of the cipher modes, which makes
>> porting the whole scale of modes supported by dm-crypt to crypto API
>> rather messy, since a lot of dm-crypt specific stuff needs to be moved
>> into the crypto drivers.
>
> Actually I think this one can probably easily handled in the crypto
> layer.  All we need is to add a multikey template that sits on top
> of an underlying IV generator.  The multikey instance can then accept
> a key length that is a multiple of the underlying key length.

I thought of that, too, but unfortunately with TCW the key structure is:

| KEY 1 | KEY 2 | ... | KEY n | IV SEED (size = IV size) | WHITENING
(size = 16 bytes) |

So part of the key needs to be processed before it is split into multiple keys.

Also with the LMK mode, there is a similar optional key appendix,
which is of the same size as the other subkeys.

>>         b) New AEAD functionality; random IV generator.
>>             The soon-to-be-added AEAD functionality in dm-crypt
>> introduces a new IV generator that generates IVs randomly and stores
>> them as sector metadata. This means IV generation cannot be handled
>> solely in the driver. Also, additional AEAD implementation of IV
>> generators would be eventually needed.
>
> Again I don't see the problem here.  IV generators are supposed
> to return the IV to the caller so that it can be transmitted.
>
> For example, the IV generated in IPsec is explicitly transmitted.
> Here we just need to store the IV.

My point is that it doesn't make much sense to have a crypto API alg
that calls get_random_bytes() as part of its implementation. IMHO,
that might tempt HW drivers to replace it with some crappy
alternatives, which wouldn't be good... Also, how would we test such
alg with testmgr?

I would say the best solution in this case would be to treat the
'random' IV mode as a special case in dm-crypt: the IVs would be
generated in dm-crypt and passed to a special template (which would
have a similar interface as the other IV generation templates) that
would just pass the generated IVs to underlying skciphers instead of
generating them from the sequence number. This template would need to
provide some way to pass the IVs, e.g. by prepending them to the
plaintext/ciphertext.

Cheers,
Ondrej
