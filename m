Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3585C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983F1215EA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s3G0YEZf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437715AbfFLPrp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:47:45 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:38731 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437713AbfFLPro (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 11:47:44 -0400
Received: by mail-it1-f194.google.com with SMTP id e25so11344273itk.3
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 08:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jrz/0gJwK9Vl2uBzvkPvJdrPlNIk4CkfEMQob8aRK0g=;
        b=s3G0YEZfOOX/JVT8oSCvLvCpINdMKNUFWKDNi6P9PBvQte06WzAwxB8v4yk76zMwVt
         3Hb99ETiBRWnXmsMR1BRmcdin+dKmO/7hSnRupstkusafvn2canWynji2u0M6tRhvapS
         SAoYeSCDe09vPkbkR1E/HR2sPGWWj7qO5x3Lvw2wTgRtwxM1YI90ObOLLcTTAzKWigbN
         eMBsythfYyrCdJXTMxSMUjYfLltRstxi8LorkvYVXHs4AhrsJsoKtgJ95dkYnUjd6QIs
         gHNG3LYsJfF9JzfC3vaSrf1V4/sdFm+vpT4LIPb0m4c0r8S3U59nj7pb+Uo2+nHWeW6g
         WrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jrz/0gJwK9Vl2uBzvkPvJdrPlNIk4CkfEMQob8aRK0g=;
        b=Luwy6FIyZeTvJ/GKz8OkcGzP1WtEMGEVxxXcx1KKfwTAmg0LMy18snPNgapU5S4NVp
         2xOTnlk7rVso4/IFXM8R3eJlhWKrqIgy/FLI0E6cnc5yZmAtA8HpFeMua7JQXlLAmkYe
         35MOdU2PKHouWALTaldvXgHm3+7JDxom5Zu3RgXF0bvBrJ4GMOjicdycNQGCY47GKLqV
         imH6+POcvwo6+oGef/zq5QcWSrjslL5Qtmp3PNMnAOtBPynMrWGr2KshBQzvljwiSxZy
         qdrzsPmM3TAtgKugkCv1jQ0SkCK4oIcsyvUfhsmw0Rt11DYv5XHK1OdZJy8f0j4eiDgO
         Asfg==
X-Gm-Message-State: APjAAAVB4fc1udk+MaF6dyJOqTkPGMj+W/HkfLIUxWkR36n+3GLwLTVV
        91clTgutByvZ6oMw93fn2dByj2W29xi5uws8j5+BOwVBcpQ=
X-Google-Smtp-Source: APXvYqxFzDrXiKC0I+4YnmPZ1XnXxF4bah77+ScRffj9M0vh+xKosIYETma2+rsp9W0K/3RRtqoFPWgL9alwb3/hY/U=
X-Received: by 2002:a24:9cc6:: with SMTP id b189mr224418ite.104.1560354463801;
 Wed, 12 Jun 2019 08:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
 <20190611230938.19265-5-ard.biesheuvel@linaro.org> <20190612154255.GB680@sol.localdomain>
In-Reply-To: <20190612154255.GB680@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 12 Jun 2019 17:47:31 +0200
Message-ID: <CAKv+Gu-CQebCPCPLM8No7cdfkuDak4COdX7PXrRchRbqBeymXA@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] net/lib80211: move TKIP handling to ARC4 library code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 Jun 2019 at 17:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jun 12, 2019 at 01:09:35AM +0200, Ard Biesheuvel wrote:
> > The crypto API abstraction is not very useful for invoking ciphers
> > directly, especially in the case of arc4, which only has a generic
> > implementation in C. So let's invoke the library code directly.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  net/wireless/lib80211_crypt_tkip.c | 48 +++++++-------------
> >  1 file changed, 17 insertions(+), 31 deletions(-)
> >
>
> Doesn't net/wireless/Kconfig also need to be updated to add 'select
> CRYPTO_LIB_ARC4' to LIB80211_CRYPT_TKIP, like you did for LIB80211_CRYPT_WEP?
>

Indeed.
