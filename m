From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: jz4780-rng: Add JZ4780 PRNG devicetree
 binding documentation
Date: Sat, 26 Aug 2017 08:50:45 +0530
Message-ID: <CANc+2y7pD7EkSS-9ky4YDxGjk3wGW1PVZje2UXMRuOQJA=S+HA@mail.gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-2-prasannatsmkumar@gmail.com> <20170825215734.f5rc7fzxpl3ynnwl@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org, Mathieu Malaterre <malat@debian.org>,
        noloader@gmail.com
To: Rob Herring <robh@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34837 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754346AbdHZDUq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Aug 2017 23:20:46 -0400
In-Reply-To: <20170825215734.f5rc7fzxpl3ynnwl@rob-hp-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rob,

On 26 August 2017 at 03:27, Rob Herring <robh@kernel.org> wrote:
> On Wed, Aug 23, 2017 at 08:27:04AM +0530, PrasannaKumar Muralidharan wrote:
>> Add devicetree bindings for hardware pseudo random number generator
>> present in Ingenic JZ4780 SoC.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> ---
>> Changes in v2:
>> * Add "syscon" in CGU node's compatible section
>> * Make RNG child node of CGU.
>>
>>  .../bindings/crypto/ingenic,jz4780-rng.txt           | 20 ++++++++++++++++++++
>
> bindings/rng/ for RNG h/w.

There are two subsystem for dealing with RNG hw. Hw_random subsystem
for true RNG (driver/char/hw_random) and crypto framework for pseudo
RNG (crypto/ and drviers/crypto). This HW is pseudo RNG so I have
placed the dt bindings in bindings/crypto as the driver itself is in
drivers/crypto folder. I am wondering if there is any relation between
driver folder and bindings folder. Can you please explain the folder
relation? Should this be put in bindings/rng or bindings/crypto?

>
>>  1 file changed, 20 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>> new file mode 100644
>> index 0000000..a0c18e5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>> @@ -0,0 +1,20 @@
>> +Ingenic jz4780 RNG driver
>> +
>> +Required properties:
>> +- compatible : Should be "ingenic,jz4780-rng"
>> +
>> +Example:
>> +
>> +cgu: jz4780-cgu@10000000 {
>> +     compatible = "ingenic,jz4780-cgu", "syscon";
>> +     reg = <0x10000000 0x100>;
>> +
>> +     clocks = <&ext>, <&rtc>;
>> +     clock-names = "ext", "rtc";
>> +
>> +     #clock-cells = <1>;
>> +
>> +     rng: rng@d8 {
>
> unit-address requires reg property.

The driver uses regmap to access the registers. In this case reg
property is not useful. Is reg property still needed? If not, how
should the node be declared?

>
>> +             compatible = "ingenic,jz480-rng";
>> +     };
>> +};
>> --
>> 2.10.0
>>

Thanks,
PrasannaKumar
