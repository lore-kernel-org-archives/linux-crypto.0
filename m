From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/4] crypto: jz4780-rng: Add JZ4780 PRNG devicetree
 binding documentation
Date: Mon, 28 Aug 2017 13:31:12 -0500
Message-ID: <CAL_Jsq+YO2DRVqudNuigefikkKZiv066wW6cM8qbn5Y31t-WTQ@mail.gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-2-prasannatsmkumar@gmail.com> <20170825215734.f5rc7fzxpl3ynnwl@rob-hp-laptop>
 <CANc+2y7pD7EkSS-9ky4YDxGjk3wGW1PVZje2UXMRuOQJA=S+HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
        Paul Cercueil <paul-icTtO2rgO2OTuSrc4Mpeew@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux-MIPS <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
        Mathieu Malaterre <malat-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANc+2y7pD7EkSS-9ky4YDxGjk3wGW1PVZje2UXMRuOQJA=S+HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 25, 2017 at 10:20 PM, PrasannaKumar Muralidharan
<prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Rob,
>
> On 26 August 2017 at 03:27, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Wed, Aug 23, 2017 at 08:27:04AM +0530, PrasannaKumar Muralidharan wrote:
>>> Add devicetree bindings for hardware pseudo random number generator
>>> present in Ingenic JZ4780 SoC.
>>>
>>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> Changes in v2:
>>> * Add "syscon" in CGU node's compatible section
>>> * Make RNG child node of CGU.
>>>
>>>  .../bindings/crypto/ingenic,jz4780-rng.txt           | 20 ++++++++++++++++++++
>>
>> bindings/rng/ for RNG h/w.
>
> There are two subsystem for dealing with RNG hw. Hw_random subsystem
> for true RNG (driver/char/hw_random) and crypto framework for pseudo
> RNG (crypto/ and drviers/crypto). This HW is pseudo RNG so I have
> placed the dt bindings in bindings/crypto as the driver itself is in
> drivers/crypto folder. I am wondering if there is any relation between
> driver folder and bindings folder. Can you please explain the folder
> relation? Should this be put in bindings/rng or bindings/crypto?

There's not a 1-1 relationship though obviously there's a lot of
overlap. I'd still say this should go in bindings/rng.

>>>  1 file changed, 20 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>>> new file mode 100644
>>> index 0000000..a0c18e5
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/ingenic,jz4780-rng.txt
>>> @@ -0,0 +1,20 @@
>>> +Ingenic jz4780 RNG driver
>>> +
>>> +Required properties:
>>> +- compatible : Should be "ingenic,jz4780-rng"
>>> +
>>> +Example:
>>> +
>>> +cgu: jz4780-cgu@10000000 {
>>> +     compatible = "ingenic,jz4780-cgu", "syscon";
>>> +     reg = <0x10000000 0x100>;
>>> +
>>> +     clocks = <&ext>, <&rtc>;
>>> +     clock-names = "ext", "rtc";
>>> +
>>> +     #clock-cells = <1>;
>>> +
>>> +     rng: rng@d8 {
>>
>> unit-address requires reg property.
>
> The driver uses regmap to access the registers. In this case reg
> property is not useful. Is reg property still needed? If not, how
> should the node be declared?

What the driver (currently) does is irrelevant to the binding. Your
choice is either add the reg property or name the node just "rng".
Either is fine, but better to have more information than less IMO.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
