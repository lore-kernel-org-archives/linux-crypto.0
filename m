From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 15:55:22 +0100
Message-ID: <2090327.CHzkLTTdtg@positron.chronox.de>
References: <20170324142446.31129-1-krzk@kernel.org> <3628768.ze2UxnIp5I@tauon.atsec.com> <20170324145156.miqmxgkhn2v7rbcu@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58350 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935191AbdCXOzg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:55:36 -0400
In-Reply-To: <20170324145156.miqmxgkhn2v7rbcu@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. März 2017, 15:51:56 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,
> 
> I'll use the generated random numbers.

If you do that, may I propse that you update this seed field periodically? 
E.g. with every (or every other) user request for random data, you may update 
that field with new data.

Ciao
Stephan
