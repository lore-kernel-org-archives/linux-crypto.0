From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] crypto: cavium: fix Kconfig dependencies
Date: Tue, 14 Feb 2017 09:09:52 -0800
Message-ID: <09cdd8d4-f84b-9664-15e2-4fe923d0b744@caviumnetworks.com>
References: <20170214170739.2687818-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        George Cherian <george.cherian@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0085.outbound.protection.outlook.com ([104.47.37.85]:30496
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752455AbdBNRJ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 12:09:57 -0500
In-Reply-To: <20170214170739.2687818-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/14/2017 09:07 AM, Arnd Bergmann wrote:
> The driver fails to build if MSI support is disabled:
>
> In file included from /git/arm-soc/drivers/crypto/cavium/cpt/cptpf_main.c:18:0:
> drivers/crypto/cavium/cpt/cptpf.h:57:20: error: array type has incomplete element type 'struct msix_entry'
>   struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
>                     ^~~~~~~~~~~~
> drivers/crypto/cavium/cpt/cptpf_main.c: In function 'cpt_enable_msix':
> drivers/crypto/cavium/cpt/cptpf_main.c:344:8: error: implicit declaration of function 'pci_enable_msix';did you mean 'cpt_enable_msix'? [-Werror=implicit-function-declaration]
>
> On the other hand, it doesn't seem to have any build dependency on ARCH_THUNDER,
> so let's allow compile-testing to catch this kind of problem more easily.
> The 64-bit dependency is needed for the use of readq/writeq.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/cavium/cpt/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
> index 247f1cbbefc1..cbd51b1aa046 100644
> --- a/drivers/crypto/cavium/cpt/Kconfig
> +++ b/drivers/crypto/cavium/cpt/Kconfig
> @@ -7,7 +7,8 @@ config CRYPTO_DEV_CPT
>
>  config CAVIUM_CPT
>  	tristate "Cavium Cryptographic Accelerator driver"
> -	depends on ARCH_THUNDER
> +	depends on ARCH_THUNDER || COMPILE_TEST
> +	depends on PCI_MSI && 64BIT


Perhaps we should select PCI and PCI_MSI instead.

These systems cannot function without those.

>  	select CRYPTO_DEV_CPT
>  	help
>  	  Support for Cavium CPT block found in octeon-tx series of
>
