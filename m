Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB4CC4338F
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Aug 2021 16:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77ECA60EBD
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Aug 2021 16:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhHAQ01 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Aug 2021 12:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhHAQ00 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Aug 2021 12:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8EDE61059;
        Sun,  1 Aug 2021 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627835178;
        bh=wpnk83J5W52Cehu0wTsNOKGTslGIXxW1DA6xKjVj57M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DnAh/UDly7Bn0jw4Rv0lAOs+BP9fRFpRJ/mOb6SlFksnOaustk1C1zIKWJdaGLcN3
         prkT96qGygOkaS0SMa5L7B6uyFneKgHoAqxdhdLOco0PCXlKrN9FShTZRwIqNVPkJB
         uLPFH1/9vLf9bRkaXt/TJMlZ348c8BM6orf/ckyV+tSmRBC3Fyb2YZRDoEKyrcExHP
         4glY7k39R4pPFuut4CXMiZ3wNE7qeAkxW4yXFzOEJxxkbD26vkoD3M8+oHAR1L17Lr
         EpOc4yaoEJfn2uTAIN/Ltcpnywu0vZ4t4befktkosYOICOGU2MjDU3SMXxjJ3+aWiQ
         jIakZzd4Ac4sw==
Received: by mail-oi1-f179.google.com with SMTP id n16so14652745oij.2;
        Sun, 01 Aug 2021 09:26:18 -0700 (PDT)
X-Gm-Message-State: AOAM532yTa0IZ+KFzRPniqbjwEj9U4gdy7jxqH2bstLf6WHKzD+1CQKp
        BYc+KsQtSj6m1hctPd4rdoouGgU+ztkTrpx9BMI=
X-Google-Smtp-Source: ABdhPJz3/6J0OezwIAj9JxW632NldoAZOtXTofqhaWRPClx/rrb07RmsWgwSX5m18t60pV6FqwLR/lwyOr+i31b1/gs=
X-Received: by 2002:aca:4c49:: with SMTP id z70mr7775755oia.174.1627835178131;
 Sun, 01 Aug 2021 09:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210731204845.21196-1-andre.przywara@arm.com>
In-Reply-To: <20210731204845.21196-1-andre.przywara@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 1 Aug 2021 18:26:06 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHakwfDoAqBL_KbRHbKuF=sJ2ug-cCqYxRUQhCqzcXn9w@mail.gmail.com>
Message-ID: <CAMj1kXHakwfDoAqBL_KbRHbKuF=sJ2ug-cCqYxRUQhCqzcXn9w@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] hwrng: Add Arm SMCCC TRNG based driver
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 31 Jul 2021 at 22:49, Andre Przywara <andre.przywara@arm.com> wrote:
>
> The "Arm True Random Number Generator Firmware Interface"[1] provides
> an SMCCC based interface to a true hardware random number generator.
> So far we are using that in arch_get_random_seed(), but it might be
> useful to expose the entropy through the /dev/hwrng device as well. This
> allows to assess the quality of the implementation, by using "rngtest"
> from the rng-tools package, for example.
>
> Patch 1 creates a platform device, triggered by the previous discovery
> of the SMCCC TRNG service.
> Patch 2 implements a hw_random platform driver, which is instantiated
> through this said platform device.
>
> The driver can be loaded as module, or built into the kernel.
>
> [1] https://developer.arm.com/documentation/den0098/latest/
>
> Changelog v3 ... v4:
> - drop pointless driver loading message
> - drop unneeded init() routine
>
> Changelog v2 ... v3:
> - split platform device and driver
>
> Changelog v1 ... v2:
> - fix building as a module
> - de-register device upon exit
> - mention module name in Kconfig
>
> Andre Przywara (2):
>   firmware: smccc: Register smccc_trng platform device
>   hwrng: Add Arm SMCCC TRNG based driver
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>


>  drivers/char/hw_random/Kconfig          |  14 +++
>  drivers/char/hw_random/Makefile         |   1 +
>  drivers/char/hw_random/arm_smccc_trng.c | 123 ++++++++++++++++++++++++
>  drivers/firmware/smccc/smccc.c          |  17 ++++
>  4 files changed, 155 insertions(+)
>  create mode 100644 drivers/char/hw_random/arm_smccc_trng.c
>
> --
> 2.17.6
>
