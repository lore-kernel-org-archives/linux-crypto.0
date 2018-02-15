From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v3 0/5] crypto: ahash.c: Require export/import in ahash
Date: Thu, 15 Feb 2018 18:00:44 +0100
Message-ID: <32069edc-e816-6ab0-f057-b1dab5d30db4@partner.samsung.com>
References: <CGME20180118183438eucas1p2e2e7be8625ae0950c519e27424f9301a@eucas1p2.samsung.com>
        <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <20180215154132.GA7352@gondor.apana.org.au>
        <6b29116a-c39c-9813-34a0-d5c05bd30c9d@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
To: Marek Vasut <marex@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <6b29116a-c39c-9813-34a0-d5c05bd30c9d@denx.de>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 15.02.2018 17:27, Marek Vasut wrote:
> On 02/15/2018 04:41 PM, Herbert Xu wrote:
>> On Thu, Jan 18, 2018 at 07:33:59PM +0100, Kamil Konieczny wrote:
>>> First four patches add empty hash export and import functions to each driver,
>>> with the same behaviour as in crypto framework. The last one drops them from
>>> crypto framework. Last one for ahash.c depends on all previous.
>>>
>>> Changes in v3:
>>> added change for bfin_crc.c
>>> make this a patchset, instead of unreleated patches
>>> make commit message more descriptive
>>>
>>> Kamil Konieczny (5):
>>>   crypto: mxs-dcp: Add empty hash export and import
>>>   crypto: n2_core: Add empty hash export and import
>>>   crypto: ux500/hash: Add empty export and import
>>>   crypto: bfin_crc: Add empty hash export and import
>>>   crypto: ahash.c: Require export/import in ahash
>>>
>>>  crypto/ahash.c                        | 18 ++----------------
>>>  drivers/crypto/bfin_crc.c             | 12 ++++++++++++
>>>  drivers/crypto/mxs-dcp.c              | 14 ++++++++++++++
>>>  drivers/crypto/n2_core.c              | 12 ++++++++++++
>>>  drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
>>>  5 files changed, 58 insertions(+), 16 deletions(-)
>>
>> All applied.  Thanks.
> 
> This makes no sense, cfr my comment on 5/5
> 
> Seems like if the driver doesn't implement those, the core can easily
> detect that and perform the necessary action. Moving the checks out of
> core seems like the wrong thing to do, rather you should enhance the
> checks in core if they're insufficient in my opinion.

The bug can only be in driver which will not implement those two functions,
but we already had all drivers with those due to patches 1..4
All other drivers do have them.

Additionally, with crypto we want minimize code and run as fast as possible.

Moving checks out of core will impose on driver author need for implement
those functions, or declare them empty, but in case of empty ones 
crypto will not work properly with such driver.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
