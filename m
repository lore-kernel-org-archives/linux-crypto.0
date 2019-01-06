Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ua1-f67.google.com ([209.85.222.67]:42018 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfAFKjL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 05:39:11 -0500
Received: by mail-ua1-f67.google.com with SMTP id d21so13317908uap.9
        for <linux-crypto@vger.kernel.org>; Sun, 06 Jan 2019 02:39:09 -0800 (PST)
MIME-Version: 1.0
References: <20190104041625.3259-1-ebiggers@kernel.org> <20190104041625.3259-4-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-4-ebiggers@kernel.org>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Sun, 6 Jan 2019 12:38:57 +0200
Message-ID: <CAOtvUMchF-g7SCG4OZtg4jGKue6XBGGF+HsW3Hr5bsL_aEnwhQ@mail.gmail.com>
Subject: Re: [PATCH 03/16] crypto: ofb - fix handling partial blocks and make thread-safe
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 4, 2019 at 6:20 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Fix multiple bugs in the OFB implementation:
>
> 1. It stored the per-request state 'cnt' in the tfm context, which can be
>    used by multiple threads concurrently (e.g. via AF_ALG).
> 2. It didn't support messages not a multiple of the block cipher size,
>    despite being a stream cipher.
> 3. It didn't set cra_blocksize to 1 to indicate it is a stream cipher.
>
> To fix these, set the 'chunksize' property to the cipher block size to
> guarantee that when walking through the scatterlist, a partial block can
> only occur at the end.  Then change the implementation to XOR a block at
> a time at first, then XOR the partial block at the end if needed.  This
> is the same way CTR and CFB are implemented.  As a bonus, this also
> improves performance in most cases over the current approach.


Well, it certainly looks like my implementation had a lot of room for
improvement :-)
Thank you for doing this, Eric

Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
