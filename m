From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 17:58:18 +0300
Message-ID: <20170324145818.3muyy4cq3gms5len@kozik-lap>
References: <20170324142446.31129-1-krzk@kernel.org>
 <3628768.ze2UxnIp5I@tauon.atsec.com>
 <20170324145156.miqmxgkhn2v7rbcu@kozik-lap>
 <2090327.CHzkLTTdtg@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35381 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752863AbdCXO60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:58:26 -0400
Content-Disposition: inline
In-Reply-To: <2090327.CHzkLTTdtg@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 24, 2017 at 03:55:22PM +0100, Stephan Müller wrote:
> Am Freitag, 24. März 2017, 15:51:56 CET schrieb Krzysztof Kozlowski:
> 
> Hi Krzysztof,
> > 
> > I'll use the generated random numbers.
> 
> If you do that, may I propse that you update this seed field periodically? 
> E.g. with every (or every other) user request for random data, you may update 
> that field with new data.

Sounds reasonable. Thanks for feedback, it is much appreciated.

Best regards,
Krzysztof
