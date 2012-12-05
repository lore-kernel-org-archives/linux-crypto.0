From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 0/7] crypto: omap-aes updates
Date: Wed, 5 Dec 2012 12:28:46 +0200
Message-ID: <CALLzPKaR8W+T1BfdzYVPE37sMna5OZBLn-JzpF+d5wufNX6_yQ@mail.gmail.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
	<CALLzPKZ20iQXGw9k4sxiVW0VOTdV5pw6Gz8W8V4SRpe=qVY+4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Mark A. Greer" <mgreer@animalcreek.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:57290 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753714Ab2LEK2s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Dec 2012 05:28:48 -0500
Received: by mail-ob0-f197.google.com with SMTP id v19so22971130obq.4
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2012 02:28:46 -0800 (PST)
In-Reply-To: <CALLzPKZ20iQXGw9k4sxiVW0VOTdV5pw6Gz8W8V4SRpe=qVY+4w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am not working on OMAP anymore and not able to test anything.
But in general changes are OK for me.

- Dmitry


On Tue, Nov 20, 2012 at 2:08 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> Great. You also worked on AES...
> Will take a loos asap.
>
> On Mon, Nov 19, 2012 at 9:03 PM, Mark A. Greer <mgreer@animalcreek.com> wrote:
>> From: "Mark A. Greer" <mgreer@animalcreek.com>
>>
>> This series updates the crypto omap-aes driver and supporting
>> infrastructure.
>>
>> Notes:
>>
>> a) Based on omap-sham patches recently submitted, XXX
>>
>> b) Since these patches will likely go though the OMAP tree (and not
>>    through the crypto tree), it would be nice if the crypto guy(s)
>>    would ACK or NACK patches 4-7 which modify the
>>    drivers/crypto/omap-sham.c driver.
>>
>> c) These have only been tested on an omap2420 h4 and an am37x evm.
>>
>> d) Many thanks to Jon Hunter for testing on his omap2420 h4.
>>
>> Mark A. Greer (7):
>>   ARM: OMAP2xxx: hwmod: Convert AES crypto devcie data to hwmod
>>   ARM: OMAP3xxx: hwmod: Convert AES crypto device data to hwmod
>>   ARM: OMAP2+: Remove unnecessary message when no AES IP is present
>>   crypto: omap-aes: Remove cpu_is/omap_type check from driver
>>   crypto: omap-aes: Convert to use pm_runtime API
>>   crypto: omap-aes: Add code to use dmaengine API
>>   crypto: omap-aes: Remove usage of private DMA API
>>
>>  arch/arm/mach-omap2/clock2430_data.c               |   1 +
>>  arch/arm/mach-omap2/clock3xxx_data.c               |   1 +
>>  arch/arm/mach-omap2/devices.c                      |  75 +-------
>>  arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   1 +
>>  arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   1 +
>>  .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |  18 ++
>>  arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |  38 ++++
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  62 +++++++
>>  arch/arm/mach-omap2/omap_hwmod_common_data.h       |   2 +
>>  drivers/crypto/omap-aes.c                          | 202 ++++++++++++---------
>>  10 files changed, 251 insertions(+), 150 deletions(-)
>>
>> --
>> 1.7.12
>>
