From: Darren Stevens <darren@stevens-zone.net>
Subject: Re: hwrng: pasemi_rng.c: Migrate to managed API
Date: Wed, 31 Aug 2016 15:02:53 +0100 (BST)
Message-ID: <48bab268a61.66716f37@auth.smtp.1and1.co.uk>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
 <20160825121546.GA25650@Red>
 <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
 <48b8455031e.651d5701@auth.smtp.1and1.co.uk>
 <CANc+2y64+ECEh0GwQU4qQrEtsFjjbmaRJYt1t=J1Q3nT6TG6sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, mpm@selenic.com, olof@lixom.net,
        linuxppc-dev@lists.ozlabs.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50504 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934774AbcHaOFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 10:05:24 -0400
In-Reply-To: <CANc+2y64+ECEh0GwQU4qQrEtsFjjbmaRJYt1t=J1Q3nT6TG6sA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello PrasannaKumar

On 30/08/2016, PrasannaKumar Muralidharan wrote:
> Hi Darren,
>> On mine (Amigaone X1000) that is correct, we boot linux with a vmlinux
>> file, and the bootloader (CFE) passes a fixed dtb. I think it is
>> possible to dump the tree from inside CFE, if it would help I can
>> invetigate?
>
> I don't know if it is possible to get dts from dtb even if you manage
> to extract devicetree blob from your system.

I didn't explain well, There is a CFE command 'show devtree' here's the
relevant bits (I Hope)

[CFE ]CFE> show devtree
[/]
 | #interrupt-cells                 val   0x00000002
 | #address-cells                   val   0x00000002
 | #size-cells                      val   0x00000002

...[snip]...

   [sdc@fc000000]
    | name                          str   'sdc' 
    | device_type                   str   'sdc' 
    | #address-cells                val   0x00000001
    | #size-cells                   val   0x00000001
    | compatible                    str   '1682m-sdc' 'pasemi,pwrficient-sdc'
'pasemi,sdc' 
    | reg                           cell  00000000 FC000000 00000000 00800000 

...[snip]...

      [rng@fc105000]
       | name                       str   'rng' 
       | device_type                str   'rng' 
       | compatible                 str   '1682m-rng' 'pasemi,pwrficient-rng'
'pasemi,rng' 
       | reg                        cell  FC105000 00001000 


Regards
