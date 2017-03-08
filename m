From: Romain Perier <romain.perier@collabora.com>
Subject: Re: [PATCH 0/4] hwrng: omap - fixes and improvements
Date: Wed, 8 Mar 2017 09:37:17 +0100
Message-ID: <bfada3f4-b8b6-16e3-ec65-79469a194b70@collabora.com>
References: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33387 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdCHKdC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 05:33:02 -0500
In-Reply-To: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,


Le 07/03/2017 à 15:14, Thomas Petazzoni a écrit :
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

Reviewed-by: Romain Perier <romain.perier@collabora.com>
