Return-Path: <SRS0=09LE=QH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD54C282D9
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 09:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 939B120B1F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Jan 2019 09:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfAaJF3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Jan 2019 04:05:29 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41589 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfAaJF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Jan 2019 04:05:29 -0500
Received: by mail-oi1-f196.google.com with SMTP id j21so2096291oii.8
        for <linux-crypto@vger.kernel.org>; Thu, 31 Jan 2019 01:05:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIuaQy3oXLliDQ1OXJvDPvmuJ+EYkvpUsfkbj+cxM90=;
        b=IPPR697ZdKAaDcMTidVE7H/kn5Qu+kgxqEbsWhE9U+cjPQjRW0I9hiDMkdXSMF5HKA
         SfG683HHg83pu24g6wB3o0/CweKcJxgfHqVVL77qLJiWrMjC3xprPT9ZlCZVSwfc2khH
         gjswQTe8u6UFxLfV+Hd8uOSlypXd3M2+zZmJlxldBvquSwoxFu5cNCYAKApmDhrkddnZ
         01SXptc2FiKarDQMX4whkELTDUCkNkDhftzCeivEbiM2clPLbxFL+EOyN9GzO0T2+A87
         L5xutlnOXURzOimWCrAMbdXFGSGW/rT4N4Pea30GimxG9mFZX7YkGdx0SM2I3BYva9XG
         iFkA==
X-Gm-Message-State: AJcUukcna8hvaaSaPaErZ9HHRU6zhZuZYbXd/X4rsGaPFHIRXeG3OEWU
        ag3Pct57LIdtXdTUtBxOQILTMAilhUalXyShbfOvieae
X-Google-Smtp-Source: ALg8bN5UyaRl3IfwMVPjrubA/yjJ5ePDHRWuk1mrGVr6RXmM4pB17NiCxOx3PXQvZAp8dtjct9EYKDeMVhOprtlxA08=
X-Received: by 2002:aca:4b8f:: with SMTP id y137mr15119422oia.132.1548925528134;
 Thu, 31 Jan 2019 01:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20190123224926.250525-1-ebiggers@kernel.org> <20190123224926.250525-3-ebiggers@kernel.org>
In-Reply-To: <20190123224926.250525-3-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 31 Jan 2019 10:05:17 +0100
Message-ID: <CAFqZXNv+=qgg+Jo4iC72D++BmoxK4S0XiKED47M7MQJjFtMYRw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 02/15] crypto: morus - fix handling chunked inputs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Wed, Jan 23, 2019 at 11:52 PM Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The generic MORUS implementations all fail the improved AEAD tests
> because they produce the wrong result with some data layouts.  Fix them.
>
> Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementations")
> Cc: <stable@vger.kernel.org> # v4.18+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/morus1280.c | 13 +++++++------
>  crypto/morus640.c  | 13 +++++++------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/crypto/morus1280.c b/crypto/morus1280.c
> index 3889c188f266..b83576b4eb55 100644
> --- a/crypto/morus1280.c
> +++ b/crypto/morus1280.c
> @@ -366,18 +366,19 @@ static void crypto_morus1280_process_crypt(struct morus1280_state *state,
>                                            const struct morus1280_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *dst;
> -       const u8 *src;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, walk.nbytes);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }

Hm... I assume the problem was that skcipher_walk may give you nbytes
that is not rounded to the algorithm's walksize (aka walk.stride) even
in the middle of the stream, right? I must have misread the code in
skcipher.c and assumed that it automatically makes every step of a
round size, with the exception of the very last one, which may include
a final partial block. Thinking about it now it makes sense to me that
this isn't the case, since for stream ciphers it would mean some
unnecessary memcpy'ing in the skcipher_walk code...

Maybe you could explain the problem in one or two sentences in the
commit message(s), since the contract of skcipher_walk doesn't seem to
be documented anywhere and so it is not obvious why the change is
necessary.

Thank you for all your work on this - the improved testmgr tests were
long needed!

>  }
>
> diff --git a/crypto/morus640.c b/crypto/morus640.c
> index da06ec2f6a80..b6a477444f6d 100644
> --- a/crypto/morus640.c
> +++ b/crypto/morus640.c
> @@ -365,18 +365,19 @@ static void crypto_morus640_process_crypt(struct morus640_state *state,
>                                           const struct morus640_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *dst;
> -       const u8 *src;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, walk.nbytes);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> --
> 2.20.1.321.g9e740568ce-goog
>

--
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
