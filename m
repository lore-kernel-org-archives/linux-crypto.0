From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2,01/12] hwrng: bcm2835 - Obtain base register via resource
Date: Wed, 29 Nov 2017 17:30:28 +1100
Message-ID: <20171129063028.GB21594@gondor.apana.org.au>
References: <20171108004449.32730-2-f.fainelli@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108004449.32730-2-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 07, 2017 at 04:44:38PM -0800, Florian Fainelli wrote:
> In preparation for consolidating bcm63xx-rng into bcm2835-rng, make sure
> that we obtain the base register via platform_get_resource() since we
> need to support the non-DT enabled MIPS-based BCM63xx DSL SoCs.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
