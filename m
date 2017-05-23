From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Tue, 23 May 2017 12:13:28 +0100
Message-ID: <9a3961ee-1396-cc8f-64ca-12beacf75c2a@arm.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-2-antoine.tenart@free-electrons.com>
 <7986721e-3a2b-23fb-61d7-7032f0d65533@arm.com>
 <20170522143049.GD14976@kwain.lan>
 <e8ef1f11-539c-9abc-9977-36366d4994b1@arm.com>
 <20170522145440.GE14976@kwain.lan>
 <44fc18ba-a06a-de89-2172-08c093880e79@arm.com>
 <20170522213746.403aa844@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758513AbdEWLNd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 07:13:33 -0400
In-Reply-To: <20170522213746.403aa844@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22/05/17 20:37, Thomas Petazzoni wrote:
> Hello,
> 
> On Mon, 22 May 2017 16:02:33 +0100, Marc Zyngier wrote:
> 
>>> It also says: 87 =>  34 En Lv 5, which is the IRQ I'm looking for.  
>>
>> Ah, that one as well. So how is the interrupt routed? Via the ICU, and
>> then to the GIC (with several ICU sources mapped on a single SPI)?
> 
> The crypto block being in the CP part, it has a wired interrupt to the
> ICU (also in the CP). The ICU then turns this wired interrupt into a
> memory write transaction to a register called GICP SPI in the AP, which
> triggers a SPI interrupt in the GIC.

Is that some kind of Level-triggered MSI, à la GICv3 GICD_SETSPI_NSR?

> In the current mainline kernel, the ICU is configured by the firmware
> and creates static associations between wired interrupts in the CP and
> corresponding SPI interrupts. Therefore the Device Tree currently
> reference such SPI interrupts directly.
> 
> However, I have a patch series that I plan to submit hopefully in the
> next days that adds an ICU driver, and changes the Device Tree to refer
> to the ICU interrupt instead.

OK, I'm quite interested to see that, specially if my above hunch is
right...

> Therefore, I don't think the binding should reference anything else
> than the usual info about the interrupts property.

That I completely agree with, as long as it doesn't describe anything
that is semantically incorrect.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
