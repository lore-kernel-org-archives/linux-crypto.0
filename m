From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 0/4] hwrng: omap - fixes and improvements
Date: Tue, 7 Mar 2017 15:14:06 +0000
Message-ID: <20170307151406.GS11350@io.lakedaemon.net>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:51655 "EHLO
        outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756122AbdCGTfJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 14:35:09 -0500
Content-Disposition: inline
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Thomas,

On Tue, Mar 07, 2017 at 03:14:45PM +0100, Thomas Petazzoni wrote:
> Hello,
> 
> This small patch series brings a few fixes and improvements to the
> omap_rng driver. The first fix is particularly important, as it fixes
> using the driver built as a module on SoCs that require a clock for
> the IP to work properly.
> 
> Thanks,
> 
> Thomas
> 
> Thomas Petazzoni (4):
>   hwrng: omap - write registers after enabling the clock
>   hwrng: omap - use devm_clk_get() instead of of_clk_get()
>   hwrng: omap - Do not access INTMASK_REG on EIP76
>   hwrng: omap - move clock related code to omap_rng_probe()
> 
>  drivers/char/hw_random/omap-rng.c | 36 +++++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)

For the whole series,

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
