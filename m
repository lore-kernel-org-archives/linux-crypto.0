Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA85C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Oct 2022 18:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJQSU1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Oct 2022 14:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiJQSUZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2022 14:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002764C02A
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 11:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E62BDB819D9
        for <linux-crypto@vger.kernel.org>; Mon, 17 Oct 2022 18:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D10CC433D6;
        Mon, 17 Oct 2022 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666030820;
        bh=hkkJWDsveoQkK3tWWYnwGetFM4sqAcAz3V6vQQ8j+VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oB4u044nHJi8WVabMIpNyaSOtAgPun2xRc6a6IYUwovdzzSKeN/Tn9xpA9XwEFVHs
         s52yXRZtu4pkHbJdw8LaUZljZJLqNFZqnuHOaJmBWDtpWSFNh9ZAZsRZs8dXWC5XrF
         ElyHVbsQtB7JLk6gy04YPNYKcHbMS2B1YetA5Mr75GEeUk21YnW+wKSVyCUBoknBkw
         5rUi+0TzWFadV7yQJz41wK0KR6fFJgkQ0/z/aWqPwWYRItUd5IbRjDX0sXjeyz2gZA
         GLsR06TaSfZHwEF7+u+Bm5nodQB49IO/CvUclAs6b99v7qk1LUinquzhEfnirbhJpM
         NZcXeEbSKgsFg==
Date:   Mon, 17 Oct 2022 11:20:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org,
        jason@zx2c4.com, herbert@gondor.apana.org.au,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH v2] crypto: gcmaes - Provide minimal library
 implementation
Message-ID: <Y02c4kfTIj4XZxNV@sol.localdomain>
References: <20221014104713.2613195-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014104713.2613195-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 14, 2022 at 12:47:13PM +0200, Ard Biesheuvel wrote:
> Note that table based AES implementations are susceptible to known
> plaintext timing attacks on the encryption key. The AES library already
> attempts to mitigate this to some extent, but given that the counter
> mode encryption used by GCM operates exclusively on known plaintext by
> construction (the IV and therefore the initial counter value are known
> to an attacker), let's take some extra care to mitigate this, by calling
> the AES library with interrupts disabled.

Note that crypto/gf128mul.c has no mitigations against timing attacks.  I take
it that is something that needs to be tolerated here?

> diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
> index 9d7eff04f224..dfbc381df5ae 100644
> --- a/include/crypto/gcm.h
> +++ b/include/crypto/gcm.h
> @@ -3,6 +3,9 @@
>  
>  #include <linux/errno.h>
>  
> +#include <crypto/aes.h>
> +#include <crypto/gf128mul.h>
> +
>  #define GCM_AES_IV_SIZE 12
>  #define GCM_RFC4106_IV_SIZE 8
>  #define GCM_RFC4543_IV_SIZE 8
> @@ -60,4 +63,67 @@ static inline int crypto_ipsec_check_assoclen(unsigned int assoclen)
>  
>  	return 0;
>  }
> +
> +struct gcmaes_ctx {
> +	be128			ghash_key;
> +	struct crypto_aes_ctx	aes_ctx;
> +	unsigned int		authsize;
> +};
> +
> +/**
> + * gcmaes_expandkey - Expands the AES and GHASH keys for the GCM-AES key
> + * 		      schedule
> + *
> + * @ctx:	The data structure that will hold the GCM-AES key schedule
> + * @key:	The AES encryption input key
> + * @keysize:	The length in bytes of the input key
> + * @authsize:	The size in bytes of the GCM authentication tag
> + *
> + * Returns 0 on success, or -EINVAL if @keysize or @authsize contain values
> + * that are not permitted by the GCM specification.
> + */
> +int gcmaes_expandkey(struct gcmaes_ctx *ctx, const u8 *key,
> +		     unsigned int keysize, unsigned int authsize);

These comments are duplicated in the .c file too.  They should be in just one
place, probably the .c file since that approach is more common in the kernel.

Also, this seems to be intended to be a kerneldoc comment, but the return value
isn't documented in the correct format.  It needs to be "Return:".  Try this:

$ ./scripts/kernel-doc -v -none lib/crypto/gcmaes.c
lib/crypto/gcmaes.c:35: info: Scanning doc for function gcmaes_expandkey
lib/crypto/gcmaes.c:48: warning: No description found for return value of 'gcmaes_expandkey'
lib/crypto/gcmaes.c:114: info: Scanning doc for function gcmaes_encrypt
lib/crypto/gcmaes.c:142: info: Scanning doc for function gcmaes_decrypt
lib/crypto/gcmaes.c:162: warning: No description found for return value of 'gcmaes_decrypt'

> +config CRYPTO_LIB_GCMAES
> +	tristate
> +	select CRYPTO_GF128MUL
> +	select CRYPTO_LIB_AES
> +	select CRYPTO_LIB_UTILS

Doesn't this mean that crypto/gf128mul.c needs to be moved into lib/crypto/?

- Eric
