From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
Subject: Re: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Wed, 11 Jan 2017 15:55:11 +0100
Message-ID: <CAAUqJDvA9Qwci7DFF4j4_D_=zYz81Rn1cgEnmQhhOS-JWrpXGA@mail.gmail.com>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org> <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Binoy Jayan <binoy.jayan@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36697 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938055AbdAKOze (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 09:55:34 -0500
In-Reply-To: <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Binoy,

2016-12-13 9:49 GMT+01:00 Binoy Jayan <binoy.jayan@linaro.org>:
> Currently, the iv generation algorithms are implemented in dm-crypt.c.
> The goal is to move these algorithms from the dm layer to the kernel
> crypto layer by implementing them as template ciphers so they can be
> implemented in hardware for performance. As part of this patchset, the
> iv-generation code is moved from the dm layer to the crypto layer and
> adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
> at a time. Each bio contains the in memory representation of physically
> contiguous disk blocks. The dm layer sets up a chained scatterlist of
> these blocks split into physically contiguous segments in memory so that
> DMA can be performed. The iv generation algorithms implemented in geniv.c
> include plain, plain64, essiv, benbi, null, lmk and tcw.

I like what you are trying to achieve, however I don't think the
solution you are heading towards (passing sector number to a special
crypto template) would be the best approach here. Milan is currently
trying to add authenticated encryption support to dm-crypt (see [1])
and as part of this change, a new random IV mode would be introduced.
This mode generates a random IV for each sector write, includes it in
the authenticated data and stores it in the sector's metadata (in a
separate part of the disk). In this case dm-crypt will need to have
control over the IV generation (or at least be able to somehow
retrieve it after the crypto operation).

That said, I believe a different approach would be preferable here. I
would suggest, instead of moving the IV generation to the crypto
layer, to add a new type of request to skcipher API (let's call it
'skcipher_bulk_request'), which could be used to submit several
messages at once (together in a single sg list), each with their own
IV, to a skcipher. This would allow drivers to optimize handling of
such requests (e.g. the SIMD ciphers could call kernel_fpu_begin/end
just once for the whole request). It could be done in such a way, that
implementing this type of requests would be optional and a fallback
implementation, which would just split the request into regular
skcipher_requests, would be automatically set for the ciphers that do
not set it themselves. That way this would require no changes to
crypto drivers in the beginning and optimizations could be added
incrementally.

The advantage of this approach to handling such "bulk" requests is
that crypto drivers could just optimize regular algorithms (xts(aes),
cbc(aes), etc.) and wouldn't need to mess with dm-crypt-specific IV
generation. This also means that other users that could potentially
benefit from bulking requests (perhaps network stack?) could use the
same functionality.

I have been playing with this idea for some time now and I should have
an RFC patchset ready soon...

Binoy, Herbert, what do you think about such approach?

[1] https://www.redhat.com/archives/dm-devel/2017-January/msg00028.html

> When using multiple keys with the original dm-crypt, the key selection is
> made based on the sector number as:
>
> key_index = sector & (key_count - 1)
>
> This restricts the usage of the same key for encrypting/decrypting a
> single bio. One way to solve this is to move the key management code from
> dm-crypt to cryto layer. But this seems tricky when using template ciphers
> because, when multiple ciphers are instantiated from dm layer, each cipher
> instance set with a unique subkey (part of the bigger master key) and
> these instances themselves do not have access to each other's instances
> or contexts. This way, a single instance cannot encryt/decrypt a whole bio.
> This has to be fixed.

Please note that the "keycount" parameter was added to dm-crypt solely
for the purpose of implementing the loop-AES partition format. In
general, the security benefit gained by using keycount > 1 is
debatable, so it does not really make sense to use it for anything
else than accessing legacy loopAES partitions. Since Milan decided to
add it as a generic parameter, instead of hard-coding the
functionality for the LMK mode, it can be technically used also in
other combinations, but IMHO it is perfectly reasonable to just give
up on optimizing the cases when keycount > 1. I believe the loop-AES
partition support is just not that important :)

Thanks,
Ondrej
