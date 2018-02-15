From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 0/5] crypto: ahash.c: Require export/import in ahash
Date: Thu, 15 Feb 2018 17:27:32 +0100
Message-ID: <6b29116a-c39c-9813-34a0-d5c05bd30c9d@denx.de>
References: <CGME20180118183438eucas1p2e2e7be8625ae0950c519e27424f9301a@eucas1p2.samsung.com>
 <20180118183404.12583-1-k.konieczny@partner.samsung.com>
 <20180215154132.GA7352@gondor.apana.org.au>
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
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180215154132.GA7352@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/15/2018 04:41 PM, Herbert Xu wrote:
> On Thu, Jan 18, 2018 at 07:33:59PM +0100, Kamil Konieczny wrote:
>> First four patches add empty hash export and import functions to each driver,
>> with the same behaviour as in crypto framework. The last one drops them from
>> crypto framework. Last one for ahash.c depends on all previous.
>>
>> Changes in v3:
>> added change for bfin_crc.c
>> make this a patchset, instead of unreleated patches
>> make commit message more descriptive
>>
>> Kamil Konieczny (5):
>>   crypto: mxs-dcp: Add empty hash export and import
>>   crypto: n2_core: Add empty hash export and import
>>   crypto: ux500/hash: Add empty export and import
>>   crypto: bfin_crc: Add empty hash export and import
>>   crypto: ahash.c: Require export/import in ahash
>>
>>  crypto/ahash.c                        | 18 ++----------------
>>  drivers/crypto/bfin_crc.c             | 12 ++++++++++++
>>  drivers/crypto/mxs-dcp.c              | 14 ++++++++++++++
>>  drivers/crypto/n2_core.c              | 12 ++++++++++++
>>  drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
>>  5 files changed, 58 insertions(+), 16 deletions(-)
> 
> All applied.  Thanks.

This makes no sense, cfr my comment on 5/5

Seems like if the driver doesn't implement those, the core can easily
detect that and perform the necessary action. Moving the checks out of
core seems like the wrong thing to do, rather you should enhance the
checks in core if they're insufficient in my opinion.

-- 
Best regards,
Marek Vasut
