From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: rng: Document BCM7278 RNG200 compatible
Date: Mon, 6 Nov 2017 14:26:59 -0600
Message-ID: <20171106202659.kmqvq6jvvehsg6ii@rob-hp-laptop>
References: <20171101232006.3943-1-f.fainelli@gmail.com>
 <20171101232006.3943-2-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
        <devicetree@vger.kernel.o
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:47754 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbdKFU1B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 15:27:01 -0500
Content-Disposition: inline
In-Reply-To: <20171101232006.3943-2-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 01, 2017 at 04:20:05PM -0700, Florian Fainelli wrote:
> BCM7278 includes a RGN200 hardware random number generator, document the
> compatible string for that version of the IP.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
