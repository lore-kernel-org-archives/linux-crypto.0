From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH v3 0/8] Add support for SafeXcel IP-76 to OMAP RNG
Date: Thu, 20 Oct 2016 09:02:33 +0200
Message-ID: <dd208140-468c-f17d-1a5f-b297fa0688ec@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
 <57DBEB1A.4050602@free-electrons.com> <57E8F1F1.6040906@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from up.free-electrons.com ([163.172.77.33]:49724 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750912AbcJTHCg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 03:02:36 -0400
In-Reply-To: <57E8F1F1.6040906@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Le 26/09/2016 à 12:01, Romain Perier a écrit :
>
>
> Le 16/09/2016 14:52, Romain Perier a écrit :
>> Hello,
>>
>> Le 16/09/2016 12:08, Romain Perier a écrit :
>>> The driver omap-rng has a lot of similarity with the IP block SafeXcel
>>> IP-76. A lot of registers are the same and the way that the driver works
>>> is very closed the description of the TRNG EIP76 in its datasheet.
>>>
>>> This series refactorize the driver, add support for generating bigger
>>> output random data and add a device variant for SafeXcel IP-76, found
>>> in Armada 8K.
>>>
>>> Romain Perier (8):
>>>    dt-bindings: Add vendor prefix for INSIDE Secure
>>>    dt-bindings: omap-rng: Document SafeXcel IP-76 device variant
>>>    hwrng: omap - Switch to non-obsolete read API implementation
>>>    hwrng: omap - Remove global definition of hwrng
>>>    hwrng: omap - Add support for 128-bit output of data
>>>    hwrng: omap - Don't prefix the probe message with OMAP
>>>    hwrng: omap - Add device variant for SafeXcel IP-76 found in
>>> Armada 8K
>>>    arm64: dts: marvell: add TRNG description for Armada 8K CP
>>>
>>>   Documentation/devicetree/bindings/rng/omap_rng.txt |  14 +-
>>>   .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>>>   .../boot/dts/marvell/armada-cp110-master.dtsi      |   8 +
>>>   .../arm64/boot/dts/marvell/armada-cp110-slave.dtsi |   8 +
>>>   drivers/char/hw_random/Kconfig                     |   2 +-
>>>   drivers/char/hw_random/omap-rng.c                  | 162
>>> ++++++++++++++++-----
>>>   6 files changed, 152 insertions(+), 43 deletions(-)
>>>
>>
>> If possible, I would like to get "Tested-by" tags by the omap guys
>> before this set of patches is merged, to be sure that there are no
>> regressions for the OMAP variant.
>>
>> Thanks,
>
> Added omap ML to Cc:
>
> Romain,

Without any feedbacks from the OMAP guys, could you merge please ? 
Regressions can be detected in "next" and then fixed.

Regards,
Romain
-- 
Romain Perier, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
