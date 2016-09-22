From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Fix Kconfig dependencies for FIPS
Date: Thu, 22 Sep 2016 17:32:51 +0800
Message-ID: <20160922093251.GA5584@gondor.apana.org.au>
References: <CAM5Ud7Ph1LR_8F7Pm9x55B9bozuQL+=6NZfVMjPtTPiDswfUHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: NTU <neotheuser@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53729 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbcIVJdF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 05:33:05 -0400
Content-Disposition: inline
In-Reply-To: <CAM5Ud7Ph1LR_8F7Pm9x55B9bozuQL+=6NZfVMjPtTPiDswfUHw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

NTU <neotheuser@gmail.com> wrote:
> Currently FIPS depends on MODULE_SIG, even if MODULES is disabled.
> This change allows the enabling of FIPS without support for modules.
> 
> If module loading support is enabled, only then does
> FIPS require MODULE_SIG.
> 
> Signed-off-by: Alec Ari <neotheuser@gmail.com>
> ---
> crypto/Kconfig | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 84d7148..fd28805 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -24,7 +24,7 @@ comment "Crypto core or helper"
> config CRYPTO_FIPS
>     bool "FIPS 200 compliance"
>     depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) &&
> !CRYPTO_MANAGER_DISABLE_TESTS
> -    depends on MODULE_SIG
> +    depends on (MODULE_SIG || !MODULES)
>     help
>       This options enables the fips boot option which is
>       required if you want to system to operate in a FIPS 200

Your email has turned tabs into white spaces.  Please fix it
and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
