Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76957C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 19:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FD922B30
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 19:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407774AbgLLTsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgLLTsI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 14:48:08 -0500
Date:   Sat, 12 Dec 2020 11:47:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607802448;
        bh=vNFu1FQqXn693Eeq23d8uH8kLV3j5vVMLIyTP5bgQHM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=psf59Wn8qrDbR/ptPO1SiHhVgC3vnxPRWwAvRQIgP/vWgK4CU2mOA9r8rGbeD8dyf
         BOPDEO7rg+XDciE0toY5QQEAvAQihGVQIMt8nOWgPFoNLXOS/IKvSo0WKCeaayQq1N
         62sO6ue+rsdmaKTLu26EgGeWI8+z8IDU0nL1WmjCIcjlAOp8/jpHCfkIw05jtWd43w
         3xXzWXN/tUkdoxCT4hLmZ/2JBIVOMu2sdxfDeADVFocCi+g5M03cYSO1X8ZhRmUXzS
         6oO5D4VjUDDxtH0XFKOqgxLaPcOCcjhVEJyvnpcLdrlrc4KAliE/3QhOxqMoKGxjIw
         zQxu0zvAY3Ifw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: arm/chacha-neon - add missing counter increment
Message-ID: <X9UeTo2uHdepDLsq@sol.localdomain>
References: <20201212083243.27073-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212083243.27073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 12, 2020 at 09:32:43AM +0100, Ard Biesheuvel wrote:
> Commit 86cd97ec4b943af3 ("crypto: arm/chacha-neon - optimize for non-block
> size multiples") refactored the chacha block handling in the glue code in
> a way that may result in the counter increment to be omitted when calling
> chacha_block_xor_neon() to process a full block. This violates the API,
> which requires that the output IV is suitable for handling more input as
> long as the preceding input has been presented in round multiples of the
> block size.

It appears that the library API actually requires that the counter be
incremented on partial blocks too.  See __chacha20poly1305_encrypt().

I guess the missing increment in chacha_doneon() just wasn't noticed before
because chacha20poly1305 only needs this behavior on 32-byte inputs, and
chacha_doneon() is only executed when the length is over 64 bytes.

> 
> So increment the counter after calling chacha_block_xor_neon().
> 
> Fixes: 86cd97ec4b943af3 ("crypto: arm/chacha-neon - optimize for non-block size multiples")
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/chacha-glue.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> index 7b5cf8430c6d..f19e6da8cdd0 100644
> --- a/arch/arm/crypto/chacha-glue.c
> +++ b/arch/arm/crypto/chacha-glue.c
> @@ -60,6 +60,7 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
>  		chacha_block_xor_neon(state, d, s, nrounds);
>  		if (d != dst)
>  			memcpy(dst, buf, bytes);
> +		state[12] += 1;
>  	}

Maybe write this as:

	state[12]++;
