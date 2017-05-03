From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 2/3] crypto: inside-secure: add SafeXcel EIP197 crypto
 engine driver
Date: Wed, 3 May 2017 18:14:49 +0100
Message-ID: <c018afb6-202c-6e89-d990-c2259dc07f6e@arm.com>
References: <20170424075407.19730-1-antoine.tenart@free-electrons.com>
 <20170424075407.19730-3-antoine.tenart@free-electrons.com>
 <8ff65d6a5e5e4d388d3c5a384e4f5fd6@IL-EXCH01.marvell.com>
 <20170424085731.wbg53t5lcler4mng@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com"
        <gregory.clement@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "thomas.petazzoni@free-electrons.com"
        <thomas.petazzoni@free-electrons.com>,
        "boris.brezillon@free-electrons.com"
        <boris.brezillon@free-electrons.com>,
        Ofer Heifetz <oferh@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Igal Liberman <igall@marvell.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59540 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbdECROz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 13:14:55 -0400
In-Reply-To: <20170424085731.wbg53t5lcler4mng@kwain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/04/17 09:57, Antoine Tenart wrote:
> Hi Igal,
> 
> On Mon, Apr 24, 2017 at 08:50:32AM +0000, Igal Liberman wrote:
>> [...]
>>
>>> +	priv->clk = of_clk_get(dev->of_node, 0);
>>> +	if (!IS_ERR(priv->clk)) {
>>> +		ret = clk_prepare_enable(priv->clk);
>>> +		if (ret) {
>>> +			dev_err(dev, "unable to enable clk (%d)\n", ret);
>>> +			return ret;
>>> +		}
>>> +	} else {
>>> +		/* The clock isn't mandatory */
>>> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
>>> +			return -EPROBE_DEFER;
>>> +	}
>>> +
>>> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>>
>> The correct address width of the engine in Marvell SoCs is 40bit.

Is that what the IP block itself is internally limited to, or just how
many bits happen to be wired up externally in the particular Marvell
integrations?

> Oops. I'll update.

If the device itself can handle full 64-bit addresses, then the driver
should reflect that regardless of the integration - describing
integration limitations is the job of the firmware, e.g. with DT
"dma-ranges", assuming they actually matter (typically if the whole SoC
interconnect and physical memory map is the same width then having an
even wider DMA mask doesn't make any difference - 64 bits still just
means "everything").

If it's the case that the IP is configurable and could be synthesised
with various internal address widths, then that might warrant a DT
property to identify the particular configuration if it's not readable
from some ID register, although it may be reasonable in practice to
simply assume the chosen configuration to be sane (i.e. not smaller than
the rest of the system) and that the driver can set the maximal DMA mask
as above.

Robin.

> 
> Thanks!
> Antoine
> 
