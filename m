From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] hwrng: omap - fixes and improvements
Date: Thu, 16 Mar 2017 18:08:22 +0800
Message-ID: <20170316100822.GB12137@gondor.apana.org.au>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        romain.perier@collabora.com, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41971 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751182AbdCPKIj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:08:39 -0400
Content-Disposition: inline
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Patches 1-3 applied to crypto and patch 4 applied to cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
