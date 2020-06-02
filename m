Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D657DC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 12:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9B72074B
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591100087;
	bh=hS7g9g/aSqZzPJBPg66kKL88fBvDX9aRfUs29YzvkBs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=glmV7BmHyM/9idP/oe/vLYmgMkzz+2ry3h6vRsbyUSqx+TEzcLXVnIw8BjLYFCm7n
	 xX+vlVMPypjMslWerY43bIVskmzdHT8sD+BDkbh8KakOP6RVqviSiq3X67voq3xaAj
	 lov8slr84iJHwBDh3Qf2yjbw769Gti7mi5D6Eh/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgFBMOq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgFBMOq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 08:14:46 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE6A2068D;
        Tue,  2 Jun 2020 12:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591100085;
        bh=hS7g9g/aSqZzPJBPg66kKL88fBvDX9aRfUs29YzvkBs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=yl/i7Qiqq7UoiHmOVqVo+SEn4KgETDEedHdFCdNCuS9f2E2SQng2voWzPfHPcO6YE
         8CF1FQSd08KxkT7RlTX59097gDyqNuMBxG3McsUgXYZn1n9qp24KE+RNxGUKVpsrLE
         /QrUIwIAtq/wHHtTJJMYo7XfANI0AplH+lQth1YE=
Received: by mail-oi1-f169.google.com with SMTP id c194so7020383oig.5;
        Tue, 02 Jun 2020 05:14:45 -0700 (PDT)
X-Gm-Message-State: AOAM532rmY1+BQ9CYyDuFLCE6cBO2lFp6FW3CClAI+rFysYQbJT/FXPy
        M54+9xkJyfwX2roPJdU0xR9VP8/LUClsqFo7BaQ=
X-Google-Smtp-Source: ABdhPJxW1sEkwPq7K4sRBd1zGPvt9cMm19769d1cEMMvHkLmv/96Zuuq0m9uCjS+3j1U8+rNjcP1B0egOpse0Ai0JB0=
X-Received: by 2002:aca:b707:: with SMTP id h7mr2899814oif.174.1591100084934;
 Tue, 02 Jun 2020 05:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 2 Jun 2020 14:14:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
Message-ID: <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
Subject: Re: Security Random Number Generator support
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, wsd_upstream@mediatek.com,
        Crystal Guo <Crystal.Guo@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2 Jun 2020 at 10:15, Neal Liu <neal.liu@mediatek.com> wrote:
>
> These patch series introduce a security random number generator
> which provides a generic interface to get hardware rnd from Secure
> state. The Secure state can be Arm Trusted Firmware(ATF), Trusted
> Execution Environment(TEE), or even EL2 hypervisor.
>
> Patch #1..2 adds sec-rng kernel driver for Trustzone based SoCs.
> For security awareness SoCs on ARMv8 with TrustZone enabled,
> peripherals like entropy sources is not accessible from normal world
> (linux) and rather accessible from secure world (HYP/ATF/TEE) only.
> This driver aims to provide a generic interface to Arm Trusted
> Firmware or Hypervisor rng service.
>
>
> changes since v1:
> - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs can reuse
>   this driver.
>   - refine coding style and unnecessary check.
>
>   changes since v2:
>   - remove unused comments.
>   - remove redundant variable.
>
>   changes since v3:
>   - add dt-bindings for MediaTek rng with TrustZone enabled.
>   - revise HWRNG SMC call fid.
>
>   changes since v4:
>   - move bindings to the arm/firmware directory.
>   - revise driver init flow to check more property.
>
>   changes since v5:
>   - refactor to more generic security rng driver which
>     is not platform specific.
>
> *** BLURB HERE ***
>
> Neal Liu (2):
>   dt-bindings: rng: add bindings for sec-rng
>   hwrng: add sec-rng driver
>

There is no reason to model a SMC call as a driver, and represent it
via a DT node like this.

It would be much better if this SMC interface is made truly generic,
and wired into the arch_get_random() interface, which can be used much
earlier.


>  .../devicetree/bindings/rng/sec-rng.yaml      |  53 ++++++
>  drivers/char/hw_random/Kconfig                |  13 ++
>  drivers/char/hw_random/Makefile               |   1 +
>  drivers/char/hw_random/sec-rng.c              | 155 ++++++++++++++++++
>  4 files changed, 222 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/sec-rng.yaml
>  create mode 100644 drivers/char/hw_random/sec-rng.c
>
> --
> 2.18.0
