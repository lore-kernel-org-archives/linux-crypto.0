Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:48171 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbeKTJ5U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 04:57:20 -0500
MIME-Version: 1.0
References: <20181105232526.173947-11-ebiggers@kernel.org> <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com> <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
 <20181117001718.GA175522@gmail.com> <CAHmME9rtsCk8ZLt05xRKMGr4CVRnaUvCaVOS_WX3N22HOat4-A@mail.gmail.com>
 <20181119052451.qttzfgcm4hvbdc4u@gondor.apana.org.au> <CAHmME9oXAnD0sbO2cKeTtotCMohX2Hu6P=uzA_6u0EWECU9Bpg@mail.gmail.com>
 <20181119225414.GB258711@gmail.com> <CAHmME9okRjuYUiL0D=6ZmtMX6rvxU+0xvy2tva+LetjU9itx8Q@mail.gmail.com>
 <20181119232345.GC258711@gmail.com>
In-Reply-To: <20181119232345.GC258711@gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 20 Nov 2018 00:31:02 +0100
Message-ID: <CAHmME9o9N0r55i4zHu5p-9wcKPsfVVhRC+kbzx0TYxSTZG5kbQ@mail.gmail.com>
Subject: Re: [RFC PATCH] zinc chacha20 generic implementation using crypto API code
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

On Tue, Nov 20, 2018 at 12:23 AM Eric Biggers <ebiggers@kernel.org> wrote:
> It's much better to have the documentation in a permanent location.

Agreed.

> I actually did add ChaCha12 support to most of the Zinc assembly in
> "[WIP] crypto: assembly support for ChaCha12"
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/commit/?h=adiantum-zinc&id=0a7787a515a977e11b680f1752b430ca1744e399).
> But I skipped AVX-512 and MIPS since I didn't have a way to test those yet,
> and I haven't ported the changes to your new perl scripts yet.

Oh, great. If you're playing with this in the context of the WireGuard
repo, you can run `ARCH=mips make test-qemu -j$(nproc)` (which is
what's running on https://www.wireguard.com/build-status/ ). For
AVX-512 testing, I've got a box I'm happy to give you access to, if
you want to send an SSH key and your employer allows for that kind of
thing etc. I can have a stab at all of this too if you like.

Jason
