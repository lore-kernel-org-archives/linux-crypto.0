From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] crypto: ccp - Introduce the AMD Secure Processor
 device
Date: Wed, 28 Jun 2017 15:30:23 -0500
Message-ID: <fd5c85fd-1270-f8fd-0562-3c52c03b3a19@amd.com>
References: <20170623160630.63292-1-brijesh.singh@amd.com>
 <20170623160630.63292-3-brijesh.singh@amd.com>
 <047bd869-675c-33de-d454-7773a711266d@amd.com>
 <7f88d0bd-daa8-5ab0-ae73-80432d2c791d@amd.com>
 <7336ca67-910f-2444-80d4-3b5398e9c2d7@amd.com>
 <79ad80ef-1c25-334a-9885-77373f356df2@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0072.outbound.protection.outlook.com ([104.47.36.72]:60432
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751795AbdF1Uag (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 16:30:36 -0400
In-Reply-To: <79ad80ef-1c25-334a-9885-77373f356df2@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/28/2017 3:26 PM, Brijesh Singh wrote:
> 
> 
> On 06/28/2017 02:53 PM, Tom Lendacky wrote:
>>>
>>> In this I am leaving the top level config as-is and adding
>>> CONFIG_CRYPTO_DEV_SP_CCP to enable the CCP device support inside the 
>>> SP device driver.
>>>
>>> [*] Support for AMD Secure Processor
>>> <M>  Secure Processor device driver
>>> <M>    Encryption and hashing offload support
>>> -*-    Cryptographic Coprocessor device
>>
>> I think the "Encryption and hashing offload support" should be indented
>> under "Cryptographic Coprocessor device" since it is a function of the
>> CCP and not the SP. Not sure if we can remove a level of menu somehow,
>> something to explore.
> 
> Good point, the updated Kconfig looks like this and let me know it works.

I think that looks better.

Thanks,
Tom

> 
> [*] Support for AMD Secure Processor
> <M>   Secure Processor device driver
> [*]     Cryptographic Coprocessor device
> <M>       Encryption and hashing offload support
> 
> # cat drivers/crypto/ccp/Kconfig
> 
> config CRYPTO_DEV_CCP_DD
>           tristate "Secure Processor device driver"
>           default m
>           help
>             Provides AMD Secure Processor device driver.
>             If you choose 'M' here, this module will be called ccp.
> 
>   config CRYPTO_DEV_SP_CCP
>           bool "Cryptographic Coprocessor device"
>           default y
>           depends on CRYPTO_DEV_CCP_DD
>           select HW_RANDOM
>           select DMA_ENGINE
>           select DMADEVICES
>           select CRYPTO_SHA1
>           select CRYPTO_SHA256
>           help
>             Provides the support for AMD Cryptographic Coprocessor (CCP) 
> device
>             which can be used to offload encryption operations such as 
> SHA, AES
>             and more.
> 
>   config CRYPTO_DEV_CCP_CRYPTO
>           tristate "Encryption and hashing offload support"
>           default m
>           depends on CRYPTO_DEV_CCP_DD
>           depends on CRYPTO_DEV_SP_CCP
>           select CRYPTO_HASH
>           select CRYPTO_BLKCIPHER
>           select CRYPTO_AUTHENC
>           help
>             Support for using the cryptographic API with the AMD 
> Cryptographic
>             Coprocessor. This module supports offload of SHA and AES 
> algorithms.
>             If you choose 'M' here, this module will be called ccp_crypto.
