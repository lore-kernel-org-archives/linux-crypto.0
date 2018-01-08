From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH] crypto: clear htmldocs build warnings for crypto/hash
Date: Mon, 08 Jan 2018 17:43:18 +0100
Message-ID: <2b4fa5b0-dadb-47fe-2bbd-b051ad343bc4@partner.samsung.com>
References: <CGME20180106230157epcas2p2a3dc70ac85fbd7861ddf916fde5dd2be@epcas2p2.samsung.com>
        <1515279703-14070-1-git-send-email-me@tobin.cc>
        <724b85c9-f3df-15b2-7aa2-4089f232c155@partner.samsung.com>
        <20180108155619.GA5350@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "Tobin C. Harding" <me@tobin.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33894 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932623AbeAHQnX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 11:43:23 -0500
In-reply-to: <20180108155619.GA5350@gondor.apana.org.au>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 08.01.2018 16:56, Herbert Xu wrote:
> On Mon, Jan 08, 2018 at 02:11:21PM +0100, Kamil Konieczny wrote:
>>
>>
>> On 07.01.2018 00:01, Tobin C. Harding wrote:
>>> SPHINX build emits multiple warnings of kind:
>>>
>>> 	warning: duplicate section name 'Note'
>>>
>>> (when building kernel via make target 'htmldocs')
>>>
>>> This is caused by repeated use of comments of form:
>>>
>>> 	* Note: soau soaeusoa uoe
>>>
>>> We can change the format without loss of clarity and clear the build
>>> warnings.
>>>
>>> Add '**[mandatory]**' or '**[optional]**' as kernel-doc field element
>>> description prefix
>>>
>>> This renders in HTML as (prefixes in bold)
>>>
>>> final
>>>     [mandatory] Retrieve result from the driver. This function finalizes the
>>>     transformation and retrieves the resulting hash from the driver and
>>>     pushes it back to upper layers. No data processing happens at this
>>>     point unless hardware requires it to finish the transformation (then
>>>     the data buffered by the device driver is processed).
>>>
>>> Signed-off-by: Tobin C. Harding <me@tobin.cc>
>>> ---
>>>
>>> This patch begs the question why the other members of struct ahash_alg
>>> are not marked? Some are marked 'optional' some 'mandatory'. It would
>>> seem that if the marking were necessary for some members it is necessary
>>> for all to eliminate ambiguity?
>>>
>>> thanks
>>
>> import, export are optional
> 
> No import/export must be implemented for all hashes.

Is it mandatory for both async hash and shash ?

in crypto/ahash.c in function

static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)

there is:

	hash->export = ahash_no_export;
	hash->import = ahash_no_import;

and later in the same function:

	if (alg->export)
		hash->export = alg->export;
	if (alg->import)
		hash->import = alg->import;

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
