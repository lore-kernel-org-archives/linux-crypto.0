From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH 0/3] crypto: picoxcell - Cleanups removing non-DT code
Date: Mon, 2 Jan 2017 14:49:57 -0300
Message-ID: <5cbfeb40-f3c3-8473-24af-f302e3c6f02b@osg.samsung.com>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
 <2309314.lMWYhcWsTB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2309314.lMWYhcWsTB@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Arnd,

On 01/02/2017 02:10 PM, Arnd Bergmann wrote:
> On Monday, January 2, 2017 2:06:56 PM CET Javier Martinez Canillas wrote:
>>
>> This small series contains a couple of cleanups that removes some driver's code
>> that isn't needed due the driver being for a DT-only platform.
>>
>> The changes were suggested by Arnd Bergmann as a response to a previous patch:
>> https://lkml.org/lkml/2017/1/2/342
>>
>> Patch #1 allows the driver to be built when the COMPILE_TEST option is enabled.
>> Patch #2 removes the platform ID table since isn't needed for DT-only drivers.
>> Patch #3 removes a wrapper function that's also not needed if driver is DT-only.
>>
>>
> 
> Looks good, but I don't know if the first patch causes some build warnings

Thanks for looking at the patches.

> on non-ARM platforms, better wait at least for the 0-day build results,
> and maybe build-test on x86-32 and x86-64.
> 

I should had mentioned that I built tested for arm, arm64, x86-32 and x86-64,
and saw now issues. But I agree with you that it's better to wait for the
0-day builder in case it reports issues on some platforms.

> 	Arnd
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
