From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v3 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Tue, 23 May 2017 14:56:27 +0200
Message-ID: <20170523145627.63054e08@free-electrons.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
        <20170424075407.19730-2-antoine.tenart@free-electrons.com>
        <7986721e-3a2b-23fb-61d7-7032f0d65533@arm.com>
        <20170522143049.GD14976@kwain.lan>
        <e8ef1f11-539c-9abc-9977-36366d4994b1@arm.com>
        <20170522145440.GE14976@kwain.lan>
        <44fc18ba-a06a-de89-2172-08c093880e79@arm.com>
        <20170522213746.403aa844@free-electrons.com>
        <9a3961ee-1396-cc8f-64ca-12beacf75c2a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com,
        boris.brezillon@free-electrons.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org,
        robin.murphy@arm.com, oferh@marvell.com,
        linux-arm-kernel@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:39650 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965392AbdEWM4a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 08:56:30 -0400
In-Reply-To: <9a3961ee-1396-cc8f-64ca-12beacf75c2a@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Tue, 23 May 2017 12:13:28 +0100, Marc Zyngier wrote:

> > The crypto block being in the CP part, it has a wired interrupt to the
> > ICU (also in the CP). The ICU then turns this wired interrupt into a
> > memory write transaction to a register called GICP SPI in the AP, which
> > triggers a SPI interrupt in the GIC.  
> 
> Is that some kind of Level-triggered MSI, à la GICv3 GICD_SETSPI_NSR?

It is some kind of MSI, and the registers are called
GICP_SETSPI/GICP_CLRSPI, so I would assume it's quite similar to this
GICv3 feature.

> > However, I have a patch series that I plan to submit hopefully in the
> > next days that adds an ICU driver, and changes the Device Tree to refer
> > to the ICU interrupt instead.  
> 
> OK, I'm quite interested to see that, specially if my above hunch is
> right...

I'll send the patches soon. I'm sure there will be lots of comments :)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
