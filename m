From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v3 0/4] crypto: Add driver for JZ4780 PRNG
Date: Sat, 25 Nov 2017 20:16:03 +0530
Message-ID: <CANc+2y6DSjrsQj9kSz1go4-v+WVG2YcxeDc6Ehgm-bbf4qG+=A@mail.gmail.com>
References: <20170918140241.24003-1-prasannatsmkumar@gmail.com>
 <20171012143011.GA30173@gondor.apana.org.au> <CANc+2y5VzWx+kLBO+=aWHLE5OGAGvuB_eVAzJ52ZVy79ad9Nxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Rob Herring <robh+dt@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-mips@linux-mips.org,
        Mathieu Malaterre <malat@debian.org>, noloader@gmail.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:46866 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbdKYOqE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Nov 2017 09:46:04 -0500
Received: by mail-io0-f172.google.com with SMTP id q64so19192943iof.13
        for <linux-crypto@vger.kernel.org>; Sat, 25 Nov 2017 06:46:04 -0800 (PST)
In-Reply-To: <CANc+2y5VzWx+kLBO+=aWHLE5OGAGvuB_eVAzJ52ZVy79ad9Nxg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ralf,

On 12 October 2017 at 22:59, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> Hi Herbert,
>
> On 12 October 2017 at 20:00, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Mon, Sep 18, 2017 at 07:32:37PM +0530, PrasannaKumar Muralidharan wrote:
>>> This patch series adds support of pseudo random number generator found
>>> in Ingenic's JZ4780 and X1000 SoC.
>>>
>>> Create cgublock node which has CGU and RNG node as its children. The
>>> cgublock node uses "simple-bus" compatible which helps in exposing CGU
>>> and RNG nodes without changing CGU driver. Add 'syscon' compatible in
>>> CGU node in jz4780.dtsi. The jz4780-rng driver uses regmap exposed via
>>> syscon interface to access the RNG registers. CGU driver is not
>>> modified in this patch set as registers used by CGU driver and this
>>> driver are different.
>>>
>>> PrasannaKumar Muralidharan (4):
>>>   crypto: jz4780-rng: Add JZ4780 PRNG devicetree binding documentation
>>>   crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
>>>   crypto: jz4780-rng: Add RNG node to jz4780.dtsi
>>>   crypto: jz4780-rng: Enable PRNG support in CI20 defconfig
>>
>> Please indicate which patches are intended to go through the crypto
>> trees.
>
> From https://patchwork.linux-mips.org/patch/17162/ I expect the same.
> Either all patches go via crypto tree or via mips tree.
> The dtsi changes is not yet acked by MIPS / JZ4780 maintainer. Let's
> wait for it.
>
> Thanks,
> PrasannaKumar

Should I do anything more for this series?

Thanks,
PrasannaKumar
