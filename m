From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - select CONFIG_CRYPTO_RSA
Date: Tue, 1 Aug 2017 16:17:42 -0500
Message-ID: <670c80c6-9dc8-881c-51b5-618df900388d@amd.com>
References: <20170731211104.2012741-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0058.outbound.protection.outlook.com ([104.47.34.58]:53120
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752108AbdHAVS2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 17:18:28 -0400
In-Reply-To: <20170731211104.2012741-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/31/2017 04:10 PM, Arnd Bergmann wrote:
> Without the base RSA code, we run into a link error:
>
> ERROR: "rsa_parse_pub_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!
> ERROR: "rsa_parse_priv_key" [drivers/crypto/ccp/ccp-crypto.ko] undefined!
>
> Like the other drivers implementing RSA in hardware, this
> can be avoided by always enabling the base support when we build
> CCP.
>
> Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/ccp/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 15b63fd3d180..6d626606b9c5 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -27,6 +27,7 @@ config CRYPTO_DEV_CCP_CRYPTO
>  	select CRYPTO_HASH
>  	select CRYPTO_BLKCIPHER
>  	select CRYPTO_AUTHENC
> +	select CRYPTO_RSA
>  	help
>  	  Support for using the cryptographic API with the AMD Cryptographic
>  	  Coprocessor. This module supports offload of SHA and AES algorithms.
>

Reviewed by: Gary R Hook <gary.hook@amd.com>
