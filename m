Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56400C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF1C20833
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 14:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RlgzUmgf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfFQOj6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 10:39:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38322 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbfFQOj6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 10:39:58 -0400
Received: by mail-io1-f66.google.com with SMTP id d12so13710140iod.5
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sv6MBkFuxNWS4Y7/ODJd1UzhH6pb23qCRtVaIHF/q+c=;
        b=RlgzUmgfx9yyf3BBvyHR0xyyMh+HYVVEyb+v0qWRWjZWwRwnft22o6i6RXitzgYxpt
         bM3fzgoVGnCZ8/KJSEsW0Gb32WP2cPFqMtVMP331n/L/EKo0nYYh/D2K1UFOsgA1ZCj3
         dcPtlokzdrTzbMOKnwurcUwqmR62ByudM9TcOJ3gSEdPjTbgXJQCkazD6LjYutdh+i5o
         RijbGxrM4qHBvHSocR6sbHd4ijRbwAUsQen7gjUB3Uv7A+SRQBZhejgBTXY7r194EFd0
         LeelsBjgL34ouhUOLzNzdusfidDaYD9kyzjC5wwUw1DhNVgHCq5BGmnFMV/sDSxwYfSS
         q7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sv6MBkFuxNWS4Y7/ODJd1UzhH6pb23qCRtVaIHF/q+c=;
        b=Nkx+iS9IDfkAvE2fD8m0sV0eklZmDXDcntMotzmSnAqSvmqlRMYrHHREbeX2zb9a5/
         Kx0CCudYqSc7B840BCI25U7163TEq59jIj7qspcyssovZE1Vk8iUNHcfidZfGt7QaoDY
         ITV9ERw3SHZnbbGSYBrBL0IBdEbW8rklLzQzwV/bu36sxEvG6OyGs3tmRbsmJujECjTk
         hjHGv+MD1+InIMmV8Xyhj/cn7NwLjzhZ/XY9d0JR7InUfNchzGdJBOYwyDsDMuMPYwcU
         ZklJegVcdvCrBAuawjUSSIT18hdw1+y3t0QwFULo+g82jPen82yb0dQKYsVTGO430sTP
         t4ag==
X-Gm-Message-State: APjAAAXmGbV7l3gZmi5wtelECY3t3evRvv7iIa87FrwDU8pJDALDUVig
        3WNNCQqIEgK37BccOYUIpVBNyh4d5vPYFL1f5mwSgQ==
X-Google-Smtp-Source: APXvYqyYa6j6Ch8HnyOd5iu7uBxGZ09vXQaTQDB4sfKP+VxQ9J+WjmYVU2uD8/bsKEKMsda+BAlZYfs5I2M96mF0JRs=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr16879074iom.283.1560782397535;
 Mon, 17 Jun 2019 07:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com>
 <8e58230a-cf0e-5a81-886b-6aa72a8e5265@gmail.com> <CAKv+Gu9sb0t6EC=MwVfqTw5TKtatK-c8k3ryNUhV8O0876NV7g@mail.gmail.com>
 <CAKv+Gu-LFShLW-Tt7hwBpni1vQRvv7k+L_bpP-wU86x88v+eRg@mail.gmail.com> <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
In-Reply-To: <90214c3d-55ef-cc3a-3a04-f200d6f96cfd@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 16:39:45 +0200
Message-ID: <CAKv+Gu82BLPWrX1UzUBLf7UB+qJT6ZPtkvJ2Sa9t28OpXArhnw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Jun 2019 at 16:35, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 17/06/2019 15:59, Ard Biesheuvel wrote:
> >
> > So my main question/showstopper at the moment is: which modes do we
> > need to support for ESSIV? Only CBC? Any skcipher? Or both skciphers
> > and AEADs?
>
> Support, or cover by internal test? I think you nee to support everything
> what dmcrypt currently allows, if you want to port dmcrypt to new API.
>
> I know of many systems that use aes-xts-essiv:sha256 (it does not make sense
> much but people just use it).
>
> Some people use serpent and twofish, but we allow any cipher that fits...
>

Sure,  that is all fine

> For the start, run this
> https://gitlab.com/cryptsetup/cryptsetup/blob/master/tests/mode-test
>
> In other words, if you add some additional limit, we are breaking backward compatibility.
> (Despite the configuration is "wrong" from the security point of view.)
>

Yes, but breaking backward compatibility only happens if you break
something that is actually being *used*. So sure,
xts(aes)-essiv:sha256 makes no sense but people use it anyway. But is
that also true for, say, gcm(aes)-essiv:sha256 ?
