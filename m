From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] crypto: ccp - Introduce the AMD Secure Processor
 device
Date: Wed, 28 Jun 2017 14:53:05 -0500
Message-ID: <7336ca67-910f-2444-80d4-3b5398e9c2d7@amd.com>
References: <20170623160630.63292-1-brijesh.singh@amd.com>
 <20170623160630.63292-3-brijesh.singh@amd.com>
 <047bd869-675c-33de-d454-7773a711266d@amd.com>
 <7f88d0bd-daa8-5ab0-ae73-80432d2c791d@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0059.outbound.protection.outlook.com ([104.47.38.59]:33120
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751501AbdF1TxM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 15:53:12 -0400
In-Reply-To: <7f88d0bd-daa8-5ab0-ae73-80432d2c791d@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/28/2017 2:39 PM, Brijesh Singh wrote:
> 
> 
> On 06/28/2017 12:47 PM, Tom Lendacky wrote:
>>>
>>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>>> index 0528a62..418f991 100644
>>> --- a/drivers/crypto/Kconfig
>>> +++ b/drivers/crypto/Kconfig
>>> @@ -512,14 +512,14 @@ config CRYPTO_DEV_ATMEL_SHA
>>>         To compile this driver as a module, choose M here: the module
>>>         will be called atmel-sha.
>>> -config CRYPTO_DEV_CCP
>>> -    bool "Support for AMD Cryptographic Coprocessor"
>>> +config CRYPTO_DEV_SP
>>> +    bool "Support for AMD Secure Processor"
>>>       depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && 
>>> HAS_IOMEM
>>>       help
>>> -      The AMD Cryptographic Coprocessor provides hardware offload 
>>> support
>>> -      for encryption, hashing and related operations.
>>> +      The AMD Secure Processor provides hardware offload support for 
>>> memory
>>> +      encryption in virtualization and cryptographic hashing and 
>>> related operations.
>>> -if CRYPTO_DEV_CCP
>>> +if CRYPTO_DEV_SP
>>>       source "drivers/crypto/ccp/Kconfig"
>>>   endif
>>> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
>>> index 2238f77..bc08f03 100644
>>> --- a/drivers/crypto/ccp/Kconfig
>>> +++ b/drivers/crypto/ccp/Kconfig
>>> @@ -1,26 +1,37 @@
>>> -config CRYPTO_DEV_CCP_DD
>>> -    tristate "Cryptographic Coprocessor device driver"
>>> -    depends on CRYPTO_DEV_CCP
>>> -    default m
>>> -    select HW_RANDOM
>>> -    select DMA_ENGINE
>>> -    select DMADEVICES
>>> -    select CRYPTO_SHA1
>>> -    select CRYPTO_SHA256
>>> -    help
>>> -      Provides the interface to use the AMD Cryptographic Coprocessor
>>> -      which can be used to offload encryption operations such as SHA,
>>> -      AES and more. If you choose 'M' here, this module will be called
>>> -      ccp.
>>> -
>>>   config CRYPTO_DEV_CCP_CRYPTO
>>>       tristate "Encryption and hashing offload support"
>>> -    depends on CRYPTO_DEV_CCP_DD
>>> +    depends on CRYPTO_DEV_SP_DD
>>>       default m
>>>       select CRYPTO_HASH
>>>       select CRYPTO_BLKCIPHER
>>>       select CRYPTO_AUTHENC
>>> +    select CRYPTO_DEV_CCP
>>>       help
>>>         Support for using the cryptographic API with the AMD 
>>> Cryptographic
>>>         Coprocessor. This module supports offload of SHA and AES 
>>> algorithms.
>>>         If you choose 'M' here, this module will be called ccp_crypto.
>>> +
>>> +config CRYPTO_DEV_SP_DD
>>> +    tristate "Secure Processor device driver"
>>> +    depends on CRYPTO_DEV_SP
>>> +    default m
>>> +    help
>>> +      Provides the interface to use the AMD Secure Processor. The
>>> +      AMD Secure Processor support the Platform Security Processor 
>>> (PSP)
>>> +      and Cryptographic Coprocessor (CCP). If you choose 'M' here, this
>>> +      module will be called ccp.
>>> +
>>> +if CRYPTO_DEV_SP_DD
>>> +config CRYPTO_DEV_CCP
>>> +    bool "Cryptographic Coprocessor interface"
>>> +    default y
>>> +    select HW_RANDOM
>>> +    select DMA_ENGINE
>>> +    select DMADEVICES
>>> +    select CRYPTO_SHA1
>>> +    select CRYPTO_SHA256
>>> +    help
>>> +      Provides the interface to use the AMD Cryptographic Coprocessor
>>> +      which can be used to offload encryption operations such as SHA,
>>> +      AES and more.
>>> +endif
>>
>> I think the Kconfig changes need to be looked at a bit closer. The
>> hierarchy of original version is changed and the number of entries
>> might be able to be reduced.
>>
> 
> Thanks Tom, how about the below patch?
> 
> In this I am leaving the top level config as-is and adding
> CONFIG_CRYPTO_DEV_SP_CCP to enable the CCP device support inside the SP 
> device driver.
> 
> [*] Support for AMD Secure Processor
> <M>  Secure Processor device driver
> <M>    Encryption and hashing offload support
> -*-    Cryptographic Coprocessor device

I think the "Encryption and hashing offload support" should be indented
under "Cryptographic Coprocessor device" since it is a function of the
CCP and not the SP. Not sure if we can remove a level of menu somehow,
something to explore.

Thanks,
Tom

> 
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 0528a62..148b516 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -513,11 +513,11 @@ config CRYPTO_DEV_ATMEL_SHA
>            will be called atmel-sha.
> 
>   config CRYPTO_DEV_CCP
> -       bool "Support for AMD Cryptographic Coprocessor"
> +       bool "Support for AMD Secure Processor"
>          depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && 
> HAS_IOMEM
>          help
> -         The AMD Cryptographic Coprocessor provides hardware offload 
> support
> -         for encryption, hashing and related operations.
> +         The AMD Secure Processor provides hardware offload support for 
> memory
> +         encryption in virtualization and cryptographic hashing and 
> related operations.
> 
>   if CRYPTO_DEV_CCP
>          source "drivers/crypto/ccp/Kconfig"
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 2238f77..ef3a5fb 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -1,26 +1,34 @@
>   config CRYPTO_DEV_CCP_DD
> -       tristate "Cryptographic Coprocessor device driver"
> -       depends on CRYPTO_DEV_CCP
> +       tristate "Secure Processor device driver"
>          default m
> -       select HW_RANDOM
> -       select DMA_ENGINE
> -       select DMADEVICES
> -       select CRYPTO_SHA1
> -       select CRYPTO_SHA256
>          help
> -         Provides the interface to use the AMD Cryptographic Coprocessor
> -         which can be used to offload encryption operations such as SHA,
> -         AES and more. If you choose 'M' here, this module will be called
> -         ccp.
> +         Provides AMD Secure Processor device driver.
> +         If you choose 'M' here, this module will be called ccp.
> +
> +if CRYPTO_DEV_CCP_DD
> 
>   config CRYPTO_DEV_CCP_CRYPTO
>          tristate "Encryption and hashing offload support"
> -       depends on CRYPTO_DEV_CCP_DD
>          default m
>          select CRYPTO_HASH
>          select CRYPTO_BLKCIPHER
>          select CRYPTO_AUTHENC
> +       select CRYPTO_DEV_SP_CCP
>          help
>            Support for using the cryptographic API with the AMD 
> Cryptographic
>            Coprocessor. This module supports offload of SHA and AES 
> algorithms.
>            If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_CCP
> +       bool "Cryptographic Coprocessor device"
> +       default y
> +       select HW_RANDOM
> +       select DMA_ENGINE
> +       select DMADEVICES
> +       select CRYPTO_SHA1
> +       select CRYPTO_SHA256
> +       help
> +         Provides the support for AMD Cryptographic Coprocessor (CCP) 
> device
> +         which can be used to offload encryption operations such as 
> SHA, AES
> +         and more.
> +endif
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 59493fd..d2f1b52 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -1,9 +1,9 @@
>   obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
> -ccp-objs := ccp-dev.o \
> +ccp-objs  := sp-dev.o ccp-platform.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>              ccp-ops.o \
>              ccp-dev-v3.o \
>              ccp-dev-v5.o \
> -           ccp-platform.o \
>              ccp-dmaengine.o \
>              ccp-debugfs.o
>   ccp-$(CONFIG_PCI) += ccp-pci.o
