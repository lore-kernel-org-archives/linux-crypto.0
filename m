Return-Path: <SRS0=ZGow=UW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4219C43613
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 09:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B6C20820
	for <linux-crypto@archiver.kernel.org>; Sun, 23 Jun 2019 09:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XIWvSciJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfFWJaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Jun 2019 05:30:55 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45625 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfFWJaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jun 2019 05:30:55 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so1946328ioc.12
        for <linux-crypto@vger.kernel.org>; Sun, 23 Jun 2019 02:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvgYQJkZGqcc1lfJilFFMb7xsNi0HiPMMJpo064zefM=;
        b=XIWvSciJXTWxUHdpOJ/Jiw7mhnXChMAz38UwfOCNYhyxtiP5995AZVApj5EI1r64qE
         G5Wb50bCXsb63Sy0BT9k05wbOEaMxUv54DGQFr61UYycrgIvHMzur3LWuloXlUEBCCaw
         dtFMdlCVVo3+ieBGYj2lThfkRy8GABw5srKabwQYjzqsUnZt0LRsesAbKNb+ATr9jcPw
         iah80UTd4lExTLdH1RzhcUQ4it23dakXPQiMyqQpY4Yp0RS8wvEIV6o8w/mkaNN5d98P
         yAk/MjnWrm0JKZw9hhyk9KJDeSjzHSgAZL2sMFJOkgPmwLTOa2yjnFos/mv5KvelBlLz
         29rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvgYQJkZGqcc1lfJilFFMb7xsNi0HiPMMJpo064zefM=;
        b=KOpnSN3LE/n4OWHXSamZSTvR4+vPRkxcuAULZO9cd7bZ1Q7c2LjJkjRQolEYWDhqMi
         7D7cAjo/YEFk/0WVnV0xWmy0FMsLbahP98u/+XPIk9QsDeNt2kw5p7RJPX0mz5Nj0muk
         06rq7F5eCfp2NVSV99DTdPHCgadu268kem2LLUl42hkMml4dayfaJUG4EAtj8sqvf/Rj
         EY65CE8BkIlZ17D05o3eKXoCCfPIcNXaKFP8ZgJxuG/daHin9ftnwHNs8hPZg437tRB3
         yc+FciytUgM6kajiVSrcmeepo16fYmFhg8dn+Uh5EcbMZntP/ussU2p7geqit5Km5sMe
         5Klg==
X-Gm-Message-State: APjAAAUCy5Z+Jjc2NFchGZlww/fmQ2suoofjBXJee/eYfo5gJWj9Ue9c
        WgAoLl9advZFaS5tVc741qLINCRcW/m6xCc84R7esw==
X-Google-Smtp-Source: APXvYqw231WPDSV0vp3+/kcuJTLLvj6P/KErcOQKt6Gw4rdKpxSKVjzoeHQpp0qSCZAo3xz5kn3MmfYU0+FjLta6sSY=
X-Received: by 2002:a5e:d51a:: with SMTP id e26mr503654iom.71.1561282254656;
 Sun, 23 Jun 2019 02:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
In-Reply-To: <20190621080918.22809-1-ard.biesheuvel@arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 23 Jun 2019 11:30:41 +0200
Message-ID: <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 21 Jun 2019 at 10:09, Ard Biesheuvel <ard.biesheuvel@arm.com> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
...
>
> - given that hardware already exists that can perform en/decryption including
>   ESSIV generation of a range of blocks, it would be useful to encapsulate
>   this in the ESSIV template, and teach at least dm-crypt how to use it
>   (given that it often processes 8 512-byte sectors at a time)

I thought about this a bit more, and it occurred to me that the
capability of issuing several sectors at a time and letting the lower
layers increment the IV between sectors is orthogonal to whether ESSIV
is being used or not, and so it probably belongs in another wrapper.

I.e., if we define a skcipher template like dmplain64le(), which is
defined as taking a sector size as part of the key, and which
increments a 64 LE counter between sectors if multiple are passed, it
can be used not only for ESSIV but also for XTS, which I assume can be
h/w accelerated in the same way.

So with that in mind, I think we should decouple the multi-sector
discussion and leave it for a followup series, preferably proposed by
someone who also has access to some hardware to prototype it on.
