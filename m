From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: crypto: marvell/CESA: Issues with non cache-line aligned buffers
Date: Fri, 3 Jul 2015 16:41:16 +0200
Message-ID: <20150703144116.GK13481@lunn.ch>
References: <20150703114305.15611807@bbrezillon>
 <20150703131059.GX7557@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnaud Ebalard <arno@natisbad.org>,
	Will Deacon <will.deacon@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:33675 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbbGCOrc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 10:47:32 -0400
Content-Disposition: inline
In-Reply-To: <20150703131059.GX7557@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> A few other things I notice when looking at this code:
> 
>         /* Not all platforms can gate the clock, so it is not
>            an error if the clock does not exists. */
>         cp->clk = clk_get(&pdev->dev, NULL);
>         if (!IS_ERR(cp->clk))
>                 clk_prepare_enable(cp->clk);
> 
> So, if clk_get() returns PTR_ERR(-EPROBE_DEFER) we treat that clock as
> missing?  Is that really the behaviour you want there?

Hi Russell

I probably added that to the older driver and it got copied into the
newer one.

The clock it is using is added to the system using CLK_OF_DECLARE()
This results in an entry in the __clk_of_table table. That table is
walked in of_clk_init(), which is called by time_init() in
arch/arc/kernel/time.c, early in the boot.

If we get -EPROBE_DEFER, something is seriously wrong.

   Andrew
