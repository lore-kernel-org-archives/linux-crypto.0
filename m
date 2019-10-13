Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B50C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 06:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DAD020663
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 06:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ShHctQMI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJMG3u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 02:29:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37885 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJMG3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 02:29:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so13677430wmc.2
        for <linux-crypto@vger.kernel.org>; Sat, 12 Oct 2019 23:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcJ7Kv1ST9YbGxqx4tgfEVL19WmMfSIFjEryHkrxqaM=;
        b=ShHctQMIAMUEsc4GsPIKwVo7BaxtA/IH8w/7Imj4tm0mGBrIFwVfV7ELQaSvJSlEjc
         r6G/5eGmPT4AmRnsFXTU4hud3uI5T8lcoG6t5Au5+2XmTznxgF7jdxBXqGCwcPofCqiN
         K8ePCjmhAVEQSOS48hJ3Ap0yr4Ev4qvnWlpkyPNwMoYW65uFF7td0WNt8yC+znjxNxhf
         f87SIcJ/405TP5H1YSlhz/FYH42vWWIP+YIzS6Fm4lGkEVwyJHIVSgmli91yQqv2xHrr
         6JCiVL8HkhUVImkuKO9S/LYvzH8u8opYzoSE8JUpL4OTKI0HYsQenqJNA0qkll1KaqGB
         luZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcJ7Kv1ST9YbGxqx4tgfEVL19WmMfSIFjEryHkrxqaM=;
        b=r+Z+9C1PLZ3SrFyCAnFamFEvanQtI/97pXZTxD80pxVZ7NZpGzNI7kFuFTX6HU5zXk
         6jRpwAh4upXAjymgG26DJCkGHmJDn8hHCXMx2Ao5X8ck19HA4mALf1yBW4F5Fmi0fQBP
         F/fst7JSmPPg+Thc/6LlSIoBWS9crBJtFoxtAQpcpd1JOjujwnL6N8s5i9tMhbEB1ev2
         4oN7YMeW64CPfCZLf6AYllJIhPj2jnl4PW1XsVj7VuVvWBET5tdyI0CQOLaM9NDHe9EW
         bjqRoNabEb4gZGcNW2KA5fK5jWQ3IhcKoWEq7QrUqmAEQk9ShE+vxJMcwtEtVMLGCzZm
         w8Qg==
X-Gm-Message-State: APjAAAXykiKIBUMYAObp3rUQyl0ZWMKceYys2iRMIubVZWumcvmx1/Kc
        BKyrY/oMbo2Gl0gZTW+kOmUSDlNgvABv4kpphQ7fhg==
X-Google-Smtp-Source: APXvYqxQOJKzj7kLS8VKcVx0K23FigMu5lWnFTg7n8/Dbq+Wi535YTj5c3SXPfhU3OGjcDrK5VwCQXY8VlhZG3vRdGQ=
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr9465516wmc.136.1570948187865;
 Sat, 12 Oct 2019 23:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191013043918.337113-1-ebiggers@kernel.org>
In-Reply-To: <20191013043918.337113-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 13 Oct 2019 08:29:35 +0200
Message-ID: <CAKv+Gu8nN48aWoeW-aA_1OA_s8Qw0nUbyg+GCZ9DsUA3tDNprg@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: nx - convert to skcipher API
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series converts the PowerPC Nest (NX) implementations of AES modes
> from the deprecated "blkcipher" API to the "skcipher" API.  This is
> needed in order for the blkcipher API to be removed.
>
> This patchset is compile-tested only, as I don't have this hardware.
> If anyone has this hardware, please test this patchset with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
>
> Eric Biggers (4):
>   crypto: nx - don't abuse blkcipher_desc to pass iv around
>   crypto: nx - convert AES-ECB to skcipher API
>   crypto: nx - convert AES-CBC to skcipher API
>   crypto: nx - convert AES-CTR to skcipher API
>
>  drivers/crypto/nx/nx-aes-cbc.c | 81 ++++++++++++++-----------------
>  drivers/crypto/nx/nx-aes-ccm.c | 40 ++++++----------
>  drivers/crypto/nx/nx-aes-ctr.c | 87 +++++++++++++++-------------------
>  drivers/crypto/nx/nx-aes-ecb.c | 76 +++++++++++++----------------
>  drivers/crypto/nx/nx-aes-gcm.c | 24 ++++------
>  drivers/crypto/nx/nx.c         | 64 ++++++++++++++-----------
>  drivers/crypto/nx/nx.h         | 19 ++++----
>  7 files changed, 176 insertions(+), 215 deletions(-)
>

Hi Eric,

Thanks for taking this on. I'll look in more detail at these patches
during the week. In the meantime, I may have a stab at converting ccp,
virtio-crypto and omap aes/des myself, since i have the hardware to
test those.

Thanks,
Ard.
