From: Johannes Goetzfried
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: linux-next: Tree for Jun 13 (crypto)
Date: Wed, 13 Jun 2012 21:05:40 +0200
Message-ID: <20120613190540.GY17705@kronos.redsun>
References: <20120613155440.14672516ffaf5b01f91bb0a2@canb.auug.org.au>
 <4FD8BB95.4000307@xenotime.net>
 <20120613200317.20733xjrnmv47y04@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120613200317.20733xjrnmv47y04@www.81.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 13, 2012 at 08:03:17PM +0300, Jussi Kivilinna wrote:
> >arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_xts_decrypt':
> >(.text+0x856c): multiple definition of `serpent_xts_decrypt'
> >arch/x86/crypto/serpent-sse2-x86_64.o:(.text+0xae8): first defined here
> 
> Reverting commit e2f4d85d5b2049a90859aa10de914ed31a4f17a4, "crypto:
> serpent - add common glue code for avx and sse2 implementation",
> should help for most.
> 
> >arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_dec_blk_8way':
> >(.text+0x3d70): multiple definition of `serpent_dec_blk_8way'
> >arch/x86/crypto/serpent-avx-x86_64.o: In function `__serpent_enc_blk_8way':
> >(.text+0x0): multiple definition of `__serpent_enc_blk_8way'
> 
> Attached patch should solve these (patch depends on above revert).

I'm really sorry about this, it shouldn't have happened. The most easiest
solution to this problem would be to make the choice between
CRYPTO_SERPENT_SSE2_X86_64 and CRYPTO_SERPENT_AVX_X86_64 an exclusive-or choice
in crypto/Kconfig. I don't think there is an use-case, where somebody would
want to link both implementations into the same kernel image or even load both
implementations as module. This would avoid duplicating the glue-code again.

Another possibility would be to add a serpent-common-x86_64 module, but this
wouldn't be a trivial change and imo a little bit too much just to avoid
duplicating this code.

- Johannes
