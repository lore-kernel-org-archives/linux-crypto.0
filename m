From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/12] bcm63xx-rng conversion to bcm2835-rng
Date: Thu, 2 Nov 2017 12:06:24 -0700
Message-ID: <cf0cc77c-6114-74d3-2342-b9c4a55f6800@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <1329593033.127526.1509649260041@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Mark Rutlan
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329593033.127526.1509649260041-7tX72C7vayboQLBSYMtkGA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Stefan,

On 11/02/2017 12:01 PM, Stefan Wahren wrote:
> Hi Florian,
> 
>> Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> hat am 2. November 2017 um 02:03 geschrieben:
>>
>>
>> Hi,
>>
>> As it usually happens when there is a fair amount of HW IP block re-use,
>> competing implementations show up. In that case the BCM2835 HWRNG driver and
>> the BCM63xx RNG driver have exactly the same register offsets and this is
>> indeed the same piece of HW.
>>
>> This patch series first prepares the bcm2835-rng to be more future proof and
>> support newer platforms, and the last part brings in what is necessary to
>> migrate the bcm63xx-rng over to bcm2835-rng. Finally we delete bcm63xx-rng
>> completely.
>>
>> The reason why BCM2835 RNG was kept over BCM63xx RNG is because the former
>> deals correctly with a warm up count and the number of words available in the
>> FIFO size.
> 
> are these the same patches as in this branch [1]?
> 
> https://github.com/ffainelli/linux/commits/rng-consolidation

Yes, this branch contains these 12 patches.
-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
