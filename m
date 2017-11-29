From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [v2,01/12] hwrng: bcm2835 - Obtain base register via resource
Date: Wed, 29 Nov 2017 09:38:52 -0800
Message-ID: <ac49deb2-6f81-1daf-596d-16fd6bd6af32@gmail.com>
References: <20171108004449.32730-2-f.fainelli@gmail.com>
 <20171129063028.GB21594@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
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
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129063028.GB21594@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11/28/2017 10:30 PM, Herbert Xu wrote:
> On Tue, Nov 07, 2017 at 04:44:38PM -0800, Florian Fainelli wrote:
>> In preparation for consolidating bcm63xx-rng into bcm2835-rng, make sure
>> that we obtain the base register via platform_get_resource() since we
>> need to support the non-DT enabled MIPS-based BCM63xx DSL SoCs.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> All applied.  Thanks.

Hu, okay, I actually had a v3 prepared that I was going to post
addressing some of the comments. Should I send an incremental set of
changes now?
-- 
Florian
