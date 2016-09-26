From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH v3 0/8] Add support for SafeXcel IP-76 to OMAP RNG
Date: Mon, 26 Sep 2016 12:01:21 +0200
Message-ID: <57E8F1F1.6040906@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
 <57DBEB1A.4050602@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:41939 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S964818AbcIZKBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 06:01:24 -0400
In-Reply-To: <57DBEB1A.4050602@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Le 16/09/2016 14:52, Romain Perier a écrit :
> Hello,
>
> Le 16/09/2016 12:08, Romain Perier a écrit :
>> The driver omap-rng has a lot of similarity with the IP block SafeXcel
>> IP-76. A lot of registers are the same and the way that the driver works
>> is very closed the description of the TRNG EIP76 in its datasheet.
>>
>> This series refactorize the driver, add support for generating bigger
>> output random data and add a device variant for SafeXcel IP-76, found
>> in Armada 8K.
>>
>> Romain Perier (8):
>>    dt-bindings: Add vendor prefix for INSIDE Secure
>>    dt-bindings: omap-rng: Document SafeXcel IP-76 device variant
>>    hwrng: omap - Switch to non-obsolete read API implementation
>>    hwrng: omap - Remove global definition of hwrng
>>    hwrng: omap - Add support for 128-bit output of data
>>    hwrng: omap - Don't prefix the probe message with OMAP
>>    hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K
>>    arm64: dts: marvell: add TRNG description for Armada 8K CP
>>
>>   Documentation/devicetree/bindings/rng/omap_rng.txt |  14 +-
>>   .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>>   .../boot/dts/marvell/armada-cp110-master.dtsi      |   8 +
>>   .../arm64/boot/dts/marvell/armada-cp110-slave.dtsi |   8 +
>>   drivers/char/hw_random/Kconfig                     |   2 +-
>>   drivers/char/hw_random/omap-rng.c                  | 162
>> ++++++++++++++++-----
>>   6 files changed, 152 insertions(+), 43 deletions(-)
>>
>
> If possible, I would like to get "Tested-by" tags by the omap guys
> before this set of patches is merged, to be sure that there are no
> regressions for the OMAP variant.
>
> Thanks,

Added omap ML to Cc:

Romain,
-- 
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
