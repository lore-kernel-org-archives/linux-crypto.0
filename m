Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCE0C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 891E4206BA
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553276922;
	bh=+pF7qIwcjTl7K54ijiv4ebjBmWQnq15K3Q5kaNtf6sE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SN50fuQJZyDp0tcOwa6QuMZFpDLIVRlcSYKfIIt3EYGamUEGZQbbX701s/QxEUz4m
	 mCpXkRgHDe9uKu6G4+IYXvvt6v3vmoG0Rvm4rGypYdblxL3KvuLWx7r3zb0KqsemnQ
	 rCQFUR56h2PGrk2DWeYpkfKefzRFVWGFeE2nyx7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfCVRsl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 13:48:41 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38172 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfCVRsl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 13:48:41 -0400
Received: by mail-lj1-f195.google.com with SMTP id p14so1797330ljg.5
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2019 10:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8m8qhWDBjWqa7fntMBLESHaGmro+6lwh8566Qfdifhk=;
        b=Hx40yLghBsxHOA3JVS3XgQ7Yvy5tQne7YNIbVG7/BZdyX8QMi3CIwKyP9otm0r1K2c
         A51sUudjhu865BW9SYnZVy7KN1T69TGoSTxgqyQYD7f5EPgTxDc5W2xwOpMjXGA/Z0vN
         sNWuoAm5P/wEIn/FRRi+ekcaNabG8UHy5iVwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8m8qhWDBjWqa7fntMBLESHaGmro+6lwh8566Qfdifhk=;
        b=Sq3wQdfClyQCxIcflhqXJXYdqPGEkDju/QQmR6gfC1u79tBKAI4cvrWqPEHIkXzfBv
         RkPvMu4QeVOZ5km125Tzln9vWGpYxr9o2o80RdX4foBBVd9PN7Bif/6Xa8/oIA1T0BVr
         uXQa6o/NVuY9fyozKX3FV9znekzlGiBv9lD7LboZ8qz5H6Ctwqh4aHoP9ej6cDujqNk9
         jukH86Wm8kHOyuxb8JtOQrGIJIs1Cx7ybab8p3DvqVVsl6iQe/6p0ee1mMPiERCUA6Ra
         IbVL8ihVSEaYzl/TPKPXQWKmUxeiSpa2hwZ1frz6iG8M4L8I9Y1ZvpXnTxBdeWa0TBA+
         atwQ==
X-Gm-Message-State: APjAAAVhjauVqHynKmwACdvxTWPUPPGQWbDC+GoJlAQHsP2bejs9ijJO
        FxR7TthXhdY56ry7VOCh8bljseecv4I=
X-Google-Smtp-Source: APXvYqzsZ8a4tWhBd5327J9e/tf6X9aJDqEqOXd2xMAcBXdG4F2sIVBUX6bdKy/7Utkvsamp0D9EUQ==
X-Received: by 2002:a2e:9a91:: with SMTP id p17mr5617393lji.127.1553276918609;
        Fri, 22 Mar 2019 10:48:38 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id f22sm1948013ljk.18.2019.03.22.10.48.36
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 10:48:37 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id f18so2754730lja.10
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2019 10:48:36 -0700 (PDT)
X-Received: by 2002:a2e:3e0e:: with SMTP id l14mr630483lja.125.1553276916674;
 Fri, 22 Mar 2019 10:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au> <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 22 Mar 2019 10:48:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
Message-ID: <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
Subject: Re: [PATCH 0/17] Add zinc using existing algorithm implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 22, 2019 at 12:56 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> - The way WireGuard uses crypto in the kernel is essentially a
> layering violation

What? No.

That's just wrong.

It's only a layering violation if you accept and buy into the crypto/ model.

And Jason obviously doesn't.

And honestly, I'm 1000% with Jason on this. The crypto/ model is hard
to use, inefficient, and completely pointless when you know what your
cipher or hash algorithm is, and your CPU just does it well directly.

> we even have support already for async accelerators that implement it,

Afaik, none of the async accelerator code has ever been worth anything
on real hardware and on any sane and real loads. The cost of going
outside the CPU is *so* expensive that you'll always lose, unless the
algorithm has been explicitly designed to be insanely hard on a
regular CPU.

(Corollary: "insanely hard on a regular CPU" is also easy to do by
making the CPU be weak and bad. Which is not a case we should optimize
for).

The whole "external accelerator" model is odd. It was wrong. It only
makes sense if the accelerator does *everything* (ie it's the network
card), and then you wouldn't use the wireguard thing on the CPU at
all, you'd have all those things on the accelerator (ie a "network
card that does WG").

One of the (best or worst, depending on your hangups) arguments for
external accelerators has been "but I trust the external hardware with
the key, but not my own code", aka the TPM or Disney argument.  I
don't think that's at all relevant to the discussion either.

The whole model of async accelerators is completely bogus. The only
crypto or hash accelerator that is worth it are the ones integrated on
the CPU cores, which have the direct access to caches.

And if the accelerator is some tightly coupled thing that has direct
access to your caches, and doesn't need interrupt overhead or address
translation etc (at which point it can be worth using) then you might
as well just consider it an odd version of the above. You'd want to
poll for the result anyway, because not polling is too expensive.

Just a single interrupt would completely undo all the advantages you
got from using specialized hardware - both power and performance.

And that kind of model would work just fine with zinc.

So an accelerator ends up being useful in two cases:

 - it's entirely external and part of the network card, so that
there's no extra data transfer overhead

 - it's tightly coupled enough (either CPU instructions or some on-die
cache coherent engine) that you can and will just use it synchronously
anyway.

In the first case, you wouldn't run wireguard on the CPU anyway - you
have a network card that just implements the VPN.

And in the second case, the zinc model is the right one.

So no. I don't believe "layering violation" is the issue here at all.

The only main issue as far as I'm concerned is how to deal with the
fact that we have duplicate code and effort.

                      Linus
