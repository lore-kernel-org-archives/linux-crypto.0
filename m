From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 0/5] crypto: ahash.c: Require export/import in ahash
Date: Fri, 16 Feb 2018 10:49:07 +0100
Message-ID: <9c9d274c-f2fc-7f2c-1ae9-81dd0f116bbb@denx.de>
References: <CGME20180118183438eucas1p2e2e7be8625ae0950c519e27424f9301a@eucas1p2.samsung.com>
 <20180118183404.12583-1-k.konieczny@partner.samsung.com>
 <20180215154132.GA7352@gondor.apana.org.au>
 <6b29116a-c39c-9813-34a0-d5c05bd30c9d@denx.de>
 <32069edc-e816-6ab0-f057-b1dab5d30db4@partner.samsung.com>
 <d7300e36-392a-18cf-5176-6eaf4c16eb43@denx.de>
 <cdb62a71-bb7e-8c62-06bc-ab91c9642e06@partner.samsung.com>
 <14364c45-8f56-e6d6-66f2-8357bf89a894@denx.de>
 <77b4e0a0-0e2c-af7a-690e-4d516d616717@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77b4e0a0-0e2c-af7a-690e-4d516d616717@partner.samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/16/2018 10:16 AM, Kamil Konieczny wrote:
> 
> On 15.02.2018 19:32, Marek Vasut wrote:
>> On 02/15/2018 07:06 PM, Kamil Konieczny wrote:
>>>
>>>
>>> On 15.02.2018 18:06, Marek Vasut wrote:
>>>> On 02/15/2018 06:00 PM, Kamil Konieczny wrote:
>>>>>
>>>>>
>>>>> On 15.02.2018 17:27, Marek Vasut wrote:
>>>>>> On 02/15/2018 04:41 PM, Herbert Xu wrote:
>>>>>>> On Thu, Jan 18, 2018 at 07:33:59PM +0100, Kamil Konieczny wrote:
>>>>>>>> First four patches add empty hash export and import functions to each driver,
>>>>>>>> with the same behaviour as in crypto framework. The last one drops them from
>>>>>>>> crypto framework. Last one for ahash.c depends on all previous.
>>>>>>>>
>>>>>>>> Changes in v3:
>>>>>>>> added change for bfin_crc.c
>>>>>>>> make this a patchset, instead of unreleated patches
>>>>>>>> make commit message more descriptive
>>>>>>>>
>>>>>>>> Kamil Konieczny (5):
>>>>>>>>   crypto: mxs-dcp: Add empty hash export and import
>>>>>>>>   crypto: n2_core: Add empty hash export and import
>>>>>>>>   crypto: ux500/hash: Add empty export and import
>>>>>>>>   crypto: bfin_crc: Add empty hash export and import
>>>>>>>>   crypto: ahash.c: Require export/import in ahash
>>>>>>>>
>>>>>>>>  crypto/ahash.c                        | 18 ++----------------
>>>>>>>>  drivers/crypto/bfin_crc.c             | 12 ++++++++++++
>>>>>>>>  drivers/crypto/mxs-dcp.c              | 14 ++++++++++++++
>>>>>>>>  drivers/crypto/n2_core.c              | 12 ++++++++++++
>>>>>>>>  drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
>>>>>>>>  5 files changed, 58 insertions(+), 16 deletions(-)
>>>>>>>
>>>>>>> All applied.  Thanks.
>>>>>>
>>>>>> This makes no sense, cfr my comment on 5/5
>>>>>>
>>>>>> Seems like if the driver doesn't implement those, the core can easily
>>>>>> detect that and perform the necessary action. Moving the checks out of
>>>>>> core seems like the wrong thing to do, rather you should enhance the
>>>>>> checks in core if they're insufficient in my opinion.
>>>>>
>>>>> The bug can only be in driver which will not implement those two functions,
>>>>> but we already had all drivers with those due to patches 1..4
>>>>> All other drivers do have them.
>>>>
>>>> The core can very well check if these functions are not populated and
>>>> return ENOSYS
>>>>
>>>>> Additionally, with crypto we want minimize code and run as fast as possible.
>>>>
>>>> So you remove all NULL pointer checks ? Esp. in security-sensitive code?
>>>> What is the impact of this non-critical path code on performance?
>>>>
>>>> Come on ...
>>>>
>>>
>>> Why you want checks for something that not exist ?
>>>
>>> Those without them will not work and will do Oops in crypto testmgr,
>>> so such drivers should not be used nor accepted in drivers/crypto
>>>
>>> Ask yourself why crypto do not check for NULL in ahash digest or other
>>> required ahash functions.
>>
>> Are you suggesting that the kernel code should NOT perform NULL pointer
>> checks ?
>>
>> Are you suggesting each driver should implement every single callback
>> available and if it is not implemented, return -ENOSYS ? This looks like
>> a MASSIVE code duplication.
> 
> It is source code duplication. One do not load all crypto drivers at once,
> simple because one board has only one crypto HW (or few closely related),

You can compile kernel with generic config and at that point you have
all the duplicated code stored on your machine. But this discussion is
moving away from the point I was concerned about -- that this patchset
_increases_ code duplication and I find this wrong.

> and if one even try, almost none of them will initialize on given
> hardware. E.g. on Exynos board only exynos drivers will load, on board with
> omap crypto only omap crypto will load.
>  
>>>>> Moving checks out of core will impose on driver author need for implement
>>>>> those functions, or declare them empty, but in case of empty ones 
>>>>> crypto will not work properly with such driver.
>>>>
>>>> You can very well impose that in the core, except you don't duplicate
>>>> the code.
>>>
>>> Now size of crypto core is reduced.
>>
>> You implemented the same code thrice, it surely is not reduced.
> 
> As I said above, it reduces binary size at cost of more source code in few drivers.

It does NOT reduce the binary size, just try compiling all the drivers
in and it will make the kernel bigger.

-- 
Best regards,
Marek Vasut
