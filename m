From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Mon, 22 May 2017 15:48:30 +0100
Message-ID: <e8ef1f11-539c-9abc-9977-36366d4994b1@arm.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-2-antoine.tenart@free-electrons.com>
 <7986721e-3a2b-23fb-61d7-7032f0d65533@arm.com>
 <20170522143049.GD14976@kwain.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39464 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934866AbdEVOsf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 10:48:35 -0400
In-Reply-To: <20170522143049.GD14976@kwain.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,

On 22/05/17 15:30, Antoine Tenart wrote:
> Hi Marc,
> 
> On Wed, May 03, 2017 at 05:36:38PM +0100, Marc Zyngier wrote:
>> On 24/04/17 08:54, Antoine Tenart wrote:
>>> +
>>> +	crypto: crypto@800000 {
>>> +		compatible = "inside-secure,safexcel-eip197";
>>> +		reg = <0x800000 0x200000>;
>>> +		interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
>>
>> I'm puzzled. How can the interrupt can be both level *and* edge? That
>> doesn't make any sense.
> 
> I agree this looks odd. I took it from Russel's ICU mapping:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2017-February/489040.html

This emails says:

ICU-irq => GIC-SPI-num Enable Edge/Level ICU-group
[...]
   24 =>  34 En Lv 0

which seems to clearly indicate Level (no Edge involved here).

> The driver does not use this interrupt (yet?). I'm not sure what is this
> interrupt exact configuration...

Surely the TRM would indicate this, wouldn't it?

> Do you want me to remove this from the documentation (and device trees)?

I'd rather you clarify it, if possible.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
