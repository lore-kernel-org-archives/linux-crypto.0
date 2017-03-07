From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH 0/4] hwrng: omap - fixes and improvements
Date: Tue,  7 Mar 2017 15:14:45 +0100
Message-ID: <1488896089-17586-1-git-send-email-thomas.petazzoni@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, romain.perier@collabora.com,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58558 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdCGOQa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2017 09:16:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This small patch series brings a few fixes and improvements to the
omap_rng driver. The first fix is particularly important, as it fixes
using the driver built as a module on SoCs that require a clock for
the IP to work properly.

Thanks,

Thomas

Thomas Petazzoni (4):
  hwrng: omap - write registers after enabling the clock
  hwrng: omap - use devm_clk_get() instead of of_clk_get()
  hwrng: omap - Do not access INTMASK_REG on EIP76
  hwrng: omap - move clock related code to omap_rng_probe()

 drivers/char/hw_random/omap-rng.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

-- 
2.7.4
