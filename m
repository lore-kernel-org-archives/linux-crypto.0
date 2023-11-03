Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C648CC4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 02:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjKCCeh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 22:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjKCCeg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 22:34:36 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8FB125
        for <linux-crypto@vger.kernel.org>; Thu,  2 Nov 2023 19:34:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-540c54944c4so3183499a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Nov 2023 19:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698978869; x=1699583669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83Mh0Hre2kxUrqYxpVjiCMzDqfE2crUP+cBGGsoLEyY=;
        b=S2aQEWCAJPMS0Rd8RKVTkbSyVYThUf+sYKWWUH7RJgsA4SpOTbfO/GiH4BBbhZeFoS
         RrEO/ucxqVnBqAyf14muUyVquYYRBWUlY/UPgkrqKlDBsaUC0vszIpcs6nadxD2RC9lN
         9PEIIACcVWRJDjSKpEu2Lo9Sa5wxKuEXXyJ5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698978869; x=1699583669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83Mh0Hre2kxUrqYxpVjiCMzDqfE2crUP+cBGGsoLEyY=;
        b=qh0nz3546SLLSgPvL90pYzOqtk07Wot58UHOMEw9dLPLCQdq5X2p6rFujgKMLkDzDK
         BIRYmsPhQq7YyWGUKtZEWvfKTNIcq7lFkNa+17kc2mHNGyMMQ91CW6MxubxIDqexQXgi
         Mf4ibv6389pz7Lr92o3xWfit5nF18IY/Gy2XDsEn7A0zImMaMq9WPGv0FsG84BdSMyOa
         lUpGibx2vomjsTExi02QPK5nyvmUSfdUbVASghFq4VMz4aXu6x05VlsTZH4weT8tLFjD
         PimHoV4FZEKuT/GtL2F40y7p8pBphdIlRKfgKXAMzbQkCL2/UNWxNrzDKEQl6MSnoKK+
         3C1Q==
X-Gm-Message-State: AOJu0Yx5dWRd6kuu6X66C9IZKAZpHw+ci+57LPKZkCEJe+/rtYYnvqwh
        uRwGkTOVPAOJnwKVMJOToTaIV3obh9yP/gb4K/FFUQHy
X-Google-Smtp-Source: AGHT+IEcCAEVNmFFb8mWWnANOX6jTtcJTF5+dgX3Ldd2NcvdAyXvKbiv/Ma1B276dXGEJl2vx2E+IA==
X-Received: by 2002:a05:6402:50d2:b0:51d:b184:efd with SMTP id h18-20020a05640250d200b0051db1840efdmr1262336edb.20.1698978869143;
        Thu, 02 Nov 2023 19:34:29 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id f29-20020a50a6dd000000b0053dff5568acsm404431edc.58.2023.11.02.19.34.28
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 19:34:28 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-9adb9fa7200so322104066b.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Nov 2023 19:34:28 -0700 (PDT)
X-Received: by 2002:a17:906:c450:b0:9a5:c38d:6b75 with SMTP id
 ck16-20020a170906c45000b009a5c38d6b75mr1120736ejb.15.1698978868229; Thu, 02
 Nov 2023 19:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <YjE5yThYIzih2kM6@gondor.apana.org.au> <YkUdKiJflWqxBmx5@gondor.apana.org.au>
 <YpC1/rWeVgMoA5X1@gondor.apana.org.au> <Yui+kNeY+Qg4fKVl@gondor.apana.org.au>
 <Yzv0wXi4Uu2WND37@gondor.apana.org.au> <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au> <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au> <ZOxnTFhchkTvKpZV@gondor.apana.org.au> <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
In-Reply-To: <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Nov 2023 16:34:11 -1000
X-Gmail-Original-Message-ID: <CAHk-=wj0-QNH5gMeYs3b+LU-isJyE4Eu9p8vVH9fb-vHHmUw0g@mail.gmail.com>
Message-ID: <CAHk-=wj0-QNH5gMeYs3b+LU-isJyE4Eu9p8vVH9fb-vHHmUw0g@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.7
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 1 Nov 2023 at 20:56, Herbert Xu <herbert@gondor.apana.org.au> wrote=
:
>
> Stephan M=C3=BCller (5):
>       crypto: jitter - add RCT/APT support for different OSRs
>       crypto: jitter - Allow configuration of memory size
>       crypto: jitter - Allow configuration of oversampling rate
>       crypto: jitter - reuse allocated entropy collector
>       crypto: jitter - use permanent health test storage

This is beyond annoying.

These are adding Kconfig questions that don't make sense. The whole
jitter thing is debatably useful in the first place, and now you just
annoy users with random questions.

And I mean truly random - the whole jitter entropy is voodoo
programming to begin with, and having some crazy 8MB buffer for it is
just ridiculous.

Honestly, this all smells like somebody's PhD thesis, not a real life thing=
.

And no, we don't make our Kconfig questions more annoying for some PhD thes=
is.

We also don't ask people questions that don't have valid answers. Just
because the whole "what is entropy in the first place" isn't
clear-cut, we don't then punt some tweaking question to the user.

We have a very simple and stupid jitter entropy thing AT BOOT TIME
just to try to generate some amount of entropy to make boots
non-repeatable (see "try_to_generate_entropy()" in
drivers/char/random.c).

Honestly, the whole crypto layer one is ridiculous overkill in the
first place, but the annoying new questions have now literally made me
consider just removing it entirely.

Because no, IT IS NOT OK TO ASK CRAZY QUESTIONS. If some developer
cannot come up with a reasonable answer, a random user sure has hell
cannot.

And no, any question that says "do you want to use 8MB of memory for
jitter entropy" is just batsh*t crazy.

This kind of crap needs to stop.

If somebody wants to do this kind of thing, just do it in user space.
It's ridiculously pointless in the kernel.

Convince me I'm wrong. But there is no way in *hell* you will convince
me that we should ask users about some jitter memory sizing.
Allocating memory for timing analysis is silly to begin with, since
any kernel thing could just use the physical memory mapping we already
have in the kernel. I suspect strongly that all this code has been
influenced by code running in user space, where it belongs, and where
you do need to allocate memory to have it available.

Please just make this noise go away.

             Linus
