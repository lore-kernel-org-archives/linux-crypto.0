Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35006C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6E86128E
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352019AbhI3O7F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352018AbhI3O7E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Sep 2021 10:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18966128E;
        Thu, 30 Sep 2021 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633013841;
        bh=Ul6eldZNU2CyYIjwQhqq+NM/92KkckTfZvBzAyidh0U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qU8OrPaMSytRZUhHLphRmXUU8eJafDbVZdicAkGC6IPTwxIHpPMfnF4bqsgWXNEXn
         lv4xdKF/dclZfeqCvb9Dx4xCxEGOntmdjjDRAhcyPiwq2yFrpO+S5PsPbFqzxZOOvt
         ZSBdRCvQej1tY9T+7OYM/c3k1WhoDaJKLQPKCsEuJG5VlJoD9EzLrmoRwp55NGmPqj
         2G2uGw9BdnWp+iYb7FpjWHxDKH5BJJWV+cptWJMgUvdrrmkbAbsyE34HAmUMY+9nWb
         F1zLc41Om3yeVXR/dHYY0Pw7M2Po0D4Vybl5GO6RN/qnAlqqHIxbMmdzvM7LlPXBLM
         XIjFyg/ruuQ/w==
Received: by mail-oi1-f182.google.com with SMTP id s69so7554699oie.13;
        Thu, 30 Sep 2021 07:57:21 -0700 (PDT)
X-Gm-Message-State: AOAM5314oN1eR4Cav+aP7uniNQmPh1/RMyrepz4KqBLR6/HXfC+dgm/2
        mTdA820sHUVkVzcrb+2xEfN6HOhOpJXYzu5xagE=
X-Google-Smtp-Source: ABdhPJxa7tQhbO5f833cDMIA7bEkH5e0OAXqjiEZue1VHO80HjU/rF6NrjrxNY3sjNSzuMzQUZw70y41rVMYG0MtyU8=
X-Received: by 2002:aca:32c2:: with SMTP id y185mr3140111oiy.47.1633013841293;
 Thu, 30 Sep 2021 07:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210923063027.166247-1-xiaokang.qian@arm.com>
 <YVK1u4BgVAa84fMa@sol.localdomain> <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
 <PA4PR08MB60168642B59CCFC91A3F4ABDEEAA9@PA4PR08MB6016.eurprd08.prod.outlook.com>
In-Reply-To: <PA4PR08MB60168642B59CCFC91A3F4ABDEEAA9@PA4PR08MB6016.eurprd08.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 30 Sep 2021 16:57:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEHOscYf0qxdzAw2u_J+zb2dXfWdK07MkBZUnJZv0Ds0g@mail.gmail.com>
Message-ID: <CAMj1kXEHOscYf0qxdzAw2u_J+zb2dXfWdK07MkBZUnJZv0Ds0g@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way interleave
 of aes and ghash
To:     Xiaokang Qian <Xiaokang.Qian@arm.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will@kernel.org>, nd <nd@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 Sept 2021 at 03:32, Xiaokang Qian <Xiaokang.Qian@arm.com> wrote:
>
> Thanks for the review.
>
> I will firstly change the decrypt path to compare the tag using SIMD code=
, and then  pass all of the self tests include fuzz tests(enabled by CONFIG=
_CRYPTO_MANAGER_EXTRA_TESTS=3Dy), big endian ,little endian tests.
>

OK

> About the 1K data point, I just remember that the 1420 bytes packet is co=
mmonly used in IPSEC.
>

Yes, but your code is faster than the existing code for 1420 byte
packets, right? So why should we keep the original code? We don't use
GCM for block storage, and if IPsec throughput is a key performance
metric for your system, you are likely to be using the maximum packet
size so 1420 bytes not 1k.


>
> -----Original Message-----
> From: Ard Biesheuvel <ardb@kernel.org>
> Sent: Wednesday, September 29, 2021 5:04 AM
> To: Eric Biggers <ebiggers@kernel.org>
> Cc: Xiaokang Qian <Xiaokang.Qian@arm.com>; Herbert Xu <herbert@gondor.apa=
na.org.au>; David S. Miller <davem@davemloft.net>; Catalin Marinas <Catalin=
.Marinas@arm.com>; Will Deacon <will@kernel.org>; nd <nd@arm.com>; Linux Cr=
ypto Mailing List <linux-crypto@vger.kernel.org>; Linux ARM <linux-arm-kern=
el@lists.infradead.org>; Linux Kernel Mailing List <linux-kernel@vger.kerne=
l.org>
> Subject: Re: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way inter=
leave of aes and ghash
>
> On Tue, 28 Sept 2021 at 08:27, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Sep 23, 2021 at 06:30:25AM +0000, XiaokangQian wrote:
> > > To improve performance on cores with deep piplines such as A72,N1,
> > > implement gcm(aes) using a 4-way interleave of aes and ghash
> > > (totally
> > > 8 blocks in parallel), which can make full utilize of pipelines
> > > rather than the 4-way interleave we used currently. It can gain
> > > about 20% for big data sizes such that 8k.
> > >
> > > This is a complete new version of the GCM part of the combined
> > > GCM/GHASH driver, it will co-exist with the old driver, only serve
> > > for big data sizes. Instead of interleaving four invocations of AES
> > > where each chunk of 64 bytes is encrypted first and then ghashed,
> > > the new version uses a more coarse grained approach where a chunk of
> > > 64 bytes is encrypted and at the same time, one chunk of 64 bytes is
> > > ghashed (or ghashed and decrypted in the converse case).
> > >
> > > The table below compares the performance of the old driver and the
> > > new one on various micro-architectures and running in various modes
> > > with various data sizes.
> > >
> > >             |     AES-128       |     AES-192       |     AES-256    =
   |
> > >      #bytes | 1024 | 1420 |  8k | 1024 | 1420 |  8k | 1024 | 1420 |  =
8k |
> > >      -------+------+------+-----+------+------+-----+------+------+--=
---+
> > >         A72 | 5.5% |  12% | 25% | 2.2% |  9.5%|  23%| -1%  |  6.7%| 1=
9% |
> > >         A57 |-0.5% |  9.3%| 32% | -3%  |  6.3%|  26%| -6%  |  3.3%| 2=
1% |
> > >         N1  | 0.4% |  7.6%|24.5%| -2%  |  5%  |  22%| -4%  |  2.7%|
> > > 20% |
> > >
> > > Signed-off-by: XiaokangQian <xiaokang.qian@arm.com>
> >
> > Does this pass the self-tests, including the fuzz tests which are
> > enabled by CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?
> >
>
> Please test both little-endian and big-endian. (Note that you don't need =
a big-endian user space for this - the self tests are executed before the r=
ootfs is mounted)
>
> Also, you will have to rebase this onto the latest cryptodev tree, which =
carries some changes I made recently to this driver.
>
> Finally, I'd like to discuss whether we really need two separate drivers =
here. The 1k data point is not as relevant as the other ones, which show a =
worthwhile speedup for all micro architectures and data sizes (although I w=
ill give this a spin on TX2 myself when I have the
> chance)
>
> *If* we switch to this implementation completely, I would like to keep th=
e improvement I added recently to the decrypt path to compare the tag using=
 SIMD code, rather than copying it out and using memcmp().
> Could you look into adopting this for this version as well?
>
> --
> Ard.
