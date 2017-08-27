From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: Add driver for JZ4780 PRNG
Date: Sun, 27 Aug 2017 12:09:58 +0530
Message-ID: <CANc+2y4EmmeYX7DVdjR7evt1siK4YS9MenTwjJRvubOr-yfuVw@mail.gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org, Mathieu Malaterre <malat@debian.org>,
        noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38174 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdH0GkA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Aug 2017 02:40:00 -0400
In-Reply-To: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 23 August 2017 at 08:27, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> This patch series adds support of pseudo random number generator found
> in Ingenic's JZ4780 and X1000 SoC.
>
> Based on Paul's review comments, add 'syscon' compatible in CGU node in
> jz4780.dtsi. jz4780-rng driver uses regmap exposed via syscon interface
> to access the RNG registers. CGU driver is not modified in this patch
> set as registers used by CGU driver and this driver are different.
>
> PrasannaKumar Muralidharan (4):
>   crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
>   crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
>   crypto: jz4780-rng: Add RNG node to jz4780.dtsi
>   crypto: jz4780-rng: Enable PRNG support in CI20 defconfig
>
>  .../bindings/crypto/ingenic,jz4780-rng.txt         |  20 +++
>  MAINTAINERS                                        |   5 +
>  arch/mips/boot/dts/ingenic/jz4780.dtsi             |   6 +-
>  arch/mips/configs/ci20_defconfig                   |   5 +
>  drivers/crypto/Kconfig                             |  19 +++
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/jz4780-rng.c                        | 168 +++++++++++++++++++++
>  7 files changed, 223 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>  create mode 100644 drivers/crypto/jz4780-rng.c
>
> --
> 2.10.0
>

The rng node which is the child node of CGU is ignored so the driver's
probe is not called at all. Realised that the tests were using crng
instead of this. Don't know how to get this working. Will submit a new
version once the issue is fixed.

Please do not take this patch series.

Thanks,
PrasannaKumar
