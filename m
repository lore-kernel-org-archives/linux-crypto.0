Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABEDC4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 06:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 832892311A
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 06:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438406AbgLLGof (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 01:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438399AbgLLGoQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 01:44:16 -0500
Date:   Fri, 11 Dec 2020 22:43:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607755416;
        bh=BKe3RqZftxgWgdo4mwyE9tnxQC7zlNP7NcNvP7TPzvE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=aF3+08tB4biUWZmUuNEQVmTAEYpzFjCY9FGeh4mJLe5arcieKvnJ8dx4cKptqd6wI
         9Ye/zJ5dQo0qpo4YE4fkFqk3FgqiaAkF7srv4pVq5nmu3N4GGq9LNyEmcRy/bOMuT6
         +kq+TMjmVfp7i7UNMfkuca/tzzgkhJqRH7acmvJXqxu+xspEr929BAak6ad0uxKZsJ
         AkKrnFTn2maCd3Fxv2YKFcHFjR39Zz/PG9Hsi42uBqbXUmuCJA5BbOXDDvKwouZ5c7
         WyjjVKgVMd4nPFxY/nBaWTfnNgHtUXl57dNMvB19+I3nOYhaLqe5Yyqf/Y9tYW9/Wu
         hBOw7FdFf4Q7g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - optimize for non-block size
 multiples
Message-ID: <X9RmlccBrwoY7zXS@sol.localdomain>
References: <20201103162809.28167-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103162809.28167-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Tue, Nov 03, 2020 at 05:28:09PM +0100, Ard Biesheuvel wrote:
> @@ -42,24 +42,24 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
>  {
>  	u8 buf[CHACHA_BLOCK_SIZE];
>  
> -	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
> -		chacha_4block_xor_neon(state, dst, src, nrounds);
> -		bytes -= CHACHA_BLOCK_SIZE * 4;
> -		src += CHACHA_BLOCK_SIZE * 4;
> -		dst += CHACHA_BLOCK_SIZE * 4;
> -		state[12] += 4;
> -	}
> -	while (bytes >= CHACHA_BLOCK_SIZE) {
> -		chacha_block_xor_neon(state, dst, src, nrounds);
> -		bytes -= CHACHA_BLOCK_SIZE;
> -		src += CHACHA_BLOCK_SIZE;
> -		dst += CHACHA_BLOCK_SIZE;
> -		state[12]++;
> +	while (bytes > CHACHA_BLOCK_SIZE) {
> +		unsigned int l = min(bytes, CHACHA_BLOCK_SIZE * 4U);
> +
> +		chacha_4block_xor_neon(state, dst, src, nrounds, l);
> +		bytes -= l;
> +		src += l;
> +		dst += l;
> +		state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
>  	}
>  	if (bytes) {
> -		memcpy(buf, src, bytes);
> -		chacha_block_xor_neon(state, buf, buf, nrounds);
> -		memcpy(dst, buf, bytes);
> +		const u8 *s = src;
> +		u8 *d = dst;
> +
> +		if (bytes != CHACHA_BLOCK_SIZE)
> +			s = d = memcpy(buf, src, bytes);
> +		chacha_block_xor_neon(state, d, s, nrounds);
> +		if (d != dst)
> +			memcpy(dst, buf, bytes);
>  	}
>  }
>  

Shouldn't this be incrementing the block counter after chacha_block_xor_neon()?
It might be needed by the library API.

Also, even with that fixed, this patch is causing the self-tests (both the
chacha20poly1305_selftest(), and the crypto API tests for chacha20-neon,
xchacha20-neon, and xchacha12-neon) to fail when I boot a kernel in QEMU.  This
doesn't happen on real hardware (Raspberry Pi 2), and I don't see any other bugs
in this patch, so I'm not sure what the problem is.  Did you run the self-tests
on every platform you tested this on?

- Eric
