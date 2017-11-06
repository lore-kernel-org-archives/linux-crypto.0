From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 10/12] dt-bindings: rng: Incorporate brcm,bcm6368.txt
 binding
Date: Mon, 6 Nov 2017 15:38:26 -0600
Message-ID: <20171106213826.vetpedvdiwwmo4hs@rob-hp-laptop>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-11-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        <linux-crypto@vger
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:43748 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbdKFVi2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 16:38:28 -0500
Content-Disposition: inline
In-Reply-To: <20171102010408.27736-11-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 01, 2017 at 06:04:06PM -0700, Florian Fainelli wrote:
> Since the same block is used on BCM2835 and BCM6368, merge the bindings
> and remove the brcm,bcm6368.txt binding document.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/rng/brcm,bcm2835.txt       | 22 +++++++++++++++++++---
>  .../devicetree/bindings/rng/brcm,bcm6368.txt       | 17 -----------------
>  2 files changed, 19 insertions(+), 20 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm6368.txt

Acked-by: Rob Herring <robh@kernel.org>
