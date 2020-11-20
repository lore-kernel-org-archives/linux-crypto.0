Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D964CC5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 03:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A4C20BED
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 03:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgKTDop (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:44:45 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33432 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgKTDoo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 22:44:44 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kfxLk-0005FP-Tc; Fri, 20 Nov 2020 14:44:42 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2020 14:44:40 +1100
Date:   Fri, 20 Nov 2020 14:44:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
Message-ID: <20201120034440.GA18047@gondor.apana.org.au>
References: <20201109083143.2884-1-ardb@kernel.org>
 <20201109083143.2884-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109083143.2884-3-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 09, 2020 at 09:31:42AM +0100, Ard Biesheuvel wrote:
> When working on crypto algorithms, being able to run tcrypt quickly
> without booting an entire Linux installation can be very useful. For
> instance, QEMU/kvm can be used to boot a kernel from the command line,
> and having tcrypt.ko builtin would allow tcrypt to be executed to run
> benchmarks, or to run tests for algortithms that need to be instantiated
> from templates, without the need to make it past the point where the
> rootfs is mounted.
> 
> So let's relax the requirement that tcrypt can only be built as a
> module when CRYPTO_MANAGER_EXTRA_TESTS is enabled, as this is already
> documented as a crypto development-only symbol.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 094ef56ab7b4..9ff2d687e334 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -201,7 +201,7 @@ config CRYPTO_AUTHENC
>  
>  config CRYPTO_TEST
>  	tristate "Testing module"
> -	depends on m
> +	depends on m || CRYPTO_MANAGER_EXTRA_TESTS
>  	select CRYPTO_MANAGER
>  	help
>  	  Quick & dirty crypto test module.

This breaks the build:

crypto/Kconfig:150:error: recursive dependency detected!
crypto/Kconfig:150:     symbol CRYPTO_MANAGER_EXTRA_TESTS depends on CRYPTO_MANAGER
crypto/Kconfig:119:     symbol CRYPTO_MANAGER is selected by CRYPTO_TEST
crypto/Kconfig:206:     symbol CRYPTO_TEST depends on CRYPTO_MANAGER_EXTRA_TESTS
For a resolution refer to Documentation/kbuild/kconfig-language.rst
subsection "Kconfig recursive dependency limitations"

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
