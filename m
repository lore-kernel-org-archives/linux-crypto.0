Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C852C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 21:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3273F611EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 21:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242843AbhI1VFz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242829AbhI1VFy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 17:05:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF94B6135D;
        Tue, 28 Sep 2021 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632863054;
        bh=dx0ZpQGYPCR29OtNi20oDfVXROdfnahILA1jroXWLp4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pOKMzWaHmapYq1YuLdn+RCjcUg7fQ9E4Dl4GTjwC2dhMggB8eUCq8QlQx36upm4hH
         SnA7CJ+5nFgf2CYkaeLTKAImpCoAvM5ddMBlvngiDusEaRWT3HLdOH1U5suzGgqXit
         I+NAUgFQKt2SEST7bf6evK/aZWqRw2kgs2+SfPaNfbXKTKocYKA9xuxAfqqXxBGkea
         3RoOPiIW/6rw4I8sSSawvZwflBJ81tc+/JrnIHSPSuxYE9yhdm4Trhgmxsg56WHBHO
         S3f9mZkc9oQk3vqj9ilUNSVD+Aabhrb9K/rbf1SO4JqXLqlYPGP7Td7KBB5lJOI3k5
         eQ2tdu8/dvoKA==
Received: by mail-oi1-f172.google.com with SMTP id s69so111684oie.13;
        Tue, 28 Sep 2021 14:04:14 -0700 (PDT)
X-Gm-Message-State: AOAM531ofdOW8HSfWuk0K11JudaJmP9fYejDdGWvUHI9NOGYRwU1J9rM
        1SIY9Nxjsy+fApRiIC1rJJrNfr72uI8gyItuSRs=
X-Google-Smtp-Source: ABdhPJxdBxXgCipUNfiw/6xo0sHrKV/ePM1U43+cxcAchIYhk576pmL5yoJ6HFOq8FRbZ0qhXDy2Qw0TncI7+ViUGJU=
X-Received: by 2002:a05:6808:1148:: with SMTP id u8mr5129711oiu.33.1632863054165;
 Tue, 28 Sep 2021 14:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210923063027.166247-1-xiaokang.qian@arm.com> <YVK1u4BgVAa84fMa@sol.localdomain>
In-Reply-To: <YVK1u4BgVAa84fMa@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Sep 2021 23:04:03 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
Message-ID: <CAMj1kXHeJBUAzcLHRNYDbbUDe5vRS7Bxy_LKF5gdRLJca7TNRQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way interleave
 of aes and ghash
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     XiaokangQian <xiaokang.qian@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, nd <nd@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Sept 2021 at 08:27, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Sep 23, 2021 at 06:30:25AM +0000, XiaokangQian wrote:
> > To improve performance on cores with deep piplines such as A72,N1,
> > implement gcm(aes) using a 4-way interleave of aes and ghash (totally
> > 8 blocks in parallel), which can make full utilize of pipelines rather
> > than the 4-way interleave we used currently. It can gain about 20% for
> > big data sizes such that 8k.
> >
> > This is a complete new version of the GCM part of the combined GCM/GHASH
> > driver, it will co-exist with the old driver, only serve for big data
> > sizes. Instead of interleaving four invocations of AES where each chunk
> > of 64 bytes is encrypted first and then ghashed, the new version uses a
> > more coarse grained approach where a chunk of 64 bytes is encrypted and
> > at the same time, one chunk of 64 bytes is ghashed (or ghashed and
> > decrypted in the converse case).
> >
> > The table below compares the performance of the old driver and the new
> > one on various micro-architectures and running in various modes with
> > various data sizes.
> >
> >             |     AES-128       |     AES-192       |     AES-256       |
> >      #bytes | 1024 | 1420 |  8k | 1024 | 1420 |  8k | 1024 | 1420 |  8k |
> >      -------+------+------+-----+------+------+-----+------+------+-----+
> >         A72 | 5.5% |  12% | 25% | 2.2% |  9.5%|  23%| -1%  |  6.7%| 19% |
> >         A57 |-0.5% |  9.3%| 32% | -3%  |  6.3%|  26%| -6%  |  3.3%| 21% |
> >         N1  | 0.4% |  7.6%|24.5%| -2%  |  5%  |  22%| -4%  |  2.7%| 20% |
> >
> > Signed-off-by: XiaokangQian <xiaokang.qian@arm.com>
>
> Does this pass the self-tests, including the fuzz tests which are enabled by
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>

Please test both little-endian and big-endian. (Note that you don't
need a big-endian user space for this - the self tests are executed
before the rootfs is mounted)

Also, you will have to rebase this onto the latest cryptodev tree,
which carries some changes I made recently to this driver.

Finally, I'd like to discuss whether we really need two separate
drivers here. The 1k data point is not as relevant as the other ones,
which show a worthwhile speedup for all micro architectures and data
sizes (although I will give this a spin on TX2 myself when I have the
chance)

*If* we switch to this implementation completely, I would like to keep
the improvement I added recently to the decrypt path to compare the
tag using SIMD code, rather than copying it out and using memcmp().
Could you look into adopting this for this version as well?

-- 
Ard.
