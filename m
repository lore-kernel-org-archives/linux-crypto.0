Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB35EC4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 19:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814DC20663
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 19:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oD/LOIwu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbfJMTtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 15:49:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41808 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbfJMTtM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 15:49:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so1352391wrm.8
        for <linux-crypto@vger.kernel.org>; Sun, 13 Oct 2019 12:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WzXFmyngDWBgvgmIQTM6V3XN27zxR9QlMTf8A4TVEF8=;
        b=oD/LOIwu1+A2o+j8TGZqlV8v+zSKsu1vdiCfmsocLS8QKJUCG9P28HlFe4sVhf+pSE
         8oRoSCdcuTogdgoLz45YU9TQkuvbjh7qPMuBjyPXL4FtNCqrdxbFxoIwMPekM4N2Lyvk
         RD+ytm0g+ODdQTRJM6M85onYsfRAuGmjQDnJpMcQZgHo6sYm4BuGFBrVnRkwWqEZvgkX
         y5Unh8RvgjQQNDkdk5lDlVu+opszElAEOGqZ/yCZID7oNRYcxBl70gfZ6r3RbCF7RCIf
         ASMC12DjCvXutTkbF8Phqm56hmYC98GTiuWxeRqlh5iMq4WIURwbWR2utNxchRkvR6L/
         Oeaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WzXFmyngDWBgvgmIQTM6V3XN27zxR9QlMTf8A4TVEF8=;
        b=Diwv7Pbo0pfekRTTm4XyuS8BnGNCwQaCz6/x9seb75c8HhN2dr4moPCy6gB3L3Zmgi
         UZgwgcCUBp4+6wUk+cP0yj8GfmqFsHJjA1Cv+lxuGTkTmgI+fLLPwt4aX3nvqgjI16JK
         lpbcGHCMmmDNyOvZXCDzRR+2T7vtpYwXA0OFZR2uTdY6o4s9ckd1TYQJRyn5NmuyLkTT
         ka69uuh9sfIGLAN5WOAiHaDpKsRNSGpkejWBegjI1RO7NrNrGFK8ivceJD1RUh5EGjXC
         IGP1GAO5xDsZPF8k/grYIYqIOF1sDUptsihnfJX4WJicvuwA5RB/YBibVVVDOdv2AlND
         RQ/Q==
X-Gm-Message-State: APjAAAU0iaABDpUMRvPpUTti7+UhbfzTRarveZcT+1KhSqDtZQhER4qI
        +hr+3qrP6iuAinkxaMmkeqpOwvgStZ8dlKlQyKDA+w==
X-Google-Smtp-Source: APXvYqwY6WRr3MREi99N5eVbZbe1587LZ/OY3CQJgIRdDFC5qLEVs1jENHgWMuG/3UHFgbnjcAcBmAOYlw2t0FRa9/A=
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr22258746wrr.200.1570996149368;
 Sun, 13 Oct 2019 12:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191013043918.337113-1-ebiggers@kernel.org> <CAKv+Gu8nN48aWoeW-aA_1OA_s8Qw0nUbyg+GCZ9DsUA3tDNprg@mail.gmail.com>
 <CAKv+Gu-PEemQvXv=kqxfqb4RvmpdU2h7TZHKps2FKTBUTKFehQ@mail.gmail.com> <20191013185616.GA10007@sol.localdomain>
In-Reply-To: <20191013185616.GA10007@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 13 Oct 2019 21:48:58 +0200
Message-ID: <CAKv+Gu_+yG0grjr+Y7rO8KYkvO5xjB-Y7B_AzuMPEHVTaUJB8w@mail.gmail.com>
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

On Sun, 13 Oct 2019 at 20:56, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Oct 13, 2019 at 05:31:31PM +0200, Ard Biesheuvel wrote:
> > On Sun, 13 Oct 2019 at 08:29, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Sun, 13 Oct 2019 at 06:40, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > This series converts the PowerPC Nest (NX) implementations of AES modes
> > > > from the deprecated "blkcipher" API to the "skcipher" API.  This is
> > > > needed in order for the blkcipher API to be removed.
> > > >
> > > > This patchset is compile-tested only, as I don't have this hardware.
> > > > If anyone has this hardware, please test this patchset with
> > > > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> > > >
> > > > Eric Biggers (4):
> > > >   crypto: nx - don't abuse blkcipher_desc to pass iv around
> > > >   crypto: nx - convert AES-ECB to skcipher API
> > > >   crypto: nx - convert AES-CBC to skcipher API
> > > >   crypto: nx - convert AES-CTR to skcipher API
> > > >
> > > >  drivers/crypto/nx/nx-aes-cbc.c | 81 ++++++++++++++-----------------
> > > >  drivers/crypto/nx/nx-aes-ccm.c | 40 ++++++----------
> > > >  drivers/crypto/nx/nx-aes-ctr.c | 87 +++++++++++++++-------------------
> > > >  drivers/crypto/nx/nx-aes-ecb.c | 76 +++++++++++++----------------
> > > >  drivers/crypto/nx/nx-aes-gcm.c | 24 ++++------
> > > >  drivers/crypto/nx/nx.c         | 64 ++++++++++++++-----------
> > > >  drivers/crypto/nx/nx.h         | 19 ++++----
> > > >  7 files changed, 176 insertions(+), 215 deletions(-)
> > > >
> > >
> > > Hi Eric,
> > >
> > > Thanks for taking this on. I'll look in more detail at these patches
> > > during the week. In the meantime, I may have a stab at converting ccp,
> > > virtio-crypto and omap aes/des myself, since i have the hardware to
> > > test those.
> > >
> >
> > OK, I got a bit carried away, and converted a bunch of platforms in
> > drivers/crypto (build tested only, except for the virtio driver)
> >
> > crypto: qce - switch to skcipher API
> > crypto: rockchip - switch to skcipher API
> > crypto: stm32 - switch to skcipher API
> > crypto: sahara - switch to skcipher API
> > crypto: picoxcell - switch to skcipher API
> > crypto: mediatek - switch to skcipher API
> > crypto: mxs - switch to skcipher API
> > crypto: ixp4xx - switch to skcipher API
> > crypto: hifn - switch to skcipher API
> > crypto: chelsio - switch to skcipher API
> > crypto: cavium/cpt - switch to skcipher API
> > crypto: nitrox - remove cra_type reference to ablkcipher
> > crypto: bcm-spu - switch to skcipher API
> > crypto: atmel-tdes - switch to skcipher API
> > crypto: atmel-aes - switch to skcipher API
> > crypto: s5p - switch to skcipher API
> > crypto: ux500 - switch to skcipher API
> > crypto: omap - switch to skcipher API
> > crypto: virtio - switch to skcipher API
> > crypto: virtio - deal with unsupported input sizes
> > crypto: virtio - implement missing support for output IVs
> > crypto: ccp - switch from ablkcipher to skcipher
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=ablkcipher-removal
> >
> > I pushed the branch to kernelci, so hopefully we'll get some automated
> > results, but I think only a small subset of these are boot tested atm.
>
> Awesome, thanks for doing this!  I was just planning to do "blkcipher" for now,
> but your patches will take care of almost all of "ablkcipher" too.
>

Yeah. I thought it was about time we take care of this, and ablkcipher
is much more straightforward anyway.

> A few things I noticed from quickly skimming through your patches:
>

Thanks. These are all mistakes on my part - I went through these at
high speed with lots of mechanical search-replace.

> "ecb-des3-omap", "cbc-des3-omap", "atmel-ecb-tdes", "atmel-cbc-tdes", and
> "atmel-ofb-tdes" had their min and/or max key size incorrectly changed to 8
> (DES_BLOCK_SIZE or DES3_EDE_BLOCK_SIZE) rather than left as 24
> (DES3_EDE_KEY_SIZE or 3*DES_KEY_SIZE).
>
> cra_blocksize for "atmel-cfb64-aes" was changed from CFB64_BLOCK_SIZE to
> AES_BLOCKSIZE.  Intentional?
>
> cra_blocksize for "stm32-ctr-aes" and for "cfb-aes-mtk" was changed from 1 to
> AES_BLOCK_SIZE.  Intentional?
>
> CRYPTO_ALG_NEED_FALLBACK was added to "cbc-des-picoxcell" and "ecb-des-picoxcell".
> Intentional?
>
> In drivers/crypto/ixp4xx_crypto.c, .walksize was set on "rfc3686(ctr(aes))"
> rather than .chunksize.  Intentional?
>
> In drivers/crypto/qce/, CRYPTO_ALG_TYPE_ABLKCIPHER should be replaced with
> CRYPTO_ALG_TYPE_SKCIPHER.
>
> In drivers/crypto/stm32/, could rename crypto_algs[] to skcipher_algs[].
>
> Thanks!
>
> - Eric
