Return-Path: <SRS0=Xb3v=UI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E0C28EBD
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 12:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4AB212F5
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 12:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KjaluRhy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbfFIMDs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Jun 2019 08:03:48 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51746 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfFIMDs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jun 2019 08:03:48 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so9280417itl.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jun 2019 05:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1/bKLuVcbf3mtJNnphXn7xbCzCXGczFCO3JRU8fVqI=;
        b=KjaluRhy+z1Hvyspgcr7P0LcwP5lKwhU6W/HLjIsuM1JHokdqFChdfzcQ8BnMjZUFH
         Gpm4Htd3enLolmd5eNeaUplucjdKLiSzX7QuUhzL6TLbcRptu2Bv7Z8TYcWB+gD1ge4I
         CZpxO+dUU+XMKZSJtd/EIhwJVrmB+nw1HxXtPQvoR/lcMjAXJl9UGeJMTW6VUt2YjT29
         iehFDbPK2MnzC10PDtnpDp5K9EhIGg3De/nvVgs4JvOunNwWRJ3vh3V6+TRt26PsF80O
         yjR/aJ49fUENOdzz5/tGPsrB/Xun0R2tA2zST0p8gBtIuVDQ9SBiwpT+0nO8hEKQlLRe
         J6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1/bKLuVcbf3mtJNnphXn7xbCzCXGczFCO3JRU8fVqI=;
        b=dtbWKOyUkK+NQmIqpTnZV+7IEUAXArhLasDxOiA1vYrF6gipRstn6adP3YZuF6mIut
         B4ONpgMbcffkeM/Y9UZ3O3x8dB1T2AR+4u2oDP4p0cz1kX/RoG8iF//b80nuV+QaWBEn
         QkTnzghC6Vjx4zlp9x4yRYUhAKvNiCZrRdamN1pyeIITZ2KReJ+lKrfEBe6+tC2SJvXW
         aXXO+QFis0jN9jvPokikrYya+Gcg53RP68OQ4pNb6CMWtRg3NTqTvwwq4/pUO1zzwZzU
         gvdGWo2c31kT3szs++CZ9y8czjX6CSegBG42O2RZ3uZRYO/jO0/EJgWi66rcYDrj/+3V
         UqRA==
X-Gm-Message-State: APjAAAWz9amfEfuN9U0KPOiaCO3yWIBn7HMGFm1kmOqx1QpazNpT4Ygy
        1LI1ceMeQic3ZATWe23wfQcEOXEfIcFOG3afuQWWIOBBiEk=
X-Google-Smtp-Source: APXvYqyMaG5P/xNdcAO7+cdMxn2EseLlaLu/DidLY2s9jsZNY1AOUkWM+wmAB2HSTmRqQqX6zyWgoSff6w55C1Y6yes=
X-Received: by 2002:a24:4f88:: with SMTP id c130mr9921295itb.104.1560081827323;
 Sun, 09 Jun 2019 05:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 9 Jun 2019 14:03:35 +0200
Message-ID: <CAKv+Gu_pbRGha9jO-5=d0d3Qtsi+=MLrrgfHaaiqtEzB3AEJmw@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] crypto: rc4 cleanup
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(adding Johannes back to the cover letter cc)

On Sun, 9 Jun 2019 at 13:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> This is a follow-up to, and supersedes [0], which moved some WEP code from
> the cipher to the skcipher interface, in order to reduce the use of the bare
> cipher interface in non-crypto subsystem code.
>
> Since using the skcipher interface to invoke the generic C implementation of
> an algorithm that is known at compile time is rather pointless, this series
> moves those users to a new arc4 library interface instead, which is based on
> the existing code.
>
> Along the way, the arc4 cipher implementation is removed entirely, and only
> the ecb(arc4) code is preserved, which is used in a number of places in the
> kernel, and is known to be used by at least 'iwd' from user space via the
> algif_skcipher API.
>
> [0] https://lore.kernel.org/linux-crypto/20190607144944.13485-1-ard.biesheuvel@linaro.org/
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Biggers <ebiggers@google.com>
>
> Ard Biesheuvel (7):
>   crypto: arc4 - refactor arc4 core code into separate library
>   net/mac80211: move WEP handling to ARC4 library interface
>   net/lib80211: move WEP handling to ARC4 library code
>   net/lib80211: move TKIP handling to ARC4 library code
>   crypto: arc4 - remove cipher implementation
>   ppp: mppe: switch to RC4 library interface
>   fs: cifs: switch to RC4 library interface
>
>  MAINTAINERS                        |   1 +
>  crypto/Kconfig                     |   4 +
>  crypto/arc4.c                      | 106 ++------------------
>  drivers/net/ppp/Kconfig            |   3 +-
>  drivers/net/ppp/ppp_mppe.c         |  92 ++---------------
>  fs/cifs/Kconfig                    |   2 +-
>  fs/cifs/cifsencrypt.c              |  50 +++------
>  include/crypto/arc4.h              |  13 +++
>  lib/Makefile                       |   2 +-
>  lib/crypto/Makefile                |   3 +
>  lib/crypto/libarc4.c               |  74 ++++++++++++++
>  net/mac80211/Kconfig               |   2 +-
>  net/mac80211/cfg.c                 |   3 -
>  net/mac80211/ieee80211_i.h         |   4 +-
>  net/mac80211/key.h                 |   1 +
>  net/mac80211/main.c                |  48 +--------
>  net/mac80211/mlme.c                |   2 -
>  net/mac80211/tkip.c                |   8 +-
>  net/mac80211/tkip.h                |   4 +-
>  net/mac80211/wep.c                 |  47 ++-------
>  net/mac80211/wep.h                 |   4 +-
>  net/mac80211/wpa.c                 |   4 +-
>  net/wireless/Kconfig               |   1 +
>  net/wireless/lib80211_crypt_tkip.c |  42 +++-----
>  net/wireless/lib80211_crypt_wep.c  |  43 ++------
>  25 files changed, 176 insertions(+), 387 deletions(-)
>  create mode 100644 lib/crypto/Makefile
>  create mode 100644 lib/crypto/libarc4.c
>
> --
> 2.20.1
>
