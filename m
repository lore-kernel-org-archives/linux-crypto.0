From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v3 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Mon, 22 May 2017 16:54:40 +0200
Message-ID: <20170522145440.GE14976@kwain.lan>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-2-antoine.tenart@free-electrons.com>
 <7986721e-3a2b-23fb-61d7-7032f0d65533@arm.com>
 <20170522143049.GD14976@kwain.lan>
 <e8ef1f11-539c-9abc-9977-36366d4994b1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45253 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934731AbdEVOyl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 10:54:41 -0400
Content-Disposition: inline
In-Reply-To: <e8ef1f11-539c-9abc-9977-36366d4994b1@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 22, 2017 at 03:48:30PM +0100, Marc Zyngier wrote:
> On 22/05/17 15:30, Antoine Tenart wrote:
> > On Wed, May 03, 2017 at 05:36:38PM +0100, Marc Zyngier wrote:
> >> On 24/04/17 08:54, Antoine Tenart wrote:
> >>> +
> >>> +	crypto: crypto@800000 {
> >>> +		compatible = "inside-secure,safexcel-eip197";
> >>> +		reg = <0x800000 0x200000>;
> >>> +		interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
> >>
> >> I'm puzzled. How can the interrupt can be both level *and* edge? That
> >> doesn't make any sense.
> > 
> > I agree this looks odd. I took it from Russel's ICU mapping:
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2017-February/489040.html
> 
> This emails says:
> 
> ICU-irq => GIC-SPI-num Enable Edge/Level ICU-group
> [...]
>    24 =>  34 En Lv 0

It also says: 87 =>  34 En Lv 5, which is the IRQ I'm looking for.

Antoine.

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
