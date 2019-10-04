Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB09C4CED1
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85BBE222C2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="2ECfLjBo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388417AbfJDNg6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:36:58 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:34139 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388376AbfJDNg6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:36:58 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 74788fea;
        Fri, 4 Oct 2019 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=7WFG5JfNXT+cN8gKNsLKv1E0UGI=; b=2ECfLjB
        o5JWCqOxoUeS+YmVyg83FKnEH8hQ35uSLh4LYRAWFLKoeigs9nw0Gv6Ou3ggM5lM
        GPrt3Edo9qkftcEVFRwncw8vEqxW7wzBsK4mJNLJQx2XrxuCLk6JlcQFx8clGDD+
        Afv+DzWCAWSFsaqH93GBsJPGcZ13YHHM5dzX72WYiQrSmoG4V+3oXoQxzqc6ULq1
        3MP5E9ZOKK4pGEkKNScXsOL+AX9XrxvsmT2wbb2bohnz0pq77Ne0hDKBZrzGYgbu
        M6sR9vNZ52hfBujV1xDbYrQ2KZql2X4ofUOnrBJJTS3YteW0WlVDRfR9fVeLPs+4
        CsTm+IUgd369b6w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 025c9ea3 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 12:50:01 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:36:49 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 02/20] crypto: x86/chacha - expose SIMD ChaCha routine
 as library function
Message-ID: <20191004133649.GC112631@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191002141713.31189-3-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 04:16:55PM +0200, Ard Biesheuvel wrote:
> Wire the existing x86 SIMD ChaCha code into the new ChaCha library
> interface.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/crypto/chacha_glue.c | 36 ++++++++++++++++++++
>  crypto/Kconfig                |  1 +
>  include/crypto/chacha.h       |  6 ++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index bc62daa8dafd..fd9ef42842cf 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -123,6 +123,42 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
>  	}
>  }
>  
> +void hchacha_block(const u32 *state, u32 *stream, int nrounds)
> +{
> +	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> +
> +	if (!crypto_simd_usable()) {
> +		hchacha_block_generic(state, stream, nrounds);
> +	} else {
> +		kernel_fpu_begin();
> +		hchacha_block_ssse3(state, stream, nrounds);
> +		kernel_fpu_end();
> +	}
> +}
> +EXPORT_SYMBOL(hchacha_block);

Please correct me if I'm wrong:

The approach here is slightly different from Zinc. In Zinc, I had one
entry point that conditionally called into the architecture-specific
implementation, and I did it inline using #includes so that in some
cases it could be optimized out.

Here, you override the original symbol defined by the generic module
from the architecture-specific implementation, and in there you decide
which way to branch.

Your approach has the advantage that you don't need to #include a .c
file like I did, an ugly yet very effective approach.

But it has two disadvantages:

1. For architecture-specific code that _always_ runs, such as the
  MIPS32r2 implementation of chacha, the compiler no longer has an
  opportunity to remove the generic code entirely from the binary,
  which under Zinc resulted in a smaller module.

2. The inliner can't make optimizations for that call.

Disadvantage (2) might not make much of a difference. Disadvantage (1)
seems like a bigger deal. However, perhaps the linker is smart and can
remove the code and symbol? Or if not, is there a way to make the linker
smart? Or would all this require crazy LTO which isn't going to happen
any time soon?
