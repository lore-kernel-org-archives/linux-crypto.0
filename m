From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] hwrng: iproc-rng200: Add support for BCM7278
Date: Fri, 10 Nov 2017 22:36:25 +1100
Message-ID: <20171110113625.GA26163@gondor.apana.org.au>
References: <20171101232006.3943-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE"
        <bcm-kernel-feedback-list@broadcom.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Martin Kaiser <martin@kaiser.cx>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35822 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752713AbdKJLje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 06:39:34 -0500
Content-Disposition: inline
In-Reply-To: <20171101232006.3943-1-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 01, 2017 at 04:20:04PM -0700, Florian Fainelli wrote:
> Hi,
> 
> This patch series adds support for the RNG200 block found on the BCM7278 SoC.
> This requires us to update the compatible string (and associated binding
> document) as well as the Kconfig option to make that driver selectable with
> ARCH_BRCMSTB gating the enabling of such SoCs.
> 
> Thank you
> 
> Florian Fainelli (2):
>   dt-bindings: rng: Document BCM7278 RNG200 compatible
>   hwrng: iproc-rng200: Add support for BCM7278

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
