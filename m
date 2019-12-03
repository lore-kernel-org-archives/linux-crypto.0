Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3E5C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 11:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003BC20674
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 11:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q5OqucyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfLCLnG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 06:43:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44253 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCLnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 06:43:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so3213778wrm.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 03:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WtzGmBHj0RGuxebJ0ct299uESioKozN0N+8U01Ge8gY=;
        b=q5OqucyLgIWO5exq6evNbkJa6XVF/JPsAdp1bQJwd4ZSEd1y9/b3E4i/QGQqBMOQp7
         pLPF0wIfeFtJ5W0mRxYO+f+7+/CDnbvW4FsvaL33jOWs06lAi4X0VJkzjBMHeGhlwhD9
         3vsACE84rjISStRuuOxvTKDR8Ywejbnz6IHq8c38du5vfb3zhnUB3V6TDhM7LjxLQfcn
         BRnW4KkPPlKJf8aN3WbCWgKTt3XooPWiaf05lhURdL+BGqS/uVpBke9MOCzydaupeTob
         +LG+Mt7mkoDbWBadK4ExV+/dPvEMnarntA/Am93G/B4T3czT4GRYmEAafNR3iCAQTGFC
         F9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WtzGmBHj0RGuxebJ0ct299uESioKozN0N+8U01Ge8gY=;
        b=fEUi2xV6obfofCmpPpqxBojiG8u5ztJIcFnV0UFBdpvys/drg6qRyyLDPW4YEUuOkk
         g6vWfyoMVujt0rO67eujK9gvtKCbmYH9HaUOurORGhOG4UnZxvhhLuwFANYN+GvI64O3
         /uLrBXBH3jdqDtHLZGglqAG5sRi9WIiRpEvgEPbCD/DkuQhtkqtp6sWrE4FfbAguzUfB
         o5efo/KT019cAQTdAnT/pUDMpFdRW2M4aMGN3szqzNjcMMElQ0RxMBc0zoqpa9qLVkYf
         uG/DA0UmRBwX/98u0nQ7eZhzoin7xOQyr0R4cFxXMeR94HWQQjE+R5uy4mKV1FJmHbHe
         FnkQ==
X-Gm-Message-State: APjAAAV8z5TCK4iSvVLqqMyb9dRYIp8Y8wJGfaYJ8ub1UJbjt0bZBkHx
        ntM7rvetsKFozVqJImvqhRhQ70TjCtP8raHVOyfLzw==
X-Google-Smtp-Source: APXvYqwV+sJixNx2Vd/HDxQQO4L/AQBWYb50tWVlasG2ZpWyOA0elQazXFZOpDrffW4GcmWEJVdAfKSRjXDOWJSOgNY=
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr2713085wrj.325.1575373384054;
 Tue, 03 Dec 2019 03:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20191202214230.164997-1-ebiggers@kernel.org>
In-Reply-To: <20191202214230.164997-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Dec 2019 11:42:59 +0000
Message-ID: <CAKv+Gu8VK-Kq5qb86eh=WusjwXiBcudT5h=KhGJMyBY25BedfQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] crypto: api - remove crypto_tfm::crt_u
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2 Dec 2019 at 21:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series removes the per-algorithm-type union from struct crypto_tfm
> now that its only remaining users are the "compress" and "cipher"
> algorithm types, and it's not really needed for them.
>
> This shrinks every crypto transform for every algorithm by 28 bytes on
> 64-bit platforms (12 bytes on 32-bit), and also removes some code.
>
> Note that the new-style strongly-typed algorithms (i.e. everything other
> than "compress" and "cipher") don't need crt_u, since they embed struct
> crypto_tfm in a per-algorithm-type custom struct instead.
>
> Eric Biggers (2):
>   crypto: compress - remove crt_u.compress (struct compress_tfm)
>   crypto: cipher - remove crt_u.cipher (struct cipher_tfm)
>

Good riddance

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

>  crypto/api.c           | 15 +------
>  crypto/cipher.c        | 92 +++++++++++++++++-------------------------
>  crypto/compress.c      | 31 ++++++--------
>  crypto/internal.h      |  3 --
>  include/linux/crypto.h | 91 ++++++-----------------------------------
>  5 files changed, 61 insertions(+), 171 deletions(-)
>
> --
> 2.24.0.393.g34dc348eaf-goog
>
