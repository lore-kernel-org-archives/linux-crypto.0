Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E339DE7AD6E
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 15:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjJCPZj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjJCPZh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 11:25:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F60A6
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 08:25:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C62C433C7;
        Tue,  3 Oct 2023 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696346732;
        bh=g1iuKh4ZfWiEBpKOvmDQZDYCbhUMEMf3u1k/K1yDYEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sby3rdr09kzWbvgX6INPUuJD+Bm73azs/bryQFZs8FY/jfNqK44nM4exYvEh3vNly
         2fkwBlKIKzFfSKJ0Mb9f0QaziFRr9LeOLWg0ukM39e9AzDbsvsFUYtzyBYZQwmOpuc
         VkWNXVZNGKUGwNiNyxEYLXwkSjGVXaP+f0qpecJ1kIxENoQYmEx0j0mjR8Z8j4z7zK
         zY6WLlGFyrjE321Wn6W0aDKADmALcdJFl0gFllGD82durArQdSRKnsGorie7jdRX46
         K/CyZ5+28UkCCDiQGQBKjlugiMMC07/SM5TtNPSjzY8UlFn9/9kwS3ae2+i5p1ykIw
         yOxijHmRuv4kw==
Date:   Tue, 3 Oct 2023 08:25:30 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: skcipher - Add dependency on ecb
Message-ID: <20231003152530.GA63187@dev-arch.thelio-3990X>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-9-herbert@gondor.apana.org.au>
 <20231002202522.GA4130583@dev-arch.thelio-3990X>
 <ZRuLK6SIuq9qYqpB@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRuLK6SIuq9qYqpB@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 03, 2023 at 11:31:55AM +0800, Herbert Xu wrote:
> On Mon, Oct 02, 2023 at 01:25:22PM -0700, Nathan Chancellor wrote:
> >
> > I am noticing a failure to get to user space when booting OpenSUSE's
> > armv7hl configuration [1] in QEMU after this change as commit
> > 705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher"). I can
> > reproduce it with GCC 13.2.0 from kernel.org [2] and QEMU 8.1.1, in case
> > either of those versions matter.  The rootfs is available at [3] in case
> > it is relevant.
> 
> Thanks for the report.  This is caused by a missing dependency
> on ECB.  Please try this patch:
> 
> ---8<---
> As lskcipher requires the ecb wrapper for the transition add an
> explicit dependency on it so that it is always present.  This can
> be removed once all simple ciphers have been converted to lskcipher.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Fixes: 705b52fef3c7 ("crypto: cbc - Convert from skcipher to lskcipher")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the quick fix!

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index ed931ddea644..bbf51d55724e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -85,6 +85,7 @@ config CRYPTO_SKCIPHER
>  	tristate
>  	select CRYPTO_SKCIPHER2
>  	select CRYPTO_ALGAPI
> +	select CRYPTO_ECB
>  
>  config CRYPTO_SKCIPHER2
>  	tristate
> @@ -689,7 +690,7 @@ config CRYPTO_CTS
>  
>  config CRYPTO_ECB
>  	tristate "ECB (Electronic Codebook)"
> -	select CRYPTO_SKCIPHER
> +	select CRYPTO_SKCIPHER2
>  	select CRYPTO_MANAGER
>  	help
>  	  ECB (Electronic Codebook) mode (NIST SP800-38A)
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
