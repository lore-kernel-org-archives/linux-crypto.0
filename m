From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] crypto: ccp - Introduce the AMD Secure Processor
 device
Date: Wed, 28 Jun 2017 12:47:07 -0500
Message-ID: <047bd869-675c-33de-d454-7773a711266d@amd.com>
References: <20170623160630.63292-1-brijesh.singh@amd.com>
 <20170623160630.63292-3-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
To: Brijesh Singh <brijesh.singh@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0047.outbound.protection.outlook.com ([104.47.41.47]:36384
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751544AbdF1RrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 13:47:14 -0400
In-Reply-To: <20170623160630.63292-3-brijesh.singh@amd.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/23/2017 11:06 AM, Brijesh Singh wrote:
> The CCP device is part of the AMD Secure Processor. In order to expand
> the usage of the AMD Secure Processor, create a framework that allows
> functional components of the AMD Secure Processor to be initialized and
> handled appropriately.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>   drivers/crypto/Kconfig            |  10 +--
>   drivers/crypto/ccp/Kconfig        |  43 +++++----
>   drivers/crypto/ccp/Makefile       |   6 +-
>   drivers/crypto/ccp/ccp-dev-v3.c   |   5 +-
>   drivers/crypto/ccp/ccp-dev-v5.c   |   5 +-
>   drivers/crypto/ccp/ccp-dev.c      | 106 +++++++++-------------
>   drivers/crypto/ccp/ccp-dev.h      |  21 +----
>   drivers/crypto/ccp/ccp-pci.c      |  81 +++++++++++------
>   drivers/crypto/ccp/ccp-platform.c |  70 ++++++++-------
>   drivers/crypto/ccp/sp-dev.c       | 180 ++++++++++++++++++++++++++++++++++++++
>   drivers/crypto/ccp/sp-dev.h       | 120 +++++++++++++++++++++++++
>   include/linux/ccp.h               |   3 +-
>   12 files changed, 475 insertions(+), 175 deletions(-)
>   create mode 100644 drivers/crypto/ccp/sp-dev.c
>   create mode 100644 drivers/crypto/ccp/sp-dev.h
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 0528a62..418f991 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -512,14 +512,14 @@ config CRYPTO_DEV_ATMEL_SHA
>   	  To compile this driver as a module, choose M here: the module
>   	  will be called atmel-sha.
>   
> -config CRYPTO_DEV_CCP
> -	bool "Support for AMD Cryptographic Coprocessor"
> +config CRYPTO_DEV_SP
> +	bool "Support for AMD Secure Processor"
>   	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
>   	help
> -	  The AMD Cryptographic Coprocessor provides hardware offload support
> -	  for encryption, hashing and related operations.
> +	  The AMD Secure Processor provides hardware offload support for memory
> +	  encryption in virtualization and cryptographic hashing and related operations.
>   
> -if CRYPTO_DEV_CCP
> +if CRYPTO_DEV_SP
>   	source "drivers/crypto/ccp/Kconfig"
>   endif
>   
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 2238f77..bc08f03 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -1,26 +1,37 @@
> -config CRYPTO_DEV_CCP_DD
> -	tristate "Cryptographic Coprocessor device driver"
> -	depends on CRYPTO_DEV_CCP
> -	default m
> -	select HW_RANDOM
> -	select DMA_ENGINE
> -	select DMADEVICES
> -	select CRYPTO_SHA1
> -	select CRYPTO_SHA256
> -	help
> -	  Provides the interface to use the AMD Cryptographic Coprocessor
> -	  which can be used to offload encryption operations such as SHA,
> -	  AES and more. If you choose 'M' here, this module will be called
> -	  ccp.
> -
>   config CRYPTO_DEV_CCP_CRYPTO
>   	tristate "Encryption and hashing offload support"
> -	depends on CRYPTO_DEV_CCP_DD
> +	depends on CRYPTO_DEV_SP_DD
>   	default m
>   	select CRYPTO_HASH
>   	select CRYPTO_BLKCIPHER
>   	select CRYPTO_AUTHENC
> +	select CRYPTO_DEV_CCP
>   	help
>   	  Support for using the cryptographic API with the AMD Cryptographic
>   	  Coprocessor. This module supports offload of SHA and AES algorithms.
>   	  If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_DD
> +	tristate "Secure Processor device driver"
> +	depends on CRYPTO_DEV_SP
> +	default m
> +	help
> +	  Provides the interface to use the AMD Secure Processor. The
> +	  AMD Secure Processor support the Platform Security Processor (PSP)
> +	  and Cryptographic Coprocessor (CCP). If you choose 'M' here, this
> +	  module will be called ccp.
> +
> +if CRYPTO_DEV_SP_DD
> +config CRYPTO_DEV_CCP
> +	bool "Cryptographic Coprocessor interface"
> +	default y
> +	select HW_RANDOM
> +	select DMA_ENGINE
> +	select DMADEVICES
> +	select CRYPTO_SHA1
> +	select CRYPTO_SHA256
> +	help
> +	  Provides the interface to use the AMD Cryptographic Coprocessor
> +	  which can be used to offload encryption operations such as SHA,
> +	  AES and more.
> +endif

I think the Kconfig changes need to be looked at a bit closer. The
hierarchy of original version is changed and the number of entries
might be able to be reduced.

Thanks,
Tom
