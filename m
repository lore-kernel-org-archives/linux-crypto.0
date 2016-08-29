From: Darren Stevens <darren@stevens-zone.net>
Subject: Re: hwrng: pasemi_rng.c: Migrate to managed API
Date: Mon, 29 Aug 2016 18:52:15 +0100 (BST)
Message-ID: <48b8455031e.651d5701@auth.smtp.1and1.co.uk>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
 <20160825121546.GA25650@Red>
 <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        mpm@selenic.com, olof@lixom.net, linuxppc-dev@lists.ozlabs.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:54868 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752808AbcH2Sxg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 14:53:36 -0400
In-Reply-To: <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello PrasannaKumar

On 25/08/2016, PrasannaKumar Muralidharan wrote:
>> I will propose to use devm_ioremap_resource() instead for removing this
>> hardcoded 0x100, but i cannot find any user of this driver in any dts.
>> (And so cannot check that this 0x100 is given in any DT resource node)
>
>> Is this normal ?
>
> I wanted to use devm_ioremap_resource but could not find DT entry
> required for this driver in any of the .dts files. So did not change
> that. I could not find any dts/dtsi for this platform. So I assume
> that the dtb is not present in the kernel, dtb is supplied by the
> bootloader. I may be wrong in this. Can anyone confirm this?

On mine (Amigaone X1000) that is correct, we boot linux with a vmlinux file,
and the bootloader (CFE) passes a fixed dtb. I think it is possible to dump
the tree from inside CFE, if it would help I can invetigate?

Regards
Darren
