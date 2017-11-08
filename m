From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Wed, 8 Nov 2017 19:23:03 +0000
Message-ID: <20171108192303.GT9463@n2100.armlinux.org.uk>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
 <20171108004449.32730-8-f.fainelli@gmail.com>
 <1065382783.63901.1510168797132@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Martin Kaiser <martin@kaiser.cx>,
        Matt Mackall <mpm@selenic.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>, devicetree@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57624 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdKHTXj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 14:23:39 -0500
Content-Disposition: inline
In-Reply-To: <1065382783.63901.1510168797132@email.1und1.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 08, 2017 at 08:19:57PM +0100, Stefan Wahren wrote:
> Hi Florian,
> > +	/* Clock is optional on most platforms */
> > +	priv->clk = devm_clk_get(dev, NULL);
> > +
> 
> At least EPROBE_DEFER should be handled here:
> 
> if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
> 	return -EPROBE_DEFER;

	if (priv->clk == ERR_PTR(-EPROBE_DEFER))
		return -EPROBE_DEFER;

is a simpler test for one particular error-pointer value.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
