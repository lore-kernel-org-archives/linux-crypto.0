From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC] CRYPTO: Fix more AES build errors:
Date: Sun, 5 Jan 2014 20:57:11 +0800
Message-ID: <20140105125711.GA26278@gondor.apana.org.au>
References: <E1Vylu8-0005Q9-MO@rmk-PC.arm.linux.org.uk>
 <CAKv+Gu9SrF_jkNc1ie+AX07YVGUdAYMGoKnJopFyirwh=acDVQ@mail.gmail.com>
 <20140105125105.GA26174@gondor.apana.org.au>
 <20140105125557.GA27432@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59241 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaAEM5T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Jan 2014 07:57:19 -0500
Content-Disposition: inline
In-Reply-To: <20140105125557.GA27432@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 05, 2014 at 12:55:57PM +0000, Russell King - ARM Linux wrote:
> On Sun, Jan 05, 2014 at 08:51:05PM +0800, Herbert Xu wrote:
> > On Thu, Jan 02, 2014 at 07:16:46PM +0100, Ard Biesheuvel wrote:
> > > On 2 January 2014 18:17, Russell King <rmk+kernel@arm.linux.org.uk> wrote:
> > > > Building a multi-arch kernel results in:
> > > >
> > > > arch/arm/crypto/built-in.o: In function `aesbs_xts_decrypt':
> > > > sha1_glue.c:(.text+0x15c8): undefined reference to `bsaes_xts_decrypt'
> > > > arch/arm/crypto/built-in.o: In function `aesbs_xts_encrypt':
> > > > sha1_glue.c:(.text+0x1664): undefined reference to `bsaes_xts_encrypt'
> > > > arch/arm/crypto/built-in.o: In function `aesbs_ctr_encrypt':
> > > > sha1_glue.c:(.text+0x184c): undefined reference to `bsaes_ctr32_encrypt_blocks'
> > > > arch/arm/crypto/built-in.o: In function `aesbs_cbc_decrypt':
> > > > sha1_glue.c:(.text+0x19b4): undefined reference to `bsaes_cbc_encrypt'
> > > >
> > > 
> > > Interestingly, when I try to reproduce this, the reference is
> > > (correctly) reported to reside in aesbs-glue.c and not sha1_glue.c
> > > 
> > > > This code is already runtime-conditional on NEON being supported, so
> > > > there's no point compiling it out depending on the minimum build
> > > > architecture.
> > > >
> > > 
> > > Agreed. It is a leftover from the way this code was embedded into
> > > OpenSSL originally.
> > > 
> > > > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > > ---
> > > > This is more a request for acks since I'd like to keep it/push it through
> > > > my tree to reduce the autobuilder failures.
> > > >
> > > >  arch/arm/crypto/bsaes-armv7.pl |    2 +-
> > > 
> > > The .S_shipped file produced by this script should be updated at the same time.
> > > 
> > > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > Patch applied to the crypto tree.  Thanks a lot!
> 
> Since when do patches with "RFC" in the subject line get applied to other
> people's trees?

OK I'll back it out.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
