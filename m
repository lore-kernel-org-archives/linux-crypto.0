Return-Path: <SRS0=DsWe=6K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEE3C54FCB
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 12:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5DC320A8B
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Apr 2020 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587905824;
	bh=5ABxmCph/AEBhxrGHnnsoaYgeGTDosiEQu9/OEZ3qlk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ey9tTgUUonSErK6fYfOgaMBPDnF2v3rAW5iE3t++KPGMb/l/0H7+R0WmPpe1Ak5PM
	 qV5GgVF2o98zrjLjV7ugtPPsKZP7PI6gqG9JZ/SzmkyTSUUuvleyYY3Ib/ai1yf+FA
	 Svw3rJwYAXc7ml7A7FSOlUWC/DWoZihtfllhDMQQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgDZM5E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 26 Apr 2020 08:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgDZM5D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Apr 2020 08:57:03 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424932078E;
        Sun, 26 Apr 2020 12:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587905823;
        bh=5ABxmCph/AEBhxrGHnnsoaYgeGTDosiEQu9/OEZ3qlk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QlfVQk7WG2r4dyEklMbcAMy0GMpDWSj0TEk+tRDbBehvpH18/tpJPxkkZWfOIU0Yf
         CeM+VhrqduwkKrSgvDQOP8lAg+8RnYBV5KlQyhP5g/OpdOy0fpMYrcu6vohSDLPQ6n
         LMe9yknOIUSB9bahxDh26QG/tauNRDkNp+7+Enjg=
Received: by mail-io1-f51.google.com with SMTP id i3so15833954ioo.13;
        Sun, 26 Apr 2020 05:57:03 -0700 (PDT)
X-Gm-Message-State: AGi0PuYU58i0aaRtrf+hh2KTnL7LbW5qrb0f0L7+B0aUN8KPyy5cMlkY
        dxRPrOxj0iL7FeJTS8tqz0C1EwaOU/tZhWlzOjA=
X-Google-Smtp-Source: APiQypIiVZda1qWFcNnbDaWD1+K+dFNrZADuv/KO3CsT74d7H7QAW87LPgjCZBO4uifDcG0jHoF13wH9YekC8QUHNFc=
X-Received: by 2002:a6b:ef03:: with SMTP id k3mr16843666ioh.203.1587905822657;
 Sun, 26 Apr 2020 05:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200418104343.GA5132@amd> <DB6PR0802MB2533670AFC1473E5C5EDAD28E9D60@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <VI1PR08MB3584451F0B0B21E00ACF56A7FED70@VI1PR08MB3584.eurprd08.prod.outlook.com>
 <CAOtvUMfNgdYZF5VaqgF-51b0+KtxqgUFD6njXFX7evz1yAJc9A@mail.gmail.com>
 <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com> <DB6PR0802MB25337F768E6B2DCF943AC11CE9AE0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25337F768E6B2DCF943AC11CE9AE0@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 26 Apr 2020 14:56:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXECTnTg+2V+oh1+ONca9mUi14CJ1QXoaktM4N2rVs_+EQ@mail.gmail.com>
Message-ID: <CAMj1kXECTnTg+2V+oh1+ONca9mUi14CJ1QXoaktM4N2rVs_+EQ@mail.gmail.com>
Subject: Re: Fw: Arm CryptoCell driver -- default Y, even on machines where it
 is obviously useless
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 26 Apr 2020 at 14:50, Hadar Gat <Hadar.Gat@arm.com> wrote:
>
> Hi Ard,
>
> > -----Original Message-----
> > From: Ard Biesheuvel <ardb@kernel.org>
> > Sent: Sunday, 19 April 2020 11:55
> >
> > > > > -----Original Message-----
> > > > > From: Pavel Machek <pavel@ucw.cz>
> > > > > Sent: Saturday, 18 April 2020 13:44
> > > > >
> > > > > Hi!
> > > > >
> > > > > I'm configuring kernel for x86, and I get offered
> > HW_RANDOM_CCTRNG
> > > > > with default=Y, and help text suggesting I should enable it.
> > > > >
> > > > > That's... two wrong suggestions, right?
> > > > >
> > > > > Best regards,
> > > > > Pavel
> > > ...
> > > > ________________________________________
> > > > From: Hadar Gat <Hadar.Gat@arm.com>
> > > > Sent: Saturday, April 18, 2020 11:31 PM
> > > >
> > > > Hi Pavel,
> > > > I think you got it right..
> > > > Indeed, Arm CryptoCell CCTRNG driver couldn't be used and obviously
> > useless if the Arm CryptoCell HW does not exist in the system.
> > >
> > > There's a delicate point here though - CryptoCell is an independent
> > > hardware block, it is not tied to a particular CPU architecture.
> > > There are SoCs with none-Arm architecture CPU using it.
> > >
> > > So I would say whatever the answer is, it should be the same for any
> > > generic embedded style HW block.
> > >
> > > And the help text is not architecture specific anyway, is it not..?
> > >
> >
> > Both the default y and and the help text are indeed incorrect. This should be
> > fixed. We don't enable device drivers by default, and definitely not as as
> > builtins. A conditional default m could be acceptable if the condition is
> > sufficiently narrow.
>
> On one hand I totally agree with that and think the default should be N.
> On the other hand, most of the HW_RANDOM drivers set the default to HW_RANDOM
> and it doesn't make sense to me to do something different than almost every other HW RANDOM device.
> Do I miss something here?
>

Yes. First of all, using 'default HW_RANDOM' everywhere makes no sense
at all, but that is not your fault.

If you look at drivers/char/hw_random/Kconfig, you will see that most
drivers have additional depends lines, which means that 'default m'
(or 'default y' in case CONFIG_HW_RANDOM=y) will only take affect if
the dependency is fulfilled.

It makes no sense to enable this driver on *every* single Linux
system, right? Especially given that many architectures do not even
support device tree, which is a prerequisite to be able to even probe.




drivers/char/hw_random/Kconfig-config HW_RANDOM_INTEL
drivers/char/hw_random/Kconfig- depends on (X86 || IA64) && PCI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_AMD
drivers/char/hw_random/Kconfig- depends on (X86 || PPC_MAPLE) && PCI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_ATMEL
drivers/char/hw_random/Kconfig- depends on ARCH_AT91 && HAVE_CLK && OF
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_BCM2835
drivers/char/hw_random/Kconfig- depends on ARCH_BCM2835 ||
ARCH_BCM_NSP || ARCH_BCM_5301X || \
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_IPROC_RNG200
drivers/char/hw_random/Kconfig- depends on ARCH_BCM_IPROC ||
ARCH_BCM2835 || ARCH_BRCMSTB
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_GEODE
drivers/char/hw_random/Kconfig- depends on X86_32 && PCI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_N2RNG
drivers/char/hw_random/Kconfig- depends on SPARC64
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_VIA
drivers/char/hw_random/Kconfig- depends on X86
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_IXP4XX
drivers/char/hw_random/Kconfig- depends on ARCH_IXP4XX
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_OMAP
drivers/char/hw_random/Kconfig- depends on ARCH_OMAP16XX ||
ARCH_OMAP2PLUS || ARCH_MVEBU
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_OMAP3_ROM
drivers/char/hw_random/Kconfig- depends on ARCH_OMAP3
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_OCTEON
drivers/char/hw_random/Kconfig- depends on CAVIUM_OCTEON_SOC
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_PASEMI
drivers/char/hw_random/Kconfig- depends on PPC_PASEMI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_VIRTIO
drivers/char/hw_random/Kconfig- depends on VIRTIO
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_TX4939
drivers/char/hw_random/Kconfig- depends on SOC_TX4939
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_MXC_RNGA
drivers/char/hw_random/Kconfig- depends on SOC_IMX31
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_IMX_RNGC
drivers/char/hw_random/Kconfig- depends on HAS_IOMEM && HAVE_CLK
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_NOMADIK
drivers/char/hw_random/Kconfig- depends on ARCH_NOMADIK
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_PSERIES
drivers/char/hw_random/Kconfig- depends on PPC64 && IBMVIO
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_POWERNV
drivers/char/hw_random/Kconfig- depends on PPC_POWERNV
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_HISI
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && ARCH_HISI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_HISI_V2
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && ARM64 && ACPI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_ST
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && ARCH_STI
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_XGENE
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && ARCH_XGENE
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_STM32
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && (ARCH_STM32 ||
COMPILE_TEST)
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_PIC32
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && MACH_PIC32
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_MESON
drivers/char/hw_random/Kconfig- depends on HW_RANDOM
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_CAVIUM
drivers/char/hw_random/Kconfig- depends on HW_RANDOM && PCI && (ARM64
|| (COMPILE_TEST && 64BIT))
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_MTK
drivers/char/hw_random/Kconfig- depends on HW_RANDOM
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_S390
drivers/char/hw_random/Kconfig- depends on S390
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_EXYNOS
drivers/char/hw_random/Kconfig- depends on ARCH_EXYNOS || COMPILE_TEST
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_OPTEE
drivers/char/hw_random/Kconfig- depends on OPTEE
--
drivers/char/hw_random/Kconfig-config HW_RANDOM_NPCM
drivers/char/hw_random/Kconfig- depends on ARCH_NPCM || COMPILE_TEST
