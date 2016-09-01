From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: hwrng: pasemi_rng.c: Migrate to managed API
Date: Thu, 1 Sep 2016 12:29:47 +0530
Message-ID: <CANc+2y5jJ9GNg10ob3o7CLqzLqt9+oH8vU_RmEUjAfDdwOft9A@mail.gmail.com>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
 <20160825121546.GA25650@Red> <CANc+2y4JqGRXCLUEpMo8EB8thW5jsweh0Lg2VjuvpNgSR-AwMA@mail.gmail.com>
 <48b8455031e.651d5701@auth.smtp.1and1.co.uk> <CANc+2y64+ECEh0GwQU4qQrEtsFjjbmaRJYt1t=J1Q3nT6TG6sA@mail.gmail.com>
 <48bab268a61.66716f37@auth.smtp.1and1.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        linux-crypto@vger.kernel.org, mpm@selenic.com, olof@lixom.net,
        linuxppc-dev@lists.ozlabs.org
To: Darren Stevens <darren@stevens-zone.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48bab268a61.66716f37@auth.smtp.1and1.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> I didn't explain well, There is a CFE command 'show devtree' here's the
> relevant bits (I Hope)

This is much simple than I expected.

> [CFE ]CFE> show devtree
> [/]
>  | #interrupt-cells                 val   0x00000002
>  | #address-cells                   val   0x00000002
>  | #size-cells                      val   0x00000002
>
> ...[snip]...
>
>    [sdc@fc000000]
>     | name                          str   'sdc'
>     | device_type                   str   'sdc'
>     | #address-cells                val   0x00000001
>     | #size-cells                   val   0x00000001
>     | compatible                    str   '1682m-sdc' 'pasemi,pwrficient-sdc'
> 'pasemi,sdc'
>     | reg                           cell  00000000 FC000000 00000000 00800000
>
> ...[snip]...
>
>       [rng@fc105000]
>        | name                       str   'rng'
>        | device_type                str   'rng'
>        | compatible                 str   '1682m-rng' 'pasemi,pwrficient-rng'
> 'pasemi,rng'
>        | reg                        cell  FC105000 00001000
>

Device tree provided by CFE has the size. I will send another patch
which uses devm_ioremap_resource().

Appreciate your help. Thank you :).
