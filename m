From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 4/7] arm64: marvell: dts: add crypto engine description
 for 7k/8k
Date: Wed, 12 Apr 2017 10:56:08 +0200
Message-ID: <20170412105608.41501b63@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
        <20170329124432.27457-5-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:49907 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbdDLI4V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 04:56:21 -0400
In-Reply-To: <20170329124432.27457-5-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Wed, 29 Mar 2017 14:44:29 +0200, Antoine Tenart wrote:

> +			cpm_crypto: crypto@800000 {
> +				compatible = "inside-secure,safexcel-eip197";
> +				reg = <0x800000 0x200000>;
> +				interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,

Now that I look into this, does it makes sense for an interrupt to be
both an edge interrupt and a level interrupt at the same time? This
looks odd.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
