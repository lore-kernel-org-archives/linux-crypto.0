From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 00/10] AMD Cryptographic Coprocessor support
Date: Wed, 20 Nov 2013 10:20:10 -0600
Message-ID: <5441273.HtAtgCrPKB@tlendack-t1>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:59420
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab3KTQUc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Nov 2013 11:20:32 -0500
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Is the crypto tree the right tree to go through for this support
or would you prefer I go through another tree?

Thanks,
Tom

On Tuesday, November 12, 2013 11:45:59 AM Tom Lendacky wrote:
> Resending because of typo in mailing list address...
> 
> The following series implements support for the AMD Cryptographic
> Coprocessor (CCP).  The AMD CCP provides hardware encryption, hashing
> and other related operations.
> 
> This patch series is based on the 3.12 kernel.
> 
> ---
> 
> Tom Lendacky (10):
>       crypto: authenc - Find proper IV address in ablkcipher callback
>       crypto: scatterwalk - Set the chain pointer indication bit
>       crypto: CCP device driver and interface support
>       crypto: crypto API interface to the CCP device driver
>       crypto: CCP AES crypto API support
>       crypto: CCP AES CMAC mode crypto API support
>       crypto: CCP XTS-AES crypto API support
>       crypto: CCP SHA crypto API support
>       crytpo: CCP device driver build files
>       crypto: CCP maintainer information
> 
> 
>  MAINTAINERS                              |    7
>  crypto/authenc.c                         |    7
>  drivers/crypto/Kconfig                   |   12
>  drivers/crypto/Makefile                  |    1
>  drivers/crypto/ccp/Kconfig               |   23
>  drivers/crypto/ccp/Makefile              |   10
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c |  355 +++++
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c  |  285 ++++
>  drivers/crypto/ccp/ccp-crypto-aes.c      |  375 ++++++
>  drivers/crypto/ccp/ccp-crypto-main.c     |  432 ++++++
>  drivers/crypto/ccp/ccp-crypto-sha.c      |  497 +++++++
>  drivers/crypto/ccp/ccp-crypto.h          |  191 +++
>  drivers/crypto/ccp/ccp-dev.c             |  582 +++++++++
>  drivers/crypto/ccp/ccp-dev.h             |  272 ++++
>  drivers/crypto/ccp/ccp-ops.c             | 2020
> ++++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-pci.c             | 
> 360 +++++
>  include/crypto/scatterwalk.h             |    1
>  include/linux/ccp.h                      |  525 ++++++++
>  18 files changed, 5952 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/ccp/Kconfig
>  create mode 100644 drivers/crypto/ccp/Makefile
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-cmac.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-xts.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-main.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-sha.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto.h
>  create mode 100644 drivers/crypto/ccp/ccp-dev.c
>  create mode 100644 drivers/crypto/ccp/ccp-dev.h
>  create mode 100644 drivers/crypto/ccp/ccp-ops.c
>  create mode 100644 drivers/crypto/ccp/ccp-pci.c
>  create mode 100644 include/linux/ccp.h
-- 
Tom

Thomas Lendacky
Advanced Micro Devices, Inc.
