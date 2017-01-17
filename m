From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Tue, 17 Jan 2017 09:20:11 +0000
Message-ID: <CAKv+Gu_8dkkMUpd5FoNqXoPM-1LQcALWYxZ5c-Er9xWBFmMJgQ@mail.gmail.com>
References: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org> <20170117091152.GA31379@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33912 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdAQJUM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 04:20:12 -0500
Received: by mail-io0-f175.google.com with SMTP id l66so110329137ioi.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2017 01:20:12 -0800 (PST)
In-Reply-To: <20170117091152.GA31379@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 January 2017 at 09:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jan 16, 2017 at 09:16:35AM +0000, Ard Biesheuvel wrote:
>> Since the skcipher conversion in commit 0605c41cc53c ("crypto:
>> cts - Convert to skcipher"), the cts code tacitly assumes that
>> the underlying CBC encryption transform performed on the first
>> part of the plaintext returns an IV in req->iv that is suitable
>> for encrypting the final bit.
>>
>> While this is usually the case, it is not mandated by the API, and
>> given that the CTS code already accesses the ciphertext scatterlist
>> to retrieve those bytes, we can simply copy them into req->iv before
>> proceeding.
>
> Ugh while there are some legacy drivers that break this is certainly
> part of the API.
>
> Which underlying CBC implementation is breaking this?
>

arch/arm64/crypto/aes-modes.S does not return the IV back to the
caller, so cts(cbc-aes-ce) is currently broken.

So to be clear, it is part of the API that after calling
crypto_skcipher_encrypt(req), and completing the request, req->iv
should contain a value that could potentially be used to encrypt
additional data? That sounds highly specific to CBC (e.g., this could
never work with XTS, since the tweak generation is only performed
once), so it does not make sense for skciphers in general. For
instance, drivers for h/w peripherals that never need to map the data
to begin with (since they only pass the physical addresses to the
hardware) will need to explicitly map the destination buffer to
retrieve those bytes, on the off chance that the transform may be
wrapped by CTS.
