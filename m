Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA75C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 15:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F62D20663
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 15:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jO212bsL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfJMPbr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 11:31:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33689 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfJMPbq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 11:31:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so12738074wme.0
        for <linux-crypto@vger.kernel.org>; Sun, 13 Oct 2019 08:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=un6QLRuM9urISafHkBqQN+FKjxq2aO4SrSF2GfFXUuo=;
        b=jO212bsLMmv0ZCk3bSEoPmBHjHkwY+ZyJCGSVM+RHzjAkXms5PqkK3+8/0ZhT6F9vA
         XZ/YEWhAdg1askw8jWLcj6mM6rjij8eyC9izRQ0gklJsdRq0M3vmUlbo+kI0agXtyUwY
         Z1Yxms9xpAxmORR5EclpvtscwIZrTcqDg4DIRFprxDBarvvaTz+7tOaFS7/kX2u8zBt+
         3fFBPmSWOXGlx2qz8HqJfwbhVU3W+EsFYGpnkUzZPyVH6AKg3jMjghqnO79KAZ8nM+PF
         BHT9+9ktOjESkkVaJ427f5XmPmf7y4+hYgCKurmEslwnNa3/onzm6/IVenkiK6F8YTtH
         VNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=un6QLRuM9urISafHkBqQN+FKjxq2aO4SrSF2GfFXUuo=;
        b=j80Copu8MRgqjp8dpGGh8huaK2X71Pxf3Zs+F6RxN4rksT/6gVuUocJ2RayD44p31G
         h4yJ4i54HHrGOG01plYQDVQ3ylYB+f31x3Qxj0gYPO3566+xCtDqm/Qk5YWsnGT4UmJF
         CYzdUYA+cdSjEu3w5D1SCt4pmd4VT6sdUL1kn42m9Af7rz1mujKUo2GZ7ZBsdfzXf7hj
         K5Jv1V+zb5hLe0Kg1Spl0HMW9/59WnMwlD6ZRF/0u4MDLWht30nrp6B9i7mAxjumkK9j
         b5Hdv5JUzT2EGklKQyH2hMFePVj8xGr3kpEEwPtZzHM299+d3iT9ulrFIhOGYRq5CkLZ
         CfoQ==
X-Gm-Message-State: APjAAAW3yOi6hER8WPCPwlk4luuJP9WQOtFo71FP37E5dIVb3BsOPtjz
        6Pf1dUCVA5hmWVV0Gq3A+/S04WL5yN0sAzhj1V3mBA==
X-Google-Smtp-Source: APXvYqw5e3GV0VJAjB0u7VuHOCiMhakyp+ejLPtjBvbRRrigL7S24yII+ua3CNj1igfmSmdSLJMk/+FuYmI5Z48gEcE=
X-Received: by 2002:a1c:a9c5:: with SMTP id s188mr10638905wme.61.1570980704091;
 Sun, 13 Oct 2019 08:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191013043918.337113-1-ebiggers@kernel.org> <CAKv+Gu8nN48aWoeW-aA_1OA_s8Qw0nUbyg+GCZ9DsUA3tDNprg@mail.gmail.com>
In-Reply-To: <CAKv+Gu8nN48aWoeW-aA_1OA_s8Qw0nUbyg+GCZ9DsUA3tDNprg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 13 Oct 2019 17:31:31 +0200
Message-ID: <CAKv+Gu-PEemQvXv=kqxfqb4RvmpdU2h7TZHKps2FKTBUTKFehQ@mail.gmail.com>
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

On Sun, 13 Oct 2019 at 08:29, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This series converts the PowerPC Nest (NX) implementations of AES modes
> > from the deprecated "blkcipher" API to the "skcipher" API.  This is
> > needed in order for the blkcipher API to be removed.
> >
> > This patchset is compile-tested only, as I don't have this hardware.
> > If anyone has this hardware, please test this patchset with
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> >
> > Eric Biggers (4):
> >   crypto: nx - don't abuse blkcipher_desc to pass iv around
> >   crypto: nx - convert AES-ECB to skcipher API
> >   crypto: nx - convert AES-CBC to skcipher API
> >   crypto: nx - convert AES-CTR to skcipher API
> >
> >  drivers/crypto/nx/nx-aes-cbc.c | 81 ++++++++++++++-----------------
> >  drivers/crypto/nx/nx-aes-ccm.c | 40 ++++++----------
> >  drivers/crypto/nx/nx-aes-ctr.c | 87 +++++++++++++++-------------------
> >  drivers/crypto/nx/nx-aes-ecb.c | 76 +++++++++++++----------------
> >  drivers/crypto/nx/nx-aes-gcm.c | 24 ++++------
> >  drivers/crypto/nx/nx.c         | 64 ++++++++++++++-----------
> >  drivers/crypto/nx/nx.h         | 19 ++++----
> >  7 files changed, 176 insertions(+), 215 deletions(-)
> >
>
> Hi Eric,
>
> Thanks for taking this on. I'll look in more detail at these patches
> during the week. In the meantime, I may have a stab at converting ccp,
> virtio-crypto and omap aes/des myself, since i have the hardware to
> test those.
>

OK, I got a bit carried away, and converted a bunch of platforms in
drivers/crypto (build tested only, except for the virtio driver)

crypto: qce - switch to skcipher API
crypto: rockchip - switch to skcipher API
crypto: stm32 - switch to skcipher API
crypto: sahara - switch to skcipher API
crypto: picoxcell - switch to skcipher API
crypto: mediatek - switch to skcipher API
crypto: mxs - switch to skcipher API
crypto: ixp4xx - switch to skcipher API
crypto: hifn - switch to skcipher API
crypto: chelsio - switch to skcipher API
crypto: cavium/cpt - switch to skcipher API
crypto: nitrox - remove cra_type reference to ablkcipher
crypto: bcm-spu - switch to skcipher API
crypto: atmel-tdes - switch to skcipher API
crypto: atmel-aes - switch to skcipher API
crypto: s5p - switch to skcipher API
crypto: ux500 - switch to skcipher API
crypto: omap - switch to skcipher API
crypto: virtio - switch to skcipher API
crypto: virtio - deal with unsupported input sizes
crypto: virtio - implement missing support for output IVs
crypto: ccp - switch from ablkcipher to skcipher

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=ablkcipher-removal

I pushed the branch to kernelci, so hopefully we'll get some automated
results, but I think only a small subset of these are boot tested atm.
