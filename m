From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: pasemi_rng.c: Migrate to managed API
Date: Thu, 25 Aug 2016 18:55:00 +0530
Message-ID: <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com> <20160825121546.GA25650@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: olof@lixom.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36655 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932312AbcHYNZB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 09:25:01 -0400
In-Reply-To: <20160825121546.GA25650@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I will propose to use devm_ioremap_resource() instead for removing this hardcoded 0x100, but i cannot find any user of this driver in any dts. (And so cannot check that this 0x100 is given in any DT resource node)
>
> Is this normal ?

I wanted to use devm_ioremap_resource but could not find DT entry
required for this driver in any of the .dts files. So did not change
that. I could not find any dts/dtsi for this platform. So I assume
that the dtb is not present in the kernel, dtb is supplied by the
bootloader. I may be wrong in this. Can anyone confirm this?

Regards,
PrasannaKumar
