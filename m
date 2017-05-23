From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v5 1/4] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Tue, 23 May 2017 09:13:07 +0200
Message-ID: <20170523071307.GA5465@kwain.lan>
References: <20170522144514.6654-1-antoine.tenart@free-electrons.com>
 <20170522144514.6654-2-antoine.tenart@free-electrons.com>
 <20170522213416.7440ee32@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60828 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756442AbdEWHNT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 03:13:19 -0400
Content-Disposition: inline
In-Reply-To: <20170522213416.7440ee32@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Thomas,

On Mon, May 22, 2017 at 09:34:16PM +0200, Thomas Petazzoni wrote:
> On Mon, 22 May 2017 16:45:11 +0200, Antoine Tenart wrote:
> > +		interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
> 
> You already got the feedback previously that an interrupt that is both
> edge and level at the same time doesn't make sense. Could you fix this?
> 
> Also, the DTs that have already been merged by Grégory are wrong for
> the same reason and should be fixed.

Sure, I'll fix this and send a new version :)

Thanks,
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
