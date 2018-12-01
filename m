Return-Path: <SRS0=BBPV=OK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:41214 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeLBDxh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Dec 2018 22:53:37 -0500
Message-ID: <99ed681fa4d3233b18ae9328a14f9e23971073cb.camel@strongswan.org>
Subject: Re: [PATCH v2 4/6] crypto: x86/chacha20 - add XChaCha20 support
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Dec 2018 17:40:40 +0100
In-Reply-To: <20181129230217.158038-5-ebiggers@kernel.org>
References: <20181129230217.158038-1-ebiggers@kernel.org>
         <20181129230217.158038-5-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> An SSSE3 implementation of single-block HChaCha20 is also added so
> that XChaCha20 can use it rather than the generic
> implementation.  This required refactoring the ChaCha permutation
> into its own function. 

> [...]

> +ENTRY(chacha20_block_xor_ssse3)
> +	# %rdi: Input state matrix, s
> +	# %rsi: up to 1 data block output, o
> +	# %rdx: up to 1 data block input, i
> +	# %rcx: input/output length in bytes
> +
> +	# x0..3 = s0..3
> +	movdqa		0x00(%rdi),%xmm0
> +	movdqa		0x10(%rdi),%xmm1
> +	movdqa		0x20(%rdi),%xmm2
> +	movdqa		0x30(%rdi),%xmm3
> +	movdqa		%xmm0,%xmm8
> +	movdqa		%xmm1,%xmm9
> +	movdqa		%xmm2,%xmm10
> +	movdqa		%xmm3,%xmm11
> +
> +	mov		%rcx,%rax
> +	call		chacha20_permute
> +
>  	# o0 = i0 ^ (x0 + s0)
>  	paddd		%xmm8,%xmm0
>  	cmp		$0x10,%rax
> @@ -189,6 +198,23 @@ ENTRY(chacha20_block_xor_ssse3)
>  
>  ENDPROC(chacha20_block_xor_ssse3)
>  
> +ENTRY(hchacha20_block_ssse3)
> +	# %rdi: Input state matrix, s
> +	# %rsi: output (8 32-bit words)
> +
> +	movdqa		0x00(%rdi),%xmm0
> +	movdqa		0x10(%rdi),%xmm1
> +	movdqa		0x20(%rdi),%xmm2
> +	movdqa		0x30(%rdi),%xmm3
> +
> +	call		chacha20_permute

AFAIK, the general convention is to create proper stack frames using
FRAME_BEGIN/END for non leaf-functions. Should chacha20_permute()
callers do so?

For the other parts:

Reviewed-by: Martin Willi <martin@strongswan.org>
