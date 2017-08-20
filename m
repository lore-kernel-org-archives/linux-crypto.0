From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/6] crypto: jz4780-rng: Make ingenic CGU driver use syscon
Date: Sun, 20 Aug 2017 21:42:12 +0530
Message-ID: <CANc+2y6tRe_kkWyGX+-BT-ugb5JiZhKpPoHWkAn=2ZC6cb6uKA@mail.gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
 <20170817182520.20102-3-prasannatsmkumar@gmail.com> <3563032.h0vdzx9HfC@np-p-burton>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-mips@linux-mips.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Turquette <mturquette@baylibre.com>,
        sboyd@codeaurora.org, "David S . Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-crypto@vger.kernel.org
To: Paul Burton <paul.burton@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33009 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753064AbdHTQMO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Aug 2017 12:12:14 -0400
Received: by mail-it0-f66.google.com with SMTP id m81so3522435itb.0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Aug 2017 09:12:13 -0700 (PDT)
In-Reply-To: <3563032.h0vdzx9HfC@np-p-burton>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Paul,

Thanks for your review.

On 19 August 2017 at 02:18, Paul Burton <paul.burton@imgtec.com> wrote:
> Hi PrasannaKumar,
>
> On Thursday, 17 August 2017 11:25:16 PDT PrasannaKumar Muralidharan wrote:
>> Ingenic PRNG registers are a part of the same hardware block as clock
>> and power stuff. It is handled by CGU driver. Ingenic M200 SoC has power
>> related registers that are after the PRNG registers. So instead of
>> shortening the register range use syscon interface to expose regmap.
>> This regmap is used by the PRNG driver.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> ---
>>  arch/mips/boot/dts/ingenic/jz4740.dtsi | 14 +++++++----
>>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 14 +++++++----
>>  drivers/clk/ingenic/cgu.c              | 46
>> +++++++++++++++++++++------------- drivers/clk/ingenic/cgu.h              |
>>  9 +++++--
>>  drivers/clk/ingenic/jz4740-cgu.c       | 30 +++++++++++-----------
>>  drivers/clk/ingenic/jz4780-cgu.c       | 10 ++++----
>>  6 files changed, 73 insertions(+), 50 deletions(-)
>>
>> diff --git a/arch/mips/boot/dts/ingenic/jz4740.dtsi
>> b/arch/mips/boot/dts/ingenic/jz4740.dtsi index 2ca7ce7..ada5e67 100644
>> --- a/arch/mips/boot/dts/ingenic/jz4740.dtsi
>> +++ b/arch/mips/boot/dts/ingenic/jz4740.dtsi
>> @@ -34,14 +34,18 @@
>>               clock-frequency = <32768>;
>>       };
>>
>> -     cgu: jz4740-cgu@10000000 {
>> -             compatible = "ingenic,jz4740-cgu";
>> +     cgu_registers {
>> +             compatible = "simple-mfd", "syscon";
>>               reg = <0x10000000 0x100>;
>>
>> -             clocks = <&ext>, <&rtc>;
>> -             clock-names = "ext", "rtc";
>> +             cgu: jz4780-cgu@10000000 {
>> +                     compatible = "ingenic,jz4740-cgu";
>>
>> -             #clock-cells = <1>;
>> +                     clocks = <&ext>, <&rtc>;
>> +                     clock-names = "ext", "rtc";
>> +
>> +                     #clock-cells = <1>;
>> +             };
>>       };
>>
>>       rtc_dev: rtc@10003000 {
>> diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi
>> b/arch/mips/boot/dts/ingenic/jz4780.dtsi index 4853ef6..1301694 100644
>> --- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
>> +++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
>> @@ -34,14 +34,18 @@
>>               clock-frequency = <32768>;
>>       };
>>
>> -     cgu: jz4780-cgu@10000000 {
>> -             compatible = "ingenic,jz4780-cgu";
>> +     cgu_registers {
>> +             compatible = "simple-mfd", "syscon";
>>               reg = <0x10000000 0x100>;
>>
>> -             clocks = <&ext>, <&rtc>;
>> -             clock-names = "ext", "rtc";
>> +             cgu: jz4780-cgu@10000000 {
>> +                     compatible = "ingenic,jz4780-cgu";
>>
>> -             #clock-cells = <1>;
>> +                     clocks = <&ext>, <&rtc>;
>> +                     clock-names = "ext", "rtc";
>> +
>> +                     #clock-cells = <1>;
>> +             };
>>       };
>>
>>       pinctrl: pin-controller@10010000 {
>> diff --git a/drivers/clk/ingenic/cgu.c b/drivers/clk/ingenic/cgu.c
>> index e8248f9..2f12c7c 100644
>> --- a/drivers/clk/ingenic/cgu.c
>> +++ b/drivers/clk/ingenic/cgu.c
>> @@ -29,6 +29,18 @@
>>
>>  #define MHZ (1000 * 1000)
>>
>> +unsigned int cgu_readl(struct ingenic_cgu *cgu, unsigned int reg)
>> +{
>> +     unsigned int val = 0;
>> +     regmap_read(cgu->regmap, reg, &val);
>> +     return val;
>> +}
>> +
>> +int cgu_writel(struct ingenic_cgu *cgu, unsigned int val, unsigned int reg)
>> +{
>> +     return regmap_write(cgu->regmap, reg, val);
>> +}
>
> This is going to introduce a lot of overhead to the CGU driver - each
> regmap_read() or regmap_write() call will not only add overhead from the
> indirection but also acquire a lock which we really don't need.
>

Indeed.

> Could you instead perhaps:
>
>  - Just add "syscon" as a second compatible string to the CGU node in the
>    device tree, but otherwise leave it as-is without the extra cgu_registers
>    node.
>
>  - Have your RNG device node as a child of the CGU node, which should let it
>    pick up the regmap via syscon_node_to_regmap() as it already does.
>
>  - Leave the CGU driver as-is, so it can continue accessing memory directly
>    rather than via regmap.
>

As per my understanding, CGU driver and syscon will map the same
register set. Is that fine?

Thanks,
PrasannaKumar
