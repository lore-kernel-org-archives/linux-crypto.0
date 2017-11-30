From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2,01/12] hwrng: bcm2835 - Obtain base register via resource
Date: Thu, 30 Nov 2017 18:14:37 +1100
Message-ID: <20171130071437.GA30622@gondor.apana.org.au>
References: <20171108004449.32730-2-f.fainelli@gmail.com>
 <20171129063028.GB21594@gondor.apana.org.au>
 <ac49deb2-6f81-1daf-596d-16fd6bd6af32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41050 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdK3HTr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 02:19:47 -0500
Content-Disposition: inline
In-Reply-To: <ac49deb2-6f81-1daf-596d-16fd6bd6af32@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 09:38:52AM -0800, Florian Fainelli wrote:
>
> Hu, okay, I actually had a v3 prepared that I was going to post
> addressing some of the comments. Should I send an incremental set of
> changes now?

Please send it as an incremental set.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
