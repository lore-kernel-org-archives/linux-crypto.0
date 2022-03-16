Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A14CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 17:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiCPRSO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiCPRSO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 13:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB92B5A5B6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 10:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE53617F4
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 17:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E17DC340E9;
        Wed, 16 Mar 2022 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647451018;
        bh=CuFK42Lq/IdAzN/xKxJA6rqnaUcCUg5Ve1N188cKPaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dd1OcjE6jRVCpXWTwjeOVnQhX7t4hrWLvcX3ZDankTP7E6/wT6m3ABZRH6kqNawuO
         pjDEMIwjLLGsSrv+MuyouBzMIogK0SxBQ57TUs0ttXxzgCEJCgPskgnS41ftP5rZCy
         GMfuBKCwbLJqq+Y30MSL+9dW8AbKBkhDhbFfo2+D9AId9lepRLPkyI/uxI2QP5EH9H
         NmTCs98e1vFE+jRW5fHQzoNqtQnuAPweppp6OU99+xzkQPynkl0pUWadQY2cE81WTC
         kGHtiWTK5fLzEsRIahvouU1viS/2MxQMDE4zHLXSU2HUT5oeq6Hf0Xnm92EtuMVMpr
         9dS/lhsQK87ow==
Date:   Wed, 16 Mar 2022 17:16:57 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        tianjia.zhang@linux.alibaba.com
Subject: Re: [PATCH] crypto: move sm3 and sm4 into crypto directory
Message-ID: <YjIbiX5swxfO6B43@gmail.com>
References: <20220314031101.663883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314031101.663883-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 13, 2022 at 09:11:01PM -0600, Jason A. Donenfeld wrote:
> The lib/crypto libraries live in lib because they are used by various
> drivers of the kernel. In contrast, the various helper functions in
> crypto are there because they're used exclusively by the crypto API. The
> SM3 and SM4 helper functions were erroniously moved into lib/crypto/
> instead of crypto/, even though there are no in-kernel users outside of
> the crypto API of those functions. This commit moves them into crypto/.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm64/crypto/Kconfig    |  4 ++--
>  crypto/Kconfig               | 18 ++++++++++++------
>  crypto/Makefile              |  6 ++++--
>  {lib/crypto => crypto}/sm3.c |  0
>  {lib/crypto => crypto}/sm4.c |  0
>  lib/crypto/Kconfig           |  6 ------
>  lib/crypto/Makefile          |  6 ------
>  7 files changed, 18 insertions(+), 22 deletions(-)
>  rename {lib/crypto => crypto}/sm3.c (100%)
>  rename {lib/crypto => crypto}/sm4.c (100%)
> 
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index 2a965aa0188d..454621a20eaa 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -45,13 +45,13 @@ config CRYPTO_SM3_ARM64_CE
>  	tristate "SM3 digest algorithm (ARMv8.2 Crypto Extensions)"
>  	depends on KERNEL_MODE_NEON
>  	select CRYPTO_HASH
> -	select CRYPTO_LIB_SM3
> +	select CRYPTO_SM3
>  
>  config CRYPTO_SM4_ARM64_CE
>  	tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
>  	depends on KERNEL_MODE_NEON
>  	select CRYPTO_ALGAPI
> -	select CRYPTO_LIB_SM4
> +	select CRYPTO_SM4
>  
>  config CRYPTO_GHASH_ARM64_CE
>  	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index d6d7e84bb7f8..517525d7d12e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -274,7 +274,7 @@ config CRYPTO_ECRDSA
>  
>  config CRYPTO_SM2
>  	tristate "SM2 algorithm"
> -	select CRYPTO_LIB_SM3
> +	select CRYPTO_SM3
>  	select CRYPTO_AKCIPHER
>  	select CRYPTO_MANAGER
>  	select MPILIB
> @@ -1005,9 +1005,12 @@ config CRYPTO_SHA3
>  	  http://keccak.noekeon.org/
>  
>  config CRYPTO_SM3
> +	tristate
> +
> +config CRYPTO_SM3_GENERIC
>  	tristate "SM3 digest algorithm"
>  	select CRYPTO_HASH
> -	select CRYPTO_LIB_SM3
> +	select CRYPTO_SM3
>  	help
>  	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3).
>  	  It is part of the Chinese Commercial Cryptography suite.

This patch generally looks good, but perhaps CRYPTO_SM3 and CRYPTO_SM3_GENERIC
should be merged?  Having separate options provides the ability to enable the
architecture implementation without the generic implementation, so arguably it's
the right thing to do; however, that's not what the other algorithms in crypto/
do.  For example, if you enable CONFIG_CRYPTO_SHA3, you get the generic SHA-3
algorithms as well as the SHA-3 library functions.  I.e., there's no
CONFIG_CRYPTO_SHA3_GENERIC.

IMO, being consistent is more important than providing the ability to omit the
generic implementation.

- Eric
