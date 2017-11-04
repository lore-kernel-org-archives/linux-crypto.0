From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Sat, 4 Nov 2017 21:17:21 +0100
Message-ID: <20171104201721.GA1394@lunn.ch>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-8-f.fainelli@gmail.com>
 <944505791.223880.1509803454887@email.1und1.de>
 <e12063f9-86e4-e9ce-2a7f-f85fe2ce352f@gmail.com>
 <547786283.132202.1509819754396@email.1und1.de>
 <20171104193731.GA751@lunn.ch>
 <20171104200806.GS9463@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, Matt Mackall <mpm@selenic.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:42186 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbdKDURg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Nov 2017 16:17:36 -0400
Content-Disposition: inline
In-Reply-To: <20171104200806.GS9463@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> The clk API outside of DT doesn't have knowledge of when it's "complete"
> to be able to determine whether the clock is not present or temporarily
> missing.  I've already NAK'd this suggestion.

Hi Russell

O.K, yes, makes sense.

We do have of_clk_get_by_name() and of_clk_get(). Would optional
variants of these be acceptable?

	 Andrew
