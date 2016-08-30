From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: hwrng: pasemi_rng.c: Migrate to managed API
Date: Tue, 30 Aug 2016 12:46:32 +0530
Message-ID: <CANc+2y64+ECEh0GwQU4qQrEtsFjjbmaRJYt1t=J1Q3nT6TG6sA@mail.gmail.com>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
 <20160825121546.GA25650@Red> <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
 <48b8455031e.651d5701@auth.smtp.1and1.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        mpm@selenic.com, olof@lixom.net, linuxppc-dev@lists.ozlabs.org
To: Darren Stevens <darren@stevens-zone.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48b8455031e.651d5701@auth.smtp.1and1.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Darren,

>> I wanted to use devm_ioremap_resource but could not find DT entry
>> required for this driver in any of the .dts files. So did not change
>> that. I could not find any dts/dtsi for this platform. So I assume
>> that the dtb is not present in the kernel, dtb is supplied by the
>> bootloader. I may be wrong in this. Can anyone confirm this?
>
> On mine (Amigaone X1000) that is correct, we boot linux with a vmlinux file,
> and the bootloader (CFE) passes a fixed dtb. I think it is possible to dump
> the tree from inside CFE, if it would help I can invetigate?

I don't know if it is possible to get dts from dtb even if you manage
to extract devicetree blob from your system.

Labbe, Do you know anyway to get dts from dtb? Is this step really
required to remove 0x100 value for this patch given that the value was
present here for years? If extracting dtb and converting dtb to dts is
easy and not time consuming, I am in favour of finding a way to remove
hard coded value.
