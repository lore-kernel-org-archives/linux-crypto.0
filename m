Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbeLEGK6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:10:58 -0500
Date: Tue, 4 Dec 2018 22:10:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Martin Willi <martin@strongswan.org>
Cc: linux-crypto@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] crypto: x86/chacha20 - add XChaCha20 support
Message-ID: <20181205061054.GA26750@sol.localdomain>
References: <20181129230217.158038-1-ebiggers@kernel.org>
 <20181129230217.158038-5-ebiggers@kernel.org>
 <99ed681fa4d3233b18ae9328a14f9e23971073cb.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99ed681fa4d3233b18ae9328a14f9e23971073cb.camel@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

On Sat, Dec 01, 2018 at 05:40:40PM +0100, Martin Willi wrote:
> 
> > An SSSE3 implementation of single-block HChaCha20 is also added so
> > that XChaCha20 can use it rather than the generic
> > implementation.  This required refactoring the ChaCha permutation
> > into its own function. 
> 
> > [...]
> 
> > +ENTRY(chacha20_block_xor_ssse3)
> > +	# %rdi: Input state matrix, s
> > +	# %rsi: up to 1 data block output, o
> > +	# %rdx: up to 1 data block input, i
> > +	# %rcx: input/output length in bytes
> > +
> > +	# x0..3 = s0..3
> > +	movdqa		0x00(%rdi),%xmm0
> > +	movdqa		0x10(%rdi),%xmm1
> > +	movdqa		0x20(%rdi),%xmm2
> > +	movdqa		0x30(%rdi),%xmm3
> > +	movdqa		%xmm0,%xmm8
> > +	movdqa		%xmm1,%xmm9
> > +	movdqa		%xmm2,%xmm10
> > +	movdqa		%xmm3,%xmm11
> > +
> > +	mov		%rcx,%rax
> > +	call		chacha20_permute
> > +
> >  	# o0 = i0 ^ (x0 + s0)
> >  	paddd		%xmm8,%xmm0
> >  	cmp		$0x10,%rax
> > @@ -189,6 +198,23 @@ ENTRY(chacha20_block_xor_ssse3)
> >  
> >  ENDPROC(chacha20_block_xor_ssse3)
> >  
> > +ENTRY(hchacha20_block_ssse3)
> > +	# %rdi: Input state matrix, s
> > +	# %rsi: output (8 32-bit words)
> > +
> > +	movdqa		0x00(%rdi),%xmm0
> > +	movdqa		0x10(%rdi),%xmm1
> > +	movdqa		0x20(%rdi),%xmm2
> > +	movdqa		0x30(%rdi),%xmm3
> > +
> > +	call		chacha20_permute
> 
> AFAIK, the general convention is to create proper stack frames using
> FRAME_BEGIN/END for non leaf-functions. Should chacha20_permute()
> callers do so?
> 

Yes, I'll do that.  (Ard suggested similarly in the arm64 version too.)

- Eric
