From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v2 06/12] hwrng: bcm2835-rng: Rework interrupt masking
Date: Wed, 8 Nov 2017 19:46:37 +0100 (CET)
Message-ID: <1086045224.63286.1510166797078@email.1und1.de>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
 <20171108004449.32730-7-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Sean Wang <sean.wang@mediatek.com>, Martin Kaiser <martin@kaiser.cx>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Matt Mackall <mpm@selenic.com>, Russell King <rmk+kernel@armlinux.org.uk>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org,
 Harald Freudenberger <freude@linux.vnet.ibm.com>,
 Rob Herring <robh+dt@kernel.org>, bcm-kernel-feedback-list@broadcom.com,
 linux-crypto@vger.kernel.org,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 linux-arm-kernel@lists.infradead.org, linux-rpi-kernel@lists.infradead.org
To: Florian Fainelli <f.fainelli@gmail.com>, Eric Anholt <eric@anholt.net>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171108004449.32730-7-f.fainelli@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian,

> Florian Fainelli <f.fainelli@gmail.com> hat am 8. November 2017 um 01:44 geschrieben:
> 
> 
> The interrupt masking done for Northstart Plus and Northstar (BCM5301X)
> is moved from being a function pointer mapped to of_device_id::data into
> a proper part of the hwrng::init callback. While at it, we also make the
> of_data be a proper structure indicating the platform specifics, since
> the day we need to add a second type of platform information, we would
> have to do that anyway.

in the lack of proper documentation for bcm2835 rng, is it possible that we should mask the interrupts for bcm2835 as well?
